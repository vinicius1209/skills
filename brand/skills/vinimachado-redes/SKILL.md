---
name: vinimachado-redes
description: Formato, tamanho, estrutura, cadência e CTA de cada rede da VM (Instagram, X, LinkedIn), e como adaptar uma ideia ou peça pronta para as três sem virar copia-e-cola. Carregar sempre que for escrever, adaptar ou planejar post para uma rede específica. Complementa vinimachado-voice (como soa), vinimachado-pilares (o que dizer) e vinimachado-public (o que não pode).
---

# Redes da VM: o que muda de uma rede para outra

A voz é a mesma em todo lugar (`vinimachado-voice`). O que muda é **público dominante,
tamanho, estrutura e CTA**. Público por rede e frente: `marca/ARQUITETURA.md`.
Estado de cada perfil (handle, bio, cadência, o que funcionou): `conteudo/redes/<rede>.md`.

## Regra de ouro da adaptação

Uma ideia, três peças. **Nunca o mesmo texto colado nas três redes.** Para adaptar:

1. Escreva a **tese em uma frase** (o que a pessoa leva). Ela é igual nas três.
2. Troque o **exemplo** pelo do público da rede (dono de negócio no IG, dev no X, gestor no LinkedIn).
3. Troque o **formato** (carrossel → thread → post com documento).
4. Troque o **CTA** pelo da rede (tabela abaixo). Um CTA por peça.

## Instagram (público: Jean e donos de pequeno negócio)

Regras completas de formato nas skills `vinimachado-pilares` (papel de cada formato no
algoritmo), `vinimachado-design` (carrossel) e `vinimachado-reels` (Reel). Resumo:

- Reel = descoberta. Carrossel = segundo toque e salvamento. Stories = DM e venda.
- Caption: palavra-chave ("construir com IA") nas 2 primeiras frases, 3 a 5 hashtags de nicho.
- CTA: lead magnet (Glossário, Spec-4), comunidade, WhatsApp. Régua: no máximo 1 "comenta X" a cada 4 posts.
- Agente: `carrossel-writer`, `caption-writer`, `reel-roteirista`.

## X (público: devs e builders)

- **Tamanho:** 280 caracteres por post sem Premium. Se o Vini tiver Premium, post longo é
  permitido, mas o gancho continua nos primeiros 280. Conferir em `conteudo/redes/x.md`.
- **Formatos:**
  - *Post solto:* uma observação concreta do dia ("Hoje o agente apagou X porque..."). É o grosso.
  - *Thread:* 4 a 8 posts. O primeiro precisa funcionar sozinho (gancho + promessa).
    Um post por ideia. O último fecha e convida, sem "🧵 fim".
  - *Demo:* vídeo curto ou GIF de tela (Frota rodando, antes/depois). Mostrar a tarefa, não a lista de recursos.
  - *Resposta:* comentar com substância em posts de gente maior do nicho. Conta como distribuição.
- **Link:** fora do primeiro post. Coloque na resposta ao próprio post.
- **Tom:** mais técnico que no IG (o calibre 70/20/10 inverte para mais técnico), mas sem
  jargão gratuito. Build in public com número real ou nenhum número.
- **CTA:** beta da Frota, "me segue que eu conto como terminou", pergunta aberta. Nada de "link na bio".
- Agente: `x-writer`. Pasta: `conteudo/x/`.

## LinkedIn (público: empresários, gestores, devs sêniores)

- **Tamanho:** até 3.000 caracteres. Só as primeiras ~2 linhas (por volta de 200 caracteres)
  aparecem antes do "ver mais": o gancho mora ali.
- **Formatos:**
  - *Post de texto:* caso, lição ou decisão de negócio. Parágrafos de 1 a 2 linhas, respiro entre eles.
  - *Documento (PDF):* o carrossel do IG reaproveitado. O `conteudo/build.sh` já gera o PDF em
    `conteudo/preview/<nome>-IG-1080x1350.pdf`. Ajustar a capa e o slide final pro público daqui.
  - *Caso da agência:* problema do cliente → o que foi feito → resultado observável. Só com
    autorização do cliente (`vinimachado-public`).
- **Link:** no primeiro comentário, não no corpo.
- **Hashtags:** 3 a 5, no fim.
- **Tom:** o mesmo Vini, um grau mais formal no vocabulário, zero "corporatês" ("sinergia",
  "alavancar", "case de sucesso"). Primeira pessoa, concreto.
- **CTA:** conversa no WhatsApp ou e-mail `projetos@vinimachado.dev` para agência; beta para Frota.
- Agente: `linkedin-writer`. Pasta: `conteudo/linkedin/`.

## Tabela de CTA por rede e frente

| Frente | Instagram | X | LinkedIn |
|---|---|---|---|
| Mentoria | Glossário, Spec-4, comunidade, DM | Spec-4 | Spec-4, conversa |
| Agência | WhatsApp, antes/depois | raramente | WhatsApp, e-mail |
| Produtos | Story com link | beta da Frota | beta da Frota |
| Bastidor | seguir | seguir, responder | comentar |

## Cadência de partida (o Vini tem ~8h por semana; ajustar em `conteudo/CALENDARIO.md`)

| Rede | Por semana | Esforço do Vini |
|---|---|---|
| Instagram | 2 posts (ter e sáb) + stories quando houver bastidor | gravar Reel, aprovar, postar |
| X | 3 a 5 posts soltos + 1 thread ou demo | aprovar e postar; responder |
| LinkedIn | 2 posts (1 pode ser o documento do carrossel da semana) | aprovar e postar |

Os agentes rascunham tudo. O Vini só faz o que exige presença: gravar, decidir, publicar, responder DM.

## Antes de entregar qualquer peça

1. `vinimachado-voice`: sem travessão, sem tics de IA, gíria certa.
2. `vinimachado-public`: ninguém exposto sem autorização, nada da Prime.
3. Preço, prazo ou nome de oferta citado bate com `marca/OFERTAS.md`.
4. Salvar em `conteudo/<rede>/rascunhos/AAAA-MM-DD-slug.md` com o frontmatter abaixo e rodar `content-reviewer`.

```yaml
---
rede: x | linkedin | instagram
frente: agencia | produtos | mentoria | bastidor
pilar: <pilar de vinimachado-pilares, se houver>
status: rascunho | revisado | publicado
origem: <arquivo da peça original, se for adaptação>
publicar_em: AAAA-MM-DD
---
```
