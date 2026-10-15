# Nuvem e containers

`SV-CLD-0001` e `SV-CON-0001` são do conjunto mínimo obrigatório.

---

## SV-CLD-0001 — Cloud e armazenamento

```yaml
id: SV-CLD-0001
canonical_name: Cloud Configuration and Storage
display_name_pt_br: Cloud e armazenamento
aliases: [bucket público, storage público, IAM de nuvem, metadados de instância, serverless, infraestrutura como código]
category: CLOUD.CONFIGURATION
description: >
  Verifica se recursos de nuvem têm políticas de acesso coerentes com a
  classificação, se metadados e credenciais temporárias estão protegidos e se
  IAM, rede e armazenamento respeitam as fronteiras previstas.
scope:
  asset_types: [cloud]
methods: [configuration_review, manual_review]
references:
  cwe: [CWE-284, CWE-668, CWE-732]
  asvs: []
  wstg: [WSTG-CONF-11]
  attack: [T1530, T1552.005]
  note: O ASVS cobre aplicações; para a nuvem a verificação segue o CIS Benchmark do provedor e a política da organização.
severity_default: high
confidence_threshold: medium
preconditions:
  - Há acesso de leitura às políticas, à infraestrutura como código ou às APIs administrativas autorizadas.
pass_criteria:
  - Recursos possuem políticas de acesso coerentes com sua classificação.
  - Metadados e credenciais temporárias estão protegidos.
  - IAM, rede e armazenamento respeitam as fronteiras previstas.
  - Registros e alertas de configuração estão habilitados conforme os requisitos.
fail_criteria:
  - Dados privados ficam acessíveis publicamente sem autorização.
  - Uma identidade pode acessar recursos fora de seu escopo.
  - Uma configuração permite obter credenciais ou privilégios indevidos.
inconclusive_criteria:
  - Só a infraestrutura como código foi inspecionada e o estado real pode divergir.
  - Políticas de organização ou de conta não estavam visíveis.
false_positive_guidance:
  - Um bucket público pode conter exclusivamente conteúdo público intencional.
  - A configuração isolada não comprova sempre a exposição efetiva.
  - Políticas de organização, rede e identidade podem alterar o resultado efetivo.
remediation:
  - Bloquear acesso público por padrão e liberar só o que é público por decisão.
  - Exigir a versão protegida do serviço de metadados e restringir quem o alcança.
  - Reduzir permissões IAM e habilitar registros de configuração.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-IDN-0001, SV-APP-0006, SV-DATA-0001]
duplicate_of: null
```

Métodos: inspeção de políticas, infraestrutura como código e APIs administrativas autorizadas.

**Aprovar quando:**
- Recursos possuem políticas de acesso coerentes com sua classificação.
- Metadados e credenciais temporárias estão protegidos.
- IAM, rede e armazenamento respeitam as fronteiras previstas.
- Registros e alertas de configuração estão habilitados conforme os requisitos.

**Reprovar quando:**
- Dados privados ficam acessíveis publicamente sem autorização.
- Uma identidade pode acessar recursos fora de seu escopo.
- Uma configuração permite obter credenciais ou privilégios indevidos.

**Falsos positivos:**
- Um bucket público pode conter exclusivamente conteúdo público intencional.
- A configuração isolada não comprova sempre a exposição efetiva.
- Políticas de organização, rede e identidade podem alterar o resultado efetivo.

---

## SV-CON-0001 — Containers e orquestração

```yaml
id: SV-CON-0001
canonical_name: Container and Orchestration Security
display_name_pt_br: Containers e orquestração
aliases: [container escape, privileged container, Kubernetes RBAC, segredo em imagem, registry]
category: CONTAINER.ISOLATION
description: >
  Verifica privilégios de containers, segredos em imagens, rastreabilidade de
  imagens e a autorização do plano de controle e o isolamento entre workloads.
scope:
  asset_types: [container]
methods: [configuration_review, static_analysis, manual_review]
references:
  cwe: [CWE-250, CWE-668]
  asvs: []
  wstg: []
  attack: [T1610, T1611]
  note: O ASVS e o WSTG não cobrem orquestração; a verificação segue o CIS Benchmark de Docker ou Kubernetes da versão em uso.
severity_default: high
confidence_threshold: medium
preconditions:
  - Há acesso a manifests, Dockerfiles, imagens ou configuração do cluster.
pass_criteria:
  - Containers possuem privilégios compatíveis com suas funções.
  - Segredos não são embutidos em imagens.
  - Imagens e dependências são rastreáveis.
  - A autorização do plano de controle e o isolamento entre workloads estão configurados conforme a política.
fail_criteria:
  - Um workload não confiável possui acesso privilegiado indevido.
  - Um segredo é exposto.
  - Uma configuração permite escape ou acesso não autorizado comprovado.
inconclusive_criteria:
  - Só os manifests foram inspecionados e o estado do cluster pode divergir.
  - Admission controllers ou políticas do cluster não estavam visíveis.
false_positive_guidance:
  - Executar como root não prova, isoladamente, um escape de container.
  - Uma imagem com CVE não prova explorabilidade no ambiente.
  - A avaliação deve considerar capabilities, mounts, namespaces, seccomp e configuração efetiva.
remediation:
  - Rodar como usuário sem privilégio, sem privileged e com capabilities mínimas.
  - Injetar segredos em tempo de execução, nunca na imagem.
  - Fixar imagens por digest e restringir o RBAC ao necessário.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-SCM-0001, SV-DATA-0001, SV-HOST-0001]
duplicate_of: null
```

Métodos: inspeção de manifests, imagens, permissões e configuração do cluster.

**Aprovar quando:**
- Containers possuem privilégios compatíveis com suas funções.
- Segredos não são embutidos em imagens.
- Imagens e dependências são rastreáveis.
- A autorização do plano de controle e o isolamento entre workloads estão configurados conforme a política.

**Reprovar quando:**
- Um workload não confiável possui acesso privilegiado indevido.
- Um segredo é exposto.
- Uma configuração permite escape ou acesso não autorizado comprovado.

**Falsos positivos:**
- Executar como root não prova, isoladamente, um escape de container.
- Uma imagem com CVE não prova explorabilidade no ambiente.
- A avaliação deve considerar capabilities, mounts, namespaces, seccomp e configuração efetiva.
