# Anatomia dos 7 slides — sistema VM

Cada slide tem função, modo (dark/surface/light), gimmick visual e padrão de copy. Esse documento serve de checklist quando for criar carrossel novo.

> Observação tipográfica: SF Apple **não é tão "brutal"** no peso 900 quanto o Cabinet Grotesk era. Pra compensar, a régua canônica usa tamanhos maiores e `letter-spacing` mais negativo (`-0.04em` a `-0.045em` no massive). Não força um peso que não existe — confia no tamanho.

---

## Slide 01 — Capa

**Função:** hook em primeira pessoa que expressa virada de chave, OU número da edição + tese da edição.

**Modo padrão:** `.dark` (pode ser `.light` em temas editoriais).

**Estrutura visual (variante A — capa logo + headline):**
- Header completo (logo VM SVG + `ED. NN · TIPO`)
- Logo VM grande (220-280px de largura) ou número de edição massive 240px amarelo
- H1 140-184px em 2-3 linhas, palavra-chave em `--vm-primary`
- Sub ~26px em `--vm-text-muted` explicando o post
- Footer completo (`vinimachado.dev` + `01 / 07`)

**Estrutura visual (variante B — capa número da edição):**
- Header completo
- Número de edição **240px** amarelo `massive` (ex: `04`)
- Pode ter seta brutalist amarela atravessando horizontal (retângulo + triângulo) — herança visual do antigo NEON, mantida como gimmick opcional
- H1 abaixo ~140px com tese da edição
- Sub e footer iguais

**Copy padrão:**
```
[Frase do antes em primeira pessoa, passado.]
[Frase do depois em primeira pessoa, presente, com palavra-chave em amarelo.]
```

---

## Slide 02 — Sintoma / dor

**Função:** descreve o problema que o leitor reconhece. Cria identificação.

**Modo padrão:** `.light` (pode ser `.surface` se o tema for mais técnico).

**Estrutura visual:**
- Header slim (`▮` solo + meta-label uppercase)
- Eyebrow opcional `▮ A dor` na parte de cima do `.content`
- H2 88-108px com palavra-final em amarelo (sublinhado handwritten opcional)
- Bullets com seta `›` amarela (3-4 itens, ~26px)
- Closer-line em itálico cinza
- Footer slim (só `02 / 07` à direita)

**Copy padrão:**
```
H2: [Reconhecimento do problema, com palavra-chave em amarelo].
Bullets:
  - [Sintoma 1 com strong em palavra-chave.]
  - [Sintoma 2 com strong.]
  - [Sintoma 3 com strong.]
  - [Sintoma 4 com strong opcional.]
Closer-line: [Frase-síntese em itálico, cinza muted].
```

---

## Slide 03 — Virada / quote autoridade

**Função:** explica a causa do problema OU apresenta a virada conceitual que resolve.

**Modo padrão:** `.dark` ou `.surface` (impacto da virada pede peso visual).

**Estrutura visual (variante A — texto puro):**
- Header slim
- H2 ~84px com palavra-chave em amarelo
- 2 parágrafos densos de 26px (max 920px de largura)
- Quote final em SF Italic + amarelo (`font-style: italic`)

**Estrutura visual (variante B — bloco amarelo invadindo):**
- Header slim
- Coluna esquerda 58% do slide: H2 + parágrafo de virada (em fundo escuro do slide)
- Coluna direita 42% invadindo a borda: bloco amarelo full-bleed com quote em preto + crédito da autoridade
- Margem do `.content` é `0 -84px` à direita pra estender até a borda

**Copy padrão:**
```
H2: [Tese ou diagnóstico em 2 linhas, palavra final em amarelo].
Parágrafo 1: [Explicação técnica precisa].
Parágrafo 2: [Implicação prática + chamada à ação].
Quote: ["Frase-bordão entre aspas, em itálico, amarelo."]
```

---

## Slide 04 — Bordão

**Função:** **frase-tese repetível**. É o slide que vira screenshot, vira citation. Cada carrossel deveria ter um bordão único e memorável.

**Modo padrão:** `.dark` **sempre** (regra absoluta).

**Estrutura visual:**
- Header slim
- Eyebrow opcional `▮ anota essa` em amarelo
- H2 massive (196-220px) em 2 linhas:
  - Linha 1: `color: var(--vm-text-muted)` (cinza médio) — pode ter strike `text-decoration: line-through` amarelo se for antes/depois
  - Linha 2: `color: var(--vm-primary)` (amarelo)
- **Zero rotação. Zero bloco invadindo. Pure typography.** (Mudança importante vs Folloni antigo, que rotacionava bloco amarelo.)
- Post-text ~24px em `--vm-text-muted` (0.7 opacity), max 880px, abaixo do bordão
- Footer slim

**Copy padrão:**
```
Eyebrow: ▮ anota essa
H2 linha 1: [Pré-palavra cinza]
H2 linha 2: [Palavra-chave amarela]
Post-text: [Justificativa em 1-2 frases, com strong na chave.]
```

**Exemplos:**
- Linha 1: "Método" (cinza) / Linha 2: "> prompt." (amarelo)
- Linha 1: "IA não é ~~ferramenta~~." (cinza, strike no "ferramenta") / Linha 2: "É infra." (amarelo)
- Linha 1: "SPEC primeiro." (cinza) / Linha 2: "Código depois." (amarelo)

**CSS canônico:**
```css
.s4 .bordao {
  font-size: 210px;
  line-height: 0.88;
  letter-spacing: -0.045em;
  font-weight: 900;
}
.s4 .bordao .dim { color: var(--vm-text-muted); }
.s4 .bordao .hi  { color: var(--vm-primary); }
.s4 .bordao .strike {
  text-decoration: line-through;
  text-decoration-color: var(--vm-primary);
  text-decoration-thickness: 6px;
}
```

---

## Slide 05 — Método visual / prova

**Função:** **slide-gimmick**. É onde cada carrossel se diferencia visualmente. Mostra prova concreta do método.

**Modo padrão:** `.surface` (`#071321`) pra terminal/panel escuro, `.light` pra bento card claro.

**Estrutura visual:**
- Header slim
- H2 64-76px
- Lead 22-26px (opcional)
- **Gimmick visual** (varia por carrossel):
  - **Terminal panel** (mais comum): caixa `--vm-bg` com border 1.5px amarelo, header de 3 dots + nome do arquivo, body em SF Mono mostrando spec/código/output
  - **Árvore de arquivos**: `<pre>` em SF Mono mostrando estrutura de pastas; folders em azul (`--vm-blue`), hot folders em amarelo, comments em cinza muted
  - **Pipeline visual horizontal**: 4-5 stages conectados por setas, cada stage com bullet colorido (mas paleta limitada a yellow + blue + cinzas — sem verde/roxo/cyan)
  - **Marquee amarelo horizontal** (full-bleed): pra slide de tese repetida em massa
  - **Bento card grid**: 2-4 cards brancos com pílula amarela de categoria + título escuro + bullets
  - **Stats pills outline**: linha de 2-3 stats grandes (`7+ ANOS`, `R$ X PROCESSADOS`, etc)
- Closer line opcional ~22px, palavra-final amarela
- Footer slim

**Padrão do terminal panel (header + content):**
```html
<div class="terminal">
  <div class="t-head">
    <span class="t-dots"><i></i><i></i><i></i></span>
    <span class="t-name mono">~ projeto · arquivo.md</span>
  </div>
  <pre class="t-body mono">conteúdo SF Mono</pre>
</div>
```

CSS completo em `design-system.md` (Element library item 11).

---

## Slide 06 — Método pro leitor

**Função:** **acionável**. 4 steps numerados que o leitor pode aplicar agora, sem precisar ser dev.

**Modo padrão:** `.light`.

**Estrutura visual:**
- Header slim
- H2 ~70-72px com palavra-chave em amarelo
- Lead frase (opcional)
- 4 steps numerados em coluna:
  - Número 64px bold amarelo (`01`, `02`, `03`, `04`)
  - Título 26px bold preto/escuro
  - Exemplo 19px itálico cinza muted dark, entre aspas
  - Separador `1px var(--vm-line-dark)` entre steps
- Closer line com palavra-chave em amarelo
- Footer slim

**Copy padrão:**
```
H2: [Inversão da expectativa. "Tu não precisa de [coisa técnica], precisa de [acionável]."]
Lead: [Frase introdutória de 1 linha].
01 / [Título do step]
   "[Exemplo concreto entre aspas, italic.]"
02 / [Título do step]
   "[Exemplo concreto.]"
03 / [Título do step]
   "[Exemplo concreto.]"
04 / [Título do step]
   "[Exemplo concreto.]"
Closer: [Frase-síntese, palavra final em amarelo].
```

**Exemplos de exemplo concreto:**
- "Personal perdendo aluno por falta de retorno entre treinos."
- "Cliente recompra em 90 dias. Desconto máximo 12%."

---

## Slide 07 — CTA

**Função:** captura. Promete recurso específico em troca de comentário com palavra-chave ou clique em link.

**Modo padrão:** `.dark` **sempre**.

**Estrutura visual:**
- Header completo (logo VM SVG branco + `ED. NN · TIPO`)
- Logo VM SVG médio (60-80px de altura) opcional acima do H2
- H2 80-110px com palavra-chave em amarelo
- Lead ~25px (`--vm-text-muted`)
- **Pill amarelo CTA grande** (versão estática de `.btn-bubble-yellow`):
  - Fundo `--vm-primary`, texto `--vm-text-dark` bold
  - Padding `24px 40px`, border-radius `999px`
  - Conteúdo: "comenta `PALAVRA-CHAVE` aqui embaixo →" ou "pega o glossário →"
  - Box-shadow `0 8px 0 rgba(0,0,0,0.18)` pra dar peso
- Assinatura final:
  ```
  ▮ VM. Método > prompt.
  ```
  - `▮` em amarelo, `VM.` branco, `Método > prompt.` amarelo
- Meta de canal embaixo: `vinimachado.dev` em mono cinza
- Footer completo (`vinimachado.dev` + `07 / 07`)

**Copy padrão:**
```
H2: [Promessa. "Te mando o que eu uso." em 2-3 linhas, palavra-chave amarela].
Lead: [Reforço da promessa + bullet do que entrega.]
Pill CTA: comenta [PALAVRA-CHAVE] aqui embaixo →
Signature: ▮ VM. Método > prompt.
Meta: vinimachado.dev
```

**Palavras-chave em uso (referência):**
- Carrossel 01: `GLOSSÁRIO` ou `MENTORIA`
- Carrossel 02: `SPEC`
- Carrossel 03: `SKILLS`

**Cada palavra-chave precisa ter um lead magnet real existindo antes do post sair.** Senão quebra a promessa.

---

## Checklist de criação de carrossel novo

Antes de gerar o HTML:

- [ ] Tema cristalizado em 1 frase (a tese)
- [ ] Bordão do slide 4 definido (frase-síntese repetível, 2 linhas)
- [ ] Gimmick visual do slide 5 escolhido (terminal? árvore? marquee? bento? stats?)
- [ ] Palavra-chave do CTA decidida (e o lead magnet correspondente existe ou está sendo produzido)
- [ ] Antes/depois do slide 1 escrito (ou número da edição definido)
- [ ] Exemplos concretos pra cada step do slide 6 (de preferência ligados a nichos reais: personal, coach, empreendedor)
- [ ] Modo de cada slide decidido (dark/surface/light)

Depois do HTML pronto:

- [ ] Roda `bash build.sh` (em macOS — SF Apple só funciona nativamente lá)
- [ ] Confere todos os 7 PNGs
  - [ ] Slide 1 — logo VM SVG renderizou na cor certa? Headline cabe sem quebrar?
  - [ ] Slide 4 — bordão massive cabe no slide? Acentos não foram cortados? Linha 2 amarela tá legível?
  - [ ] Slide 5 — gimmick visual renderizou? Terminal panel tá com border amarela?
  - [ ] Slide 7 — pill amarelo tá com sombra? Assinatura tem `▮ VM. Método > prompt.` na ordem certa?
- [ ] `▮` está azul em slide light e amarelo em slide dark/surface?
- [ ] Brand reduzido: slides 2-6 têm só `▮` no header (não `vinimachado.dev`)?
- [ ] Submete pro `content-reviewer` (gate anti-IA-tics + privacy)
- [ ] Atualiza `marketing/IDEIAS.md` na tabela "Carrosséis em produção"
