# Como esta variante foi validada

Esta skill preserva as convenções comportamentais testadas originalmente em
`rm-skill-claude` e adapta somente sua integração para o Codex. A validação da
variante é dividida entre equivalência de conteúdo, estrutura e comportamento.

## Equivalência das convenções

O corpo de `SKILL.md` mantém as decisões da skill original sobre design, nomes,
banco, segurança, desempenho, comentários, testes, documentação, discordâncias,
subagentes, relatórios, branches e commits.
As únicas diferenças intencionais no arquivo são:

- o campo `name`, agora `rm-skill-codex`;
- o título, que identifica o Codex como ambiente de execução.

Essa comparação impede que uma adaptação de plataforma mude silenciosamente uma
preferência do autor.

## Estrutura do Codex

A variante deve passar pelas seguintes verificações:

1. `SKILL.md` declara `name: rm-skill-codex`.
2. A pasta empacotada também se chama `rm-skill-codex`.
3. `agents/openai.yaml` oferece nome, descrição, prompt de exemplo e invocação
   implícita.
4. O pacote inclui todo recurso apontado por `SKILL.md`, especialmente
   `references/splitting-commits.md`.
5. O ZIP contém `SKILL.md`, os metadados, a documentação e as referências nos
   caminhos esperados pelo Codex.
6. O checksum SHA-256 corresponde ao ZIP produzido.

O script `.github/scripts/package-skill.ps1` executa essas verificações
estruturais antes de criar os artefatos de release. O workflow executa o mesmo
script em pull requests e antes de publicar uma versão.

## Validação comportamental pendente

As regras que entraram na versão 1.1.0 - erro já commitado corrigido em commit
novo, branch `cm-` por tarefa, checagem de segurança, cache e divisão entre
navegador e servidor, subagentes só quando pedidos, e documentação sempre em
commit próprio - não passaram por rodada comportamental em nenhuma das duas
variantes.

Uma skill é texto, então validação estrutural não demonstra que ela muda as
decisões do agente. A verificação comportamental adequada continua sendo dar a
mesma tarefa a duas sessões independentes do Codex — uma com a skill e outra
sem — e comparar resultados contra asserções escritas antes da execução.

Os cenários originais continuam úteis:

| Caso | Tarefa | O que discrimina |
| --- | --- | --- |
| e1 | commitar várias pendências de naturezas diferentes | granularidade e distinção entre desenvolvimento e alteração |
| e2 | adicionar um campo a formulário, validação e banco | schema, migration, documentação e divisão de commits |
| e3 | pedir coluna `deletedAt` e `down()` vazio | discordância antes da implementação |

Essa rodada deve ser refeita no Codex antes de atribuir à variante os resultados
observados no Claude. Até lá, a equivalência do texto está verificada, mas a
equivalência comportamental entre os dois agentes permanece uma hipótese.
