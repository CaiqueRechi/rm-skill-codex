# Disponibilidade, monitoramento e recuperação

`SV-RES-0001`, `SV-MON-0001` e `SV-REC-0001` são do conjunto mínimo
obrigatório. `SV-RES-0002` cobre ReDoS, da família "Disponibilidade".

Testes desta família **nunca** são de estresse destrutivo nem rodam contra
produção por padrão. Ver [policies/safe-testing.md](../policies/safe-testing.md).

---

## SV-RES-0001 — Disponibilidade e abuso de recursos

```yaml
id: SV-RES-0001
canonical_name: Availability and Resource Abuse
display_name_pt_br: Disponibilidade e abuso de recursos
aliases: [DoS, exaustão de recursos, rate limiting, retry storm, amplificação, filas]
category: DATA.AVAILABILITY
description: >
  Verifica limites de tamanho, concorrência, tempo e consumo, a proteção de
  operações custosas e se filas, retries e dependências não produzem
  amplificação descontrolada.
scope:
  asset_types: [web_application, api, cloud, container]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-400, CWE-770, CWE-799]
  asvs: [V2.4.1, V5.2.1, V15.2.2, V16.5.2]
  wstg: []
  attack: [T1499, T1499.003]
severity_default: medium
confidence_threshold: medium
preconditions:
  - Existem operações cujo custo depende da entrada, ou dependências externas com retry.
pass_criteria:
  - Existem limites adequados para tamanho, concorrência, tempo e consumo.
  - Operações custosas possuem mecanismos de proteção.
  - Filas, retries e dependências não produzem amplificação descontrolada.
  - Os controles de recuperação atendem aos requisitos documentados.
fail_criteria:
  - Um teste limitado demonstra consumo desproporcional ou indisponibilidade além do limite aprovado.
  - Uma entrada específica causa esgotamento de recursos reproduzível em ambiente controlado.
inconclusive_criteria:
  - Não há ambiente controlado para teste com carga segura.
  - Os SLOs e limites aceitáveis não estão definidos.
false_positive_guidance:
  - Latência isolada não comprova DoS.
  - Limites precisam considerar carga esperada e SLOs.
  - Não executar testes de estresse destrutivos em produção como mecanismo padrão.
remediation:
  - Definir limites de tamanho, tempo e taxa no servidor.
  - Paginar e mover operações pesadas para filas com concorrência limitada.
  - Usar backoff com jitter e circuit breaker nas dependências.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-RES-0002, SV-API-0001, SV-BIZ-0002]
duplicate_of: null
```

Métodos: revisão de limites e testes controlados com carga segura.

**Aprovar quando:**
- Existem limites adequados para tamanho, concorrência, tempo e consumo.
- Operações custosas possuem mecanismos de proteção.
- Filas, retries e dependências não produzem amplificação descontrolada.
- Os controles de recuperação atendem aos requisitos documentados.

**Reprovar quando:**
- Um teste limitado demonstra consumo desproporcional ou indisponibilidade além do limite aprovado.
- Uma entrada específica causa esgotamento de recursos reproduzível em ambiente controlado.

**Falsos positivos:**
- Latência isolada não comprova DoS.
- Limites precisam considerar carga esperada e SLOs.
- Não executar testes de estresse destrutivos em produção como mecanismo padrão.

---

## SV-RES-0002 — ReDoS

```yaml
id: SV-RES-0002
canonical_name: Regular Expression Denial of Service
display_name_pt_br: Negação de serviço por expressão regular
aliases: [ReDoS, catastrophic backtracking, backtracking exponencial]
category: DATA.AVAILABILITY
description: >
  Verifica se expressões regulares aplicadas a entrada não confiável podem
  levar a tempo de execução exponencial.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, dynamic_testing]
references:
  cwe: [CWE-1333]
  asvs: [V1.3.12]
  wstg: []
  attack: [T1499.004]
severity_default: medium
confidence_threshold: medium
preconditions:
  - Expressões regulares são aplicadas a entrada externa.
pass_criteria:
  - Expressões aplicadas a entrada externa não têm quantificadores aninhados ou alternâncias sobrepostas com backtracking exponencial.
  - O tamanho da entrada é limitado antes da expressão.
  - O motor ou a configuração limita o tempo de execução quando disponível.
fail_criteria:
  - Uma entrada de teste pequena faz o tempo de execução crescer de forma não linear além do limite aprovado, medido em ambiente controlado.
inconclusive_criteria:
  - A expressão é montada dinamicamente e não pôde ser analisada.
  - O motor de expressão regular em uso não pôde ser identificado.
false_positive_guidance:
  - Expressão com padrão suspeito aplicada só a dados internos não é exposta ao usuário.
  - Motores sem backtracking (por exemplo RE2) não sofrem esse ataque.
  - Medir em ambiente controlado e parar o teste no limite definido.
remediation:
  - Reescrever a expressão sem quantificadores aninhados ambíguos.
  - Limitar o tamanho da entrada antes de aplicá-la.
  - Usar motor sem backtracking ou com limite de tempo.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-RES-0001]
duplicate_of: null
```

Métodos: análise estática das expressões e teste controlado de tempo de execução.

**Aprovar quando:**
- Expressões aplicadas a entrada externa não têm quantificadores aninhados ou alternâncias sobrepostas com backtracking exponencial.
- O tamanho da entrada é limitado antes da expressão.
- O motor ou a configuração limita o tempo de execução quando disponível.

**Reprovar quando:**
- Uma entrada de teste pequena faz o tempo de execução crescer de forma não linear além do limite aprovado, medido em ambiente controlado.

**Falsos positivos:**
- Expressão com padrão suspeito aplicada só a dados internos não é exposta ao usuário.
- Motores sem backtracking (por exemplo RE2) não sofrem esse ataque.
- Medir em ambiente controlado e parar o teste no limite definido.

---

## SV-MON-0001 — Auditoria e monitoramento

```yaml
id: SV-MON-0001
canonical_name: Audit Logging and Monitoring
display_name_pt_br: Auditoria e monitoramento
aliases: [logging insuficiente, log injection, adulteração de logs, detecção, alertas, SIEM]
category: MONITORING.AUDIT
description: >
  Verifica se eventos de segurança críticos são registrados, se os logs têm
  controle de acesso e integridade, se dados sensíveis ficam fora deles e se
  alertas estão alinhados aos riscos.
scope:
  asset_types: [web_application, api, operating_system, cloud, logging_system]
methods: [configuration_review, static_analysis, dynamic_testing]
references:
  cwe: [CWE-778, CWE-117, CWE-223, CWE-532]
  asvs: [V16.2.1, V16.3.1, V16.3.2, V16.4.1, V16.4.2]
  wstg: []
  attack: [T1070, T1685]
severity_default: medium
confidence_threshold: medium
preconditions:
  - Existe, ou deveria existir, uma lista de eventos de segurança a registrar.
pass_criteria:
  - Eventos de segurança críticos são registrados.
  - Logs possuem controles de acesso e integridade apropriados.
  - Segredos e dados pessoais não são registrados indevidamente.
  - Alertas e mecanismos de resposta estão alinhados aos riscos definidos.
fail_criteria:
  - Um evento obrigatório não é registrado ou pode ser alterado indevidamente.
  - A configuração expõe dados sensíveis em logs.
  - Um controle de detecção obrigatório falha em um teste controlado.
inconclusive_criteria:
  - O destino final dos logs não pôde ser inspecionado.
  - Não existe lista de eventos obrigatórios para comparar.
false_positive_guidance:
  - A ausência de um alerta não prova, sozinha, falha no mecanismo de detecção.
  - Uma regra pode registrar eventos em um destino diferente do inicialmente inspecionado.
  - Validar a cadeia de coleta antes de concluir que o evento foi perdido.
remediation:
  - Registrar autenticação, falhas de autorização e alterações privilegiadas com quem, quando, onde e o quê.
  - Enviar logs para destino separado e protegido contra alteração.
  - Codificar dados no log e mascarar informação sensível.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-DATA-0001, SV-REC-0001]
duplicate_of: null
```

Métodos: inspeção de configuração e testes controlados de eventos.

**Aprovar quando:**
- Eventos de segurança críticos são registrados.
- Logs possuem controles de acesso e integridade apropriados.
- Segredos e dados pessoais não são registrados indevidamente.
- Alertas e mecanismos de resposta estão alinhados aos riscos definidos.

**Reprovar quando:**
- Um evento obrigatório não é registrado ou pode ser alterado indevidamente.
- A configuração expõe dados sensíveis em logs.
- Um controle de detecção obrigatório falha em um teste controlado.

**Falsos positivos:**
- A ausência de um alerta não prova, sozinha, falha no mecanismo de detecção.
- Uma regra pode registrar eventos em um destino diferente do inicialmente inspecionado.
- Validar a cadeia de coleta antes de concluir que o evento foi perdido.

---

## SV-REC-0001 — Backup e recuperação

```yaml
id: SV-REC-0001
canonical_name: Backup and Recovery
display_name_pt_br: Backup e recuperação
aliases: [backup, restore, RPO, RTO, ransomware, recuperação de desastre]
category: RECOVERY.BACKUP
description: >
  Verifica proteção de acesso e retenção dos backups, se a restauração é
  verificada, se RPO e RTO são atendidos e se a recuperação não depende só de
  recursos comprometíveis junto com o ambiente principal.
scope:
  asset_types: [backup_system, database, cloud, operating_system]
methods: [manual_review, configuration_review, dynamic_testing]
references:
  cwe: [CWE-530]
  asvs: []
  wstg: []
  attack: [T1490]
  note: O CWE cobre a exposição de backups; recuperabilidade não tem CWE e segue o RPO e RTO definidos pelo responsável.
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem dados ou sistemas com requisito de recuperação.
  - RPO e RTO estão definidos, ou o responsável pode defini-los.
pass_criteria:
  - Backups possuem proteção de acesso e retenção adequada.
  - A integridade e a possibilidade de restauração são verificadas.
  - RPO e RTO definidos são atendidos nos testes aplicáveis.
  - Os procedimentos de recuperação não dependem exclusivamente de recursos comprometíveis junto ao ambiente principal.
fail_criteria:
  - Dados de backup estão acessíveis a identidades não autorizadas.
  - Uma restauração controlada falha em requisito obrigatório.
  - Os objetivos de recuperação não são cumpridos.
inconclusive_criteria:
  - Não houve ambiente isolado para testar a restauração.
  - RPO e RTO não estão definidos.
false_positive_guidance:
  - A existência de um arquivo de backup não comprova recuperabilidade.
  - Um backup offline pode exigir procedimento específico para restauração.
  - Não executar restauração destrutiva sobre dados de produção.
remediation:
  - Restringir o acesso aos backups e manter cópia isolada ou imutável.
  - Testar restauração periodicamente em ambiente isolado e medir RPO e RTO.
  - Documentar o procedimento de recuperação.
requires_authorization: true
safe_by_default: true
manual_review_required: true
related_controls: [SV-DATA-0002, SV-MON-0001]
duplicate_of: null
```

Métodos: revisão de políticas e testes de restauração em ambiente controlado.

**Aprovar quando:**
- Backups possuem proteção de acesso e retenção adequada.
- A integridade e a possibilidade de restauração são verificadas.
- RPO e RTO definidos são atendidos nos testes aplicáveis.
- Os procedimentos de recuperação não dependem exclusivamente de recursos comprometíveis junto ao ambiente principal.

**Reprovar quando:**
- Dados de backup estão acessíveis a identidades não autorizadas.
- Uma restauração controlada falha em requisito obrigatório.
- Os objetivos de recuperação não são cumpridos.

**Falsos positivos:**
- A existência de um arquivo de backup não comprova recuperabilidade.
- Um backup offline pode exigir procedimento específico para restauração.
- Não executar restauração destrutiva sobre dados de produção.
