# skills

Minha casa de A.I. — as skills, agentes e workflows que uso nos meus projetos,
organizados por domínio. Cada pasta de topo é um domínio independente com suas
próprias skills e o próprio README explicando o quê e como usar.

## Os domínios

| Domínio | O que é | Skills |
|---|---|---|
| [`dev/`](dev/) | **Spec-Driven Development** — pipeline de desenvolvimento assistido por IA (discovery → prd → spec → developer → test-suite → code-review → pr), com agentes, hooks e references. Portável pra qualquer projeto. | 9 pipeline + `domain-template` |
| [`brand/`](brand/) | **Marca do Vini** — voz, privacidade, pilares de conteúdo, design de carrossel, sistema de Reels e formato por rede. As skills que uso em vários projetos de conteúdo. | 6 |
| [`studio/`](studio/) | **Sala de edição de YouTube** — pré-produção, transcrição, ingest, retenção, edição, Reels e criativos sociais. O julgamento editorial do `vinimachado-studio`. | 7 |

## O que é uma skill

Uma pasta com `SKILL.md` (índice + regras invioláveis) e, quando precisa, uma
`references/` com os detalhes. O agente carrega a skill quando a tarefa é relevante e
ela injeta o conhecimento no contexto — pensa numa wiki que só abre na página certa.

Pra usar num projeto novo: copie a pasta da skill pra `.claude/skills/` do projeto. O
domínio `dev/` traz também agentes, hooks e um `settings.json` de exemplo — veja
[`dev/README.md`](dev/README.md) pra instalação completa.

## Modelo: snapshot curado

Este repo é a **vitrine/biblioteca** das skills. As de `brand/` e `studio/` têm uma
fonte viva rodando dentro dos projetos de origem (`vinimachado/`, o HQ da marca, e
`vinimachado/studio/`); aqui ficam cópias curadas pra consulta e reuso. Ao editar uma
regra, mantenha **uma direção só de sync** (origem → repo, ou repo → origem) pra não
divergir. Cada README de domínio anota a fonte viva e os acoplamentos.

## Spec-Driven Development

Toda a metodologia SDD (guia de implementação, comparação com outras ferramentas e a
apresentação visual) mora em [`dev/docs/`](dev/docs/):

```
/discovery → /prd → /spec → /developer → /test-suite → /code-review → /pr
 (refine)    (what)  (how)    (build it)    (test it)     (check it)    (ship it)
```

Ou rode `/feature` — o orquestrador que faz o pipeline inteiro de uma vez.
