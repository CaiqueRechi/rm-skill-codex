# {{PROJETO}}

> Arquivo de orientação para {{AGENTE}}. Fica fora do git e foi criado por
> `$crow:context` (plugin `crow`). `CLAUDE.md`, `AGENTS.md` e `GEMINI.md` têm o
> mesmo conteúdo, só muda esta linha — cada ferramenta lê o seu.

{{RESUMO_EM_DUAS_LINHAS}}

## Antes de qualquer coisa

Este projeto passa de uma sessão para outra, e de uma ferramenta para outra,
pelos arquivos abaixo. Leia todos antes de agir:

1. [CONTEXT.md](CONTEXT.md) — estado atual, objetivos, decisões e restrições
2. [ARCHITECTURE.md](ARCHITECTURE.md) — arquitetura técnica
3. [TASKS.md](TASKS.md) — o que está feito, em andamento e a seguir
4. [.context/HANDOFF.md](.context/HANDOFF.md) — onde a última sessão parou e a próxima ação
5. [.context/CONVENTIONS.md](.context/CONVENTIONS.md) — as convenções de trabalho do Caique; valem em tudo que você fizer aqui
6. `.context/messages/` — mensagens com `to:` igual ao seu id, à sua ferramenta ou `all`, e `status: new`. Depois de agir sobre uma, mude para `status: read`.

Confira se branch, último commit e arquivos pendentes do HANDOFF batem com o
`git` de agora. Se não batem, alguém continuou depois — diga isso antes de
seguir. Depois continue da **próxima ação** do HANDOFF; não refaça o que já
está concluído.

## Antes de parar

Quando terminar, trocar de modelo ou perceber que o contexto está acabando:

- `TASKS.md` — mova o que terminou, atualize o que está em andamento
- `CONTEXT.md` — atualize o estado atual; decisões novas entram como linha nova na tabela, as antigas não são editadas
- `ARCHITECTURE.md` — só se a arquitetura mudou
- `.context/HANDOFF.md` — onde parou e **uma** próxima ação concreta
- `.context/sessions/<AAAA-MM-DD>-<seu id>.md` — acrescente o que fez nesta sessão

Seu id é ferramenta + modelo, minúsculo e com hífen: `codex-gpt-5`,
`claude-code-opus-5.5`, `gemini-cli-2.5-pro`.

## Falar com outro agente

Crie `.context/messages/<AAAAMMDD-HHMMSS>-<seu id>-to-<destino>.md` com
`from`, `to`, `date`, `status: new` e o texto. Um arquivo por mensagem, nunca
um arquivo compartilhado. Para responder, crie outra com `reply_to:` apontando
o arquivo original.

## Regras inegociáveis

- **Subagentes só quando o Caique pedir explicitamente**, nesta conversa. Só então.
- **Recomeçar do zero nunca é o caminho mais fácil.** Não apague trabalho para
  refazer; construa sobre o que existe. Nunca afirme que algo existe, funciona
  ou foi verificado sem ter visto — diga o que viu e o que está deduzindo.
- **Pergunte antes de uma mudança grande.** Dúvida que possa mudar a
  arquitetura ou fugir de qualquer regra documentada: pare e pergunte a ele
  explicitamente.
- **Nunca faça commit com coautoria.** Nenhum `Co-Authored-By` nem outro
  trailer de atribuição.
- **Nenhum destes arquivos vai para o git.** Nunca adicione `CLAUDE.md`,
  `AGENTS.md`, `GEMINI.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `TASKS.md` ou
  `.context/` a um commit.
