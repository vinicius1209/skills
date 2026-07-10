---
name: studio-transcription
description: Transcrição "full power" de vídeos com a API da OpenAI (whisper-1 para timestamps de palavra + gpt-4o-transcribe para texto limpo). Quando e como rodar o harness, formatos de saída e como ler.
---

# studio-transcription

Transcrição "full power" de um vídeo bruto. O harness roda **dois modelos** na mesma gravação e
escreve os dois resultados em `projects/<slug>/`. Um modelo te dá onde cortar (timestamps por
palavra), o outro te dá o texto limpo pra ler e analisar a história.

Script de verdade: `scripts/transcribe_openai.py` (o que faz o trabalho) e
`scripts/transcribe.sh` (o wrapper que carrega o `.env` e chama o Python). Não reimplemente nada
aqui: rode o script e raciocine sobre a saída.

## Quando usar

- Depois de gravar e (idealmente) depois do ingest. Passo 3 do workflow:
  `new_project -> ingest -> transcribe -> editor-companion -> cut-planner -> reels-cutter -> privacy-reviewer`.
- Sempre que precisar do texto pra análise editorial **ou** dos timestamps pra cortar.
- O agente `transcriber` é quem dispara isto. Você (humano) também pode rodar direto.

Não use pra: extrair frames, detectar silêncio ou cenas (isso é o `studio-ingest`). Transcrição
só cuida de áudio -> texto + tempo.

## Por que dois modelos (a sacada)

É a regra dura do estúdio: **"full power" = whisper-1 E gpt-4o-transcribe**. Cada um existe por um
motivo diferente, e um não substitui o outro.

- **whisper-1** com `response_format=verbose_json` e
  `timestamp_granularities[]=word` + `timestamp_granularities[]=segment`. É o único que devolve
  **timestamp por palavra**. Isso é o que torna o corte "frame-accurate": dá pra ancorar um corte
  no início exato de uma palavra, não num bloco de legenda grosso de 4 segundos. Vira `words.json`,
  `segments.json`, `transcript.srt` e `transcript.vtt`.
  - Analogia pro Jean: é a régua milimetrada. Marca onde cada palavra começa e termina, pro corte
    não engolir o início de uma frase nem deixar meio segundo de silêncio sobrando.

- **gpt-4o-transcribe** com `response_format=json`. Não devolve timestamp, mas escreve a **prosa
  mais limpa e correta**: pontuação melhor, menos alucinação, jargão grafado certo (porque é
  enviesado pelo prompt de contexto). Vira `transcript.txt` (o arquivo "leia este").
  - Analogia pro Jean: é o revisor. Não te diz onde cortar, te entrega o texto pronto pra ler sem
    tropeçar.

Resumo de quem lê o quê:

| Pra... | Leia |
|---|---|
| Entender a história, achar erros, ganchos, buracos | `transcript.txt` |
| Cortar no tempo certo (frame-accurate) | `words.json` |
| Legenda / referência por bloco | `transcript.srt`, `transcript.vtt`, `segments.json` |
| Comparar o que cada modelo ouviu | `transcript.gpt4o.txt` vs `transcript.whisper.txt` |
| Auditar o que aconteceu na run | `meta.json`, `raw/` |

## Comandos exatos

O caminho normal é o wrapper, que carrega o `.env` sozinho:

```bash
# scripts/transcribe.sh <source-media> <out-dir> [name]
scripts/transcribe.sh projects/fleube-5/source.mov projects/fleube-5 fleube-5
```

Equivalente chamando o Python direto (precisa do `OPENAI_API_KEY` já no ambiente):

```bash
set -a; source .env; set +a
python3 scripts/transcribe_openai.py \
  --source projects/fleube-5/source.mov \
  --out    projects/fleube-5 \
  --name   fleube-5
```

Reaproveitar áudio já extraído (pula o re-extract do vídeo):

```bash
python3 scripts/transcribe_openai.py --audio projects/fleube-5/audio.wav --out projects/fleube-5
```

Flags úteis:

- `--language`: código do idioma (default `pt`). Veja a seção de idioma abaixo.
- `--prompt-file`: prompt de contexto (default `prompts/transcription-context.txt`).
- `--whisper-model`: default `whisper-1` (ou env `STUDIO_WHISPER_MODEL`).
- `--text-model`: default `gpt-4o-transcribe` (ou env `STUDIO_TEXT_MODEL`); passe `none` pra
  pular o modelo de texto e usar só o whisper.
- `--force`: refaz mesmo se já existir saída. Veja idempotência abaixo.

## Arquivos de saída

Tudo em `projects/<slug>/`:

| Arquivo | Modelo | Pra que serve |
|---|---|---|
| `transcript.txt` | gpt-4o-transcribe (fallback whisper) | **Leia este.** Prosa limpa pra análise. |
| `transcript.gpt4o.txt` | gpt-4o-transcribe | Texto cru do modelo de prosa (só existe se o text-model rodou). |
| `transcript.whisper.txt` | whisper-1 | Texto cru do whisper, pra comparar. |
| `transcript.srt` | whisper-1 | Legenda com timestamp por segmento. Também é o "done marker". |
| `transcript.vtt` | whisper-1 | Mesma legenda em WebVTT. |
| `words.json` | whisper-1 | `[{word, start, end}]` em segundos. **Cortes frame-accurate.** |
| `segments.json` | whisper-1 | `[{start, end, text}]` por bloco. |
| `meta.json` | (nenhum) | Relatório da run: duração, nº de chunks, modelos, contagem de segmentos/palavras. |
| `raw/` | (nenhum) | Resposta crua de cada chamada de API (`raw_<model>_<tag>_tryN.json`), pra debug. |

`transcript.txt` é sempre o melhor texto disponível: se o gpt-4o-transcribe rodou, é ele; se
falhou ou foi pulado com `--text-model none`, cai pro texto do whisper. Os intermediários
(`upload.mp3`, `chunk_*.mp3`) são apagados no fim. O que sobra é só o que importa.

## O prompt de contexto (e como estender por vídeo)

O harness manda `prompts/transcription-context.txt` como o `prompt` da API nos **dois** modelos.
Ele não dita o que falar, ele **enviesa o ASR** pra grafar jargão e nomes próprios certos:
Claude Code, OpenCode, GLM, Spec-4, Jean, harness, lock-in, janela de contexto, etc. Sem isso, o
modelo escreve "clod code", "spec quatro", "lockin" e você perde tempo corrigindo.

Analogia pro Jean: é o glossário que você entrega pro estagiário antes dele transcrever. Ele já
sabe que "GLM" não é "GLN" porque você listou antes.

Pra estender num vídeo específico (ex.: o vídeo cita o nome de um produto ou uma sigla nova):

1. **Preferido (não-destrutivo):** copie o arquivo base, adicione os termos novos e aponte com a
   flag:
   ```bash
   cp prompts/transcription-context.txt projects/<slug>/prompt.txt
   # edite projects/<slug>/prompt.txt e acrescente os termos do vídeo
   python3 scripts/transcribe_openai.py --source ... --out projects/<slug> \
     --prompt-file projects/<slug>/prompt.txt
   ```
2. Só edite o arquivo base global se o termo é recorrente em todo vídeo do canal.

Mantenha o prompt curto e em pt-BR. É uma lista de termos, não um briefing. Privacidade vale aqui
também: não coloque slug real, PR, repo ou nome de mentorado no prompt se isso for vazar pro
arquivo de saída.

## Limite de 25 MB e chunking

A API recusa upload acima de 25 MB. O harness lida com isso sozinho, em duas camadas:

1. **Transcode primeiro.** Toda fonte vira `upload.mp3` mono, 16 kHz, 64 kbps. Áudio de fala não
   precisa de mais que isso, e isso já derruba a maioria dos vídeos longos pra baixo do limite.
2. **Chunk por tempo se ainda for grande.** Acima de ~24 MB (margem de segurança), divide em N
   pedaços iguais por tempo, transcreve cada um, e **costura os timestamps de volta** somando o
   offset de início do chunk em cada `start`/`end`. Pra você, o resultado é um `words.json` e um
   `segments.json` contínuos, como se fosse uma transcrição só.

Você não faz nada: é automático. Só saiba que vídeo muito longo gera mais chamadas de API (uma por
chunk por modelo).

## .env / OPENAI_API_KEY

A chave **sempre** vem do `.env` (gitignored). Nunca hardcode, nunca commite.

- `scripts/transcribe.sh` carrega o `.env` sozinho (`set -a; source .env; set +a`) e aborta se o
  arquivo não existir, mandando copiar do `.env.example`.
- Se chamar o Python direto, exporte a chave antes (`set -a; source .env; set +a`). Sem a chave o
  script sai com código 2 e a mensagem `OPENAI_API_KEY not set (source the .env first)`.
- Erros de auth/quota (chave errada, sem crédito) abortam rápido, sem ficar tentando de novo à toa.
  Erros transitórios de rede tentam de novo até 4 vezes com backoff.

## Escolhendo o idioma

Default é `pt` (português do Brasil), que é o caso normal do canal. O idioma é passado pra API
em **ambos** os modelos via `--language`. Use outro código ISO só se o vídeo for em outra língua
(ex.: `--language en`). Deixar no idioma certo melhora a precisão e evita o modelo "traduzir" sem
querer. Não misture: um vídeo, um idioma por run.

## Nota de custo (aproximada)

Você paga pelos **dois** modelos, por minuto de áudio. Como roda whisper-1 + gpt-4o-transcribe na
mesma gravação, o custo por minuto é a soma dos dois. Ordem de grandeza: alguns centavos de dólar
por minuto de áudio somando os dois modelos; um vídeo longo de ~1h fica na casa de alguns dólares.
Confira o preço atual na tabela oficial da OpenAI antes de citar número em qualquer lugar público
(regra do estúdio: número precisa de fonte real). Pra economizar numa passada rápida onde você só
quer o texto, use `--text-model none` e rode só o whisper.

## Idempotência (--force)

O harness usa `transcript.srt` como marcador de "já feito". Se ele existe e você **não** passou
`--force`, a run sai com `already transcribed` e não gasta API. Pra refazer (mudou o prompt,
trocou de modelo, a fonte foi reeditada), passe `--force`. Reaproveita o mesmo diretório de saída
e sobrescreve os arquivos.

## Pegadinhas

- **Jargão grafado errado.** Se aparecer "clod code", "spec quatro", "vibe códi" no
  `transcript.txt`, o termo não está no prompt de contexto. Adicione e rode com `--force`. O prompt
  enviesa, não garante 100%.
- **Música e ruído alucinam texto.** Trechos com música de fundo, aplauso ou silêncio longo podem
  gerar frases fantasma (legenda inventada, "obrigado por assistir" do nada). Confira esses trechos
  no `transcript.srt` contra o vídeo antes de confiar no corte. Áudio limpo de fala é o que o
  harness assume.
- **Timestamp só vem do whisper.** O gpt-4o-transcribe não tem tempo. Se você só rodou o text-model,
  não tem `words.json` utilizável pra corte. "Full power" existe justamente pra você ter os dois.
- **Vídeo longo = mais chunks = mais latência e mais chamadas.** Espere a run terminar; o costurar
  de timestamps já cuida da continuidade.
- **Nunca sobrescreva a mídia fonte.** O harness só lê a fonte e escreve no `--out`. Corte é
  não-destrutivo (isso é regra do estúdio, vale pro render também).
- **`raw/` é seu amigo no debug.** Se o texto saiu estranho, abra a resposta crua da API ali antes
  de culpar o script.

Vini. Método > prompt.
