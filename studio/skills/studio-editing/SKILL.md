---
name: studio-editing
description: Craft de edição de long-form YouTube + toolchain ffmpeg/EDL: jump cuts, corte de silêncio, J/L cuts, punch-in zoom, speed-ramp, denoise, b-roll, e como montar/renderizar o EDL.
---

# Skill: Studio Editing (long-form)

O craft de edição do canal e a toolchain que executa o corte. A divisão é a mesma do resto do
estúdio: o julgamento editorial (o que cortar, onde acelerar, quando dar zoom) é tarefa de
agente; a execução (transformar a decisão em vídeo) é tarefa determinística do
`scripts/render_edl.py`. O agente nunca reimplementa ffmpeg na mão. Ele escreve um `EDL.json` e
deixa o script renderizar.

EDL = lista de decisões de corte. Pensa nela como a **receita escrita antes de cozinhar**: cada
linha diz qual pedaço do bruto entra, em que ordem e em que velocidade. O bruto nunca é tocado.

## Quando usar esta skill

- O `cut-planner` vai emitir um `EDL.json` e precisa saber qual técnica aplicar em cada trecho.
- O `editor-companion` está montando o roughcut e quer o vocabulário de corte certo no
  `COMPANION.md`.
- Alguém precisa entender o schema do EDL ou como o render funciona antes de mexer.

Não use pra Reels/Shorts verticais (isso é `studio-reels-longform` + `brand/.../vinimachado-reels`).
Não use pra decidir a narrativa/retenção (isso é `studio-retention`). Aqui é só o **como cortar**.

## Regra de ouro: corte é não-destrutivo

Nunca sobrescreve o arquivo de origem. Todo render sai num arquivo novo (`-roughcut.mp4`,
`-v2.mp4`). O bruto (`source`) é sagrado. Se errou o corte, ajusta o EDL e renderiza de novo. O
EDL é texto, versionável, barato de refazer. O vídeo renderizado é descartável.

## As técnicas de edição (e quando cada uma entra)

### Jump cut
Remover o tempo morto entre frases mantendo o mesmo enquadramento. É o corte padrão do canal:
toda pausa longa, "éééé", respiração ou retomada de fala vira um corte duro. No EDL isso é
simplesmente **dois segmentos `keep` adjacentes** com um buraco entre eles (o fim de um não
encosta no início do próximo). O `render_edl.py` já põe um fade de áudio de 20ms em cada junção
pra matar o clique.

Quando: sempre. É o que dá ritmo de canal de tech ao vídeo.

### Corte de silêncio (silence trim)
Caso especial do jump cut, guiado por dado. O `scripts/ingest.sh` gera `ingest/silences.txt`
(via ffmpeg `silencedetect`). Cada bloco de silêncio acima de ~700ms é candidato a corte. O
`cut-planner` lê esse arquivo, cruza com `words.json` (timestamps de palavra do whisper-1) e
fecha os pontos de corte exatos no frame.

Quando: limpar dead air sem cortar conteúdo. Cuidado pra não cortar pausa dramática proposital.

### J-cut / L-cut
Cortes onde áudio e vídeo não trocam no mesmo instante.
- **J-cut**: o áudio do próximo trecho entra **antes** do vídeo (ouço a próxima ideia, ainda
  vendo a anterior). Ótimo pra emendar pensamentos sem solavanco.
- **L-cut**: o áudio do trecho atual continua **depois** do vídeo já ter trocado (a voz segura,
  a imagem corta pra b-roll ou pra tela).

O `render_edl.py` faz cortes duros (áudio e vídeo juntos). Pra J/L cut de verdade você descola
as trilhas, e isso hoje é manual no editor (DaVinci/Premiere) ou via receita em
`docs/FFMPEG-RECIPES.md`. No EDL, anota a intenção no `label` (ex: `"label": "L-cut: voz segura
sobre b-roll do terminal"`) pra não perder a decisão no roughcut.

Quando: transições entre blocos, ou pra esconder um jump cut feio com a continuidade do áudio.

### Punch-in zoom (110–125%)
Dar um zoom de 110% a 125% no enquadramento pra criar um segundo "ângulo" sem segunda câmera.
Quebra a monotonia da cabeça parada e marca um momento de ênfase (a frase que importa, a
confissão, o número). Acima de ~125% começa a pixelar e parece desespero. Mantém entre
110 e 125%.

Quando: a cada 20–40s de fala parada, ou em cima da frase-chave do trecho. No EDL marca no
`label` o ponto e o fator (ex: `"label": "punch-in 115% na frase do prejuizo"`). Na camada de
finishing, isso vira `punchins[]` no `finish-schedule.json` e roda por `scripts/composite.py`.

### Speed-ramp (2–4x)
Acelerar trechos de baixo conteúdo informativo: escrever no canvas/quadro, esperar build/deploy,
arrumar setup, navegar menu. 2x pra coisa que ainda precisa ser lida; 3–4x pra pura espera.
No EDL é nativo: `"speed": 2.0` no segmento. O render aplica `setpts` no vídeo e encadeia
`atempo` no áudio (que só vai até 2.0, então o script encadeia automaticamente pra fatores
maiores). O áudio acelerado fica agudo; pra dead air puro, considera mutar (receita no doc).

Quando: canvas-writing, dead air, espera de máquina. Nunca acelera explicação ou confissão.

### Audio denoise
Tirar chiado de fundo, ar-condicionado, hum. No EDL é o campo `audio_denoise`, aplicado no
output inteiro (ex: `"afftdn=nf=-25"`). `nf` é o piso de ruído em dB: mais negativo = mais
agressivo. Exagerou, a voz fica metálica/embaixo d'água. Começa em `-25` e só sobe se precisar.

Quando: sempre que o bruto tem ruído de fundo audível. Se o áudio já tá limpo, deixa de fora.

### B-roll
Cobrir a fala com imagem de apoio: tela do editor, terminal rodando, o app real (com slug/PR/repo
**borrados**, regra de privacidade), diagrama. Esconde jump cut, ilustra o que tá sendo dito,
dá descanso visual.

Quando: enquanto a voz explica algo que tem imagem ("aqui eu rodei o agent e ele..."). No EDL,
marca no `label` onde entra e o que cobre. Na camada de finishing, isso vira `brolls[]` no
`finish-schedule.json` e roda por `scripts/composite.py`. Corte simples (trocar a câmera pela tela
inteira) pode virar um `keep` da fonte certa se o b-roll já estiver gravado na mesma timeline.

### Lower-third / cards overlay
Texto sobreposto: nome/título (lower-third), card de definição de termo, KPI grande, citação.
Usa a paleta da marca (navy `#010A14`, amarelo `#FFF200`, texto `#f3f4f6`, surface `#071321`,
vermelho `#ff4d4d` só pra alerta). **Todo termo de método no card precisa da tradução do Jean na
tela ou na fala** (spec = a regra do jogo escrita antes do código; agent = funcionário digital;
hook = gatilho automático). Sem em-dash em texto na tela.

Quando: apresentar a si mesmo, ancorar um número (com fonte real), destravar uma palavra técnica.
Overlays são camada de finishing por cima do roughcut. Gerar PNG com `scripts/overlay.py` e aplicar
com `scripts/composite.py`.

Regra de layout: lower-third, callout e b-roll em janela nao usam canto fixo como aposta. Gere PNG
movel no manifesto (`"canvas": "box"`) e use `"placement": "auto"` no `finish-schedule.json`. O
`composite.py` chama `layout_guard.py`, amostra os frames daquele cue e escolhe a posicao que menos
cobre camera, rosto, texto no canvas ou tela importante. Posicao fixa so e aceitavel quando o guard
passa. `allow_overlap: true` e excecao explicita para card de quadro cheio ou cobertura editorial
intencional.

## O schema do EDL.json

`EDL.json` é a entrada do `scripts/render_edl.py`. Schema mínimo:

| Campo | Obrig. | O que é |
|---|---|---|
| `source` | sim | caminho do bruto (nunca é alterado) |
| `output` | sim | caminho do render novo (não-destrutivo) |
| `keep` | sim | lista de segmentos a manter, **na ordem final** |
| `fps` | não | frames por segundo do output (default 30) |
| `audio_denoise` | não | filtro ffmpeg aplicado no output inteiro (ex: `afftdn=nf=-25`) |

Cada item de `keep[]`:

| Campo | Obrig. | O que é |
|---|---|---|
| `start` | sim | segundo inicial no bruto (use `words.json` pra fechar no frame) |
| `end` | sim | segundo final no bruto |
| `speed` | não | fator de velocidade (default 1.0; 2.0 = dobro; aceita >2 e <0.5) |
| `label` | não | nota humana do trecho (não afeta o render, mas documenta a decisão) |

## Como o render_edl.py vira corte

`python3 scripts/render_edl.py projects/<slug>/EDL.json`

O que ele faz, exatamente:

1. **Reordena pela ordem da lista.** Os segmentos saem na sequência em que aparecem em `keep[]`,
   não na ordem do bruto. É assim que você joga um cold open lá do meio pro começo: basta listá-lo
   primeiro.
2. **Cortes duros (jump cuts).** Cada segmento é um `trim`/`atrim` independente, concatenados
   (`concat`). Sem crossfade de vídeo: corte seco, padrão do canal.
3. **Fade de áudio de 20ms em cada junção.** Mata o clique/estalo no ponto de corte. É o `fade`
   de `0.02s` aplicado no início e no fim de cada leg de áudio.
4. **Speed-ramp por segmento.** `speed` aplica `setpts=PTS/speed` no vídeo e encadeia `atempo`
   no áudio (atempo só vai de 0.5 a 2.0, então o script encadeia sozinho pra fatores maiores).
5. **Denoise opcional no output inteiro** via `audio_denoise`.
6. **Encode fixo:** H.264 `libx264`, `crf 18`, preset `medium`, `yuv420p`, áudio AAC 48 kHz
   stereo 192k. Output mp4.

`--dry-run` imprime o comando ffmpeg completo + a duração final estimada e **não renderiza nada**.
Use sempre antes de um render pesado pra conferir a duração e os argumentos.

```bash
python3 scripts/render_edl.py projects/<slug>/EDL.json --dry-run   # confere cmd + duração
python3 scripts/render_edl.py projects/<slug>/EDL.json             # renderiza de verdade
```

## Mini-exemplo de EDL

Cold open puxado do meio pro começo, intro logo depois, e um trecho de canvas-writing acelerado
2x no fim. Bruto e output em arquivos separados (não-destrutivo):

```json
{
  "source": "projects/exemplo/source.mov",
  "output": "projects/exemplo/exemplo-roughcut.mp4",
  "fps": 30,
  "audio_denoise": "afftdn=nf=-25",
  "keep": [
    {"start": 154.2, "end": 207.8, "label": "cold open: o erro que custou caro (puxado do meio)"},
    {"start": 0.0,   "end": 44.3,  "label": "intro + promessa do video"},
    {"start": 44.3,  "end": 152.0, "label": "desenvolvimento: o metodo"},
    {"start": 235.0, "end": 295.0, "speed": 2.0, "label": "speed-ramp 2x: escrevendo a spec no canvas"},
    {"start": 295.0, "end": 330.0, "label": "fechamento + CTA /spec-4"}
  ]
}
```

Lê assim: o vídeo começa pela tensão (154.2–207.8), volta pra promessa (0–44.3), entrega o
desenvolvimento, acelera a parte de escrever no canvas, e fecha. O bruto continua intocado;
quem mexe é só o `exemplo-roughcut.mp4`.

## Pra fundo

- **`docs/EDL-FORMAT.md`**: o schema completo do EDL, todos os campos, edge cases e validação.
- **`docs/FFMPEG-RECIPES.md`**: receitas copy-paste pra punch-in zoom, J/L cut, mute em
  speed-ramp, crop/scale, overlay de card e concat fora do EDL.

## Antes de fechar o corte (checklist de marca)

- Cortes não-destrutivos: o `source` não foi tocado, o render saiu em arquivo novo.
- Sem em-dash em qualquer texto na tela (card, lower-third, título, legenda).
- Slugs/PRs/repos/RPCs reais borrados em todo b-roll de tela. Filha nunca por nome.
  Mentorado/cliente só anonimizado e autorizado; Jean (Meu Ingresso) pode por nome.
- Todo termo de método que aparece em card tem a tradução do Jean junto (na tela ou na fala).
- Número na tela só com fonte real. Nada inventado.
- CTA aponta só pro que existe: /spec-4, /glossario, VM — Vibe Coders, mentoria 1:1.
  Nunca "Code Agent PRO".
- Assinatura, quando entra, é exatamente: `Vini. Método > prompt.`
