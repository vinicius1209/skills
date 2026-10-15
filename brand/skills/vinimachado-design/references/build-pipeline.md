# Build pipelines — Chrome headless centralizado

Dois scripts bash, mesma engine (Chrome headless print-to-pdf). Centralizado pra evitar gambiarra a cada novo formato de output.

| Script | Input | Output | Quando usar |
|--------|-------|--------|-------------|
| `build.sh` | `carrosseis/*.html` | PDF 1080×1350 + 7 PNGs por carrossel | Carrossel novo de IG |
| `build-leadmagnets.sh` | `lead-magnets/*.md` | PDF A4 por lead magnet | Glossário, templates, ebooks curtos |

Ambos rodam de `cd marketing && bash <script>`.

## Pipeline 1 — Carrosséis (HTML → PDF 1080×1350)

## Como rodar

```bash
cd marketing
bash build.sh
```

Se quiser regenerar só um carrossel (mais rápido), modificar o glob temporariamente ou rodar Chrome direto:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="preview/MEU-CARROSSEL-IG-1080x1350.pdf" \
  "file://$(pwd)/carrosseis/MEU-CARROSSEL.html"

pdftoppm -png -r 96 "preview/MEU-CARROSSEL-IG-1080x1350.pdf" "preview/MEU-CARROSSEL-png/slide"
```

## Pré-requisitos

- **macOS** — SF UI Display + SF Mono são fontes do sistema Apple, não têm CDN. Build em outras plataformas vai cair no fallback `system-ui` e perder a tipografia canônica. O Vini só builda em Mac, então é seguro.
- **Google Chrome** instalado em `/Applications/Google Chrome.app`
- **pdftoppm** disponível: `brew install poppler`

## O que o script faz

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Validações
[[ ! -x "$CHROME" ]] && exit 1
command -v pdftoppm >/dev/null || exit 1

mkdir -p preview

shopt -s nullglob
files=(carrosseis/*.html)

for html in "${files[@]}"; do
  name="$(basename "$html" .html)"
  pdf="preview/${name}-IG-1080x1350.pdf"
  png_dir="preview/${name}-png"

  "$CHROME" \
    --headless --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$pdf" \
    "file://$(pwd)/$html"

  rm -rf "$png_dir"
  mkdir -p "$png_dir"
  pdftoppm -png -r 96 "$pdf" "$png_dir/slide"
done
```

## Saída esperada

Pra cada `carrosseis/03-ia-modelo-negocio.html`:

```
preview/
├── 03-ia-modelo-negocio-IG-1080x1350.pdf
└── 03-ia-modelo-negocio-png/
    ├── slide-1.png
    ├── slide-2.png
    ├── slide-3.png
    ├── slide-4.png
    ├── slide-5.png
    ├── slide-6.png
    └── slide-7.png
```

PNGs ficam em **1080×1350px**, prontos pra subir como carrossel no IG (ordem: slide-1 a slide-7).

## Troubleshooting

### Texto saiu em fonte system fallback (não SF UI Display)
- Roda o build em macOS — SF Apple é fonte do sistema, não tem CDN
- Confirma no Chrome inspector que `font-family` resolve em `SF UI Display` (e não cai pro `system-ui`)
- Em macOS recente (10.11+) `SF UI Display` está disponível por default

### Bordão (slide 4) com letras cortadas em cima ou embaixo
- Aumenta o `line-height` do `.bordao` de `0.88` pra `0.94`
- Reduz o `font-size` de 220px pra 196px (a régua aceita esse intervalo)
- Ver `padrao-7-slides.md` slide 4

### `pdftoppm: command not found`
- Roda `brew install poppler`
- No Linux: `apt install poppler-utils`

### PDF gerado com tamanho errado
- Confirmar `@page { size: 1080px 1350px; margin: 0; }` no CSS
- Confirmar `.slide { width: 1080px; height: 1350px; }`
- Chrome usa o `@page` na exportação print-to-pdf

### PNG saindo blurry/baixa resolução
- Aumentar o `-r 96` do pdftoppm pra `-r 192` (gera 2x). Mas IG comprime — 96dpi já é suficiente

## Otimização futura (se virar gargalo)

- Paralelizar: rodar Chrome em background pra cada HTML
- Cache: pular regeneração se HTML não mudou desde último PDF
- Watch mode: rebuild automático quando salvar HTML

Por enquanto, sequencial roda em ~30s pros 6 carrosséis. Não precisa otimizar.

---

## Pipeline 2 — Lead magnets (Markdown → PDF A4)

Script: `conteudo/build-leadmagnets.sh`. Template: `conteudo/lead-magnets/template.html`.

### Como rodar

```bash
cd marketing
bash build-leadmagnets.sh
```

Itera sobre `lead-magnets/*.md` e gera `preview/<nome>-A4.pdf` pra cada um.

### O que o script faz

1. Pra cada `<nome>.md`:
2. Converte md → HTML body via `npx --yes marked -i <md> -o <body.html>`
3. Python lê o template + body, substitui `__TITLE__` (1ª linha `# ...`) e `__CONTENT__`
4. Chrome headless `--print-to-pdf` no HTML composto → PDF A4
5. Limpa arquivos temporários

### Pré-requisitos

- **macOS** (SF Apple só renderiza nativamente em Mac)
- **Google Chrome** em `/Applications/Google Chrome.app`
- **Node.js** (qualquer versão recente, pra `npx marked`)
- **Python 3** (vem com macOS)

Não precisa de Pandoc. Não precisa de wkhtmltopdf. Mesma stack do carrossel + Node pra parsear markdown.

### Por que `npx marked` e não JS no browser

Tentei primeiro carregar `marked.min.js` via CDN no template HTML e renderizar no Chrome headless. Não funcionou: `--virtual-time-budget` mesmo aumentado não esperou a CDN. Conversão server-side via `npx marked` é mais robusta e determinística.

### Por que não Pandoc

Pandoc é excelente, mas:
1. Adiciona dependência (~200MB com basictex pra PDF)
2. Default usa LaTeX, que é outro mundo de troubleshooting
3. Já temos Chrome + Node, sem custo adicional

### Template (`lead-magnets/template.html`)

- A4 com margens 22mm topo / 20mm laterais / 24mm rodapé
- Mesma paleta VM dos carrosseis. Pra lead magnet em fundo claro: `--vm-light #ffffff` (fundo), `--vm-text-dark #010A14` (texto), `--vm-primary #FFF200` (accent), `--vm-blue #007AFF` (logo + `▮` em fundo claro)
- SF UI Display + SF Mono (mesma fonte chain dos carrosseis)
- Eyebrow `▮ navegação` em azul (fundo claro)
- Traço amarelo lateral nos `h2` (mesma lógica dos slides do carrossel, escala reduzida)
- Bullets com seta `›` amarela em listas que vêm depois de h3 (formato glossário: 3 linhas por termo)
- Assinatura `▮ VM. Método > prompt.` no fim, centralizada com borda superior em cinza

Pra mudar o estilo de um novo tipo de lead magnet (ex: ebook 30 páginas, template de SPEC com seções de form), criar novo template em `lead-magnets/template-<tipo>.html` e parametrizar o script.

### Troubleshooting

#### PDF saiu cortado / só 1 página
Causa típica: heredoc shell tropeçando em aspas ou caracteres especiais do markdown. **Solução** (já aplicada no script atual): usar arquivo intermediário `.body.html` em vez de injeção via shell variable. Python lê os arquivos.

#### Texto saiu em fonte system/serif default (não SF UI Display)
- Confirma que está rodando o build em macOS (SF Apple é fonte do sistema, não tem CDN)
- Mesma regra do pipeline 1 — se um pipeline renderiza SF certo, o outro também



#### Markdown com tabela/código não renderiza
`npx marked` por default tem GFM (GitHub Flavored Markdown) ligado, então tabelas + code fences funcionam. Se quiser desligar, edita o script.

#### PDF muito grande (>1MB pra texto puro)
- Verifica se Chrome embutiu fontes. Geralmente acontece quando o PDF é todo texto.
- Pra reduzir, comprime depois com `qpdf --linearize` ou `gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook`

### Adicionar novo lead magnet

1. Criar `conteudo/lead-magnets/<slug>.md` (markdown puro)
2. Primeira linha do md vira o `<title>` do PDF (`# Título do Doc`)
3. Rodar `bash build-leadmagnets.sh`
4. PDF aparece em `conteudo/preview/<slug>-A4.pdf`
