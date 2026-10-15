# Cadeia de suprimentos e DevSecOps

`SV-SCM-0001` e `SV-DEV-0001` são do conjunto mínimo obrigatório.

---

## SV-SCM-0001 — Dependências e cadeia de suprimentos

```yaml
id: SV-SCM-0001
canonical_name: Dependency and Supply Chain Security
display_name_pt_br: Dependências e cadeia de suprimentos
aliases: [SCA, dependência vulnerável, pacote malicioso, typosquatting, SBOM, assinatura de artefato]
category: SUPPLY_CHAIN.DEPENDENCY
description: >
  Verifica se dependências são identificáveis e rastreáveis, se
  vulnerabilidades conhecidas são avaliadas quanto a versão, alcance e
  mitigação, e se fontes e integridade de artefatos são verificáveis.
scope:
  asset_types: [dependency, repository, pipeline, container]
methods: [dependency_analysis, static_analysis, manual_review]
references:
  cwe: [CWE-1395, CWE-494, CWE-829, CWE-1357]
  asvs: [V3.6.1, V15.2.1, V15.2.4]
  wstg: []
  attack: [T1195.001, T1195.002]
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem manifestos de dependências, lockfiles, SBOM ou imagens a inspecionar.
pass_criteria:
  - Dependências são identificáveis e suas versões são rastreáveis.
  - Vulnerabilidades conhecidas são avaliadas quanto à versão, alcance e mitigação.
  - Fontes e integridade de artefatos são verificáveis conforme a política.
  - O processo de atualização e correção está definido.
fail_criteria:
  - Uma dependência vulnerável e alcançável viola um requisito de segurança aplicável.
  - Um artefato comprometido ou não autorizado é incorporado ao processo de build.
  - Um segredo ativo está exposto em metadados ou arquivos do pipeline.
inconclusive_criteria:
  - Não há lockfile e as versões efetivas não puderam ser determinadas.
  - A base de vulnerabilidades consultada não pôde ser acessada.
false_positive_guidance:
  - Um CVE pode não afetar a versão efetivamente instalada.
  - Código vulnerável não alcançável reduz a evidência de explorabilidade, mas não deve ser ignorado automaticamente.
  - A ausência de SBOM não comprova a existência de uma dependência maliciosa.
remediation:
  - Versionar lockfiles e atualizar dependências dentro do prazo definido.
  - Priorizar CVEs presentes no catálogo CISA KEV.
  - Verificar integridade (hash ou assinatura) de artefatos e restringir as fontes de pacotes.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-DEV-0001, SV-CON-0001, SV-AI-0002]
duplicate_of: null
```

Métodos: análise de manifestos, lockfiles, SBOM, assinaturas e ferramentas SCA.

**Aprovar quando:**
- Dependências são identificáveis e suas versões são rastreáveis.
- Vulnerabilidades conhecidas são avaliadas quanto à versão, alcance e mitigação.
- Fontes e integridade de artefatos são verificáveis conforme a política.
- O processo de atualização e correção está definido.

**Reprovar quando:**
- Uma dependência vulnerável e alcançável viola um requisito de segurança aplicável.
- Um artefato comprometido ou não autorizado é incorporado ao processo de build.
- Um segredo ativo está exposto em metadados ou arquivos do pipeline.

**Falsos positivos:**
- Um CVE pode não afetar a versão efetivamente instalada.
- Código vulnerável não alcançável reduz a evidência de explorabilidade, mas não deve ser ignorado automaticamente.
- A ausência de SBOM não comprova a existência de uma dependência maliciosa.

---

## SV-DEV-0001 — CI/CD e repositórios

```yaml
id: SV-DEV-0001
canonical_name: CI/CD and Repository Security
display_name_pt_br: CI/CD e repositórios
aliases: [pipeline inseguro, pull_request_target, segredo em log de CI, proteção de branch, poisoned pipeline execution]
category: DEVSECOPS.PIPELINE
description: >
  Verifica se pipelines limitam permissões e a execução de código não
  confiável, se segredos ficam fora dos logs e se releases e alterações
  críticas exigem revisão e integridade.
scope:
  asset_types: [pipeline, repository]
methods: [configuration_review, static_analysis, manual_review]
references:
  cwe: [CWE-829, CWE-532, CWE-250]
  asvs: []
  wstg: []
  attack: [T1195.002]
  note: ASVS e WSTG não cobrem pipelines; a verificação segue a política de release da organização e o SSDF (NIST SP 800-218).
severity_default: high
confidence_threshold: medium
preconditions:
  - Há acesso aos arquivos de workflow e às configurações do repositório.
pass_criteria:
  - Pipelines limitam permissões e execução de código não confiável.
  - Segredos não são impressos em logs.
  - Artefatos e releases são protegidos conforme a política.
  - Alterações críticas exigem revisão e aprovação apropriadas.
fail_criteria:
  - Código não confiável consegue obter segredos ou executar ações privilegiadas.
  - Uma proteção obrigatória de release pode ser contornada.
  - Um workflow permite modificar artefatos sem controles de integridade exigidos.
inconclusive_criteria:
  - As proteções de branch e os segredos do repositório não estavam visíveis com a permissão concedida.
false_positive_guidance:
  - Uma permissão não utilizada não prova exploração, embora possa representar risco.
  - A análise deve considerar o contexto do evento, o fork e as permissões efetivas do executor.
remediation:
  - Declarar permissões mínimas por job e não expor segredos a código de forks.
  - Fixar actions e imagens por hash.
  - Proteger branches de release e exigir revisão.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-SCM-0001, SV-DATA-0001]
duplicate_of: null
```

Métodos: revisão de workflows, permissões, segredos e políticas de release.

**Aprovar quando:**
- Pipelines limitam permissões e execução de código não confiável.
- Segredos não são impressos em logs.
- Artefatos e releases são protegidos conforme a política.
- Alterações críticas exigem revisão e aprovação apropriadas.

**Reprovar quando:**
- Código não confiável consegue obter segredos ou executar ações privilegiadas.
- Uma proteção obrigatória de release pode ser contornada.
- Um workflow permite modificar artefatos sem controles de integridade exigidos.

**Falsos positivos:**
- Uma permissão não utilizada não prova exploração, embora possa representar risco.
- A análise deve considerar o contexto do evento, o fork e as permissões efetivas do executor.
