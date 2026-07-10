---
name: studio-retention
description: Rubrica de retenção e storytelling pro YouTube do Vini: cold open, primeiros 30s, arco promessa->payoff, pattern interrupts, onde corta retenção, capítulos, títulos (sem travessão) e thumbnails. O cérebro do editor-companion.
---

# Skill: Studio Retention

Este é o cérebro editorial do estúdio. O `editor-companion` carrega esta skill pra ler um
vídeo longo do Vini e responder uma pergunta só: **o espectador vai ficar?**

Não é teoria de YouTube genérico. É a destilação de dois lugares:
- **YouTube PRO do Jonas Castro** (`brand/marketing/estudos/youtube-pro-jonas.md`): retenção,
  audiência qualificada, envelope título+thumb, gancho de 30s.
- **Estratégia do canal VM** (`brand/marketing/CANAL-YOUTUBE.md`): avatar Jean, 3 pilares,
  funil, anti-guru.

A voz e as regras duras vêm de `brand/.claude/skills/vinimachado-voice/`. A privacidade vem de
`brand/.claude/skills/vinimachado-public/`. **Nunca re-deriva marca aqui**, lê de lá.

## Entradas que esta skill lê

| Arquivo | Pra quê |
|---|---|
| `projects/<slug>/transcript.txt` | a prosa limpa: o que foi dito, a tese, o arco |
| `projects/<slug>/words.json` | timestamp por palavra, pra apontar o segundo exato de um drop |
| `projects/<slug>/transcript.srt` | leitura com tempo, pra mapear blocos |
| `projects/<slug>/ingest/scenes.txt` | onde o quadro muda (ou onde NÃO muda = visual parado) |
| `projects/<slug>/ingest/silences.txt` | pausas longas, hesitação, "perai" |
| `projects/<slug>/ingest/frames/` | o que aparece na tela em cada momento |

A saída desta skill vira seções do `COMPANION.md` e dá insumo pro `cut-planner` (EDL.json) e
pro `hook-doctor` (cold open, títulos, thumbnail, capítulos).

---

## 1. A regra dos primeiros 30 segundos

> Princípio do Jonas: **gancho de 30s = fincar a pessoa com uma promessa do que ela vai ver.**
> Métrica-foco: retenção nos primeiros 30s. Cair antes de 1 min = gancho ruim.

O cold open existe pra responder, em ordem, três perguntas na cabeça do Jean:
1. **Isso é pra mim?** (ele se reconhece na dor)
2. **Tem prova de que vale?** (stake, número, ou caso real)
3. **O que eu ganho se ficar?** (a promessa)

### O que faz um cold open forte

Um cold open forte abre com **stake, número ou história**, não com saudação. Escolhe UM dos
três motores:

- **Stake (o que tá em jogo):** "A IA tentou mexer onde não devia. Em produção, com cliente
  usando." O espectador sente o risco antes de saber a solução.
- **Número com fonte real:** "Refator num SaaS em produção. 191 arquivos. Zero quebra." Número
  só entra se for caso do Vini, log, ou pesquisa citável. Inventou = corta.
- **História/confissão:** "Tu pediu uma feature pro Claude, quase deu certo, voltou amanhã e a
  IA parecia outra pessoa." Confissão antes do acerto é a assinatura da voz VM.

Depois do motor, **a promessa em uma frase**: o que ele vai sair sabendo/fazendo. E só então,
se precisar, contexto.

### O que mata um cold open (rejeitar sempre)

- ❌ "Fala aí, pessoal", "e aí, galera", "sejam bem-vindos ao canal": abertura de saudação.
- ❌ "Antes de começar, se inscreve e ativa o sininho": pedido antes da entrega.
- ❌ Intro abstrata: definir o tema de forma genérica antes de mostrar a dor concreta.
- ❌ "Nesse vídeo eu vou falar sobre...": meta-fala, anuncia em vez de entregar.
- ❌ Vinheta longa / logo animado antes da primeira palavra com peso.

### Cold open na voz VM

Abre em `tu`, mantém `tu/tua/teu` a peça inteira. Confissão concreta > abstração. Frase curta
(<18 palavras quando dá). Sem firula ("incrível", "game changer"). Exemplo bom (do Vídeo 1 do
canal):

> "Tu abre o Claude Desktop ou o Codex, pede uma feature, quase dá certo. Volta amanhã e parece
> que a IA esqueceu tudo. O problema não é só a IA. É onde tua decisão ficou salva."

Stake + dor reconhecível + promessa implícita ("vou te mostrar onde a decisão devia estar"). Sem
saudação, sem meta-fala, sem travessão.

---

## 2. O arco: promessa -> desenvolvimento -> payoff

Todo vídeo do Vini é uma promessa aberta no cold open que **precisa fechar** no fim. Se abriu
"vou te mostrar como rodar refator de 191 arquivos sem quebrar", o payoff é a métrica final +
o como. Se não fecha, o espectador sai com a sensação de "não era isso" e não volta (mata o
espectador recorrente, que é a melhor métrica de comunidade segundo o Jonas).

### As três partes

1. **Promessa (cold open + setup):** a dor + a tese + o que ele vai ganhar. Curto.
2. **Desenvolvimento (o corpo):** a prova roda. Caso real, demo, passo a passo. Cada bloco tem
   começo, meio e fim, e **uma frase que amarra antes de passar pro próximo** (princípio do
   Jonas). É o "open loop" sendo construído e parcialmente pago ao longo do caminho.
3. **Payoff (o fecho):** a promessa cumprida de forma explícita. Métrica, resultado, "olha como
   ficou". Depois, e só depois, o CTA do funil.

### Como verificar que o arco fecha (checagem obrigatória)

O `editor-companion` faz esta verificação lendo `transcript.txt`:

1. **Extrai a promessa** dos primeiros ~30-45s. Escreve ela em uma frase no COMPANION.md.
2. **Procura o payoff** no último terço. A frase de promessa e a de payoff têm que conversar.
3. **Lista os loops abertos** (perguntas/ganchos plantados: "já vou te mostrar o número", "tem
   um detalhe que quase quebrou tudo") e confirma que **cada um fecha**. Loop aberto e nunca
   pago = retenção vaza e o espectador se sente enganado.
4. Se a promessa NÃO fecha: aponta o timestamp onde deveria fechar e sugere a frase de payoff,
   ou sugere reescrever o cold open pra prometer o que o vídeo realmente entrega.

> Regra do Jonas aplicada: **clareza > criatividade em vendas; criatividade > clareza em
> storytelling.** O arco pode ser criativo. O CTA no fim é clareza pura.

---

## 3. Diagnóstico de queda de retenção

Onde o espectador desiste. O `editor-companion` cruza `transcript.txt` (o que se fala) com
`ingest/scenes.txt` + `ingest/frames/` (o que aparece) e marca cada zona de risco com timestamp
de `words.json`. Os padrões que fazem a curva cair:

| Sintoma | Como detectar | Correção |
|---|---|---|
| **Intro abstrata** | tese definida de forma genérica antes de qualquer dor concreta | trazer a dor/exemplo pra frente, cortar a definição ou jogar pro meio |
| **Meta-fala** | "nesse vídeo", "como eu falei", "voltando ao ponto", "deixa eu organizar aqui" | cortar; é fala de organização, não de conteúdo |
| **Visual parado** | `scenes.txt` sem mudança por >20-30s e frames idênticos | inserir pattern interrupt (ver seção 4): zoom, b-roll, card |
| **Pedido de desculpa verbalizado** | "desculpa o vai e vem", "perai que eu me perdi", "ignora isso", "deixa eu refazer" | cortar a fala inteira; em vídeo não existe desculpa, existe corte |
| **Hesitação / `silences.txt`** | pausa longa, "éééé", "tipo assim", "sei lá", repetição de take | jump cut: remover via EDL, fechar a pausa |
| **Lista sem mudança visual** | enumera 4-6 itens com o mesmo enquadramento o tempo todo | cada item ganha um card/zoom/cut; lista parada é a maior fonte de drop |
| **Tangente** | sai do arco por >30s pra um assunto que não paga loop nenhum | cortar ou comprimir; se for ouro, vira outro vídeo |
| **Ramp-up lento** | 60s+ até a primeira informação de valor | mover o valor pra frente, encurtar o setup |

**Para cada drop apontado, o COMPANION.md registra:** `[mm:ss]` + sintoma + ação sugerida
(corte, pattern interrupt, ou reescrita). Quando a ação é corte, o `cut-planner` materializa no
EDL.json; quando é interrupt visual, vira nota pro render.

> A retenção do Vini não se ganha com "energia" forçada (isso é anti-guru). Se ganha **cortando
> o que não serve ao arco** e **mudando o visual antes do tédio bater**.

---

## 4. Pattern interrupts (quebra de padrão visual)

O cérebro humano para de prestar atenção em um estímulo que não muda. A cada ~15-30s sem mudança
de fala forte, o visual precisa mexer. Quatro interrupts canônicos no estúdio:

| Interrupt | Quando | Como (vira nota pro EDL/render) |
|---|---|---|
| **Zoom (punch-in)** | ênfase numa frase, número, ou na cara contando confissão | crop/scale no momento exato; ver `studio-editing` e FFMPEG-RECIPES |
| **B-roll / screen** | quando ele cita uma ferramenta, tela, arquivo ou caso | sobrepor o frame relevante (`ingest/frames/`) ou screen recording |
| **Card / overlay** | número-hero, definição de termo, "antes/depois", título de bloco | card amarelo+navy, 2-4 palavras (paleta da marca) |
| **Speed-ramp** | trecho necessário mas lento (setup de ambiente, instalação) | acelerar 1.3-2x via EDL, não cortar a informação |

Regras:
- O interrupt **serve o conteúdo**, não distrai dele. Zoom sem motivo é ruído.
- No máximo um interrupt por ideia. Vídeo que muda de zoom o tempo todo cansa igual a parado.
- Card respeita a paleta: navy `#010A14`, amarelo `#FFF200`, texto `#f3f4f6`, surface `#071321`,
  vermelho `#ff4d4d` pro "sem método / quebrou".
- Termo de método em card precisa de tradução (régua do Jean): "spec" vira "a regra do jogo
  escrita antes do código", "guardrail" vira "corrimão que impede a IA de sair da pista".

---

## 5. Design de capítulos

Capítulos servem retenção de duas formas: deixam o vídeo navegável (o Jean pula pro que importa
e fica) e funcionam como mini-promessas. **10 a 13 capítulos** num vídeo de 15-35min.

Regras:
- **Título de capítulo é orientado a benefício**, não a tópico. Diz o que o espectador ganha ali.
  - ❌ "Introdução" → ✅ "Por que teu chat esquece tudo"
  - ❌ "Parte 2" → ✅ "A spec que economizou 3 semanas"
  - ❌ "Conclusão" → ✅ "O número final do refator"
- Primeiro capítulo começa em `00:00` e carrega o gancho (YouTube exige o primeiro em 0:00).
- Cada título é curto, na voz VM (`tu`, sem firula), **sem travessão**.
- Os títulos seguem o arco: dá pra ler só os capítulos e entender a promessa->payoff.
- O `editor-companion` propõe os marcadores lendo `transcript.srt` (timestamp + assunto) e
  alinhando cada um a um bloco real do arco.

---

## 6. Títulos do vídeo

O `hook-doctor` escreve os títulos; esta skill dá a regra. Título + thumbnail = **o envelope**.
A pergunta 100% honesta do Jonas: *"eu clicaria nisso se aparecesse no meu feed?"*

Princípios:
- **Curiosity gap honesto:** abre uma lacuna que o vídeo realmente fecha. Nunca clickbait que o
  payoff não cumpre (mata o espectador recorrente).
- **Nicho do nicho:** título específico filtra audiência qualificada. "Refator de 191 arquivos
  com IA. Como rodou." é melhor que "Como usar IA pra programar". Específico atrai o Jean,
  genérico atrai viewer que não vira comunidade.
- **Voz VM:** `tu`, concreto, confissão quando couber. **Sem travessão**, sem marketing-speak
  (game changer, insano, revolucionário, fórmula, segredo).
- **Número só com fonte real.** "3777 testes" entra se confere com o registro; senão, corta.
- 4 ideias-tipo do Jonas: **Como EU fiz** / **Como TU pode fazer** / **Conceito novo (tese)** /
  **Por que isso...** (opinião).

### Saída obrigatória: 3 opções

O `hook-doctor` sempre entrega **3 títulos** com ângulos diferentes, pra escolher/testar:
1. um de **caso/número** ("Refator de 191 arquivos com IA. Como rodou.")
2. um de **dor/confissão** ("Seu chat não é memória de projeto.")
3. um de **tese/conceito** ("Spec antes de código muda tudo no jeito de pedir pra IA.")

Cada um passa pelo filtro: clicaria? é pro Jean? cumpre a promessa? sem travessão?

---

## 7. Texto de thumbnail

O thumbnail carrega o clique junto com o título, sem repetir o título. Regras (anti-guru,
identidade VM):

- **2 a 4 palavras.** Lê em meio segundo no celular. Mais que isso ninguém lê.
- **Paleta da marca:** fundo navy `#010A14`, palavra-chave em amarelo `#FFF200`, texto `#f3f4f6`.
  Vermelho `#ff4d4d` só pra marcar o "errado / quebrou / sem método".
- **Sem cara de espanto.** O canal é anti-guru (regra explícita do CANAL-YOUTUBE): nada de boca
  aberta, mão no rosto, seta vermelha gritante. A força vem da palavra e do contraste, não do
  teatro.
- **Contraste com o título:** o thumb dá o ângulo emocional/visual, o título dá o específico.
  Juntos formam o envelope. Não dizer a mesma coisa duas vezes.
- **Identidade repetida** (princípio do Jonas: elementos de reconhecimento): cursor `▮`,
  amarelo+navy, tipografia consistente. Repetir em todo vídeo constrói reconhecimento de feed.
- Exemplos de texto de thumb: `CHAT ≠ MEMÓRIA`, `191 ARQUIVOS · 0 QUEBRA`, `SPEC > PROMPT`,
  `NÃO-ESCOPO`.

---

## 8. CTA preso ao funil

CTA é clareza pura (Jonas: clareza >>> criatividade em venda). Vem **depois do payoff**, nunca
antes da entrega. O funil canônico:

```
Vídeo  ->  /spec-4 ou /glossario  ->  VM — Vibe Coders  ->  mentoria 1:1
```

CTA por pilar (de CANAL-YOUTUBE):

| Pilar | CTA primário | CTA secundário |
|---|---|---|
| **1. O Método** | `/spec-4` | VM — Vibe Coders |
| **2. Construindo Ao Vivo** | VM — Vibe Coders | mentoria 1:1 |
| **3. A Tradução** | `/glossario` (Glossário do Vibe Coder) | VM — Vibe Coders |

Regras duras:
- **CTA só pra coisa que existe:** `/spec-4`, `/glossario`, VM — Vibe Coders, mentoria 1:1.
  **Code Agent PRO é vapor, nunca oferecer** (em fala, descrição, card ou comentário fixado).
- **Funil funcional do Jonas:** vídeo mostra o que sabe + CTA claro + **link na descrição** +
  **1º comentário fixado** com o link.
- **Um CTA primário por vídeo.** Empilhar destino confunde e converte menos.
- Posicionamento: micro-menção do destino pode aparecer no meio quando natural ("isso tá no
  template do /spec-4"), mas o CTA explícito é no fim, depois do payoff.
- Sem comenta-PALAVRA nos primeiros ~10 vídeos do reposicionamento (regra herdada da voz/canal).
- Fecho com a assinatura, grafia exata: **Vini. Método > prompt.**

---

## 9. Rubrica de pontuação (1-10): o que o editor-companion aplica

O `editor-companion` pontua o vídeo em 8 eixos. Cada eixo recebe nota 1-10 com justificativa e
timestamp. A média ponderada dá o **Retention Score** do vídeo, que entra no topo do COMPANION.md.

| # | Eixo | Peso | 1-3 (refazer) | 4-6 (corrigir) | 7-8 (bom) | 9-10 (publica) |
|---|---|---|---|---|---|---|
| 1 | **Cold open (30s)** | 3 | saudação/meta-fala, sem stake | dor presente mas lenta | stake/número + promessa clara | finca em <15s, na voz VM, sem travessão |
| 2 | **Arco fecha** | 3 | promessa não paga | paga em parte, loops abertos | fecha, payoff claro | payoff explícito amarra a promessa exata |
| 3 | **Drops de retenção** | 2 | vários trechos mortos | 2-3 zonas de drop | 1 drop leve | sem zona morta, ritmo limpo |
| 4 | **Pattern interrupts** | 2 | visual parado o vídeo todo | poucos, mal colocados | suficientes e motivados | cadência certa, sempre a serviço do conteúdo |
| 5 | **Capítulos** | 1 | ausentes ou genéricos | tópicos, não benefício | 10-13, orientados a benefício | navegáveis, leem o arco sozinhos |
| 6 | **Título (3 opções)** | 2 | genérico ou clickbait | ok mas largo | específico, curiosity gap honesto | filtra o Jean, clicaria no feed, sem travessão |
| 7 | **Thumbnail** | 1 | >4 palavras ou cara de espanto | paleta ok, texto fraco | 2-4 palavras, paleta certa | contrasta com título, identidade VM |
| 8 | **CTA + funil** | 1 | destino inexistente / Code Agent PRO | CTA tardio ou múltiplo | CTA certo do pilar, no fim | + descrição + comentário fixado + assinatura |

**Cálculo:** `Score = soma(nota × peso) / soma(pesos)` (pesos somam 15). Arredonda a 1 casa.

**Gates duros (zeram a publicação, independente do score):**
- Travessão em título, thumbnail, capítulo ou card.
- CTA pra Code Agent PRO ou qualquer destino que não existe.
- Número sem fonte real.
- Violação de privacidade (filha citada, mentorado/cliente não anonimizado). Isso é jurisdição
  do `privacy-reviewer`, mas o `editor-companion` sinaliza e segura.

**Leitura do score:**
- **8.0-10:** pronto pra publicar (passando os gates).
- **6.0-7.9:** publicável com os ajustes listados; vale corrigir os drops e o cold open.
- **< 6.0:** refazer roteiro/edição antes de publicar. Anota os 3 piores eixos no topo.

---

## Formato da saída no COMPANION.md

A seção de retenção do COMPANION.md sai assim:

```
## Retenção: Score 7.4/10

Promessa (00:12): "vou te mostrar onde a decisão devia estar salva"
Payoff (14:03): fecha. Mostra o /spec-4 guardando a decisão. ✔

Cold open ........ 8  finca em 11s com stake + dor reconhecível, voz tu
Arco fecha ....... 8  promessa paga; 1 loop ("o número") fecha em 12:40
Drops ............ 6  3 zonas (ver abaixo)
Interrupts ....... 7  faltam 2 entre 06:00-08:30 (visual parado)
Capítulos ........ 7  11 capítulos, 2 ainda em "tópico" não "benefício"
Título ........... 8  3 opções abaixo
Thumbnail ........ 9  "CHAT ≠ MEMÓRIA" amarelo/navy
CTA .............. 8  /spec-4 no fim + descrição + comentário fixado

Drops a cortar:
- [02:18] meta-fala "deixa eu me organizar aqui" → corte
- [06:40] visual parado 34s na mesma tela → zoom + card "spec = regra do jogo"
- [11:05] "desculpa o vai e vem" → corte a fala inteira

Títulos (3):
1. Refator de 191 arquivos com IA. Como rodou.
2. Seu chat não é memória de projeto.
3. Spec antes de código muda como tu pede pra IA.

Gates: ok (sem travessão, sem Code Agent PRO, números conferem).
```

Daí o `cut-planner` lê os drops e materializa o EDL.json, o `hook-doctor` finaliza título/thumb/
capítulos, e o `privacy-reviewer` dá o gate final antes de publicar.
