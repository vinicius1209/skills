---
name: vinimachado-reels
description: Sistema de Reels VM — gera Reels 1080×1920 com câmera Vini full-bleed embaixo (40% altura) + conteúdo informativo em cards no topo + áudio original. Usado pra cortar trechos de vídeos longos em Reels prontos pra IG/TikTok.
---

# Skill — VM Reels

Sistema canônico pra produzir Reels do Vini a partir de vídeos longos (YouTube/gravações). Padrão visual fixo, conteúdo flexível.

## Quando usar

- Vini gravou vídeo longo (caso real, explainer, tutorial)
- Quer cortar trechos em Reels 30-60s pra IG
- Cada Reel destaca **1 ângulo único** do conteúdo (KPI hero, comparação, lista, exemplo)

## Anatomia canônica de um Reel VM

```
┌─────────────────────────────┐ ← 1080×1920 (9:16)
│  (respiro)                  │ ← y=0-249
│  ▮ PILL · UPPERCASE         │ ← y=250-320 (border yellow, mono)
│                             │
│  Hook headline grande       │ ← y=340-580
│  com hi yellow              │
│                             │
│  ┌────┐ ┌────┐ ┌────┐      │ ← y=580-1140 (cards)
│  │ 01 │ │ 02 │ │ 03 │      │
│  └────┘ └────┘ └────┘      │
│  ┌────┐ ┌────┐ ┌────┐      │
│  │ 04 │ │ 05 │ │ 06 │      │
│  └────┘ └────┘ └────┘      │
│                             │
├─────────────────────────────┤ ← y=1152 (cam start)
│                             │
│   Câmera Vini full-width    │ ← y=1152-1920 (40% altura)
│   1080×768, edge-to-edge    │
│   SEM borda, SEM gap        │
│                             │
└─────────────────────────────┘
```

**Não negociável (aprendizado v5 — R3 final):**
- Cam SEM borda amarela (ficava artificial)
- Cam FULL edge-to-edge (gap zero nas laterais)
- Cam ~40% da altura (768px de 1920)
- Sem footer "VM. Método > prompt." dentro do Reel (signature vem na caption)
- Pill yellow no topo carrega a identidade
- **Conteúdo descido pra evitar gap morto no meio** — pill top: 250 (não 60), hook top: 340 (não 145), cards top: 580-720 conforme densidade. Se sobrar buraco entre cards e cam → descer mais.

## Variações de cards (escolher conforme conteúdo)

| Tipo | Grid | Quando usar |
|---|---|---|
| **2 cards** | 1 col × 2 (lado a lado) | Comparação SEM vs COM, antes/depois |
| **4 KPIs** | 2 col × 2 row | Números hero (linha/tempo/cobertura) |
| **6 lições** | 3 col × 2 row | Lista de takeaways, princípios |
| **3 steps** | 1 col × 3 (stacked) | Passo a passo numerado |

## Paleta (do BRAND-VM)

- bg: `#010A14` (navy)
- text main: `#f3f4f6`
- highlight/CTA: `#FFF200` (yellow)
- card bg: `#071321` (surface)
- error/sem-metodo: `#ff4d4d` (red)
- border-top dos cards: `#FFF200` 6px

## Tipografia

- Pill (mono): SF Mono 22px, 800, +0.32em, uppercase, border-yellow 2px
- Hook: SF Pro 88-96px, 900, -0.045em, 0.96 line-height
- Card title: 26-30px, 900
- Card number/eyebrow: SF Mono 18-20px, 900, +0.22em, yellow
- KPI value: 88px, 900, yellow

## Montagem: SEMPRE via `scripts/reel.py` (nunca ffmpeg à mão)

O Reel é montado pelo renderizador determinístico do studio, não por ffmpeg solto no `/tmp`.
Foi exatamente o build ad-hoc que entregou Reel com **cabeça cortada** e **silêncio na abertura**:
a spec existia aqui, mas nada forçava ela. Agora força.

```bash
# 1. graphic HTML -> PNG (1080x1920)
python3 scripts/html2png.py build/graphic.html build/graphic.png
# 2. escreve build/reel.json: {source, graphic, segments:[{start,end}], cam:{crop,panel_w,panel_h,panel_y}, output}
# 3. PROVA o enquadramento num frame ANTES de assar:
python3 scripts/reel.py build/reel.json --probe   # gera <output>.probe.png — abre e confere headroom
# 4. assa:
python3 scripts/reel.py build/reel.json
# 5. gate obrigatório antes de publicar:
python3 scripts/qc.py OUT.mp4                       # silêncio na abertura, resolução, áudio, head-cut
```

`reel.py` garante: aborta se o aspecto do crop != aspecto do painel (é o que distorce/zooma demais
o rosto), apara silêncio de abertura (`trim_lead_silence`), e normaliza loudness (~-14 LUFS, pra
gravação quieta não sair 15 dB abaixo). `qc.py` é o "Definition of Done": sai com erro e barra publish.

## Regra de enquadramento (a que faltava — não-negociável)

A cabeça **nunca** pode encostar/passar do topo do painel da câmera. O que garante isso é a
**geometria do crop**, não a sorte:

1. **Aspecto do crop = aspecto do painel.** Painel 1080×1120 → crop com aspecto 0.964. Painel
   1080×768 → crop com aspecto 1.40. Diferente disso, `reel.py` aborta.
2. **Headroom vem da posição do crop**, e depende da orientação da fonte:
   - **Fonte landscape (webcam 2560×1440):** o crop tem que começar no **topo da fonte (Y=0)** e
     usar a **altura cheia** — assim o topo do quadro fica acima da cabeça em qualquer movimento.
   - **Fonte vertical (selfie de celular, exibe 1080×1920):** largura cheia (X=0); o **Y da janela**
     decide o headroom. Escolhe Y testando o frame mais "inclinado pra frente" (lean-in) do trecho.
3. **Probe antes de assar, sempre.** `--probe` no início E num frame de lean-in. Se a cabeça encosta
   no topo em qualquer um, sobe o crop (landscape: Y→0 / mais altura; vertical: Y menor).

Painel **quase-quadrado** (1080×1120, o "big cam" dos Reels do Fleube) força uma fonte landscape a
zoom central e corta cabeça se o crop não começar no topo — por isso a regra 2. O painel canônico
mais leve é 1080×768 (40%, paisagem), que casa melhor com webcam landscape; o 1120 é variação
"rosto grande" e exige a regra de headroom à risca.

## Webcam crop por tipo de source

Cada source tem layout próprio. **Sempre** provar antes (via `reel.py --probe`, não no olho):

```bash
# Test crop antes do build
ffmpeg -ss 60 -i SOURCE.mp4 -frames:v 1 -vf "crop=W:H:X:Y,scale=1080:768" /tmp/test.png
```

### Tipo C — Selfie de celular vertical (stories)

Source: `stories/*.mp4` (armazenado 1920×1080 com `rotation -90` → **exibe 1080×1920**). ffmpeg
auto-rotaciona, então o crop opera no frame vertical 1080×1920. Largura cheia, escolhe só o Y:

```
crop=1080:1120:0:Y    (painel big-cam; Y ~260-360 conforme a altura da cabeça na fonte)
overlay y=800
```

Valores já validados no Fleube 5: gancho (152452) `Y=260`; janela (152646) `Y=360`. O rosto é
inerentemente grande (fonte só tem 1080 de largura); o objetivo é cabeça inteira com headroom,
não o close "sobrancelha-a-queixo".

### Tipo A — Screen recording com webcam embutida (canto)

Source: `caso-real-rough-cut.mp4`, `video1-spec4-v3.mp4`, gravações com OBS/zoom split.

```
crop=420:300:40:1060   (aspect 14:10)
scale=1080:768          (fit full width)
overlay y=1152          (start at 60%)
```

**Atenção:** webcam embutida começa em `y≈900-1060` do source 2560×1440. Se zoom de conteúdo (top) bleed na zona da cam, ajustar Y limit.

### Tipo B — Webcam full-frame (talking head puro)

Source: `gancho1.mov`, `gancho2.mov`, vídeos só de cara sem screen split.

```
crop=1700:1214:430:0   (center crop mantendo 14:10)
scale=1080:768
overlay y=1152
```

Crop centralizado de 2560×1440 (1.78:1) pra 1.4:1 (1080×768). Ajustar X se cabeça ficar descentralizada.

## Workflow de identificação de cena/take

Antes de buildar, mapear o source com frames + transcrição em paralelo:

```bash
# Extract frames cada 5s pra inspeção visual
mkdir -p /tmp/probe-SOURCE
ffmpeg -y -i SOURCE.mov -vf "fps=1/5,scale=480:-1" /tmp/probe-SOURCE/f%03d.jpg -loglevel error

# Audio mono 16kHz pra whisper
ffmpeg -y -i SOURCE.mov -vn -ac 1 -ar 16000 /tmp/probe-SOURCE.wav -loglevel error
whisper /tmp/probe-SOURCE.wav --model small --language pt --output_format srt
```

Cruzar SRT (o que se fala) com frames (o que aparece) pra escolher start/end exato. Vídeos longos costumam ter **múltiplos takes da mesma fala** — pegar o mais limpo (sem "perai", tosse, hesitação). Take 2 ou 3 geralmente é o mais refinado.

## Template HTML padrão

Estrutura mínima reusável (preencher `[PLACEHOLDERS]`):

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  html, body {
    width: 1080px; height: 1920px;
    background: #010A14;
    overflow: hidden;
    font-family: -apple-system, "SF Pro Display", system-ui, sans-serif;
    color: #f3f4f6;
    -webkit-font-smoothing: antialiased;
  }
  .canvas { width: 1080px; height: 1920px; position: relative; }

  .pill {
    position: absolute; top: 60px; left: 0; right: 0;
    text-align: center;
    font-family: ui-monospace, "SF Mono", monospace;
    font-size: 22px; font-weight: 800;
    letter-spacing: 0.32em; text-transform: uppercase;
    color: #FFF200;
  }
  .pill span {
    background: #010A14;
    padding: 10px 26px 12px; border-radius: 4px;
    border: 2px solid #FFF200;
  }

  .hook {
    position: absolute; top: 145px; left: 50px; right: 50px;
    text-align: center;
  }
  .hook h1 {
    font-size: 92px; font-weight: 900;
    letter-spacing: -0.045em; line-height: 0.96;
  }
  .hook h1 .hi {
    background: #FFF200; color: #010A14;
    padding: 0 16px 8px;
    display: inline-block; line-height: 1.0;
  }
  .hook h1 .strike {
    color: #ff4d4d;
    text-decoration: line-through;
    text-decoration-thickness: 8px;
    text-decoration-color: rgba(255,77,77,0.55);
  }

  /* CARDS — adaptar grid-template-columns ao tipo:
     2 cards  → 1fr 1fr
     4 cards  → 1fr 1fr (2x2)
     6 cards  → 1fr 1fr 1fr (3x2)
  */
  .cards {
    position: absolute;
    top: 430px; left: 50px; right: 50px;
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;  /* AJUSTAR */
    gap: 18px;
  }
  .card {
    background: #071321;
    border-top: 6px solid #FFF200;
    border-radius: 14px;
    padding: 26px 20px;
    min-height: 280px;
  }
  .card .n {
    font-family: ui-monospace, "SF Mono", monospace;
    font-size: 20px; font-weight: 900;
    color: #FFF200;
    letter-spacing: 0.22em;
    margin-bottom: 16px;
  }
  .card .t {
    font-size: 30px; font-weight: 900;
    color: #f3f4f6;
    letter-spacing: -0.025em; line-height: 1.08;
  }

  /* CAM full-bleed bottom — INVARIÁVEL */
  .cam-frame {
    position: absolute;
    bottom: 0; left: 0; right: 0;
    width: 1080px; height: 768px;
    overflow: hidden;
    background: #010A14;
  }
</style>
</head>
<body>
<div class="canvas">

  <div class="pill"><span>▮ [PILL TEXT UPPERCASE]</span></div>

  <div class="hook">
    <h1>[Hook com] <span class="hi">[palavra-chave]</span> [resto].</h1>
  </div>

  <div class="cards">
    <div class="card"><div class="n">01</div><div class="t">[Card 1]</div></div>
    <div class="card"><div class="n">02</div><div class="t">[Card 2]</div></div>
    <!-- ... -->
  </div>

  <div class="cam-frame"></div>

</div>
</body>
</html>
```

## Build script padrão

```bash
#!/usr/bin/env bash
# Reel build template
set -euo pipefail

VID="[PATH_TO_SOURCE_MP4]"
GRAPHIC_HTML="/tmp/reel-XXX-graphic.html"
GRAPHIC_PNG="/tmp/reel-XXX-graphic.png"
OUT="/Users/viniciusmachado/Movies/reel-XXX.mp4"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

START=[SECONDS]  # início do trecho
END=[SECONDS]    # fim do trecho
DURATION=$((END - START))

# 1. Render graphic via Chrome headless
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --default-background-color=00000000 \
  --window-size=1080,1920 \
  --screenshot=$GRAPHIC_PNG \
  "file://$GRAPHIC_HTML" 2>&1 | grep -i written

# 2. ffmpeg compose:
#    - Source video (audio + webcam zone)
#    - Graphic PNG (full canvas overlay)
#    - Cam extracted from source, scaled to 1080x768, placed at y=1152
ffmpeg -y \
  -ss $START -to $END -i "$VID" \
  -loop 1 -t $DURATION -i "$GRAPHIC_PNG" \
  -filter_complex "\
    [0:v]crop=420:300:40:1060,scale=1080:768,setsar=1[cam]; \
    [1:v][cam]overlay=0:1152:format=auto[final] \
  " \
  -map "[final]" -map 0:a \
  -t $DURATION \
  -c:v libx264 -profile:v high -pix_fmt yuv420p -r 30 \
  -c:a aac -ar 48000 -ac 2 -b:a 128k \
  "$OUT" -loglevel error -stats 2>&1 | tail -1

echo "Pronto: $OUT"
```

## Conteúdo — como escolher

Pra cada Reel, escolher **1 ângulo único**:

- **Hero (números)**: KPIs visuais grandes. Funciona pra viralizar.
- **Didático (comparação)**: SEM vs COM método. Funciona pra educar.
- **Lista (lições)**: 6 takeaways em grid. Funciona pra salvar.
- **Exemplo aplicado**: Spec aplicado a caso específico (Personal, CRM, etc).
- **Hook/Cold open**: Primeiros 30-60s do vídeo, sem cortes. Funciona quando o cold open já tem hook+tese.

## Caption do Reel (acompanha o Reel)

Caption vai na publicação do IG, NÃO no Reel em si. Padrão:

```
[Hook 1 linha — mesmo do Reel ou variação]

[3-5 linhas explicando o que tem no Reel]

[CTA: link bio, ou comenta PALAVRA]

[3-5 hashtags]

— Vini
```

CTA do Reel sempre vai pro lead magnet mais relevante:
- R1 KPIs / R3 Lições → `vinimachado.dev/spec-4`
- R2 Sem vs Com → mesmo
- R com exemplo Personal → mesmo

## Anti-patterns (NUNCA)

- ❌ Bordas amarelas grossas na cam (ficava artificial)
- ❌ Gap entre cam e laterais (perde força)
- ❌ Cam maior que 50% da altura (mata conteúdo informativo)
- ❌ Footer "VM. Método > prompt." dentro do Reel (compete com CTA da caption)
- ❌ Texto miúdo nos cards (precisa ler em celular)
- ❌ Em-dash (—) em qualquer texto público
- ❌ Marketing-speak (game changer, insano, transformador)
- ❌ Mais de 6 cards (vira ruído)

## Arquivos de referência

Exemplos buildados (de onde puxar quando criar novos):

- **R3 final (6 lições, layout descido v5)** — Tipo A (caso-real screen+cam): `/tmp/r3-final-graphic.html` + `/tmp/build-r3-final.sh` → `/Users/viniciusmachado/Movies/reel-caso-r3-final.mp4`
- **R1 multi-zoom (KPIs com zoom dinâmico)** — Tipo A: `/tmp/r1-dynamic-overlay.html` + `/tmp/build-r1-multi-cut.sh` → `/Users/viniciusmachado/Movies/reel-caso-r1-multi-cut-v5.mp4`
- **R2 v4 (Sem vs Com)** — Tipo A: `/tmp/r2-v4-graphic.html` → `reel-caso-r2-v4-montado.mp4`
- **Gancho "decisão no chat" (sintomas em lista)** — Tipo B (gancho2 full webcam): `/tmp/reel-gancho-graphic.html` + `/tmp/build-reel-gancho.sh` → `reel-gancho-decisao-no-chat.mp4`
- **Spec-4 método (promise + 4 blocos)** — Tipo B (vid-0527-1832 intro): `/tmp/reel-spec4-method-graphic.html` + `/tmp/build-reel-spec4-method.sh` → `reel-spec4-method-1h.mp4`

## Ângulos já cobertos (evitar duplicar)

| Reel | Ângulo | Fonte | Pillar |
|---|---|---|---|
| R1 multi-cut v5 | KPIs do caso (5h, 1 PR, 5 robôs, 4162 testes) | caso-real | Caso Real |
| R2 v4 | Sem método vs Com método (comparação) | caso-real | Caso Real |
| R3 final | 6 lições do caso | caso-real | Caso Real |
| Gancho decisão | "Problema é onde você guarda decisão" (sintomas) | gancho2 | Bastidor |
| Spec-4 método | "1 feature em 1h, 4 blocos do método" (promise) | vid 0527-1832 | Bastidor |

Próximos ângulos a explorar (não repetir os acima): Glossário de termo (Reel 40s), Prompt da semana, Caso Real outro projeto, Bastidor mentoria.

## Fluxo completo de produção

1. **Identifica source video** (caso-real, video1, etc) e mapeia o que tem (transcrição via whisper + frames a cada 5-30s)
2. **Confirma privacy** se o source mostra projeto identificável (Prime Sales Hub). Se sim, decidir se anonimiza ou usa só material limpo
3. **Escolhe trecho** (timestamp início/fim) baseado em densidade de conteúdo + áudio limpo (sem "perai", tosse, abre janela)
4. **Define ângulo do Reel** (1 de: hero/didático/lista/exemplo)
5. **Cria graphic HTML** copiando o template acima, preenchendo placeholders
6. **Cria build script** copiando o template acima, ajustando paths
7. **Roda build** → MP4 1080×1920 pronto
8. **Verifica preview** extraindo 1 frame middle (`ffmpeg -ss DUR/2 -i OUT -frames:v 1 preview.png`)
9. **Cross-check privacy** (zona da câmera Vini não revela tela secundária com dados sensíveis)
10. **Escreve caption** seguindo padrão `vinimachado-voice` skill
11. **Cross-post** Reel + Stories (mesma duração, Reel automático vai pro grid)
