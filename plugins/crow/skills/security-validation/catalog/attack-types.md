# Catálogo de ataques

Cada ataque da seção 4.4 da especificação, agrupado por família, com a regra
que o verifica. Um ataque leva a uma regra; uma regra pode cobrir vários
ataques. Quando um mesmo ataque aparece em duas famílias, as duas apontam para
a mesma regra — não há regra duplicada.

A coluna **Revisão manual** indica `manual_review_required: true`: o ataque
não tem detector automatizado confiável e a análise descrita é obrigatória.

## Entrada e interpretação

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| SQL Injection | SQLi, blind SQLi | `SV-APP-0001` | não |
| NoSQL Injection | injeção de operador | `SV-APP-0010` | não |
| Server-Side Template Injection | SSTI | `SV-APP-0011` | não |
| XML External Entity | XXE, billion laughs | `SV-APP-0012` | não |
| Command injection | OS command injection, shell injection | `SV-APP-0013` | não |
| Desserialização insegura | object injection | `SV-APP-0014` | não |
| Parsing inconsistente | parser differential | `SV-APP-0012`, `SV-API-0001` | sim — comparar como cada componente interpreta o mesmo dado (JSON, XML, URL) |

## Navegador

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Cross-Site Scripting | XSS refletido, armazenado, DOM | `SV-APP-0002` | não |
| Cross-Site Request Forgery | CSRF, XSRF | `SV-APP-0005` | não |
| Clickjacking | UI redressing | `SV-APP-0015` | não |
| CORS permissivo | origem refletida | `SV-APP-0016` | não |
| CSP ausente ou fraca | Content-Security-Policy | `SV-APP-0009` | não |

## Identidade

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Brute force | força bruta, password guessing | `SV-IDN-0002` | não |
| Credential stuffing | password spraying | `SV-IDN-0002` | não |
| Contorno ou ausência de MFA | MFA fatigue | `SV-IDN-0003` | não |
| Abuso de reset de senha | account takeover por recuperação | `SV-IDN-0004` | não |
| Tokens e sessões | session hijacking, fixation, JWT mal validado | `SV-APP-0004` | não |

## Autorização

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| IDOR / BOLA | insecure direct object reference | `SV-APP-0003` | não |
| BFLA | broken function level authorization | `SV-APP-0003` | não |
| Escalonamento de privilégios | privilege escalation | `SV-IDN-0001` | não |
| Quebra de isolamento multi-tenant | cross-tenant access | `SV-APP-0003` | não |

## APIs

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| SSRF | server-side request forgery | `SV-APP-0006` | não |
| Ausência de rate limiting | unrestricted resource consumption | `SV-API-0001` | não |
| Falta de validação de esquema | mass assignment | `SV-API-0001` | não |
| Exposição excessiva de dados | broken object property level authorization | `SV-API-0001` | não |

## Arquivos

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Upload malicioso | webshell, unrestricted upload | `SV-APP-0008` | não |
| Path traversal | directory traversal, LFI | `SV-APP-0007` | não |
| Zip Slip | extração fora do destino, zip bomb | `SV-APP-0017` | não |
| Leitura e escrita arbitrárias | arbitrary file read/write | `SV-APP-0007` | não |

## Infraestrutura

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| TLS fraco ou mal configurado | downgrade | `SV-CRY-0001`, `SV-NET-0001` | não |
| Portas expostas | serviços não inventariados | `SV-NET-0001` | não |
| Serviços inseguros | protocolos em texto claro | `SV-NET-0001` | não |
| Falta de segmentação | rede plana | `SV-NET-0001` | sim — comparar fluxos permitidos com o diagrama aprovado |

## Host

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Execução remota de código | RCE | `SV-APP-0013`, `SV-APP-0014`, `SV-HOST-0001` | não |
| Permissões excessivas | serviço como administrador | `SV-HOST-0001` | não |
| Elevação de privilégios local | local privilege escalation | `SV-HOST-0001` | não |
| Persistência | serviço ou tarefa maliciosa | `SV-HOST-0001` | sim — revisar serviços, tarefas e inicialização contra a linha de base |

## Dados

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Segredos expostos | hard-coded credentials | `SV-DATA-0001` | não |
| Criptografia inadequada | algoritmo fraco, chave embutida | `SV-CRY-0001` | não |
| Backups expostos ou irrecuperáveis | backup público | `SV-REC-0001` | sim — testar restauração em ambiente isolado |
| Violação de integridade | adulteração de dados | `SV-DATA-0002` | sim — conferir onde a política exige verificação de integridade |
| Exposição de dados pessoais | vazamento, retenção indevida | `SV-DATA-0001`, `SV-DATA-0002` | não |

## Cloud

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| IAM excessivo | permissões de nuvem amplas | `SV-CLD-0001`, `SV-IDN-0001` | não |
| Storage público | bucket público | `SV-CLD-0001` | não |
| Abuso do serviço de metadados | IMDS | `SV-CLD-0001`, `SV-APP-0006` | não |
| Credenciais de nuvem expostas | chave de acesso no código | `SV-DATA-0001` | não |
| Serverless mal configurado | função com permissão ampla | `SV-CLD-0001` | sim — revisar gatilhos e permissões de cada função |

## Containers

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Escape de container | container breakout | `SV-CON-0001` | não |
| Permissões excessivas | privileged, capabilities | `SV-CON-0001` | não |
| Imagens vulneráveis | CVE em imagem | `SV-SCM-0001`, `SV-CON-0001` | não |
| Segredos em imagem | secret em camada | `SV-CON-0001`, `SV-DATA-0001` | não |
| RBAC excessivo | cluster-admin indevido | `SV-CON-0001` | não |

## Supply chain

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Dependências vulneráveis | CVE em biblioteca | `SV-SCM-0001` | não |
| Pacotes maliciosos | typosquatting, dependency confusion | `SV-SCM-0001` | sim — conferir origem e mantenedores de pacotes novos |
| Artefatos adulterados | build comprometido | `SV-SCM-0001`, `SV-DEV-0001` | não |
| Ausência de assinatura | integridade não verificável | `SV-SCM-0001` | não |

## CI/CD

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Segredos no pipeline | secret em log de CI | `SV-DEV-0001` | não |
| Permissões excessivas do pipeline | token com escrita ampla | `SV-DEV-0001` | não |
| Execução de código não confiável | poisoned pipeline execution | `SV-DEV-0001` | não |
| Contorno da aprovação de release | push direto em branch protegida | `SV-DEV-0001` | não |

## IA

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Prompt injection | injeção direta e indireta | `SV-AI-0001` | sim — o comportamento do modelo não é determinístico |
| Vazamento de dados | LLM data leakage | `SV-AI-0001` | não |
| Isolamento de ferramentas | tool invocation fora da política | `SV-AI-0001` | não |
| Abuso de agentes | excessive agency | `SV-AI-0001` | não |
| Envenenamento e backdoor | data poisoning, modelo adulterado | `SV-AI-0002` | sim — revisar a linhagem dos dados e dos modelos |

## IoT/OT

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Firmware inseguro | firmware sem atualização assinada | `SV-IOT-0001` | sim |
| Interfaces administrativas expostas | credencial de fábrica, porta de depuração | `SV-IOT-0001` | sim |
| Protocolos industriais sem autenticação | Modbus, DNP3 expostos | `SV-OT-0001` | sim |

## Disponibilidade

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| ReDoS | catastrophic backtracking | `SV-RES-0002` | não |
| Exaustão de recursos | DoS de aplicação | `SV-RES-0001` | não |
| Filas sem limite | backlog infinito | `SV-RES-0001` | não |
| Retry storms | amplificação por retry | `SV-RES-0001` | sim — revisar política de retry das dependências |

## Lógica de negócio

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Fraude de preço | manipulação de valor | `SV-BIZ-0001` | sim — comparar com a regra de negócio documentada |
| Repetição de transações | replay, duplo envio | `SV-BIZ-0001` | não |
| Abuso de reembolsos | reembolso duplicado | `SV-BIZ-0001` | sim |
| Concorrência | race condition, double spend | `SV-BIZ-0001` | não |
| Automação abusiva | bots, scraping, spam de cadastro | `SV-BIZ-0002` | não |

## Operação

| Ataque | Também conhecido como | Regra | Revisão manual |
| --- | --- | --- | --- |
| Logs insuficientes | ausência de trilha de auditoria | `SV-MON-0001` | não |
| Adulteração de logs | indicator removal | `SV-MON-0001` | não |
| Falha de detecção | alerta que não dispara | `SV-MON-0001` | sim — validar a cadeia de coleta |
| Falha de recuperação | restore que não funciona | `SV-REC-0001` | sim |

## Sem detector automatizado

Ameaças dos domínios da seção 2.1 que não viram teste da skill, mas entram no
catálogo para não sumirem da avaliação. Quando estão no escopo, a skill
registra a análise abaixo como revisão manual e o estado resultante.

| Ameaça | Domínio | Análise necessária | Regras relacionadas |
| --- | --- | --- | --- |
| Malware, persistência, evasão, movimento lateral, C2 | 14 | revisar EDR, linha de base de serviços e tarefas, segmentação e saída de rede; nunca instalar ou simular malware | `SV-HOST-0001`, `SV-NET-0001`, `SV-MON-0001` |
| Engenharia social e phishing | 15 | revisar MFA resistente a phishing, processos de verificação fora de banda e treinamento; nunca enviar phishing sem programa autorizado | `SV-IDN-0003`, `SV-IDN-0004` |
| Comprometimento de identidade federada | 3 | revisar configuração do provedor (redirect URIs, validação de tokens, consentimento) | `SV-APP-0004`, `SV-IDN-0001` |
