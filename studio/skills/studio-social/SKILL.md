---
name: studio-social
description: Sistema de criativos e capas pra redes sociais do Vini (Reels/Feed/Stories) — capa pergunta/resposta estilo grid IG, criativo "quadrado no preto", legendas. Como briefar um creative.json, renderizar determinístico (creative.py) na identidade VM, e gerar arte com imagegen.py. O cérebro do agente social-manager.
---

# Skill: Studio Social (criativos e capas pra rede)

Esta skill é o **craft de criativo social** do estúdio: como transformar um vídeo (ou uma ideia) em
**capas de Reel** e **criativos de feed/story** que parecem do Vini, de forma **determinística** —
mesmo princípio dos Reels: nada de design ad-hoc, tudo via script + template + tokens de marca.

A identidade visual NÃO se inventa aqui. Ela vive em `assets/brand/` (travada na landing
`vinimachado.dev`). A voz vive em `brand/.claude/skills/vinimachado-voice/`. A privacidade em
`brand/.claude/skills/vinimachado-public/`. Esta skill é como você OPERA tudo isso pra rede.

## Comece sempre por um SEED

Antes de montar qualquer coisa, veja se existe um **seed** (receita congelada e versionada) pro que
você quer. Seed trava a qualidade (geometria, fonte, cor, enquadramento, prompt, regras); você só
preenche os slots de conteúdo ⇒ resultado ~idêntico toda vez. Catálogo: `python3 scripts/seed.py list`.
Detalhe de cada um: `python3 scripts/seed.py show <nome>`. Doc completa: `docs/SEEDS.md`. Command: `/seed`.

- **Reel de vídeo (cara na câmera)** → seeds `reel-tweet-card` (padrão: avatar+nome+selo+título à
  esquerda) ou `reel-card` (minimalista). Já embutem `crop:"auto"` (autocrop centra no rosto) e
  auto-fit (bloco centralizado pra qualquer título). NÃO escreva `reel.json` na mão.
- **Demo de tela (sem rosto/áudio: agente/app trabalhando)** → seed `reel-screen-demo`. Silencioso
  (música no IG; QC sinaliza áudio como exceção). Aqui NÃO tem `crop:"auto"`: percorra os frames
  (folha de contato `ffmpeg -i src -vf "fps=N,scale=...,tile=4x6" -frames:v 1 sheet.png`), ache a
  região da tela e recorte ACIMA de erros/dados sensíveis. Cuidado com o áudio durar mais que o vídeo.
- **Imagem com o rosto do Vini** → seed `face-creative` (prompt/imagegen, com a foto de referência
  travada e as proibições de marca).
- **Legenda de IG** → seed `reel-caption` (prompt/agent, voz VM).
- **Story de PASSOS (fluxo/pipeline/checklist)** → seed `story-steps` (command `/story`). Imagem 1080x1920
  on-brand DENTRO da safe-zone do Story (topo avatar/nome, base caixa de comentário). Estilos sóbrios
  editorial/mono/accent + acento amarelo/azul; até ~7-8 passos curtos. Conteúdo via `steps.json`.

Se NÃO existe seed pro formato (capas `cover-qa`/`creative-square` ainda são montadas direto pelo
`creative.py`), use os formatos abaixo — e considere **promover o formato a seed** quando ele estabilizar.

## O que dá pra produzir (formatos)

Templates em `assets/templates/`, renderizados por `scripts/creative.py`:

| Template | É | Referência | Quando usar |
|---|---|---|---|
| `cover-qa` | capa de Reel/vídeo: foto/frame full-bleed + pergunta (branco) + resposta (pill colorido) | grids estilo kasimov_umarbek / meviz.cg | deixar o feed de Reels coeso; "capa que faz clicar" |
| `creative-square` | "quadrado no preto": headline no topo + mídia em quadrado arredondado + legenda em pill amarelo | gui.serraglio | post estático / capa editorial / anúncio |

Roadmap (ainda não): `cover-scribble` (rosto + rabiscos à mão + CTA, ref. João Mendes), legendas
karaokê queimadas no Reel (ref. "JUST LIKE THE CEILING"), carrossel 1080×1350.

## O fluxo (decide → brief → render → gate)

1. **Decide** o formato e a mensagem. Para capa de Reel, a pergunta é o GANCHO (curiosity gap), a
   resposta é o TÓPICO/payoff. Use o banco de hooks da `vinimachado-voice`. Um ângulo por criativo.
2. **Escolhe a imagem**: o melhor é um FRAME do próprio vídeo (rosto nítido, olhando pra câmera).
   `creative.py` puxa o frame sozinho: `"background": {"video": "...", "at": 12.4}`. Sem vídeo bom?
   Gere um background com `scripts/imagegen.py` (peça SEM texto). Foto do avatar em `assets/brand/`.
3. **Escreve o `creative.json`** (schema abaixo) em `projects/<slug>/social/`.
4. **Renderiza**: `python3 scripts/creative.py projects/<slug>/social/<nome>.json`.
   Saída: `projects/<slug>/social/<nome>.png`. Confira o PNG (abra e olhe) antes de aprovar.
5. **Gate**: passa pelo `privacy-reviewer` (sem filha por nome, sem slug/PR/repo real na imagem,
   CTA só pro que existe, número com fonte). Sem GO, não publica.

## Schema do `creative.json`

```json
{
  "template": "cover-qa",
  "size": [1080, 1920],
  "output": "cover-jean-checkout.png",
  "accent": "blue",
  "background": {"video": "/abs/source.mov", "at": 12.4},
  "fields": {
    "handle": "@vinimachado.dev",
    "eyebrow": "CASO REAL",
    "question": "Por que o checkout caía só em produção?",
    "answer": "RACE CONDITION"
  }
}
```

- `accent`: `blue | yellow | red | cyan` (cor do pill da resposta). Azul = técnico; amarelo = signal.
- `background`: `{"video","at"}` (frame do vídeo) OU `{"image":"/abs.png"}`. Enquadramento opcional:
  `"zoom": 1.4` (aproxima) e `"pos": "center 16%"` (ponto focal). Foto de corpo inteiro num 9:16 pede
  `zoom` ~1.3-1.5 + `pos` no rosto, senão sobra parede.
- `creative-square` usa `fields.headline` (pode ter `<hi>palavra</hi>` em amarelo), `fields.caption`
  (o pill "legenda") e `fields.media` (a imagem do quadrado; cai no background se omitido).
- `output` relativo resolve ao lado do próprio `creative.json`.

## Regras de marca (inegociáveis)

- **Cores/fontes só de `assets/brand/tokens.json`.** Navy `#010A14`, amarelo `#FFF200`, azul
  `#007AFF`, texto `#f3f4f6`, SF Pro/SF Mono. Nada fora disso.
- **Sem travessão (—)** em nenhum texto. Assinatura escrita exata: `Vini. Método > prompt.`
- **Texto sobre o scrim, NUNCA sobre o rosto.** (mesma lição do layout dinâmico do long-form: card
  não cobre cara/câmera). No `cover-qa` o bloco de texto fica no terço inferior, sobre o gradiente.
- **Voz VM**: `tu`, frase curta, confissão antes do acerto, zero marketing-speak. Pergunta de capa
  é gancho real, não clickbait vazio.
- **Privacidade**: rosto da filha nunca; tela com slug/PR/repo/RPC real → não usar como frame, ou
  borrar antes. Mentorado/cliente só anonimizado + autorizado. Jean (Meu Ingresso) ok por nome.
- **CTA só pro que existe**: /spec-4, /glossario, VM — Vibe Coders, mentoria 1:1. Nunca Code Agent PRO.

## Geração de imagem (imagegen.py)

`scripts/imagegen.py "<prompt>" --out <png> [--portrait|--square|--landscape] [--quality low|medium|high]`
usa `gpt-image-2` (default; `--model` troca o modelo) com a `OPENAI_API_KEY` do `.env`. Custa por
imagem (low ~$0.02) — itere em `low`. Peça **sem texto embutido** (o texto entra via `creative.py`).

**Duas fontes de arte (assinatura primeiro, API como fallback):** o **Codex NÃO gera imagem** (é
agente de código; o `--image` dele só *envia* imagem). A geração da assinatura mora no app do ChatGPT
(não é scriptável). Então: (1) **grátis** = gere no ChatGPT, salve o PNG em `projects/<slug>/social/`
e aponte o `creative.json` (`background.image`) pra ele; (2) **automático** = `imagegen.py` (API). Os
dois funcionam porque o `creative.py` aceita qualquer imagem como fundo.
Use pra background/b-roll/arte conceitual, não pra "fingir" prova real (número/screenshot precisa
ser verdadeiro). É matéria-prima; o criativo final é montado pelo `creative.py`.

## Criativos com o rosto do Vini (face-reference, alto engajamento)

O `gpt-image-2` aceita imagem(ns) de **referência**: dá pra pegar o rosto do Vini e jogá-lo em
cenários/estilos fora da curva mantendo a semelhança. É o motor dos posts de alto engajamento. Quem
brainstorma os conceitos é o agente **creative-director** (`/imagine`).

```
scripts/imagegen.py "<prompt>" --reference assets/brand/avatar-vini.jpg \
  --out projects/<slug>/social/<nome>.png --portrait --quality low
```

Receita de prompt (semelhança + cena):
1. Ancore a semelhança: "Retrato do mesmo homem, mantenha fielmente o rosto, a barba e o cabelo, camiseta preta".
2. Cena/estilo fora da curva: setup neon, lugar improvável, metáfora visual do tema.
3. Sempre "sem nenhum texto na imagem" (o texto entra na tipografia VM via `creative.py`).
4. Paleta navy/azul/amarelo quando fizer sentido.

Banco de ângulos de engajamento (1 por peça): **pattern interrupt** (Vini num lugar improvável
ligado ao tema); **"Vini as X"** (arquétipo: o engenheiro, domando a IA); **reação/expressão**
exagerada (meme-able); **aspiracional** (o setup dos sonhos); **conceitual** (rosto + metáfora do
tema, ex.: segurando a IA na coleira).

Duas formas (assinatura primeiro, API fallback) — o mesmo prompt serve pras duas:
1. **Grátis:** cole o prompt no ChatGPT da assinatura, anexe a foto, salve o PNG em `social/`.
2. **Automático:** `imagegen.py --reference` (custa centavos na `--quality low`).

Privacidade: só o rosto do Vini. Nunca filha/mentorado/cliente. **Nunca imagem religiosa/messiânica**
(sem auréola, raios atrás da cabeça ou pose de Cristo; fé segue `vinimachado-public`). Imagem de IA é
criativo, **não "prova"** (número/print real continua tendo que ser real). **Antes de inventar,
pesquise referência real** (o que o Vini mandou, ou tendências via WebSearch) e copie o padrão.

## Onde tudo cai

`projects/<slug>/social/` — todos os `creative.json` e os PNGs. Nada em /tmp. Ver `docs/STUDIO-MAP.md`.
