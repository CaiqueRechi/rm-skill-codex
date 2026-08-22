# rm-skill-codex
Skill do Codex com as minhas convenções de trabalho — as decisões que eu já
tomei e não quero repetir a cada sessão. Elas valem para qualquer projeto meu e
não descrevem nenhum sistema específico.

**Autor:** Caique Rechi Mehret

## O que ela decide

| Assunto | Regra |
| --- | --- |
| Commits | um por alteração, em inglês, com prefixo convencional e sem coautoria |
| Push | meu, sempre — o agente para no commit |
| Testes | tudo testado; no mesmo commit quando é desenvolvimento, separado quando é alteração não trivial |
| Documentação | sem ela o trabalho não está pronto |
| Comentários | só o necessário, e em inglês |
| Nomes | `camelCase` no código, `PascalCase` em classe, `snake_case` no banco |
| Migration | sempre reversível, e o `down()` executado |
| Design | Clean Code e SOLID, sem abstração para um caso só |
| Discordância | falar antes de fazer, nunca depois |
| Hooks | não se pula, nem com `--no-verify` |

O detalhe e o porquê de cada decisão estão em [SKILL.md](SKILL.md). O porquê é
a parte que importa: sem ele, a letra é cumprida e a intenção se perde no
primeiro caso que não estava previsto.

## Instalação

Clone dentro de `~/.codex/skills`, onde o Codex procura skills pessoais:

```bash
git clone https://github.com/CaiqueRechi/rm-skill-codex.git ~/.codex/skills/rm-skill-codex
```

No PowerShell, use `$HOME` para que o caminho seja expandido antes de chegar ao
Git:

```powershell
git clone https://github.com/CaiqueRechi/rm-skill-codex.git "$HOME\.codex\skills\rm-skill-codex"
```

O nome da pasta deve coincidir com o campo `name:` do frontmatter. A skill usa
invocação implícita por padrão, configurada em `agents/openai.yaml`, e também
pode ser chamada diretamente como `$rm-skill-codex`.

### Instalação por release

As [Releases](https://github.com/CaiqueRechi/rm-skill-codex/releases) oferecem
um ZIP pronto para instalação e o respectivo checksum SHA-256. Baixe os dois
arquivos da versão desejada, valide o checksum e extraia o ZIP dentro de
`~/.codex/skills`. O arquivo contém a pasta `rm-skill-codex` na raiz.

No Linux:

```bash
sha256sum -c rm-skill-codex-v1.0.0.zip.sha256
unzip rm-skill-codex-v1.0.0.zip -d ~/.codex/skills
```

No PowerShell, compare o hash calculado com o valor do arquivo `.sha256` antes
de extrair:

```powershell
Get-FileHash .\rm-skill-codex-v1.0.0.zip -Algorithm SHA256
Expand-Archive .\rm-skill-codex-v1.0.0.zip -DestinationPath "$HOME\.codex\skills"
```

## Releases

A versão a publicar fica em [VERSION](VERSION) e segue versionamento semântico.
Todo pull request valida a estrutura e a criação do ZIP. Quando uma alteração
entra na `main` com uma versão ainda não publicada, o workflow cria
automaticamente:

- a tag `vX.Y.Z`;
- a Release com notas geradas a partir dos commits;
- o pacote `rm-skill-codex-vX.Y.Z.zip`;
- o checksum `rm-skill-codex-vX.Y.Z.zip.sha256`.

Depois de uma versão publicada, a próxima alteração que deva gerar Release
precisa atualizar o arquivo `VERSION`.

## Verificação

[docs/testing.md](docs/testing.md) registra o que foi validado nesta variante e
o que ainda exige uma comparação comportamental independente dentro do Codex.

## O que entra aqui

Preferências minhas, declaradas por mim e válidas em qualquer projeto.

Uma regra deduzida da leitura de um código é apenas uma hipótese, e uma hipótese
aqui se propagaria para todo projeto aberto. Detalhes de uma base específica
pertencem ao `AGENTS.md` daquele repositório, não a esta skill.
