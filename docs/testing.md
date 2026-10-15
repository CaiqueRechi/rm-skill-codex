# Como esta versão foi validada

A 2.0.0 transforma a skill avulsa das convenções no plugin `crow`, com as seis
skills do `rm-skill-claude` 1.0.1 adaptadas para o Codex. A validação se divide
em equivalência de texto, estrutura e comportamento — e só as duas primeiras
foram feitas.

## Equivalência do texto

Cada arquivo de `plugins/crow/skills/` foi comparado com o original em
`rm-skill-claude/skills/` (`diff -r`). As únicas diferenças são as adaptações
listadas no [README](../README.md#o-que-muda-em-relação-ao-claude-code):

- `/crow:` virou `$crow:` em todos os arquivos;
- cada `$ARGUMENTS` virou uma frase dizendo que os argumentos são o que ele
  escreveu depois de `$crow:<skill>` (`analyst`, `build`, `context`, `develop`,
  `security-validation`);
- na `analyst`, a instrução de usar `AskUserQuestion` virou "a ferramenta de
  pergunta da ferramenta quando houver; senão, opções numeradas";
- `argument-hint` e `disable-model-invocation` saíram do frontmatter;
  `version` e `language` da `security-validation` foram para `metadata`;
- cada skill ganhou `agents/openai.yaml`.

A `conventions` era a única skill que já existia aqui. Comparada com a do
`crow` antes da troca, a diferença era o título ("… for Codex") e a falta do
bloco de regras inegociáveis; o `splitting-commits.md` era idêntico. A versão
nova é a do `crow`, então nada foi perdido e o bloco passou a existir.

## Estrutura

Validado com as ferramentas do próprio Codex instaladas na máquina:

| Verificação | Ferramenta | Resultado |
| --- | --- | --- |
| manifesto, campos aceitos, `SKILL.md` e `agents/openai.yaml` de cada skill | `plugin-creator/scripts/validate_plugin.py plugins/crow` | passou |
| nome do marketplace | `plugin-creator/scripts/read_marketplace_name.py` | passou (`rm-skill-codex`) |
| frontmatter de cada skill (só campos aceitos) | `skill-creator/scripts/quick_validate.py` nas seis | as seis passaram |
| pacote de release | `.github/scripts/package-plugin.ps1` | passou; recusou, de propósito, um `/crow:` deixado numa skill e um `plugin.json` com versão diferente de `VERSION` |

O `package-plugin.ps1` repete no CI o que dá para checar sem o Codex: versão
igual nos dois arquivos, plugin listado no marketplace, nome de cada pasta
igual ao `name:`, bloco de regras inegociáveis em toda skill,
`agents/openai.yaml` presente, e nenhum `$ARGUMENTS`, `AskUserQuestion`,
`disable-model-invocation`, `argument-hint` ou `/crow:` sobrando. Depois de
montar o ZIP, confere que `.agents/plugins/marketplace.json` e
`.codex-plugin/plugin.json` estão dentro dele: são pastas ocultas no Linux, e o
`Compress-Archive` as deixaria de fora sem erro. Essa parte não foi exercida
no Linux antes do primeiro CI — só no Windows.

Fontes do formato: a documentação de plugins do Codex
(`developers.openai.com/plugins/build/plugins`) para o marketplace em
`.agents/plugins/marketplace.json` e o `codex plugin marketplace add`; as
skills de plugins instalados (`$codex-security:…`, `$google-drive:…`) para a
chamada `$<plugin>:<skill>`; o validador do `plugin-creator`, que recusa
`disable-model-invocation: true`, para a troca por `openai.yaml`.

## Teste manual pendente

Não houve Codex CLI nesta máquina para instalar o plugin de ponta a ponta. O
roteiro abaixo é o aceite da 2.0.0, e só precisa ser refeito quando as
adaptações mudarem:

1. `codex plugin marketplace add CaiqueRechi/rm-skill-codex`, instalar o `crow`
   e abrir uma conversa nova. As seis skills aparecem ao digitar `$crow:`.
2. `$crow:context` num projeto de teste cria só os arquivos que faltam;
   `$crow:context save` e `$crow:context resume` funcionam.
3. `$crow:conventions` carrega sozinha antes de um commit, sem ser chamada.
4. `$crow:analyst <pedido>` faz uma pergunta por mensagem, com opções, e retoma
   de um `.context/HANDOFF.md`.
5. `$crow:develop` lê um documento de `docs/requirements/` e para no fim da
   fase.
6. `$crow:build status` responde sem subir nada.
7. `$crow:security-validation` sobre o fixture `php-app` do `rm-skill-claude`
   escreve o relatório em `docs/security/`.
8. Nenhuma das cinco skills de chamada explícita roda sem ser chamada.

Até esse roteiro passar, a equivalência do texto está verificada, mas a
equivalência de comportamento entre Claude e Codex continua uma hipótese.
