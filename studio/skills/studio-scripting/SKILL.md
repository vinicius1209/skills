---
name: studio-scripting
description: Cérebro de pré-produção do canal do Vini. Funil tema -> ângulo -> outline -> roteiro falado pra YouTube long-form, na voz VM, dentro da régua de retenção, com os pilares e o ICP Jean do CANAL-YOUTUBE. Define os artefatos (BRIEF/OUTLINE/SCRIPT.md + script.json + teleprompter + shotlist) e o schema do script.json. O cérebro do show-runner e do scriptwriter.
---

# Skill: Studio Scripting (pré-produção)

Esta skill é o **cérebro de pré-produção** do estúdio: o que acontece **antes** da câmera ligar.
Pega um tema ou uma ideia solta e leva até um **roteiro falado** que o Vini grava. Os agentes
`show-runner` (orquestra: tema -> brief -> outline) e `scriptwriter` (outline -> roteiro) rodam em
cima dela.

A régua de qualidade do roteiro **não nasce aqui**. Ela vem da `studio-retention` (cold open, arco
promessa->payoff, capítulos, título). O roteiro tem que **já nascer dentro dessa régua** em vez de
ser consertado na edição. A voz vem da `vinimachado-voice`. A estratégia (pilares, ICP, funil) vem
do `CANAL-YOUTUBE`. A privacidade vem da `vinimachado-public`. **Nunca re-deriva nada disso aqui,
lê de lá.**

## O princípio: roteiro é julgamento

No estúdio existe a divisão **script mecânico vs agente de julgamento**. Renderizar Reel, montar
EDL, rodar QC: isso é mecânico, vira `.py` determinístico. **Escrever roteiro é julgamento**: escolher
o ângulo, a confissão de abertura, onde a prova entra, qual frase fecha o loop. Por isso pré-produção
é **majoritariamente skill + agentes**, com **um único script** (`scripts/new_script.py`) que só faz
o trabalho mecânico: scaffold dos arquivos e **lint determinístico** do `script.json` (papel análogo
ao `qc.py`, mas pra roteiro em vez de vídeo). O julgamento fica no agente; o lint pega o que é regra
dura (travessão, assinatura, CTA inexistente, campo faltando).

## O funil de pré-produção (4 estágios)

```
tema/ideia  ->  ângulo  ->  outline  ->  roteiro falado
 (IDEIAS)      (1 tese)    (arco)        (SCRIPT.md + script.json)
```

1. **Tema -> ângulo.** Um tema ("spec antes de código") não é um vídeo. Vira vídeo quando ganha **um
   ângulo único**: uma tese que o Jean reconhece como dor dele. O `show-runner` escolhe o ângulo
   lendo o `CANAL-YOUTUBE` (qual pilar, qual dor do Jean) e o `IDEIAS.md`. Um vídeo carrega **uma
   tese**, não três. Se tem três, são três vídeos.
2. **Ângulo -> outline.** O ângulo vira o **arco promessa->payoff** da `studio-retention`: cold open
   (a promessa), setup, prova, payoff (a promessa cumprida), CTA. O `show-runner` entrega isso no
   `OUTLINE.md`: a espinha do vídeo em blocos, cada bloco com o beat narrativo e a intenção.
3. **Outline -> roteiro falado.** O `scriptwriter` transforma cada bloco do outline em **fala na voz
   do Vini** (`tu`, frase curta, confissão antes do acerto, sem travessão) + o que vai **na tela**
   naquele bloco. Sai o `SCRIPT.md` (humano, formato tabela) e o `script.json` (máquina).
4. **Roteiro -> gravação -> edição.** O roteiro vira insumo de gravação (teleprompter + shotlist ->
   OBS) e **contrato** de edição: o `editor-companion` compara depois o `script.json.promise` com o
   que o Vini realmente falou no `transcript.txt`.

## Os artefatos (o que cada agente escreve)

Tudo mora em `projects/<slug>/preprod/`. O `new_project.sh` cria o projeto; o `new_script.py` cria
o `preprod/`.

| Arquivo | Quem escreve | É |
|---|---|---|
| `preprod/BRIEF.md` | `show-runner` | a decisão estratégica: pilar, ICP, tese, promessa, CTA, prova obrigatória, duração-alvo |
| `preprod/OUTLINE.md` | `show-runner` | o arco em blocos (cold-open -> setup -> prova -> payoff -> cta), cada bloco com beat + intent |
| `preprod/SCRIPT.md` | `scriptwriter` | o roteiro falado: tabela **Bloco \| Fala \| Tela** por bloco, na voz VM |
| `preprod/script.json` | `scriptwriter` | a versão máquina do roteiro (schema abaixo). É o que o lint valida e o editor confere |
| `preprod/teleprompter.txt` | `new_script.py` (gerado) | só as falas, em ordem, pra ler na gravação |
| `preprod/shotlist.md` | `new_script.py` (gerado) | o que mostrar na tela por bloco (câmera/tela/card/b-roll) |

`teleprompter.txt` e `shotlist.md` são **gerados** pelo `new_script.py` a partir do `script.json`
(não escritos à mão), do mesmo jeito que um build sai de um manifesto. Editou o roteiro? Roda o
script de novo e eles se regeneram.

## Schema do `script.json` (contrato)

Este é o formato exato. O `scriptwriter` escreve, o `new_script.py` valida, o `editor-companion` lê.

```jsonc
{
  "slug": "video-02-spec-quando-nao-basta",
  "pilar": "1. O Método",          // um dos 3 pilares do CANAL-YOUTUBE
  "promise": "vou te mostrar quando uma spec simples não segura e a feature quebra o negócio",
  "cta": "/spec-4",                 // só destino que existe (ver regra dura)
  "target_sec": 780,                // duração-alvo do vídeo inteiro, em segundos
  "blocks": [
    {
      "id": "b1",
      "kind": "cold-open",          // cold-open | setup | prova | payoff | cta
      "beat": "a feature que quebrou banco e cliente",  // o beat narrativo (1 linha)
      "intent": "fincar o Jean com o stake antes de qualquer contexto",  // por que esse bloco existe
      "spoken": "Tem feature que o plan mode resolve. Tem feature que, se tu pedir no chat, quebra banco, permissão e cliente antigo.",
      "on_screen": "câmera fechada, corta pro card 'plan vs spec vs perigo'",  // o que aparece na tela
      "target_sec": 35
    }
  ]
}
```

Regras do schema:
- **Campos do topo obrigatórios:** `slug`, `pilar`, `promise`, `cta`, `target_sec`, `blocks`.
- **Cada bloco obrigatório:** `id`, `kind`, `beat`, `intent`, `spoken`, `on_screen`, `target_sec`.
- **`kind` é um de:** `cold-open` | `setup` | `prova` | `payoff` | `cta`. O arco precisa ter pelo
  menos um `cold-open` e um `payoff` (senão a promessa não fecha) e o `cta` é sempre o último bloco.
- **`promise`** é a frase literal que o cold open abre. Vira o **contrato**: o `payoff` tem que
  fechar exatamente ela, e o `editor-companion` compara essa string com o `transcript.txt` depois.
- **`spoken`** é a fala na voz VM (o que o Vini diz). É o que vai pro `teleprompter.txt`.
- **`on_screen`** é o que aparece na tela naquele bloco. É o que vira linha do `shotlist.md`.
- **`target_sec`** dos blocos soma perto do `target_sec` do topo (o lint avisa se divergir muito).

## O roteiro como CONTRATO de promessa->payoff

O `script.json.promise` é o ponto de amarração entre pré-produção e pós-produção. Na gravação, o
Vini fala em cima do roteiro mas improvisa. Depois, o `editor-companion` (via `studio-retention`)
faz a checagem do arco lendo o `transcript.txt`:

1. Extrai a promessa real dos primeiros ~30-45s do que foi falado.
2. Compara com `script.json.promise`. Se o Vini abriu uma promessa diferente da roteirizada, o
   editor sinaliza: ou o cold open desviou, ou o roteiro estava otimista.
3. Procura o payoff no último terço e confirma que fecha **a promessa do roteiro**. Loop aberto no
   roteiro e nunca pago na gravação = retenção vaza.

Ou seja: o roteiro não é só base de gravação, é a **especificação** que a edição confere contra a
execução. Promessa escrita aqui, paga lá. Mesma lógica de spec->código que o canal prega.

## Como o roteiro segue a régua da `studio-retention` (na origem)

O roteiro **já nasce** dentro da rubrica, em vez de ser corrigido na edição. O `scriptwriter` aplica
estes pontos da `studio-retention` enquanto escreve (referência, não duplicação, leia a skill pro
detalhe):

- **Cold open (seção 1):** o primeiro bloco (`kind: cold-open`) abre com **stake, número (com fonte)
  ou confissão**, nunca saudação/meta-fala. Finca em <15s. Promessa em uma frase logo depois.
- **Arco que fecha (seção 2):** o `cold-open` abre a `promise`; o `payoff` fecha a mesma promessa de
  forma explícita. Cada loop plantado no roteiro tem um bloco que o paga.
- **Sem zona morta (seção 3):** o roteiro não escreve meta-fala ("nesse vídeo eu vou falar sobre"),
  não escreve pedido de desculpa, não enfileira lista longa sem mudança de tela.
- **Pattern interrupts (seção 4):** o `on_screen` de cada bloco já prevê a mudança visual
  (câmera -> tela -> card -> b-roll) antes do tédio bater. Não deixa o mesmo enquadramento >20-30s.
- **CTA (seção 8):** o bloco `cta` vem **depois do payoff**, com **um** destino do funil, e fecha com
  o bordão falado. Nunca CTA antes da entrega.

A pontuação (Retention Score) é da edição, não da pré-produção. Mas um roteiro escrito fora dessa
régua já entra perdendo: o objetivo aqui é **entregar pro editor um vídeo que já pontua alto**.

## Voz, pilares e privacidade (lê da fonte, não re-deriva)

- **Voz:** `brand/.claude/skills/vinimachado-voice/SKILL.md`. `tu/tua/teu` a peça inteira, frase
  curta (<18 palavras), confissão antes do acerto, **sem travessão (—)**, sem marketing-speak
  (game changer, insano, revolucionário, fórmula). Todo termo de método (spec, agent, skill, hook,
  guardrail, PRD) precisa de **analogia pro Jean na mesma fala** (régua: se ele não entende e não se
  importa, reescreve). Número só com fonte real.
- **Pilares + ICP + funil:** `brand/marketing/CANAL-YOUTUBE.md`. Os 3 pilares (1. O Método ·
  2. Construindo Ao Vivo · 3. A Tradução), o avatar Jean (founder semi-técnico que já constrói com
  IA e já sentiu prejuízo), e o funil `Vídeo -> /spec-4 ou /glossario -> VM — Vibe Coders ->
  mentoria 1:1`. O CTA do roteiro segue o CTA padrão do pilar.
- **Banco de temas:** `brand/marketing/IDEIAS.md` e os 5 primeiros vídeos do `CANAL-YOUTUBE`. O
  `show-runner` puxa daqui o tema quando o Vini não dá um pronto.
- **Privacidade:** `brand/.claude/skills/vinimachado-public/SKILL.md`. Filha nunca por nome;
  mentorado/cliente só anonimizado e autorizado (Jean/Meu Ingresso é autorizado); slug/PR/repo real
  vira placeholder no `on_screen`; Prime Sales Hub em público usa ambiente local limpo com seeders
  fictícias.

## Regras duras (o `new_script.py` faz o lint, igual qc.py)

São as regras que o lint determinístico checa no `script.json` (PASS/FAIL):

- **Sem travessão (—)** em nenhum campo de texto (`promise`, `spoken`, `on_screen`, `beat`,
  `intent`). É o tic anti-IA número um. Substitui por ponto, vírgula, dois pontos.
- **Assinatura exata** quando citada: `Vini. Método > prompt.` (texto). O **bordão falado** de fecho
  de vídeo é `Menos chat solto e mais metodologia` (sem "prompt"), com *metodologia* em destaque no
  end-card. Não trocar um pelo outro.
- **CTA só pra destino que existe:** `/spec-4`, `/glossario`, `VM — Vibe Coders`, `mentoria 1:1`.
  **Nunca `Code Agent PRO`** (é vapor; não aparece em fala, card, descrição ou CTA).
- **Todo bloco tem `beat`, `intent`, `spoken`** preenchidos (o julgamento narrativo está aí).
- **Duração-alvo coerente:** a soma de `target_sec` dos blocos fica perto do `target_sec` do topo.
- **Arco mínimo:** existe pelo menos um `cold-open` e um `payoff`; o último bloco é o `cta`.

Falhou uma regra dura = **FAIL**, igual ao `qc.py`. Nada vai pra gravação com FAIL.

## Fluxo (resumo operável)

1. `show-runner` recebe o tema (ou puxa de `IDEIAS.md`), lê `CANAL-YOUTUBE`, escolhe **pilar + ICP +
   ângulo**, e escreve `preprod/BRIEF.md` + `preprod/OUTLINE.md`.
2. `scriptwriter` lê o outline, escreve `preprod/SCRIPT.md` (tabela Bloco|Fala|Tela) + `preprod/
   script.json`, na voz VM, dentro da régua da `studio-retention`.
3. `new_script.py <slug>` faz o **lint** do `script.json` (PASS/FAIL) e **gera** `teleprompter.txt`
   + `shotlist.md`.
4. Grava: lê o `teleprompter.txt`, segue o `shotlist.md` no OBS.
5. Depois de transcrever, o `editor-companion` compara `script.json.promise` vs `transcript.txt`
   (o contrato fechou?).

## O que esta skill NÃO faz

- Não monta vídeo, não corta, não renderiza. Isso é `studio-editing` / `studio-reels-longform`.
- Não re-deriva voz, pilares, retenção ou privacidade. Lê das skills fonte.
- Não escreve o lint em prosa: o lint mecânico é o `new_script.py`. A skill é o julgamento.
- Não inventa número, caso ou estatística. Número entra com fonte real ou não entra.

Vini. Método > prompt.
