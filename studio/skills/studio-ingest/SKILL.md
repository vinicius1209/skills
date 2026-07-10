---
name: studio-ingest
description: Transformar uma gravação bruta em workspace analisável: frames a cada N segundos, silencedetect (gaps/dead-air/retakes) e scene-changes. Como cruzar SRT + frames + silêncios pra mapear o vídeo.
---

# Skill — Studio Ingest

Pega uma gravação crua e cospe três coisas que o agente consegue ler: **o que está na tela** (frames),
**onde tem buraco de áudio** (silences) e **onde o plano corta** (scenes). É o passo que transforma
um `.mp4` opaco num mapa de cenas pesquisável.

Pensa nisso como destrinchar a gravação: antes de editar tu precisa de uma planta da casa, não de
um vídeo de duas horas que tu tem que assistir inteiro de novo. Ingest é a planta.

A transcrição é outra coisa (skill `studio-transcription`) e roda em paralelo. Aqui é só vídeo + áudio
bruto, sem ASR.

## Quando usar

- Acabou de gravar e rodou `scripts/new_project.sh <slug> <src>`.
- Vai abrir um projeto pra `editor-companion` / `cut-planner` analisar.
- Precisa achar dead-air, retakes e trocas de cena sem assistir a gravação inteira.

## O que `ingest.sh` produz

```bash
scripts/ingest.sh <source-media> <out-dir> [fps_every_sec] [min_sil_sec] [noise_db]
# defaults: fps_every=10  min_sil=0.8  noise_db=-30
```

No fluxo padrão o `<out-dir>` é `projects/<slug>/ingest`:

```bash
scripts/ingest.sh raw/aula-spec.mp4 projects/aula-spec/ingest
```

Saída em `projects/<slug>/ingest/`:

| Arquivo | É | Pra quê |
|---|---|---|
| `probe.txt` | codec/res/fps/duração/bitrate (1 stream de vídeo + format) | sanity check antes de cortar |
| `frames/f%04d.jpg` | 1 frame a cada `fps_every` seg, escalado pra 480w | ver **o que está na tela** sem abrir o vídeo |
| `silences.txt` | log do `silencedetect`: pares `silence_start` / `silence_end` | achar dead-air e fronteira de retake |
| `scenes.txt` | timestamps de scene-change (`scene > 0.4`) | candidatos a corte / troca de plano |

Tudo é **não destrutivo**: nunca toca na mídia fonte. É só leitura + arquivos derivados.

### `probe.txt` — leitura rápida

```bash
cat projects/aula-spec/ingest/probe.txt
# width=1920 height=1080 codec_name=h264 r_frame_rate=30/1
# duration=4821.4 size=... bit_rate=...
```

`r_frame_rate=30/1` = 30 fps. Tu precisa disso pra converter timestamp em frame quando for fechar o EDL:
`frame = round(t_segundos * fps)`. Se o `r_frame_rate` for `30000/1001` (29.97), não arredonda pra 30,
usa o valor real ou o corte escorrega meio frame ao longo do vídeo.

## Como ler `silences.txt`

O `silencedetect` emite pares. Cada bloco silencioso é um `silence_start` seguido de um `silence_end`
(e o `silence_duration`):

```
[silencedetect @ ...] silence_start: 12.430
[silencedetect @ ...] silence_end: 14.980 | silence_duration: 2.55
[silencedetect @ ...] silence_start: 41.002
[silencedetect @ ...] silence_end: 41.890 | silence_duration: 0.888
```

Como interpretar:

- **Gap > 1s = dead-air.** Tu engasgou, tomou água, pensou. Candidato forte a trim. O bloco
  `12.430 → 14.980` (2.55s) é tempo morto: corta ou acelera.
- **Gap entre 0.8s e ~1.5s, seguido de repetição** = fronteira de retake. Tu errou a frase, parou,
  respirou e refez. O silêncio é a costura entre o take ruim e o bom. O **fim** do silêncio (`silence_end`)
  é onde o take novo começa, normalmente o ponto de corte.
- **Gaps curtos (< 1s)** = respiração natural de fala. Geralmente mantém, senão o corte fica ofegante.

`min_sil=0.8` por padrão pra já filtrar pausa de fala normal. Se tu fala devagar e está pegando
respiração demais como silêncio, sobe pra `1.0`. Se estás perdendo dead-air real, baixa o `noise_db`
de `-30` pra `-35` (mais sensível) ou sobe pra `-25` (menos sensível, ambiente barulhento).

One-liners úteis:

```bash
# Só dead-air de verdade: pares com duração > 1s (start, end, dur)
grep -A1 silence_start projects/aula-spec/ingest/silences.txt \
  | grep -oE 'silence_(start|end): [0-9.]+|silence_duration: [0-9.]+'

# Listar só os silêncios longos (> 1.5s) — os trims óbvios
grep -oE 'silence_duration: [0-9.]+' projects/aula-spec/ingest/silences.txt \
  | awk -F': ' '$2 > 1.5 {print $2"s"}'

# Quantos blocos de silêncio existem (= quantos trims potenciais)
grep -c silence_start projects/aula-spec/ingest/silences.txt

# Tabela start→end pra colar no raciocínio do cut-planner
paste <(grep -oE 'silence_start: [0-9.]+' projects/aula-spec/ingest/silences.txt | cut -d' ' -f2) \
      <(grep -oE 'silence_end: [0-9.]+'   projects/aula-spec/ingest/silences.txt | cut -d' ' -f2) \
  | awk '{printf "%-9s -> %-9s  (%.2fs)\n", $1, $2, $2-$1}'
```

## Como ler `scenes.txt`

Uma linha = um timestamp em segundos onde o `ffmpeg` detectou troca de cena acima de 0.4 de diferença:

```
0.000
73.512
210.880
612.330
```

O que cada um costuma ser:

- Tu trocou de slide / compartilhou tela diferente.
- A câmera cortou (se gravou multicam ou alternou fonte).
- Mudança grande de enquadramento ou de cena na captura de tela.

`scene > 0.4` é o limiar padrão (0.0 = idêntico, 1.0 = totalmente diferente). Em screencast com muito
movimento de UI tu pega falso-positivo: sobe pra `0.5`. Em talking-head parado tu pega de menos: baixa
pra `0.3` editando a linha do `ingest.sh`. Cruza sempre cada timestamp com o frame da janela mais próxima
antes de confiar.

```bash
# Quantas trocas de cena e em que minutos
awk '{printf "%02d:%02d\n", int($1/60), int($1%60)}' projects/aula-spec/ingest/scenes.txt
```

## Escolhendo a cadência de frames

O `fps_every` é o trade-off entre granularidade e quantidade de imagem pra processar.

| Cadência | Frame por... | Quando |
|---|---|---|
| `10` (default) | 10s | Mapear long-form. Vê estrutura do vídeo, não cada gesto. Um vídeo de 80min = ~480 frames. |
| `5` | 5s | Cortar reels. Precisa de granularidade fina pra pegar a melhor expressão / o melhor frame de hook. |
| `2`-`3` | 2-3s | Caçar UM frame exato (thumbnail, momento de reação). Roda em um trecho recortado, não no vídeo inteiro, senão estoura em milhares de jpg. |

Regra: 10s pra **entender o vídeo**, 5s pra **cortar reel**, e nunca rode 2s no vídeo cheio. Pra frame
fino de um trecho, corta o trecho primeiro e ingere só ele:

```bash
# Recorta 30s ao redor de um momento e ingere a 2s pra achar o frame perfeito
ffmpeg -y -ss 612 -t 30 -i raw/aula-spec.mp4 /tmp/momento.mp4
scripts/ingest.sh /tmp/momento.mp4 projects/aula-spec/ingest-momento 2
```

Cada frame vira tempo real assim: `f0001.jpg` é o segundo `0`, `f0002.jpg` é o segundo `fps_every`,
e em geral o frame `N` está em `t = (N-1) * fps_every`. Inverso: pra achar o frame de um timestamp `t`,
`N = floor(t / fps_every) + 1`.

```bash
# Qual frame olhar pra ver o que estava na tela aos 612s, com fps_every=10
echo "f$(printf '%04d' $(( 612/10 + 1 ))).jpg"   # -> f0062.jpg
```

## O método: cruzar SRT + frames + silêncios

Aqui é onde ingest deixa de ser três arquivos soltos e vira um **mapa de planos** (shot map). Os três
ativos respondem perguntas diferentes, e o corte mora na interseção:

| Ativo | Responde | Vem de |
|---|---|---|
| `transcript.srt` | **o que está sendo dito** (e quando) | `studio-transcription` |
| `frames/*.jpg` | **o que está na tela** | ingest |
| `silences.txt` | **onde dá pra cortar sem cortar fala** | ingest |
| `scenes.txt` | **onde o plano já trocou** | ingest |

Pensa nos três como três testemunhas do mesmo crime: o SRT ouviu, os frames viram, os silêncios sabem
quando ninguém estava falando. Sozinha cada uma mente um pouco; cruzando as três tu fecha o caso.

O raciocínio, em ordem:

1. **Lê o SRT como espinha** — ele tem timestamp + texto. É a linha do tempo do que foi dito. Pra prosa
   limpa usa o `transcript.txt`, mas pra cortar usa o `.srt` porque ele carrega o tempo.
2. **Confirma na imagem** — pra cada bloco que importa, abre o frame daquele timestamp. O SRT diz "agora
   eu mostro o spec"; o frame confirma se o spec já está na tela ou se tu ainda está no rosto. Isso decide
   se o corte entra antes ou depois.
3. **Encosta o corte no silêncio** — quando decidiu cortar um trecho, não corta no meio da fala. Procura
   o `silence_start`/`silence_end` mais próximo em `silences.txt` e encosta o corte ali. Corte na boca
   aberta dá "engole sílaba"; corte no silêncio é invisível.
4. **Respeita o scene-change** — se há um `scenes.txt` perto, prefere cortar nele. A imagem já trocou,
   o corte fica natural.

Resultado: uma **shot map** que o `cut-planner` consome. Cada linha amarra os três:

```
t_in     t_out    plano(frame)        fala(SRT)                        ação
00:01:12 00:01:14 f0008 = slide 1     "...então o que é uma spec"      KEEP
00:01:14 00:01:17 f0009 = rosto       (silêncio 2.55s, dead-air)       TRIM  ← silences.txt
00:01:17 00:02:30 f0011 = terminal    "olha o agente rodando..."       KEEP
00:02:30 00:02:33 f0015 = rosto       "deixa eu refazer essa parte"    DROP retake ← silence_end 02:33
```

One-liner pra montar o esqueleto da shot map a partir do SRT (timestamps + texto), que tu depois anota
com frame e ação:

```bash
# SRT -> "in -> out  texto" por bloco
awk '
  /-->/ { split($0,a," --> "); tin=a[1]; tout=a[2]; getline txt; print tin"  "tout"  "txt; next }
' projects/aula-spec/transcript.srt
```

E pra olhar o frame de qualquer timestamp da shot map enquanto raciocina (macOS):

```bash
open projects/aula-spec/ingest/frames/f0062.jpg   # o que estava na tela aos ~10:20 com fps_every=10
```

## Como isso alimenta o `cut-planner`

O `cut-planner` não assiste o vídeo. Ele lê:

- `transcript.srt` + `words.json` → texto e **timestamp por palavra** (corte frame-accurate).
- `ingest/silences.txt` → onde encostar cada corte sem cortar fala.
- `ingest/scenes.txt` → fronteiras de plano que viram pontos de corte naturais.
- `ingest/frames/` → confirma o que está na tela em cada decisão.

Com isso ele emite o `EDL.json` (keep-list, reorders, trims de silêncio, speed-ramps), que o
`scripts/render_edl.py` renderiza. A precisão de frame vem do `words.json` (palavra a palavra); o ingest
entra dizendo **onde o corte é seguro e bonito** (silêncio + scene-change) e **o que a câmera mostra**.

Resumindo o contrato: ingest dá o **mapa**, transcription dá o **timing exato da fala**, o `cut-planner`
junta os dois em `EDL.json`. Tu nunca corta às cegas: cada corte tem uma fala (SRT), uma imagem (frame)
e uma costura (silence/scene) por trás.

## Checklist antes de passar pro cut-planner

- [ ] `probe.txt` tem o fps real (cuidado com 29.97 vs 30).
- [ ] `frames/` tem a contagem esperada (`duração / fps_every`, +/-1).
- [ ] `silences.txt` não está vazio (se está, o `noise_db` está errado pro teu ambiente).
- [ ] `scenes.txt` faz sentido (nem 0 linhas, nem uma a cada segundo — ajusta o limiar).
- [ ] cadência certa pro objetivo: 10s long-form, 5s reel.
