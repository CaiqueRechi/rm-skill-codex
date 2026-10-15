# Template do achado

Formato estruturado de um achado, validável contra
[schemas/finding.schema.json](../schemas/finding.schema.json). O relatório
traz cada achado em texto; este bloco é o registro completo, para rastreio e
revalidação.

O exemplo abaixo representa o formato de um achado **hipotético**, não o
resultado de uma análise real.

```yaml
finding_id: FIND-0001
rule_id: SV-APP-0001
asset: src/Repository/UserRepository.php
status: FAIL
severity: HIGH
confidence: HIGH
priority: P2

title: Consulta SQL vulnerável a entrada não confiável

evidence:
  type: source_analysis
  location: src/Repository/UserRepository.php
  line: 42
  detail: parâmetro "email" da requisição concatenado na cláusula WHERE
  redacted: true

impact:
  - Possível acesso não autorizado a dados

root_cause: Query construída sem parametrização adequada

references:
  - CWE-89
  - V1.2.4
  - WSTG-INPV-05

recommendation:
  - Parametrizar a consulta
  - Adicionar teste de regressão

regression_test: tests/Feature/UserSearchTest.php — busca com aspas simples retorna vazio, sem erro

limitations:
  - Nenhuma

false_positive_review:
  status: completed
  rationale: Evidência de fluxo de entrada até execução SQL
```

## Campos condicionais

- `suppression` — obrigatório quando `status: SUPPRESSED`: quem aprovou,
  quando, até quando, justificativa, risco residual e evidência.
- `cvss` — só quando aplicável, com versão e vetor; nunca inventado.
- `revalidation` — preenchido na fase 7: estado anterior, estado atual, data
  e evidência.
