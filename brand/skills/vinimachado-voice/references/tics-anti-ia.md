# Tics anti-IA — catálogo + reescrita

LLMs (incluindo eu) têm padrões previsíveis que delatam texto gerado. Esses padrões são **proibidos em conteúdo público do Vini**. Em docs internos, tolerável.

## Os 12 tics que mais aparecem

### 1. Em-dash `—`
**Como aparece:** "Comecei o projeto — e não voltei mais."
**Por que delata:** modelos de linguagem usam em-dash como pausa universal. Brasileiro escrevendo em IG raramente usa.
**Reescreve:** ponto final, vírgula, dois pontos, ou quebra de linha.
- "Comecei o projeto. E não voltei mais."
- "Comecei o projeto, e não voltei mais."

### 2. "Não é apenas X, é Y"
**Como aparece:** "IA não é apenas uma ferramenta, é uma extensão da sua mente."
**Por que delata:** estrutura batida de copy IA, parafraseia título de artigo de blog.
**Reescreve:** afirmação direta, sem o pivô.
- "IA é infraestrutura. Não ferramenta." (carrossel 03 slide 4 já adota isso)

### 3. "Aqui estão N dicas pra..."
**Como aparece:** "Aqui estão 5 dicas pra usar IA no seu negócio."
**Por que delata:** template de blog de 2010, listicle.
**Reescreve:** anedota ou método específico.
- "5 erros que cometi nos meus 3 primeiros apps com IA."
- "Como rodo discovery antes de pedir código pra IA."

### 4. "Vamos juntos nessa jornada"
**Como aparece:** "Vamos juntos nessa jornada de descoberta da IA."
**Por que delata:** sermão de coach motivacional + jargão batido.
**Reescreve:** matar a frase. Geralmente o post sobrevive sem ela.

### 5. "Imagine que..."
**Como aparece:** "Imagine que você acabou de criar seu app com IA..."
**Por que delata:** preguiça narrativa. Brasileiro abre com fato concreto, não hipótese.
**Reescreve:** abre com fato real ou pergunta direta.
- "Você criou um app com IA na semana passada. Travou no deploy."

### 6. Reticências (`...`) em excesso
**Como aparece:** "E aí... você nem percebeu... que perdeu o contexto..."
**Por que delata:** modelo enchendo linguiça quando não tem o que dizer.
**Limite:** máximo 1 por slide/post, e só quando há dúvida real ou pausa intencional.

### 7. Adjetivos empilhados
**Como aparece:** "uma incrível, transformadora e revolucionária ferramenta"
**Por que delata:** modelo treinado pra "soar bem", empilha qualificadores.
**Reescreve:** corta tudo, mantém só o substantivo.
- "uma ferramenta" (e o leitor decide se é incrível)

### 8. Bullets sem alma
**Como aparece:**
- ✅ Eficiência
- ✅ Produtividade
- ✅ Agilidade
**Por que delata:** zero informação, só palavra-bonita.
**Reescreve:** cada bullet vira frase com substantivo + verbo + objeto concreto.
- ✅ Eficiência: entrega o app em 2 dias em vez de 2 semanas.

### 9. "É importante notar que..."
**Como aparece:** "É importante notar que IA não substitui criatividade humana."
**Por que delata:** filler de modelo treinado em Wikipedia.
**Reescreve:** afirmar direto, ou matar a frase.
- "IA não substitui criatividade humana."

### 10. "Em conclusão" / "Em resumo"
**Como aparece:** "Em conclusão, IA é um aliado poderoso..."
**Por que delata:** estrutura de redação escolar.
**Reescreve:** matar. O fim do post é o fim do post, não precisa anunciar.

### 11. Emojis em sequência decorativa
**Como aparece:** "🚀✨💪 Bora construir!"
**Por que delata:** hipercompensação de coach IG dos anos 2018.
**Limite:** 0-1 emoji por post, e só quando substitui palavra (ex: 👇 substituindo "abaixo").

### 12. "Como X, Y, Z..." em frase introdutória
**Como aparece:** "Como dev sênior, mentor e criador de conteúdo, aprendi que..."
**Por que delata:** modelo pondo CV antes de afirmar.
**Reescreve:** afirma direto, identidade vem depois (ou não vem).
- "Aprendi que..."

## Checklist de revisão final

Antes de qualquer publicação rodar essa lista:

- [ ] Zero em-dash `—` no texto público
- [ ] Zero "não é apenas X, é Y"
- [ ] Zero "aqui estão N dicas"
- [ ] Zero "vamos juntos nessa jornada"
- [ ] Zero "imagine que" (substitui por fato concreto)
- [ ] Reticências `...` ≤ 1 por post
- [ ] Adjetivos empilhados removidos
- [ ] Bullets têm substância concreta (ferramenta, número, exemplo)
- [ ] Zero "é importante notar que"
- [ ] Zero "em conclusão" / "em resumo"
- [ ] Emojis ≤ 1, e só funcional
- [ ] Zero "como X, Y, Z..." abrindo
- [ ] Marketing-speak da [`vocabulario.md`](vocabulario.md) eliminado
- [ ] Gírias na grafia exata (ver [`girias-br.md`](girias-br.md))
- [ ] Identidade pessoal protegida (ver skill `vinimachado-public`)
- [ ] Termina com pergunta, CTA ou bordão (ver SKILL.md)
- [ ] Assinatura "Vini. Método > prompt." se for carrossel

## Caso real (do histórico do Vini)

Frase original que ele caçou: "Toda vez que você abre o chat, ela esqueceu o que vocês decidiram ontem."

**Problemas:**
1. Tecnicamente errado (mesma sessão preserva contexto)
2. "vocês" implica que o user e a IA são plurais, esquisito

**Reescrita aprovada:** "Dentro da conversa aberta, ela lembra. Mas você troca de chat, troca de ferramenta, ou volta amanhã. Já era. Esqueceu o nome do botão, a regra do desconto, por que você trocou de banco."

Esse é o padrão. Tecnicamente preciso + gíria BR exata + frase curta + concreto.
