---
name: vinimachado-public
description: Regras de privacidade pessoal e identidade pública do Vini que devem ser aplicadas em todo conteúdo público (carrosséis, captions, Reels, newsletter, lead magnets, posts em grupos). Define quem pode/não pode ser citado por nome, como Cristo aparece, contexto público vs privado, e o limite entre vida pessoal como cenário e como tema.
---

# Privacidade pessoal — regras duras

Regras inegociáveis pra qualquer conteúdo que vai pro mundo público (Instagram, newsletter, blog, grupo, DM-prospect, lead magnet). Em docs internos (PLANO.md, IDEIAS.md), regras mais frouxas, mas o conteúdo final precisa passar nesse filtro.

## Quem aparece e como

### Tali (esposa) — **PODE aparecer**

- Bio dele já marca **@tali_fortuna** publicamente
- Pode ser citada pelo nome em conteúdo
- Pode aparecer em foto (com consentimento por contexto)
- Exemplos OK:
  - "Construí pensando em mim e na Tali."
  - "Pergunta que a Tali me fez ontem."
  - "Casado com a Tali, pai recente, cristão."

### Filha (Helena) — **NÃO citar por nome**

- **Nunca** mencione o nome dela em conteúdo público
- Use:
  - "minha filha"
  - "pai recente"
  - "fase RN" / "fase recém-nascida"
  - "ela" (com contexto)
- O Vini questionou se vale a pena tanta info pessoal — privacidade da filha tem prioridade
- **Foto da filha em conteúdo público:** evitar. Se aparecer, sempre de costas, sem mostrar rosto, sem identificar o nome dela visualmente
- O carrossel 01 (reposicionamento) usa a frase "parei de só postar foto da minha filha aqui" — referência indireta, sem nome, OK

### Cristo / fé — **APARECE como identidade, NUNCA como sermão**

- Pode aparecer como parte de quem ele é: "cristão", "Sigo Jesus", "fé"
- **Nunca** vira tema central de post profissional
- **Nunca** pregação, citação bíblica longa, doutrina
- OK: "Cristão que programa: como concilio fé e tech." (post #E07 no IDEIAS.md, formato soft)
- OK: bio incluir "Cristão" ao lado de "Pai" e "@tali_fortuna"
- NÃO OK: carrossel Pilar 2 sobre IA terminando com versículo
- NÃO OK: caption de prompt seguido de "Deus abençoe seu negócio"

### Mentorados — **NUNCA sem permissão explícita**

- Print, screenshot, áudio de mentorado **só com autorização escrita**
- Mesmo com autorização, **anonimizar** detalhes que identifiquem (nome da empresa, valor exato, cidade pequena)
- "Mentorado me mandou 23h" → OK
- "Mentorado da empresa X em São Paulo" → NÃO OK sem permissão
- Antes de postar print, **conferir uma vez mais** se nada do print identifica a pessoa sem ela autorizar

### Cliente atual / passado de software — **NÃO citar sem autorização**

- Vini trabalhou em sistemas anti-fraude e PIX em produção (PLANO.md menciona)
- **Não** citar nomes de empresas-cliente sem autorização do contrato
- Pode falar de stack, pode falar de domínio (anti-fraude, PIX), **não** do nome
- "7 anos construindo sistema pra empresa dos outros" > "7 anos no banco X"

### Jean (Meu Ingresso) — **AUTORIZADO por nome**

- Jean e a plataforma Meu Ingresso podem ser citados por nome (autorização dada; paráfrase OK)
- Detalhes novos do caso (URL no feed, prints de conversa) pedem ratificação pontual antes de cada peça nova
- É o arquétipo do ICP: caso real, não persona inventada

### Outros devs / mentores — **OK citar publicamente acessíveis**

- Lucas Montano, Mano Deyvin, Folloni, Timóteo: figuras públicas, podem ser citadas
- Amigos privados: pedir permissão antes

---

## Prova técnica e anonimização (tratamento C, casos da Prime)

Regras duras pra screenshot, mock de terminal, ficha de obra ou qualquer prova técnica pública:

- **"Prime Sales Hub" como nome de projeto PODE aparecer** (decisão canônica: tela normal, ambiente local limpo, seeders fictícias).
- **NUNCA aparecem:** URL real de repositório, número de PR, nome real de RPC/hook/tabela, hash de commit, slug de cliente, endpoint de produção. Trocar pelos equivalentes do de-para.
- **Gate obrigatório:** `marketing/drafts/C-01-assets/CHECKLIST-ANONIMIZACAO.md` tem o de-para campo a campo (ex: `useUpdateSeller` → `useUpdateOwner`, `/gestao/transferencias` → `/admin/transfers`). Toda peça de tratamento C passa por ele ANTES do build.
- Flags perigosas de ferramenta (ex: `--dangerously-skip...`) não aparecem em conteúdo público.

## Banco de casos reais (gate de história em 1ª pessoa)

- **NUNCA inventar história em 1ª pessoa pro Vini.** Toda história "sentei sábado, terminei domingo" precisa ser caso real confirmado por ele.
- Caso não confirmado: manter o texto com marcador `<!-- TODO-VINI: confirmar caso/números antes de publicar -->` (HTML) ou `> TODO-VINI: ...` (md). A peça NÃO publica com TODO-VINI aberto.
- Números de caso (arquivos, testes, horas, valores) só com fonte real (log, manifest, registro do projeto).

## Promessa de entregável (anti-vapor)

- CTA só promete o que EXISTE: `/glossario`, `/spec-4`, Grupo VM (Vibe Coders), mentoria 1:1 via WhatsApp.
- Code Agent PRO é produto futuro em construção: nunca aparece como oferta, preço, lote ou lista VIP até existir landing + data + preço + checkout.
- Lead magnet prometido sem entregável pronto = NO-GO automático.

---

## Identidade pública aprovada

A bio dele já comunica:
> Dev sênior • Mentor de IA pra quem não programa
> Sua ideia construída por você, sem virar dev
> Pai recente | @tali_fortuna | Sigo Jesus
> 👇 Mentoria 1:1 + glossário grátis

Tudo aí é público. Conteúdo pode reforçar esses pontos.

## Onde a vida pessoal cabe vs não cabe

### Cabe (cenário, não tema)
- Carrosséis de **abertura/reposicionamento** (acontece 1x): vida pessoal pode ser mencionada como contraste ("Continuo marido da Tali, pai recente, cristão. Isso não muda. Mas...")
- Newsletter — abertura pessoal de 3 linhas em cada edição: "Comecei essa edição depois de uma noite ruim com a fase RN..."
- Stories ocasionais: foto do setup + xícara de café
- Reel "rotina": "Acordo às 5h. Aqui o que faço antes da minha filha acordar."

### Não cabe
- Carrossel de **Glossário** (Pilar 1) — puro técnico-acessível
- Carrossel de **Ferramenta da Semana** (Pilar 2) — review profissional
- Carrossel de **Prompt da Semana** (Pilar 5) — tático
- Caption de post profissional — abertura pessoal só se conecta com o tema
- Lead magnet — voz profissional sem TMI

**Regra de bolso:** se o tema é técnico (IA, ferramenta, prompt), vida pessoal só aparece em 1 frase no máximo, como cenário. Se o tema é vida (rotina, virada, abertura), aí ela pode ser central.

## Tom & limites

### Honestidade — sempre
- Se errei, conto. Se ferramenta é ruim, falo.
- Se cliente perdeu dinheiro, conto sem identificar (PLANO.md menciona "perder R$ 12.000 em AWS por isso" como exemplo)
- Se mentorado teve dificuldade, conto com permissão e anonimizado

### Vulnerabilidade — calibrada
- Confissão profissional ("perdi 6 horas com bug bobo") = forte
- Confissão emocional pesada (briga, depressão, crise) = inadequado pra esse perfil profissional
- Vulnerabilidade familiar leve ("noite ruim com a fase RN", "Tali me ajudou a achar o bug") = OK em quantidades pequenas

### Polêmica — evita
- Política partidária: nunca
- Religião como debate: nunca (Cristo aparece como identidade pessoal, não argumento)
- Brigas de creator: ignora (não responde drama, não cita inimigo público)
- Críticas a marca/produto: SIM, com fato, sem diss ("Manus quebrou no deploy 3x" > "Manus é uma porcaria")

## DM e WhatsApp — comportamento esperado

- Resposta no DM/WhatsApp é **dele mesmo**, não de robô
- Tom igual ao dos posts (humano, direto, sem firula)
- Pode demorar 1-2 dias pra responder, isso é OK e até esperado pro perfil
- Não promete o que não pode entregar

## Checklist de revisão de privacy

Antes de publicar, conferir:

- [ ] Se mencionou Tali, é OK (público no perfil)
- [ ] Se mencionou filha, **só** de forma indireta ("minha filha", "pai recente")
- [ ] Zero foto da filha mostrando rosto
- [ ] Se mencionou mentorado, **autorizado e anonimizado**
- [ ] Se mencionou cliente de software passado, **sem nome da empresa**
- [ ] Se citou outro creator, **figura pública** (não amigo privado)
- [ ] Cristo aparece como identidade, não sermão
- [ ] Vulnerabilidade calibrada (profissional ok, emocional pesada não)
- [ ] Zero polêmica política/religiosa de debate
- [ ] DM-friendly (se a pessoa abrir DM, o tom dos posts é coerente com como ele responde)
- [ ] Prova técnica passou no checklist de anonimização (zero repo/PR/RPC/hash/slug real)
- [ ] História em 1ª pessoa é caso real confirmado (zero TODO-VINI aberto)
- [ ] Todo CTA aponta pra entregável que existe (zero vapor)

## Histórico de incidente

Em sessão passada, o assistente usou "Lis" como nome da filha em vários docs (PLANO.md, IDEIAS.md, LINHA-EDITORIAL.md, carrossel rascunho). O nome correto é Helena, e mesmo assim **não deve ser citado em conteúdo público**.

A correção foi feita em todos os arquivos, e ficou estabelecida a regra: **filha NUNCA por nome**. Esse incidente é o motivo dessa skill existir — privacy infantil é prioridade absoluta.
