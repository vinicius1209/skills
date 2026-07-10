# studio/ — Sala de edição de YouTube

As skills que carregam o **julgamento editorial** do estúdio de vídeo do Vini
(`vinimachado-studio`): da pré-produção do roteiro ao corte frame-accurate, passando
por transcrição, retenção, Reels e criativos sociais.

O princípio do estúdio é a divisão em dois trilhos: **scripts determinísticos** fazem
o trabalho mecânico (transcrever, extrair frames, detectar silêncio, renderizar) e as
**skills + agentes** carregam a decisão editorial. As skills nunca reimplementam o que
um script já faz: elas mandam rodar o script e raciocinam sobre a saída.

## As skills

| Skill | O que carrega |
|---|---|
| [`studio-scripting`](skills/studio-scripting/) | Pré-produção: funil tema → ângulo → outline → roteiro falado, na voz VM, dentro da régua de retenção. Cérebro do show-runner e do scriptwriter. |
| [`studio-transcription`](skills/studio-transcription/) | Transcrição "full power" com a API da OpenAI: `whisper-1` (timestamp por palavra) + `gpt-4o-transcribe` (texto limpo). Quando/como rodar o harness e como ler a saída. |
| [`studio-ingest`](skills/studio-ingest/) | Transforma a gravação bruta em workspace analisável: frames a cada N segundos, `silencedetect` (gaps/dead-air/retakes) e scene-changes. |
| [`studio-retention`](skills/studio-retention/) | Rubrica de retenção e storytelling: cold open, primeiros 30s, arco promessa→payoff, pattern interrupts, capítulos, títulos e thumbnails. Cérebro do editor-companion. |
| [`studio-editing`](skills/studio-editing/) | Craft de edição long-form + toolchain ffmpeg/EDL: jump cuts, corte de silêncio, J/L cuts, punch-in, speed-ramp, b-roll, e como montar/renderizar o EDL. |
| [`studio-reels-longform`](skills/studio-reels-longform/) | Ponte editorial: quais trechos de um vídeo longo viram Reel e qual o plano de corte de cada um. O sistema visual mora em [`../brand/skills/vinimachado-reels`](../brand/skills/vinimachado-reels/). |
| [`studio-social`](skills/studio-social/) | Criativos e capas pra redes (Reels/Feed/Stories): brief de `creative.json`, render determinístico na identidade VM. Cérebro do social-manager. |

## Como usar

Cada skill é uma pasta com `SKILL.md`. Copie a pasta pra `.claude/skills/` do projeto
de edição que vai consumir.

> **Snapshot + acoplamento.** Estas são cópias curadas. A fonte viva roda dentro de
> `vinimachado-studio/.claude/skills/`, e várias delas citam caminhos locais do estúdio
> (`scripts/render_edl.py`, `projects/<slug>/`, `brand/`). Fora do estúdio elas valem
> como **referência do craft**, não como plug-and-play: sem os scripts e o symlink
> `brand/`, os comandos não rodam. Ao editar, mantenha uma direção só de sync com o
> estúdio pra não divergir.
