# Rastreabilidade — Revisão do codex-crow, Fase 0

> Fase: MVP (2.1.0). Branch `cm-revisao-fase-0-codex-mvp`. Documento:
> [revisao-fase-0-codex.md](revisao-fase-0-codex.md).

| RF | Regras | Arquivos principais | Evidência | Commit | Estado |
| --- | --- | --- | --- | --- | --- |
| RF-01 Identidade `codex-crow` | RN-01, RN-02 | marketplace, manifesto, README, `.gitignore` | validador do marketplace | `b2959a2` | implemented |
| RF-02 Migração | RN-03 | `README.md` | comandos e reinício documentados | `b2959a2` | implemented |
| RF-03 Nome aposentado | RN-02 | `package-plugin.ps1` | erro plantado rejeitado em `README.md:7` | `8195389` | implemented |
| RF-04 Política única | RN-04 | política, `develop`, `build` | bloco literal nas duas skills | `2bbb58e` | implemented |
| RF-05 Conferência e pacote | RN-05 | política, `package-plugin.ps1` | divergência plantada rejeitada; política presente no ZIP | `8195389` | implemented |
| RF-06 Versão 2.1.0 | RN-01 | `VERSION`, manifesto, README | pacote `crow-v2.1.0` criado | `ce3b767` | implemented |

## Verificado

- `package-plugin.ps1` concluiu e gerou ZIP e checksum.
- `quick_validate.py` passou nas seis skills em modo UTF-8.
- `validate_plugin.py` passou para `plugins/crow`.
- `read_marketplace_name.py` retornou `codex-crow`.
- Os dois controles novos foram vistos falhando com erros plantados e depois
  restaurados: política divergente e nome aposentado fora da migração.

## Não verificado

- Instalação pelo endereço GitHub `CaiqueRechi/codex-crow`, pois o repositório
  remoto ainda se chama `rm-skill-codex`.
- Carregamento manual das seis skills em uma nova conversa após o merge.
