# Taxonomia

Vocabulário fixo da skill. Toda regra, todo achado e todo relatório usam estes
termos e estas categorias.

## Hierarquia de conceitos

Ataques, vulnerabilidades, fraquezas e controles não são sinônimos.

| Conceito | Definição | Exemplo |
| --- | --- | --- |
| Ameaça | Evento ou comportamento capaz de causar dano | Roubo de sessão |
| Técnica de ataque | Método utilizado pelo adversário | Session hijacking |
| Fraqueza | Erro de projeto, código ou configuração | Cookie sem proteção adequada |
| Vulnerabilidade | Fraqueza que cria uma condição de risco verificável | Sessão reutilizável exposta a terceiros |
| Controle | Medida preventiva, detectiva ou corretiva | HTTPS, atributos de cookie e rotação de sessão |
| Evidência | Informação observável que sustenta um achado | Cookie emitido sem `Secure` |
| Achado | Resultado documentado da avaliação | Configuração de sessão inadequada |
| Risco | Impacto potencial combinado com probabilidade | Comprometimento de contas |

Uma fraqueza não é classificada automaticamente como explorável. A
classificação depende do contexto, das proteções existentes e das evidências
disponíveis.

## Categorias canônicas

Identificadores estáveis, independentes de idioma. Novas categorias podem ser
acrescentadas; as existentes não mudam de nome nem de significado.

- `APP.INJECTION`
- `APP.OUTPUT_ENCODING`
- `APP.AUTHENTICATION`
- `APP.AUTHORIZATION`
- `APP.SESSION`
- `APP.FILE_HANDLING`
- `APP.BUSINESS_LOGIC`
- `APP.API_SECURITY`
- `APP.CLIENT_SECURITY`
- `APP.CRYPTOGRAPHY`
- `APP.ERROR_HANDLING`
- `DATA.CONFIDENTIALITY`
- `DATA.INTEGRITY`
- `DATA.AVAILABILITY`
- `DATA.PRIVACY`
- `IDENTITY.CREDENTIALS`
- `IDENTITY.FEDERATION`
- `IDENTITY.PRIVILEGE`
- `NETWORK.PROTOCOL`
- `NETWORK.SEGMENTATION`
- `NETWORK.AVAILABILITY`
- `HOST.EXECUTION`
- `HOST.PRIVILEGE`
- `HOST.PERSISTENCE`
- `HOST.DEFENSE_EVASION`
- `CLOUD.CONFIGURATION`
- `CLOUD.IDENTITY`
- `CLOUD.DATA_EXPOSURE`
- `CONTAINER.ISOLATION`
- `CONTAINER.ORCHESTRATION`
- `SUPPLY_CHAIN.DEPENDENCY`
- `SUPPLY_CHAIN.BUILD`
- `SUPPLY_CHAIN.ARTIFACT`
- `DEVSECOPS.PIPELINE`
- `IOT.DEVICE_SECURITY`
- `OT.INDUSTRIAL_SECURITY`
- `AI.PROMPT_INJECTION`
- `AI.DATA_SECURITY`
- `AI.MODEL_SECURITY`
- `AI.AGENT_SECURITY`
- `MONITORING.AUDIT`
- `MONITORING.DETECTION`
- `RECOVERY.BACKUP`
- `RECOVERY.RESILIENCE`
- `SOCIAL_ENGINEERING.HUMAN`
- `FRAUD.TRANSACTION`
- `FRAUD.AUTOMATION`

## Identificação dos controles

Formato: `SV-<DOMÍNIO>-<NÚMERO>`, com número de quatro dígitos.

| Domínio | Abrange |
| --- | --- |
| `APP` | aplicação: injeção, saída, sessão, arquivos, navegador |
| `API` | APIs e integrações |
| `IDN` | identidade, credenciais, privilégios |
| `DATA` | segredos, dados sensíveis, integridade, privacidade |
| `CRY` | criptografia, chaves, certificados |
| `NET` | rede e protocolos |
| `HOST` | sistema operacional |
| `CLD` | nuvem |
| `CON` | containers e orquestração |
| `SCM` | dependências e cadeia de suprimentos |
| `DEV` | CI/CD e repositórios |
| `RES` | disponibilidade e consumo de recursos |
| `AI` | sistemas de IA, LLMs e agentes |
| `BIZ` | lógica de negócio e fraude |
| `MON` | auditoria e monitoramento |
| `REC` | backup e recuperação |
| `IOT` | dispositivos e firmware |
| `OT` | sistemas industriais |

Os códigos `SV-*` são **identificadores internos**. Nunca apresentá-los como
identificadores OWASP, CWE ou MITRE.

Um identificador, uma vez publicado, é imutável: não muda de regra, não é
reaproveitado. Uma regra retirada continua no catálogo marcada como
descontinuada.

## Campos de identidade e deduplicação

Todo item do catálogo carrega:

| Campo (seção 4.3) | Onde fica no contrato da regra |
| --- | --- |
| `id` | `id` |
| `canonical_name` | `canonical_name` — nome canônico em inglês |
| `display_name_pt_br` | `display_name_pt_br` |
| `aliases` | `aliases` — nomes alternativos e sinônimos |
| `category` | `category` — uma das categorias canônicas acima |
| `weakness_refs` | `references.cwe` |
| `verification_refs` | `references.asvs` e `references.wstg` |
| `attack_refs` | `references.attack` (ATT&CK) e `references.atlas` (ATLAS, para IA) |
| `related_controls` | `related_controls` |
| `duplicate_of` | `duplicate_of` — `null`, ou o id canônico quando o item é um alias duplicado |

Dois ataques não são equivalentes só porque compartilham palavras. SQL
Injection (`SV-APP-0001`), NoSQL Injection (`SV-APP-0010`) e Command Injection
(`SV-APP-0013`) são regras diferentes, com critérios diferentes.

## Estados de avaliação

Mutuamente exclusivos, por regra e por ativo.

| Estado | Significado |
| --- | --- |
| `PASS` | Os critérios de aprovação foram demonstrados com evidência suficiente. |
| `FAIL` | Uma condição de reprovação foi comprovada. |
| `INCONCLUSIVE` | Não há evidência suficiente para aprovar ou reprovar. |
| `NOT_APPLICABLE` | A regra não se aplica ao ativo avaliado, com justificativa. |
| `NOT_TESTED` | A regra não foi executada. |
| `ERROR` | O teste falhou por erro técnico, sem conclusão de segurança. |
| `SUPPRESSED` | O achado foi suprimido por exceção aprovada e documentada. |

`NOT_TESTED`, `ERROR` e `INCONCLUSIVE` nunca viram `PASS`. Uma regra aplicável
sem evidência suficiente não é aprovada por ausência de alertas.
