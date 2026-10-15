# Pilares — exemplos detalhados

Templates de copy expandidos pra cada pilar, com exemplos prontos do banco IDEIAS.md.

## P1 — Glossário Humano: roteiros prontos

### Git em 40 segundos

**Hook (3s):** "Te explico Git em 40 segundos sem usar a palavra 'repositório'."

**Roteiro:**
> *"Você tá editando seu app. Mexeu numa coisa, quebrou. Quer voltar. Sem Git, você reza. Com Git, você dá um comando e tá tudo de volta no estado de antes. Pronto. Git é isso: máquina do tempo do seu código. Salva versão, volta versão, junta versão de duas pessoas. Se sua IA tá te falando 'commit', 'push', 'merge' — é isso. Você não precisa decorar comando, precisa entender que existe um botão de undo serioso. Eu uso todo dia, há 7 anos."*

### Deploy

**Hook:** "'Deploy' não é bicho de sete cabeças. É isso aqui:"

**Roteiro:**
> *"Você cozinhou o prato. Tá na panela. Bom, mas ninguém vai comer. Deploy é tirar o prato da panela e colocar na mesa. No código: o app rodando no seu computador é a panela. Deploy é levar pro servidor onde a internet inteira pode acessar. Quando seu Manus fala 'failed to deploy', ele construiu o app — só não conseguiu pôr no ar. Bora resolver."*

### Env (variável de ambiente)

**Hook:** "Sua senha do banco de dados não pode estar no código. Por isso existe o env."

**Roteiro:**
> *"Olha esse cenário. Seu app precisa de senha pra falar com o banco. Se você escreve a senha no código e sobe pro GitHub, todo mundo vê. Já vi gente perder R$ 12.000 em AWS por isso. Env é um arquivinho secreto. Mora junto do projeto, não vai pro GitHub, e seu app lê de lá. Pensa nele como o cofre. Código fica visível, segredo fica fechado. Sempre."*

### Branch

**Hook:** "Branch é o esboço do esboço."

**Roteiro:**
> *"Você quer tentar uma ideia, mas não quer estragar o que já funciona. Branch é uma cópia paralela. Você mexe lá, testa lá, e só junta no principal se der certo. Se der errado, joga fora a branch e ninguém viu. É isso. Tem dev que faz 50 branches por mês, eu faço 5. Quanto mais você confia, menos precisa."*

### Build

**Hook:** "Build é o seu código indo pra academia antes de aparecer em público."

**Roteiro:**
> *"Você escreveu o código bonito, comentado, organizado. Mas o navegador não entende isso direito. Build é o processo de empacotar tudo, comprimir, traduzir e deixar leve pra rodar. É como passar um vídeo de 4K pra 1080p antes de mandar pro WhatsApp. Quando seu app demora muito pra abrir, normalmente é build mal feito."*

---

## P2 — Ferramenta da Semana: estrutura

### Manus AI — meu teste sincero

**Slides:**
1. Capa | "Testei o Manus por 7 dias construindo um SaaS real. Aqui o resumo:"
2. O que funciona | "Plano em linguagem natural. Parece mágica. É."
3. O que dá errado | "A primeira hora você acha que substituiu um dev. Na quinta, você descobre que ele não sabe o que é env."
4. Hora exata pra chamar humano | "Quando o erro repete 3 vezes seguidas, pula. Você não tem tempo."
5. Veredito | "Vale? Vale. Substitui dev? Não. Acelera quem não é dev? Demais."
6. CTA | "Salvou? Compartilha com quem tá começando."

### Manus vs Lovable vs Bolt

**Slides:**
1. Capa | "Construí o mesmo app nas três. O vencedor te surpreende."
2. O app | "Pequena landing com formulário e envio por email."
3. Manus | nota X, prós e contras.
4. Lovable | nota X.
5. Bolt | nota X.
6. Vencedor | (decidir após teste real).
7. CTA | "Qual você usa? Comenta."

---

## P3 — Caso Real: estrutura

### Snug (app pra casais)

**Hook:** "Esse app eu construí pensando em mim e na Tali."
**Pauta:**
- Por quê (motivação real, sem TMI)
- Stack: Flutter + Supabase
- Primeira versão travou em [problema específico]
- IA ajudou em [trecho específico, com prompt usado]
- Resultado: screenshot + link

### Habbo World

**Hook:** "Reconstruí o Habbo Hotel sozinho, num fim de semana, com IA."
**Pauta:** stack PixiJS + Colyseus + Supabase, prompts que destravaram movement do avatar.

### Wa-resumo-bot

**Hook:** "Construí um bot que lê o grupo do WhatsApp e me devolve o resumo do dia."
**Pauta:** uso real (qual grupo, com permissão), latência, custo de API mensal real.

---

## P4 — Bastidor: tipos de post

### Tipo: print autorizado de mentorado
> *"Mentorado me mandou 23h: 'Vini, merge conflict'."*

Compartilha o print (com permissão), depois um Reel curto explicando o que respondi e por quê.

### Tipo: áudio narrando primeira sessão típica
> *"Quando o aluno fala 'eu não sei nem por onde começar'."*

Áudio meu de 30s descrevendo o roteiro de uma primeira sessão.

### Tipo: antes/depois autorizado
Story carrossel: primeira tela do app do mentorado (com permissão) → terceira sessão.

### Tipo: 7 perguntas da primeira call
**Carrossel:**
1. "O que você quer construir?"
2. "Pra quem?"
3. "Tem alguma referência (app que você gostaria de imitar)?"
4. "Já tentou? O que travou?"
5. "Quanto tempo por semana você consegue dedicar?"
6. "Quer construir ou quer aprender?"
7. "Qual seu prazo realista?"

### Tipo: humanização real
"Aluno virou amigo. Tomou café aqui em casa." Foto + caption curta. Sem virar comercial.

---

## P5 — Prompt da Semana: estrutura

### "Faça o Cursor parar de chutar"

**Slides:**
1. Capa | "O prompt que faz o Cursor parar de chutar e perguntar antes de codar."
2. O prompt | bloco de código copiável.
3. Por que funciona | 3 linhas (forçar discovery antes de implementação).
4. CTA | "Salva pra usar amanhã."

### Backlog de prompts

- "Prompt pra IA escrever email de follow-up"
- "Prompt pra debug — quando você não sabe o que tá errado"
- "Prompt pra explicar um código que você não entende"
- "Prompt pra gerar nome de empresa / app"
- "Prompt pra revisar contrato (sem advogado)"
- "Prompt pra criar página de captura em 5 minutos"

---

## Nicho concreto: 7 ideias prontas

### #N01 — "Personal: pare de gerir aluno por planilha"
**Formato:** Carrossel VM (estrutura antes/depois + CTA palavra-chave — herdada do método de copy da Deborah Folloni)
**Ângulo:** problema → 3 ferramentas testadas → CTA "comenta PERSONAL pra eu mandar o roteiro"

### #N02 — "Construí app de gestão de aluno em 1 fim de semana com IA"
**Formato:** Reel + carrossel caso real
**Ângulo:** narrativa pessoal de teste, não promessa

### #N03 — "Coach: 3 prompts pra preparar sessão em 10 minutos"
**Formato:** Carrossel Prompt da Semana

### #N04 — "Nutri: como a IA monta plano alimentar (e onde ela ainda erra)"
**Formato:** Reel honesto, mostra limite

### #N05 — "Professor particular: cobrar mensalidade automatizada com IA + Pix"
**Formato:** Carrossel Ferramenta da Semana

### #N06 — "Por que não recomendo Manus pra personal (e o que recomendo)"
**Formato:** Reel opinativo

### #N07 — "Aluno me perguntou: posso usar IA pra montar treino? Resposta sincera"
**Formato:** Reel direto na câmera, formato Lucas Montano (anedota + opinião)

---

## Newsletter — pautas das 6 primeiras edições

| # | Tema | Lead |
|---|------|------|
| 1 | "Seu glossário chegou (e uma confissão minha)" | história do meu primeiro deploy quebrado |
| 2 | "O erro caro nos meus 3 primeiros apps com IA" | confiar sem ler |
| 3 | "Manus vs. Lovable vs. Bolt — meu teste de uma semana" | review honesto |
| 4 | "Como cobrar por um projeto construído com IA" | dilema de freelancer |
| 5 | "Os 7 prompts que uso TODO santo dia" | biblioteca prática |
| 6 | "Quando NÃO usar IA pra construir" | contra-narrativa |

---

## Stories — banco de templates

- **Enquete:** "Qual termo você mais ouve e finge entender?" (Git / Deploy / Env / API)
- **Pergunta aberta:** "O que te impede de lançar seu app hoje?"
- **Slider de emoji:** "Quão perdido você se sente com Git?"
- **Caixa de pergunta:** "Me manda sua dúvida boba que eu respondo aqui no Story"
- **Antes/depois:** print da primeira mensagem de aluno + print da terceira sessão (com permissão)
- **Polaroid:** foto do setup + frase curta sobre o que tô construindo hoje

Banco completo: [`conteudo/IDEIAS.md`](../../../..conteudo/IDEIAS.md).
