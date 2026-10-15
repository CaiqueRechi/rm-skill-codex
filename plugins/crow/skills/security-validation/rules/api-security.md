# Segurança de APIs

`SV-API-0001` é do conjunto mínimo obrigatório. SSRF é `SV-APP-0006`;
autorização por objeto e função, `SV-APP-0003` — esta regra cobre o que é
próprio de APIs: exposição e alteração de campos, limites de consumo e
inventário.

---

## SV-API-0001 — Segurança de APIs

```yaml
id: SV-API-0001
canonical_name: API Security
display_name_pt_br: Segurança de APIs
aliases: [mass assignment, excessive data exposure, broken object property level authorization, rate limiting, inventário de APIs, GraphQL, gRPC, WebSocket]
category: APP.API_SECURITY
description: >
  Verifica autenticação, autorização por objeto, função e campo, limites de
  consumo, regras de negócio no servidor e inventário das versões e
  operações expostas.
scope:
  asset_types: [api]
methods: [static_analysis, manual_review, dynamic_testing]
references:
  cwe: [CWE-639, CWE-915, CWE-770]
  asvs: [V2.4.1, V4.1.4, V8.2.3, V15.3.1, V15.3.3]
  wstg: [WSTG-ATHZ-04, WSTG-BUSL-05, WSTG-APIT-01]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - Existe API REST, GraphQL, gRPC, WebSocket ou integração exposta.
pass_criteria:
  - Autenticação, autorização por objeto e autorização por função são verificadas.
  - Campos retornados e aceitos são limitados ao necessário.
  - Os limites de consumo e as regras de negócio são aplicados no servidor.
  - As versões e operações expostas estão inventariadas.
fail_criteria:
  - Uma operação permite acesso indevido a dados, funções ou recursos.
  - Campos não autorizados podem ser alterados por entrada externa.
  - Um limite obrigatório de consumo pode ser contornado com impacto comprovado.
inconclusive_criteria:
  - Não há contrato (OpenAPI, schema GraphQL, proto) nem código das rotas para inventariar.
  - Não há identidades de teste para verificar a autorização.
false_positive_guidance:
  - Um endpoint público não é necessariamente vulnerável.
  - Documentação OpenAPI exposta não comprova falha por si só.
  - Introspecção GraphQL pode ser uma decisão legítima, dependendo da política do sistema.
remediation:
  - Declarar explicitamente os campos aceitos e retornados em cada operação.
  - Aplicar limites de taxa, tamanho e paginação no servidor.
  - Manter inventário de versões e retirar as obsoletas.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0003, SV-APP-0006, SV-RES-0001]
duplicate_of: null
```

Métodos: análise de rotas, esquemas, middleware e testes com identidades controladas.

**Aprovar quando:**
- Autenticação, autorização por objeto e autorização por função são verificadas.
- Campos retornados e aceitos são limitados ao necessário.
- Os limites de consumo e as regras de negócio são aplicados no servidor.
- As versões e operações expostas estão inventariadas.

**Reprovar quando:**
- Uma operação permite acesso indevido a dados, funções ou recursos.
- Campos não autorizados podem ser alterados por entrada externa.
- Um limite obrigatório de consumo pode ser contornado com impacto comprovado.

**Falsos positivos:**
- Um endpoint público não é necessariamente vulnerável.
- Documentação OpenAPI exposta não comprova falha por si só.
- Introspecção GraphQL pode ser uma decisão legítima, dependendo da política do sistema.
