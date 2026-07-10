---
name: vinimachado-design
description: Sistema de design dos carrosseis e surfaces visuais do Vini. Paleta navy/yellow/blue alinhada à landing vinimachado.dev, tipografia SF Apple, formato 1080×1350px para Instagram, padrão dos 7 slides, gimmicks visuais (logo VM SVG, símbolo ▮ em azul/amarelo conforme fundo, marquee amarelo, sublinhado handwritten, pill amarelo bubble), e pipeline de build via Chrome headless + pdftoppm.
---

# VM Design System — surfaces visuais do Vini

Sistema **único e unificado** pra todo carrossel, lead magnet e surface visual do Vini. Vem direto da landing `vinimachado.dev`. Quem vê o post e abre o site sente continuidade.

## Formato

- **Dimensões:** 1080 × 1350px (Instagram 4:5, sweet-spot pra mobile)
- **Quantidade de slides:** **7** (carrosséis IG aceitam até 10, mas 7 é o que o Vini adotou)
- **Padding interno:** `90px 84px` em cada slide
- **Print-to-pdf via Chrome:** `@page { size: 1080px 1350px; margin: 0; }`

## Paleta canônica (extraída de `src/index.css`)

```css
:root {
  /* Surfaces */
  --vm-bg:             #010A14;   /* deep navy — background dos surfaces escuros */
  --vm-surface:        #071321;   /* navy mais claro pra cards/painéis em fundo escuro */
  --vm-surface-hover:  #0c1c2f;   /* hover/elevated state em surface escuro */
  --vm-light:          #ffffff;   /* surfaces claros (drawer, bento cards) */
  --vm-light-soft:     #f3f4f6;   /* surface claro suave */

  /* Brand */
  --vm-primary:        #FFF200;   /* Brand Yellow — destaque, CTAs, sublinhados */
  --vm-blue:           #007AFF;   /* Brand Blue / AI Glow — logo, ▮ em fundo claro, eyebrow */

  /* Texto */
  --vm-text:           #f3f4f6;   /* texto principal em fundo escuro */
  --vm-text-dark:      #010A14;   /* texto principal em fundo claro */
  --vm-text-muted:     #9ca3af;   /* texto secundário em fundo escuro */
  --vm-text-muted-dark:#6b7280;   /* texto secundário em fundo claro */

  /* Linhas */
  --vm-line:           rgba(255,255,255,0.08);  /* divisor em fundo escuro */
  --vm-line-dark:      rgba(0,0,0,0.08);        /* divisor em fundo claro */
}
```

**Restrições:**
- **Não inventar cor nova.** A paleta é fechada — yellow, blue, navy, branco, mais cinzas de texto.
- **Gradiente proibido.** Geometria pura, cor chapada.
- **Sombra só quando funcional** (glow no `▮` se animado, drop-shadow leve em pill bubble). Nada de "card bonito com shadow grande".

## Tipografia — SF Apple

```css
font-family: "SF UI Display", -apple-system, BlinkMacSystemFont, "SF Pro Display", "SF Pro", system-ui, sans-serif;
font-family-mono: "SF Mono", SFMono-Regular, ui-monospace, Menlo, Monaco, Consolas, monospace;
```

- **Display + body:** SF UI Display (Apple). Pesos disponíveis: 400, 500, 600, 700, 800, 900.
- **Monoespaçada:** SF Mono. Pra eyebrow, terminal panel, código, árvore de arquivos.
- **Build só em macOS.** SF Apple não é fonte web — não tem CDN. O Vini só builda em Mac, então é seguro. Em outra máquina o fallback chain cobre (system-ui, sans-serif).

**Letter-spacing:**
- Display massive (bordão, hero): `-0.04em` (negativo agressivo)
- Display normal: `-0.025em`
- Body: padrão
- Uppercase labels/eyebrow: `0.18-0.24em`

**Line-height:**
- Display massive: `0.88-0.94`
- Display normal: `1.0-1.05`
- Body: `1.4-1.5`

**Observação importante:** SF Apple **não tem o peso 900 tão acentuado** que o Cabinet Grotesk tinha. Pra compensar a sensação "brutal", a régua canônica usa **tamanhos maiores** e **tracking mais negativo**. Não força um `font-weight: 900` esperando o mesmo resultado — SF nesse peso já é massiva.

## Modos de slide

São **3 modos** de fundo, escolhidos por slide. A regra é alternar pra criar ritmo. Não tem mais "light vs dark" — tem três:

| Modo | Background | Texto | Quando usar |
|---|---|---|---|
| `.slide.dark` | `--vm-bg` (`#010A14`) | `--vm-text` | Bordão (slide 4), CTA (slide 7), tese pesada |
| `.slide.surface` | `--vm-surface` (`#071321`) | `--vm-text` | Card/painel intermediário, prova visual com elevação |
| `.slide.light` | `--vm-light` (`#ffffff`) | `--vm-text-dark` | Slides de conteúdo respirado, bento, dor/método |

Ritmo típico canônico: `dark, light, light, dark, surface, light, dark` (capa pesada → conteúdo claro → bordão escuro → método em surface → método claro → CTA escuro). Mas pode variar conforme o tema.

## Tratamentos de feed (A / B / C) — ritmo entre posts

> **Atenção:** isso é ritmo de FEED (post a post no grid), não de SLIDE (dentro do carrossel). Os 3 modos de slide acima continuam valendo internamente. A diferença é o **tratamento dominante** que define como o post aparece na grade do Instagram quando o Jean rola o feed.
>
> Decidido em 2026-06-03 com o Vini: feed cold (754 seguidores, em formação) não suporta repetição visual. Todo carrossel atual usa o mesmo tratamento (navy + amarelo + headline pill bubble) — bonito isolado, monótono em sequência. Solução: 3 tratamentos alternados.

### A — Tese forte (navy/amarelo)

**Quando o feed mostra:** capa `.slide.dark` com headline gigante 2 linhas em branco+amarelo, pill amarelo dominante.

**Propósito:** tese contundente, posicionamento, manifesto, glossário. Atende **Jean-curioso**.

**Exemplos no acervo atual:** `01-reposicionamento`, `05-agent-nova-linha`, `06-cinco-paredes`, `10-spec4-explainer`.

**Marca diferencial:**
- Capa `.slide.dark`, headline `font-size: 140-200px`, 2 linhas
- Palavra-chave em pill amarelo bubble
- Ritmo interno típico `dark / light / light / dark / surface / light / dark`

### B — Carta (off-white editorial)

**Quando o feed mostra:** capa `.slide.light` (#ffffff ou #f3f4f6) com texto navy, **zero pill amarelo na capa**, peso editorial, fonte grande, ar generoso.

**Propósito:** "pensamento em voz alta", carta pessoal, post-mortem honesto, narrativa com vulnerabilidade. Atende **Jean-prejuízo** (carta sobre erro caro) e fio condutor pessoal+tech (foto com ponte).

**Diferenças canônicas pra não ser só "A invertido":**
- Capa branca pura, texto navy `#010A14`
- Headline `font-size: 96-128px`, **letter-spacing maior** (`-0.015em`, não `-0.04em`) — peso de livro, não de cartaz
- Sem pill, sem sublinhado handwritten — só tipografia + espaço
- Eyebrow opcional `▮ carta · ed. NN` em azul `#007AFF`
- Aspa grande estilo NYT opcional como gimmick (quote ornamental gigante atrás do texto)
- Ritmo interno típico `light / light / dark / light / surface / light / dark` (1 slide escuro pro bordão central, resto respirado)
- Slide 7 CTA pode ser `.light` também (link bio implícito, sem pill amarelo) — quebra com a fórmula A

**Quando NÃO usar B:** assunto contundente/manifesto (vai pra A) ou prova visual de método (vai pra C).

### C — Bastidor / prova (screenshot real)

**Quando o feed mostra:** capa com **screenshot real anonimizado** de Claude Code, OpenCode, prime-sales-hub, ou bloco terminal — dominando o frame. Texto curto.

**Propósito:** prova de método, caso real, "olha rodando", desmistificação. Atende **Jean-prejuízo** (prova de método que evitou prejuízo) e cria credibilidade pra cold audience.

**Diferenças canônicas:**
- Capa `.slide.surface` (#071321) ou `.slide.light` — fundo discreto, foco na captura
- Screenshot ocupa 60-80% do frame com `border: 1.5px solid var(--vm-primary)` ou linha azul fina
- Headline curta (1 frase, max 8 palavras) — papel é nomear a prova, não competir com ela
- Eyebrow `▮ bastidor · CC · spec` ou `▮ caso real`
- Slides 2-6 podem alternar entre prints e blocos terminal/árvore
- Slide 7 fecha com pill amarela menor, foco "vem ver o resto" em vez de "compra/comenta"

**Anonimização obrigatória:** screenshot de prime-sales-hub nunca mostra slugs reais, IDs de cliente, endpoints da Prime. Renomear pra `sales-hub-demo`, `cliente-A`, `endpoint-X`. Ver `marketing/assets/sessoes/architect-pipeline-safe.png` como referência do que passou no gate.

### Regra de rotação no feed

Linha de 6 posts (= 2 fileiras do grid IG):

```
[A] [B] [foto pessoal com ponte] [C] [A] [B]
```

- **Nunca 2 A seguidos** — é o ruído atual do feed
- **Foto pessoal nunca solta** — sempre com legenda que costura no fio condutor "dev-pai-cristão-construtor" (ver `project_fio_condutor_tech_pessoal` na memória)
- **C aparece 1x a cada 6** porque exige screenshot real anonimizado — produção mais cara, justifica raridade
- Reels e Stories não entram nessa rotação (têm canon próprio)

### Antes de produzir qualquer carrossel

1. **Olhar o último post publicado.** Se foi A, próximo é B ou C — nunca A.
2. **Escolher o sub-ICP:** Jean-curioso (A) ou Jean-prejuízo (B/C). Ver `project_jean_prejuizo_sub_icp` na memória.
3. **Definir tratamento explicitamente no comentário HTML** do `<head>`: `<!-- VM-treatment: B -->` pra o `content-reviewer` poder verificar coerência com a rotação.

## Logo VM (SVG vetorial)

Source: `src/components/Preloader.tsx`. Usa `currentColor`, então pinta com a cor herdada (parent CSS `color`).

```html
<svg width="170" height="88" viewBox="0 0 170 88" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="VM">
  <path d="M31.5244 85.8522L1.06296 2.89481C0.547021 1.48973 1.58699 0 3.0838 0H19.6844C20.5833 0 21.3876 0.558537 21.7016 1.40084L39.3518 48.7504C40.0492 50.6214 42.6972 50.6171 43.3886 48.7437L60.8574 1.40745C61.1695 0.561706 61.9755 0 62.877 0H78.4551C79.3591 0 80.1669 0.564892 80.4771 1.41409L97.7238 48.6253C98.4138 50.5141 101.087 50.5097 101.77 48.6187L118.836 1.42075C119.145 0.568092 119.954 0 120.861 0H136.422C137.329 0 138.139 0.568494 138.447 1.42159L168.404 84.379C168.911 85.7822 167.871 87.2629 166.379 87.2629H149.749C148.841 87.2629 148.031 86.6931 147.723 85.8387L130.668 38.4105C129.985 36.5114 127.299 36.5114 126.616 38.4105L109.56 85.8387C109.253 86.6931 108.443 87.2629 107.535 87.2629H91.5687C90.6632 87.2629 89.8545 86.6963 89.5453 85.8453L72.3002 38.3798C71.612 36.4858 68.9315 36.4909 68.2506 38.3876L51.2166 85.8375C50.9096 86.6926 50.0989 87.2629 49.1904 87.2629H33.5453C32.6425 87.2629 31.8356 86.6997 31.5244 85.8522Z" fill="currentColor"/>
</svg>
```

**Onde usar:**
- **Header de todos os slides (1-7):** versão pequena (~32px) à esquerda do top bar, na cor do texto principal.
- **Slide 7 (CTA), centro do slide:** versão média (60-80px) acima da assinatura. Mesma regra de cor.

**Regra firmada com Vini em 2026-05-21 (capa sem VM gigante):**

A capa (slide 1) NUNCA usa o VM em versão "drop big" (140-220px) repetida em cima da headline. Razão: o VM grande amarelo compete com a headline (ambos amarelos, ambos grandes), rouba peso da tese, e duplica o VM pequeno do header. Capa de carrossel IG funciona com 1 ponto focal — a headline. Logo grande na capa é vício de pitch deck, não de feed editorial.

**Padrão da capa correto:**
- Header: VM pequeno (~32px) à esquerda + `ED. NN · TIPO` à direita
- Conteúdo: headline GIGANTE (140-220px, palavra-chave em amarelo) + sub abaixo
- Footer: `arraste →` (esquerda) + meta `N slides · X min` (centro-direita) + linha + `vinimachado.dev` + `01/07`

A marca "respira" via header + assinatura no slide 7. Não precisa explodir na capa.

## Símbolo `▮` (cursor de terminal)

`▮` é a marca visual mais econômica do Vini. Aparece no header de todo slide do meio, no eyebrow de seções, antes de qualquer nome de produto.

**Regra de cor (crítica):**
- **Em fundo claro** (`.slide.light`, `.slide.surface` com card branco): `color: #007AFF` (azul). Source de verdade: `src/components/NavDrawer.tsx:138` (eyebrow "▮ navegação").
- **Em fundo escuro** (`.slide.dark`, `.slide.surface`): `color: #FFF200` (amarelo). Source: `src/components/ProductHero.tsx:74` (eyebrow "▮ em breve · lista de espera aberta").

**Onde usar:**
- Header dos slides do meio (2-6): só `▮` na esquerda + meta-label uppercase na direita
- Eyebrow de seções dentro do slide (`▮ navegação`, `▮ método`, `▮ ed. 04`)
- Antes do nome de produto na assinatura (`▮ Glossário do Vibe Coder`)

**Onde NÃO usar:**
- Texto corrido (não é bullet nem pontuação)
- No header dos slides 1 e 7 (esses têm logo SVG completo, não símbolo)

## Estrutura de slide (template)

```html
<section class="slide light s2">
  <div class="top">
    <span class="mark">▮</span>
    <span class="meta">A virada</span>
  </div>
  <div class="content">
    <!-- conteúdo principal -->
  </div>
  <div class="footer">
    <span class="num">02 / 07</span>
  </div>
</section>
```

- `.top` — `▮` à esquerda + meta-label uppercase à direita (rastreador de seção)
- `.content` — flexbox vertical, conteúdo central
- `.footer` — só número da página à direita (slim) nos slides do meio; brand completo + número nos slides 1 e 7

CSS skeleton completo em [`references/design-system.md`](references/design-system.md).

## Regra do brand reduzido (vinda do antigo NEON, mantida)

**Princípio:** marca completa aparece **só nos slides 1 e 7** — pontos onde o leitor entra ou sai do carrossel. Slides do meio têm marca minimalista (só `▮` + meta) pra não saturar com 14 menções de "vinimachado.dev".

**Slides 1 e 7 (capa + CTA):**
- Header: logo VM SVG (esquerda) + `ED. NN · TIPO` (direita)
- Footer: `vinimachado.dev` (esquerda) + `NN / 07` (direita)
- Linha divisória `1px var(--vm-line)` ou `var(--vm-line-dark)` conforme fundo

**Slides 2-6 (do meio):**
- Header: `▮` solo (esquerda) + meta-label (direita)
- Footer: **só** `NN / 07` na direita (`justify-content: flex-end`)
- Linha divisória mantida

## Padrão dos 7 slides

> **O número de slides segue o conteúdo, não o template.** 7 é o esqueleto de referência; carta (tratamento B) pode ter 5, caso real pode ter 8. Coesão vem de bordão + paleta + handle, não da contagem.

| # | Função | Modo | Gimmick dominante |
|---|--------|------|-------------------|
| 01 | Capa | `dark` | Headline gigante 2-3 linhas (palavra-chave em amarelo) + sub abaixo. **Nunca** VM grande amarelo na capa — só o VM pequeno do header. |
| 02 | Sintoma/dor | `light` | h2 massive + bullets com `›` amarelo + closer-line itálico cinza |
| 03 | Virada/quote autoridade | `dark` ou `surface` | Layout 2 colunas (sintoma → virada) **ou** bloco amarelo invadindo direita 42% com quote em preto |
| 04 | Bordão | `dark` | 2 linhas massive 196-220px — linha 1 branco/cinza, linha 2 amarelo. Zero rotação, pure typography |
| 05 | Método visual / prova | `surface` ou `light` | Tabela monospace estilo terminal, árvore de arquivos, pipeline visual, ou marquee amarelo horizontal |
| 06 | Método pro leitor | `light` | 4 steps numerados — number 64px amarelo, título 26px |
| 07 | CTA | `dark` | Pill amarelo grande (bubble estático) + assinatura `▮ Vini. Método > prompt.` (grafia EXATA, nunca "VM.") + meta de canal |

Detalhamento completo em [`references/padrao-7-slides.md`](references/padrao-7-slides.md).

## Gimmicks visuais (catálogo)

### 1. Pill amarelo bubble (versão estática pra carrossel)
CTA do slide 7. Pill grande `rounded-full`, fundo `--vm-primary`, texto preto bold. Em landing tem hover-bubble animado; no carrossel é só o estado de repouso.

### 2. Sublinhado handwritten
Palavra-chave em amarelo com sublinhado SVG handwritten (`/images/svg/line.svg` ou inline equivalente). Usado pra destacar 1 palavra por bordão — não abusa.

### 3. Marquee amarelo horizontal
Faixa horizontal amarela full-bleed (extrapola padding lateral) com texto preto uppercase massive. Conteúdo tipo `COMMIT SEMÂNTICO / MÉTODO > PROMPT / CLAUDE CODE / OPENCODE`. Possível em slide 5 ou 6 quando o tema pede energia.

### 4. Stats pill outline
Pílulas border 1px com número grande amarelo + label uppercase pequeno (`7+ ANOS EM PRODUÇÃO`). Pra prova rápida em slide de autoridade.

### 5. Terminal panel
Caixa `--vm-bg` (`#010A14`) com border 1.5px amarelo + texto SF Mono. Cabeçalho com 3 dots colorido (estilo macOS) ou só label `━ NOME · descrição`. Conteúdo monospace.

### 6. Bento card claro
Card branco `border-radius: 18-24px` com pílula amarela pequena no canto superior (badge categoria) + título escuro + bullets. Pra slide 5 em modo `.light`.

## Assinatura final unificada

Todo slide 7 fecha com:

```html
<div class="signature">
  <span class="mark">▮</span>
  <span class="brand">Vini.</span>
  <span class="tag">Método &gt; prompt.</span>
</div>
```

- `▮` em amarelo (fundo escuro do slide 7)
- `Vini.` branco bold (grafia canônica; "VM. Método > prompt" é assinatura ERRADA, o content-reviewer bloqueia)
- `Método > prompt.` amarelo

Não tem mais "vinimachado.dev" no header de cada slide. A regra de brand reduzido cobre isso.

## Build pipelines (centralizados — não inventar nada novo)

Existem **dois** pipelines, ambos usando **a mesma engine** (Chrome headless) pra manter consistência visual e zero duplicação de aprendizado.

### Pipeline 1: Carrosséis (HTML → PDF 1080×1350 → PNGs)

```bash
cd marketing
bash build.sh
```

O script itera sobre `carrosseis/*.html`, gera PDF 1080×1350px e exporta 7 PNGs por carrossel em `preview/<nome>-png/slide-N.png`.

**Pré-requisitos:** Google Chrome + `pdftoppm` (`brew install poppler`) + macOS (SF Apple só renderiza nativamente em Mac).

### Pipeline 2: Lead magnets (Markdown → HTML A4 → PDF)

```bash
cd marketing
bash build-leadmagnets.sh
```

O script itera sobre `lead-magnets/*.md`, converte cada um pra HTML via `npx marked`, injeta no template `lead-magnets/template.html` (mesma paleta VM dos carrosséis), e gera PDF A4 em `preview/<nome>-A4.pdf`.

**Pré-requisitos:** Google Chrome + Node.js (qualquer versão recente, pra `npx marked`) + macOS.

Detalhes completos em [`references/build-pipeline.md`](references/build-pipeline.md).

## Onde ficam os arquivos

```
vinimachado/
└── marketing/
    ├── carrosseis/                    ← HTMLs source
    │   ├── 01-*.html
    │   ├── 02-*.html
    │   └── ...
    ├── preview/                       ← outputs (gitignore-ável)
    │   └── <nome>-png/slide-N.png
    └── build.sh
```

## Naming convention

- Carrossel novo: `NN-tema-slug.html` (NN começa em 04, próximo livre)
- Variantes de design (raro): sufixar com letra (`01-X-A-tema.html`)
- Manter histórico: nunca deletar carrossel antigo, só desativar do calendário

## Material de referência

- [`references/design-system.md`](references/design-system.md) — CSS skeleton completo + tokens VM + snippets dos gimmicks
- [`references/padrao-7-slides.md`](references/padrao-7-slides.md) — anatomia de cada slide com snippets
- [`references/build-pipeline.md`](references/build-pipeline.md) — como o build.sh funciona, troubleshooting
- **Fonte canônica da paleta:** `src/index.css` (`@theme` block) — se mudar lá, mudar aqui
- **Fonte canônica do logo SVG:** `src/components/Preloader.tsx`
- **Fonte canônica da regra de cor do `▮`:** `src/components/NavDrawer.tsx` (azul-em-claro) + `src/components/ProductHero.tsx` (amarelo-em-escuro)
