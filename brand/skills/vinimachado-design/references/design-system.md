# Design system VM — CSS skeleton

CSS base que vai em todo carrossel novo. Copia daqui e adapta os blocos `.s1` até `.s7` conforme o tema.

## Boilerplate completo

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Carrossel NN — Tema</title>
<style>
  :root {
    /* Surfaces */
    --vm-bg:             #010A14;
    --vm-surface:        #071321;
    --vm-surface-hover:  #0c1c2f;
    --vm-light:          #ffffff;
    --vm-light-soft:     #f3f4f6;

    /* Brand */
    --vm-primary:        #FFF200;
    --vm-blue:           #007AFF;

    /* Texto */
    --vm-text:           #f3f4f6;
    --vm-text-dark:      #010A14;
    --vm-text-muted:     #9ca3af;
    --vm-text-muted-dark:#6b7280;

    /* Linhas */
    --vm-line:           rgba(255,255,255,0.08);
    --vm-line-dark:      rgba(0,0,0,0.08);
  }

  * { box-sizing: border-box; margin: 0; padding: 0; }
  html, body { background: #000; }
  body {
    font-family: "SF UI Display", -apple-system, BlinkMacSystemFont,
                 "SF Pro Display", "SF Pro", system-ui, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
  }
  @page { size: 1080px 1350px; margin: 0; }

  .slide {
    width: 1080px; height: 1350px;
    position: relative; overflow: hidden;
    page-break-after: always; break-after: page;
    padding: 90px 84px;
    display: flex; flex-direction: column;
  }
  .slide:last-child { page-break-after: auto; break-after: auto; }

  h1, h2, h3 {
    font-family: inherit;
    letter-spacing: -0.025em;
    line-height: 1;
    font-weight: 800;
  }
  .massive { letter-spacing: -0.04em; line-height: 0.92; font-weight: 900; }

  .mono {
    font-family: "SF Mono", SFMono-Regular, ui-monospace,
                 Menlo, Monaco, Consolas, monospace;
  }

  /* ============== Modos: dark / surface / light ============== */
  .slide.dark    { background: var(--vm-bg);      color: var(--vm-text); }
  .slide.surface { background: var(--vm-surface); color: var(--vm-text); }
  .slide.light   { background: var(--vm-light);   color: var(--vm-text-dark); }

  /* Top + footer em fundo escuro */
  .slide.dark .top,
  .slide.surface .top {
    border-bottom: 1px solid var(--vm-line);
  }
  .slide.dark .top .meta,
  .slide.surface .top .meta { color: var(--vm-text-muted); }

  .slide.dark .footer,
  .slide.surface .footer {
    color: var(--vm-text-muted);
    border-top: 1px solid var(--vm-line);
  }
  .slide.dark .footer .num,
  .slide.surface .footer .num { color: var(--vm-text); }

  /* `▮` em fundo escuro = amarelo */
  .slide.dark .mark,
  .slide.surface .mark { color: var(--vm-primary); }

  /* Top + footer em fundo claro */
  .slide.light .top {
    border-bottom: 1px solid var(--vm-line-dark);
  }
  .slide.light .top .meta { color: var(--vm-text-muted-dark); }

  .slide.light .footer {
    color: var(--vm-text-muted-dark);
    border-top: 1px solid var(--vm-line-dark);
  }
  .slide.light .footer .num { color: var(--vm-text-dark); }

  /* `▮` em fundo claro = azul */
  .slide.light .mark { color: var(--vm-blue); }

  /* ============== Top bar ============== */
  .top {
    display: flex; justify-content: space-between; align-items: center;
    padding-bottom: 18px; margin-bottom: 8px;
  }
  .top .mark {
    font-size: 22px; line-height: 1; font-weight: 800;
  }
  .top .meta {
    font-size: 13px; font-weight: 500;
    letter-spacing: 0.22em; text-transform: uppercase;
  }
  /* Slides 1 e 7 — header com logo VM SVG */
  .top.brand-full .logo { height: 32px; width: auto; }
  .top.brand-full .logo path { fill: currentColor; }

  /* ============== Footer ============== */
  .footer {
    position: absolute; left: 84px; right: 84px; bottom: 60px;
    display: flex; justify-content: space-between; align-items: center;
    padding-top: 20px;
    font-size: 13px; letter-spacing: 0.22em; text-transform: uppercase;
    font-weight: 500;
  }
  .footer.slim { justify-content: flex-end; }
  .footer .num {
    font-weight: 800; letter-spacing: 0.08em;
  }

  /* ============== Content area ============== */
  .content {
    flex: 1;
    display: flex; flex-direction: column; justify-content: center;
  }

  /* ============== Slide-specific styles aqui ============== */
  /* Adicione .s1, .s2, ..., .s7 conforme necessário */
</style>
</head>
<body>

<!-- 7 slides aqui -->

</body>
</html>
```

## Convenções

### Tamanhos de fonte por contexto

- **Capa h1** (slide 1): 140-184px, line-height 0.94, letter-spacing -0.04em
- **Número da edição** (slide 1 opcional): 240px Cabinet Mode `massive` amarelo
- **H2 massive** (slide 4 bordão): 196-220px, line-height 0.88, letter-spacing -0.045em
- **H2 dor** (slide 2): 88-108px, line-height 0.94
- **H2 normal** (slides 3, 5, 6): 58-84px, line-height 1.0-1.05
- **H2 CTA** (slide 7): 80-110px, line-height 0.96
- **Lead/parágrafo grande:** 22-27px, line-height 1.45-1.5
- **Body normal:** 19-22px, line-height 1.4-1.5
- **Step number** (slide 6): 64px bold amarelo
- **Step title:** 24-26px bold branco/preto conforme fundo
- **Eyebrow / label uppercase:** 13-16px, letter-spacing 0.22em
- **Footer:** 13px, letter-spacing 0.22em
- **Microtext mono** (legend, header de terminal): 11-14px, letter-spacing 0.14-0.18em

### Spacing

- Gap entre conteúdo principal e parágrafos: 22-36px
- Gap entre bullets de lista: 16px
- Padding do slide: 90px 84px (constante)
- Margin do footer (bottom): 60px
- Border-radius padrão: 18-24px (cards, painéis)
- Border-radius pill: 999px (rounded-full)

### Quando usar amarelo `--vm-primary`

- Palavra-chave em headlines (linha 2 do bordão, span destacado)
- Setas `›` em bullets (slide 2)
- `▮` em fundo escuro
- Pill CTA principal (slide 7)
- Marquee horizontal
- Sublinhado handwritten
- Pílula badge pequena em bento card
- Border de terminal panel
- **Nunca** em texto corrido longo (cansa os olhos)

### Quando usar azul `--vm-blue`

- `▮` em fundo claro
- Logo VM em surface light
- Eyebrow secundário quando amarelo já tá saturado no slide
- **Não usar** como CTA principal — amarelo é o protagonista; azul é da identidade da landing, mas no carrossel é coadjuvante

### Escolha de modo por slide

- Slide 4 (bordão) **sempre** `.dark` — impacto da tese
- Slide 7 (CTA) **sempre** `.dark` — fecha pesado
- Slide 1 (capa) padrão `.dark` — abre com brand forte; pode ser `.light` em temas mais editoriais
- Slides 2, 3, 6 padrão `.light` — conteúdo respirado
- Slide 5 padrão `.surface` ou `.light` — depende do gimmick visual (terminal panel pede surface; bento card pede light)

## Element library

### 1. Logo VM SVG (currentColor — pinta com a cor herdada)

```html
<svg class="logo" width="170" height="88" viewBox="0 0 170 88" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="VM">
  <path d="M31.5244 85.8522L1.06296 2.89481C0.547021 1.48973 1.58699 0 3.0838 0H19.6844C20.5833 0 21.3876 0.558537 21.7016 1.40084L39.3518 48.7504C40.0492 50.6214 42.6972 50.6171 43.3886 48.7437L60.8574 1.40745C61.1695 0.561706 61.9755 0 62.877 0H78.4551C79.3591 0 80.1669 0.564892 80.4771 1.41409L97.7238 48.6253C98.4138 50.5141 101.087 50.5097 101.77 48.6187L118.836 1.42075C119.145 0.568092 119.954 0 120.861 0H136.422C137.329 0 138.139 0.568494 138.447 1.42159L168.404 84.379C168.911 85.7822 167.871 87.2629 166.379 87.2629H149.749C148.841 87.2629 148.031 86.6931 147.723 85.8387L130.668 38.4105C129.985 36.5114 127.299 36.5114 126.616 38.4105L109.56 85.8387C109.253 86.6931 108.443 87.2629 107.535 87.2629H91.5687C90.6632 87.2629 89.8545 86.6963 89.5453 85.8453L72.3002 38.3798C71.612 36.4858 68.9315 36.4909 68.2506 38.3876L51.2166 85.8375C50.9096 86.6926 50.0989 87.2629 49.1904 87.2629H33.5453C32.6425 87.2629 31.8356 86.6997 31.5244 85.8522Z" fill="currentColor"/>
</svg>
```

Regra de cor por contexto (usa `color:` do parent, o SVG herda via `fill="currentColor"`):

```css
.slide.dark    .logo { color: var(--vm-text); }     /* branco */
.slide.surface .logo { color: var(--vm-text); }     /* branco */
.slide.light   .logo { color: var(--vm-blue); }     /* azul */
```

Pra usar o logo grande de capa (slide 1), aumenta a largura:

```html
<svg class="logo logo-hero" width="220" height="114" viewBox="0 0 170 88" ...>
```

### 2. Símbolo `▮`

```html
<span class="mark">▮</span>
```

```css
.mark { font-size: 22px; line-height: 1; font-weight: 800; }
/* cor é resolvida pelo modo do slide pai (ver boilerplate) */
```

### 3. Eyebrow (mark + label)

```html
<div class="eyebrow">
  <span class="mark">▮</span>
  <span>ed. 04 · ferramenta da semana</span>
</div>
```

```css
.eyebrow {
  display: inline-flex; align-items: center; gap: 12px;
  font-size: 13px; font-weight: 600;
  letter-spacing: 0.22em; text-transform: uppercase;
  color: var(--vm-text-muted);
}
.slide.light .eyebrow { color: var(--vm-text-muted-dark); }
```

### 4. Headline 2 linhas color-split

Palavra-chave em amarelo, resto branco/preto.

```html
<h1 class="massive">
  Parei de pedir código.<br>
  Agora eu peço <span class="hi">spec primeiro</span>.
</h1>
```

```css
.massive .hi { color: var(--vm-primary); }
```

### 5. Bullet com seta `›` amarela

```html
<ul class="bullets">
  <li>O dev <strong>vira gargalo</strong> da ideia.</li>
  <li>A IA gera código que <strong>ninguém revisa</strong>.</li>
  <li>Você refaz a mesma feature <strong>3 vezes na semana</strong>.</li>
</ul>
```

```css
.bullets { list-style: none; display: grid; gap: 16px; }
.bullets li {
  padding-left: 44px; position: relative;
  font-size: 26px; line-height: 1.45;
}
.bullets li::before {
  content: "›";
  position: absolute; left: 0; top: -4px;
  color: var(--vm-primary);
  font-size: 36px; font-weight: 900; line-height: 1;
}
```

### 6. Bordão massive 2 linhas (slide 4)

```html
<h2 class="massive bordao">
  <span class="dim">Método</span><br>
  <span class="hi">&gt; prompt.</span>
</h2>
```

```css
.bordao { font-size: 210px; line-height: 0.88; letter-spacing: -0.045em; }
.bordao .dim { color: var(--vm-text-muted); }
.bordao .hi  { color: var(--vm-primary); }
```

Zero rotação, zero bloco amarelo invadindo. Pure typography.

### 7. Sublinhado handwritten (SVG inline)

Renderiza sob a palavra em amarelo. Pra evitar dependência de arquivo externo no build, inline:

```html
<span class="hl">
  destrava
  <svg class="underline-hl" viewBox="0 0 200 14" preserveAspectRatio="none" aria-hidden="true">
    <path d="M2 8 Q 50 2, 100 7 T 198 6" stroke="currentColor" stroke-width="3" stroke-linecap="round" fill="none"/>
  </svg>
</span>
```

```css
.hl { position: relative; display: inline-block; color: var(--vm-primary); font-weight: 900; }
.hl .underline-hl {
  position: absolute; left: 0; right: 0; bottom: -8px;
  width: 100%; height: 14px;
  color: var(--vm-primary);
}
```

### 8. Pill amarelo CTA (versão estática de `.btn-bubble-yellow`)

```html
<a class="pill" href="https://vinimachado.dev">
  pega o glossário
  <span class="arrow">→</span>
</a>
```

```css
.pill {
  display: inline-flex; align-items: center; gap: 14px;
  padding: 24px 40px;
  background: var(--vm-primary);
  color: var(--vm-text-dark);
  font-size: 26px; font-weight: 800;
  letter-spacing: -0.01em;
  border-radius: 999px;
  text-decoration: none;
  box-shadow: 0 8px 0 rgba(0,0,0,0.18);
}
.pill .arrow { font-size: 22px; line-height: 1; }
```

### 9. Stats pill outline

```html
<div class="stats-pill">
  <span class="num">7+</span>
  <span class="lbl">anos em produção</span>
</div>
```

```css
.stats-pill {
  display: inline-flex; align-items: baseline; gap: 14px;
  padding: 16px 28px; border-radius: 999px;
  border: 1.5px solid currentColor;
}
.stats-pill .num {
  color: var(--vm-primary); font-weight: 900;
  font-size: 44px; letter-spacing: -0.03em;
}
.stats-pill .lbl {
  font-size: 13px; font-weight: 600;
  letter-spacing: 0.22em; text-transform: uppercase;
}
```

### 10. Marquee amarelo horizontal (estático, full-bleed)

```html
<div class="marquee">
  <span>COMMIT SEMÂNTICO · MÉTODO &gt; PROMPT · CLAUDE CODE · OPENCODE · </span>
</div>
```

```css
.marquee {
  position: relative;
  margin: 0 -84px;          /* full-bleed: cancela padding do slide */
  background: var(--vm-primary);
  color: var(--vm-text-dark);
  font-size: 84px; font-weight: 900;
  letter-spacing: -0.03em;
  line-height: 1.1;
  padding: 28px 0;
  overflow: hidden;
  white-space: nowrap;
}
.marquee span { display: inline-block; padding-left: 32px; }
```

No carrossel é estático (sem animação) — só a faixa visual. O texto pode ser repetido pra preencher a largura.

### 11. Terminal panel

```html
<div class="terminal">
  <div class="t-head">
    <span class="t-dots"><i></i><i></i><i></i></span>
    <span class="t-name mono">~ vinimachado.dev · spec.md</span>
  </div>
  <pre class="t-body mono">
features:
  - name: lead-capture
    why:  &quot;captura email pré-launch&quot;
    done: &quot;form submetido + redirect&quot;
  </pre>
</div>
```

```css
.terminal {
  background: var(--vm-bg);
  border: 1.5px solid var(--vm-primary);
  border-radius: 18px;
  overflow: hidden;
}
.t-head {
  display: flex; align-items: center; gap: 16px;
  padding: 14px 22px;
  border-bottom: 1px solid var(--vm-line);
  font-size: 14px; color: var(--vm-text-muted);
}
.t-dots { display: inline-flex; gap: 6px; }
.t-dots i {
  width: 12px; height: 12px; border-radius: 50%;
  background: var(--vm-text-muted);
  opacity: 0.5;
}
.t-body {
  padding: 22px 26px;
  font-size: 18px; line-height: 1.55;
  color: var(--vm-text);
}
```

### 12. Step numerado (slide 6)

```html
<div class="step">
  <span class="ix">01</span>
  <div class="body">
    <div class="t">Lista os 3 piores momentos do seu mês</div>
    <div class="ex">"Aluno some entre treinos. Eu manualmente passo plano novo."</div>
  </div>
</div>
```

```css
.step { display: grid; grid-template-columns: 96px 1fr; gap: 24px; padding: 24px 0; border-bottom: 1px solid var(--vm-line-dark); }
.step .ix {
  font-size: 64px; font-weight: 900;
  color: var(--vm-primary);
  letter-spacing: -0.03em; line-height: 1;
}
.step .t  { font-size: 26px; font-weight: 800; letter-spacing: -0.02em; }
.step .ex { font-size: 19px; color: var(--vm-text-muted-dark); font-style: italic; margin-top: 8px; }
```

### 13. Assinatura final

```html
<div class="signature">
  <span class="mark">▮</span>
  <span class="brand">VM.</span>
  <span class="tag">Método &gt; prompt.</span>
</div>
```

```css
.signature {
  display: inline-flex; align-items: baseline; gap: 14px;
  font-size: 26px; font-weight: 800; letter-spacing: -0.02em;
}
.signature .mark  { color: var(--vm-primary); font-size: 26px; }
.signature .brand { color: var(--vm-text); }
.signature .tag   { color: var(--vm-primary); }
```
