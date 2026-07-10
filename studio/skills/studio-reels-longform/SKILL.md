---
name: studio-reels-longform
description: Cortar um vídeo longo em Reels/Shorts: como escolher os trechos (1 ângulo único, auto-contido, densidade de hook), a ponte pro sistema visual vinimachado-reels (câmera embaixo + cards), crop Tipo A vs B, caption e diversidade de ângulos.
---

# Skill: Studio Reels (long-form para Reels/Shorts)

Esta skill faz a **ponte editorial** entre um vídeo longo já transcrito (`projects/<slug>/`) e o
sistema visual de Reels do Vini. Ela responde uma pergunta só: **quais trechos viram Reel, e qual
o plano de corte de cada um**. O *como montar o Reel* (canvas 1080×1920, câmera embaixo, cards,
HTML, build ffmpeg) NÃO mora aqui. Mora em `brand/.claude/skills/vinimachado-reels/`. Não duplica
aquele sistema. Lê de lá.

## Divisão de responsabilidade (não confundir)

| Pergunta | Quem responde |
|---|---|
| Que trecho do longo vira Reel? Por quê? | **esta skill** (`studio-reels-longform`) |
| Onde começa/termina no source (frame-accurate)? | **esta skill** + `words.json` |
| Qual ângulo, pill, hook card, caption? | **esta skill** + `vinimachado-voice` |
| Como o Reel é montado (layout, crop, HTML, ffmpeg)? | `brand/.../vinimachado-reels` |
| O texto público viola privacy/claims? | `brand/.../vinimachado-public` (gate `privacy-reviewer`) |

Regra de ouro: o agente `reels-cutter` roda esta skill pra **decidir e planejar**, e só então
abre `vinimachado-reels` pra **executar**. Nunca o contrário.

## O que é um trecho que vira Reel

Um momento só é cortável se passar em TODOS estes filtros. Se falhar um, descarta ou acha outro
take da mesma fala.

1. **Auto-contido.** Faz sentido sem ter visto o resto do vídeo. Se precisa de contexto que veio 3
   minutos antes, não é Reel. É só pedaço de Reel. Quem assiste no IG cai de paraquedas.
2. **Hook nos primeiros 2 segundos.** A primeira frase precisa prender sozinha. Sem aquecimento,
   sem "então, voltando ao que eu tava falando", sem "deixa eu te mostrar uma coisa". A fala
   começa já no soco.
3. **Um ângulo único.** Cada Reel carrega exatamente UMA ideia. Os ângulos válidos:
   - **número** (KPI hero: "5 horas, 1 PR, 4162 testes")
   - **comparação** (sem método vs com método, antes/depois)
   - **lista** (3-6 takeaways, princípios)
   - **exemplo** (o método aplicado a um caso concreto)
   - **analogia** (a tradução pro Jean: "spec é a regra do jogo escrita antes do código")
4. **Áudio limpo.** Sem "perai", sem tosse, sem hesitação longa, sem barulho de janela/cadeira no
   meio da frase. Vídeo longo costuma ter o **mesmo argumento dito 2-3 vezes**. Pega o take mais
   refinado (geralmente o segundo ou terceiro, não o primeiro).
5. **Densidade.** 30-60s precisam entregar algo. Se em 40s a pessoa só "introduz" sem pagar nada,
   o trecho é fraco. Densidade de hook > duração: melhor 32s cheios que 58s arrastados.

Anti-trecho (descarta na hora): explicação que depende de tela que não vai aparecer no Reel;
piada interna; correção de gravação ("deixa eu refazer"); número sem fonte; qualquer coisa que o
`privacy-reviewer` barraria.

## Como achar os trechos no projeto

Trabalha com dois arquivos do `projects/<slug>/` ao mesmo tempo:

- **`transcript.txt`** (texto limpo do `gpt-4o-transcribe`): pra LER e escolher o que merece Reel.
  É aqui que tu enxerga o argumento bom.
- **`words.json`** (word timestamps do `whisper-1`): pra ENCONTRAR o start/end exato em segundos.
  É o que torna o corte frame-accurate.

Fluxo de mapeamento:

1. Lê `transcript.txt` inteiro e marca cada candidato a Reel com uma frase-âncora (uma sequência
   de palavras literal que aparece no início do trecho).
2. Pra cada candidato, casa a frase-âncora com `words.json` pra achar o `start` (timestamp da
   primeira palavra) e o `end` (timestamp da última palavra + a respiração depois).
3. Cruza com `ingest/scenes.txt` e `ingest/silences.txt`: um corte que cai exatamente numa
   silence é mais limpo de fechar; uma scene-change perto do start ajuda a abrir seco.
4. Confere o `COMPANION.md` (relatório do `editor-companion`): se o story-analyst já apontou "aqui
   o vídeo tem um pico", esse pico quase sempre é um Reel.

Sempre deixa **uma folga de respiro** (≈0.2-0.4s) antes da primeira palavra e depois da última, pra
o corte não comer o ataque/cauda da fala. Os timestamps de `words.json` são da palavra falada, não
da respiração em volta.

## A ponte pro sistema visual (vinimachado-reels)

Depois de escolher trecho + ângulo, o resto é o sistema da marca. Resumo só pra orientar a decisão
(detalhe completo em `brand/.claude/skills/vinimachado-reels/SKILL.md`):

- Canvas **1080×1920** (9:16). Câmera do Vini **full-bleed embaixo**, ocupando ~40% da altura
  (1080×768, sem borda, edge-to-edge). Conteúdo informativo (pill no topo + hook + cards) na
  parte de cima.
- A escolha de **grid de cards** segue o ângulo: comparação → 2 cards; número → 4 KPIs; lista →
  6 lições; passo a passo → 3 steps.
- Paleta fixa: navy `#010A14`, yellow `#FFF200`, text `#f3f4f6`, surface `#071321`, red `#ff4d4d`.
- A assinatura "Vini. Método > prompt." **não** entra dentro do Reel. Vem na caption.

Não copia o HTML nem o build script pra cá. Quando for montar, abre `vinimachado-reels` e usa o
template de lá. Esta skill só garante que tu chega lá com a decisão certa.

### Tipo A vs Tipo B (qual crop de câmera)

O crop da câmera depende de COMO o source foi gravado. Decidir isso é parte do plano de corte,
porque muda o trecho que dá pra usar:

- **Tipo A, screen recording com webcam embutida no canto.** Source tipo OBS/zoom split (tela +
  carinha pequena no canto). A câmera é recortada da zona do canto (algo como
  `crop=420:300:40:1060` no source 2560×1440) e escalada pra 1080×768. Use quando o trecho mostra
  a tela fazendo algo (caso real, demo). **Cuidado:** se o conteúdo da tela (zoom no topo) invadir
  a zona da câmera, o crop quebra. Confere antes.
- **Tipo B, webcam full-frame (talking head puro).** Source só de cara, sem split. Crop central
  mantendo proporção (algo como `crop=1700:1214:430:0` → `scale=1080:768`). Use quando o trecho é
  o Vini falando direto pra câmera (hook, tese, cold open).

Os valores exatos e o `ffmpeg -frames:v 1` de teste de crop estão em `vinimachado-reels`. Aqui o
que importa é registrar no plano **qual tipo** o trecho exige, porque um trecho de tela só funciona
como Tipo A.

### Caveat técnico (registrar no plano)

A câmera embutida do Tipo A é pequena no source. Ao escalar 420×300 → 1080×768, a imagem **upscaleia
e fica soft** (levemente borrada). Não dá pra inventar resolução que não existe. Se o trecho depende
de a cara do Vini estar nítida, prefere um source Tipo B pra aquele ângulo, ou aceita o soft como
limitação conhecida e não tenta "consertar" com sharpening pesado (vira artefato). Anota isso no
campo `caveat` do plano pra quem montar não se assustar.

## Entregável: um plano de corte por Reel

Cada Reel escolhido vira um arquivo `projects/<slug>/reels/<id>.md` (legível, igual ao padrão de
`PLANO-EDICAO.md` da marca). O entregável NÃO é o Reel montado, é o **plano** que o sistema visual
executa: uma narrativa curta + este bloco de plano estruturado no topo do `.md`:

```jsonc
// bloco de plano no topo de projects/<slug>/reels/r1-kpis-caso.md
{
  "id": "r1-kpis-caso",
  "source": "projects/<slug>/source.mp4",
  "source_type": "A",            // A = screen+cam | B = talking-head
  "start": 412.6,                // segundos, de words.json (com respiro)
  "end":   447.2,
  "anchor": "cinco horas, um PR", // frase literal que ancora o start em words.json
  "angle": "número",             // número | comparação | lista | exemplo | analogia
  "pill": "CASO REAL",           // texto da pill (uppercase, curto)
  "hook_card": "5h, 1 PR, 4162 testes",  // headline do topo do Reel
  "cards_grid": "4 KPIs",        // qual grid de vinimachado-reels usar
  "caption": "...",              // escrita via vinimachado-voice (ver abaixo)
  "caveat": "cam Tipo A upscaleia 420->1080, fica soft; aceitar",
  "covered_angle_key": "caso-real:kpis"  // pra dedupe (ver tabela de ângulos)
}
```

Campos obrigatórios: `source`, `source_type`, `start`, `end`, `anchor`, `angle`, `pill`,
`hook_card`, `cards_grid`, `caption`, `covered_angle_key`. `caveat` só quando há um (Tipo A soft,
áudio limítrofe, privacy a confirmar).

## Caption (via vinimachado-voice)

A caption vai na publicação do IG, **não** dentro do Reel. Escreve seguindo
`brand/.claude/skills/vinimachado-voice/SKILL.md` à risca:

- Voz `tu`, humana, direta. Confissão antes do acerto. Frase curta.
- Sem em-dash. Sem marketing-speak (game changer, insano, revolucionário, fórmula).
- Número só com fonte real (o próprio caso do Vini, log). Nada de estatística inventada.
- Todo termo de método (spec, agent, skill, hook, harness, lock-in) precisa de analogia pro Jean
  na mesma caption.
- CTA só pra coisa que existe: `/spec-4`, `/glossario`, VM — Vibe Coders, mentoria 1:1. Nunca
  oferece "Code Agent PRO".
- Fecha com a assinatura exata: **Vini. Método > prompt.**

Esqueleto (preenche, não publica cru):

```
[Hook de 1 linha: o mesmo do hook_card ou uma variação]

[3-5 linhas: o que tem no Reel, com a analogia pro Jean]

[CTA pra um destino que existe]

[3-5 hashtags]

Vini. Método > prompt.
```

## Diversidade de ângulos (evitar duplicar)

Um vídeo longo NÃO deve virar cinco Reels do mesmo ângulo. Cada Reel novo precisa abrir um ângulo
diferente, senão o feed repete e a retenção cai. Mantém uma tabela de controle por projeto em
`projects/<slug>/reels/ANGLES.md` (ou no `COMPANION.md`), uma linha por Reel:

| Reel | Ângulo | Trecho (start-end) | `covered_angle_key` | Pillar |
|---|---|---|---|---|
| r1-kpis-caso | número | 412.6-447.2 | caso-real:kpis | Caso Real |
| r2-sem-com   | comparação | 88.0-131.4 | caso-real:sem-vs-com | Caso Real |
| r3-licoes    | lista | 980.2-1024.0 | caso-real:6-licoes | Bastidor |

Antes de criar um Reel, checa o `covered_angle_key`: se já existe um com a mesma chave, **não**
cria duplicado. Ou muda o ângulo, ou pega outro trecho que pague um ângulo ainda não coberto. O
`vinimachado-reels` também mantém uma lista global de "ângulos já cobertos" entre vídeos; cruza com
ela pra não repetir o que já saiu no canal.

## Fluxo (resumo operável)

1. Lê `transcript.txt` e marca candidatos (frase-âncora cada um).
2. Casa cada âncora com `words.json` → `start`/`end` com respiro; cruza com `silences.txt`/`scenes.txt`.
3. Roda os 5 filtros (auto-contido, hook em 2s, 1 ângulo, áudio limpo, densidade). Descarta os fracos.
4. Define `angle` + `source_type` (A/B) de cada sobrevivente. Anota `caveat` (ex: Tipo A soft).
5. Confere com a tabela de ângulos pra não duplicar `covered_angle_key`.
6. Escreve a `caption` via `vinimachado-voice`.
7. Emite um `projects/<slug>/reels/<id>.md` por Reel (plano no topo + narrativa) e atualiza `ANGLES.md`.
8. Passa pelo `privacy-reviewer` (privacy + claims) antes de qualquer publicação.
9. Pra MONTAR, abre `brand/.claude/skills/vinimachado-reels/` e executa o sistema visual com o plano.

## Não faça (anti-patterns desta skill)

- ❌ Recriar canvas/HTML/build ffmpeg aqui (mora em `vinimachado-reels`).
- ❌ Cortar trecho que depende de contexto que não cabe no Reel.
- ❌ Cinco Reels do mesmo ângulo do mesmo vídeo.
- ❌ Caption com em-dash, marketing-speak ou número sem fonte.
- ❌ Tentar "salvar" câmera Tipo A soft com sharpening agressivo (vira artefato).
- ❌ Publicar antes do `privacy-reviewer` (slug/PR/repo/RPC reais, mentorado não-autorizado).
- ❌ Assinatura errada. É exatamente **Vini. Método > prompt.**, nunca "VM. Método > prompt".
