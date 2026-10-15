# Lógica de negócio

`SV-BIZ-0001` é do conjunto mínimo obrigatório. `SV-BIZ-0002` cobre o abuso
por automação — bots criando registros, fraude roteirizada — da categoria
`FRAUD.AUTOMATION`.

Testes desta família usam **dados fictícios** e contas de teste. Nunca
transações reais.

---

## SV-BIZ-0001 — Lógica de negócio e transações

```yaml
id: SV-BIZ-0001
canonical_name: Business Logic and Transaction Integrity
display_name_pt_br: Lógica de negócio e transações
aliases: [fraude de preço, race condition, reembolso duplicado, pulo de etapa, replay de transação, manipulação de fluxo]
category: APP.BUSINESS_LOGIC
description: >
  Verifica se o servidor valida valores, estados e transições, se operações
  críticas são idempotentes e se a concorrência não viola invariantes de
  negócio.
scope:
  asset_types: [web_application, api]
methods: [manual_review, static_analysis, dynamic_testing]
references:
  cwe: [CWE-841, CWE-362, CWE-367, CWE-472, CWE-837]
  asvs: [V2.3.1, V2.3.2, V2.3.3, V2.3.4, V15.4.2]
  wstg: [WSTG-BUSL-01, WSTG-BUSL-02, WSTG-BUSL-04, WSTG-BUSL-06]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem regras de preço, saldo, estoque, aprovação, reembolso ou fluxos com etapas.
  - As regras de negócio estão documentadas ou podem ser obtidas do responsável.
pass_criteria:
  - O servidor valida valores, estados e transições.
  - Operações críticas são idempotentes quando necessário.
  - Regras de preço, saldo, aprovação e reembolso são verificadas no backend.
  - A concorrência não permite violar invariantes financeiros ou de negócio.
fail_criteria:
  - Uma operação autorizada viola uma regra de negócio obrigatória.
  - Requisições repetidas ou concorrentes produzem uma transação indevida.
  - Um cliente consegue alterar valores que deveriam ser determinados pelo servidor.
inconclusive_criteria:
  - As regras de negócio não estão documentadas e o responsável não pôde confirmá-las.
  - O teste de concorrência não pôde ser executado com dados fictícios.
false_positive_guidance:
  - Diferenças de arredondamento precisam ser comparadas à regra de negócio definida.
  - Um reembolso legítimo não constitui fraude.
  - A análise deve considerar consistência transacional, filas e sistemas externos.
remediation:
  - Calcular preços, totais e saldos no servidor.
  - Usar transações, travas e chaves de idempotência nas operações críticas.
  - Validar a máquina de estados em cada transição.
requires_authorization: true
safe_by_default: true
manual_review_required: true
related_controls: [SV-BIZ-0002, SV-APP-0003]
duplicate_of: null
```

Métodos: revisão de invariantes, análise de fluxos e testes com dados fictícios.

**Aprovar quando:**
- O servidor valida valores, estados e transições.
- Operações críticas são idempotentes quando necessário.
- Regras de preço, saldo, aprovação e reembolso são verificadas no backend.
- A concorrência não permite violar invariantes financeiros ou de negócio.

**Reprovar quando:**
- Uma operação autorizada viola uma regra de negócio obrigatória.
- Requisições repetidas ou concorrentes produzem uma transação indevida.
- Um cliente consegue alterar valores que deveriam ser determinados pelo servidor.

**Falsos positivos:**
- Diferenças de arredondamento precisam ser comparadas à regra de negócio definida.
- Um reembolso legítimo não constitui fraude.
- A análise deve considerar consistência transacional, filas e sistemas externos.

---

## SV-BIZ-0002 — Abuso por automação

```yaml
id: SV-BIZ-0002
canonical_name: Automation Abuse
display_name_pt_br: Abuso por automação
aliases: [bots, spam de cadastro, scraping, fraude automatizada, honeypot, captcha, anti-automação]
category: FRAUD.AUTOMATION
description: >
  Verifica se fluxos que criam registros, consomem recursos ou têm valor de
  negócio resistem a submissões automatizadas.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-799]
  asvs: [V2.4.1, V2.4.2]
  wstg: [WSTG-BUSL-05, WSTG-BUSL-07]
  attack: []
severity_default: medium
confidence_threshold: medium
preconditions:
  - Existe formulário ou endpoint que cria registros, envia mensagens, consome cota ou concede benefício.
pass_criteria:
  - Esses fluxos têm limitação por usuário e por origem.
  - Formulários públicos têm defesa contra bots (honeypot, tempo mínimo de preenchimento ou captcha).
  - Validação e rejeição de duplicatas acontecem no servidor.
  - Fluxos de alto valor exigem ritmo humano realista.
fail_criteria:
  - Um teste limitado e autorizado cria registros de teste em volume não aceito pela política, sem bloqueio.
  - A única defesa contra automação roda no navegador e é contornada.
inconclusive_criteria:
  - A proteção é feita por componente externo (WAF, serviço anti-bot) não inspecionável.
  - Não existe limite definido pela política para comparar.
false_positive_guidance:
  - Endpoint de integração entre sistemas pode ter limites diferentes, por decisão documentada.
  - Captcha não é obrigatório quando outras defesas equivalentes existem.
  - Testar com volume pequeno e só em ambiente autorizado; não gerar carga real.
remediation:
  - Limitar por usuário e por IP no servidor.
  - Adicionar honeypot, tempo mínimo ou captcha em formulários públicos.
  - Rejeitar duplicatas onde não fazem sentido.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-IDN-0002, SV-BIZ-0001, SV-RES-0001]
duplicate_of: null
```

Métodos: análise estática, revisão de configuração e testes dinâmicos de baixo volume.

**Aprovar quando:**
- Fluxos que criam registros ou consomem recursos têm limitação por usuário e por origem.
- Formulários públicos têm defesa contra bots (honeypot, tempo mínimo de preenchimento ou captcha).
- Validação e rejeição de duplicatas acontecem no servidor.
- Fluxos de alto valor exigem ritmo humano realista.

**Reprovar quando:**
- Um teste limitado e autorizado cria registros de teste em volume não aceito pela política, sem bloqueio.
- A única defesa contra automação roda no navegador e é contornada.

**Falsos positivos:**
- Endpoint de integração entre sistemas pode ter limites diferentes, por decisão documentada.
- Captcha não é obrigatório quando outras defesas equivalentes existem.
- Testar com volume pequeno e só em ambiente autorizado.
