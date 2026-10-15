# Sistemas de IA

`SV-AI-0001` é do conjunto mínimo obrigatório. `SV-AI-0002` cobre a
integridade do modelo e dos dados de treinamento, da família "IA".

As técnicas de ataque a IA vêm do MITRE ATLAS (`references.atlas`), não do
ATT&CK.

---

## SV-AI-0001 — Sistemas de IA e agentes

```yaml
id: SV-AI-0001
canonical_name: AI System and Agent Security
display_name_pt_br: Sistemas de IA e agentes
aliases: [prompt injection, injeção de prompt, injeção indireta, vazamento de dados por LLM, abuso de ferramentas de agente, RAG multi-tenant]
category: AI.AGENT_SECURITY
description: >
  Verifica se conteúdo externo é tratado como dado não confiável, se
  ferramentas aplicam autorização independentemente do modelo, se dados de
  usuários e tenants ficam isolados e se saídas são validadas antes de ter
  efeito.
scope:
  asset_types: [ai_system, api, web_application]
methods: [manual_review, configuration_review, dynamic_testing]
references:
  cwe: [CWE-1427, CWE-1426]
  asvs: []
  wstg: []
  attack: []
  atlas: [AML.T0051, AML.T0057, AML.T0053]
  note: O ASVS 5.0.0 não tem capítulo de IA.
severity_default: high
confidence_threshold: medium
preconditions:
  - O sistema usa LLM, RAG ou agente com acesso a ferramentas ou dados.
pass_criteria:
  - Conteúdo externo é tratado como dado não confiável.
  - Instruções fornecidas por documentos não podem ampliar permissões.
  - Ferramentas aplicam autorização independentemente da decisão do modelo.
  - Dados entre usuários e tenants permanecem isolados.
  - Saídas do modelo são validadas antes de produzir efeitos externos.
fail_criteria:
  - Conteúdo não confiável consegue acionar uma ferramenta privilegiada fora da política.
  - Uma consulta permite acesso comprovado a dados de outro tenant.
  - Saídas do modelo são executadas sem validação em um contexto que permita impacto indevido.
inconclusive_criteria:
  - O comportamento do modelo não é determinístico e o teste não reproduziu nem descartou a hipótese.
  - As permissões das ferramentas conectadas não puderam ser inspecionadas.
false_positive_guidance:
  - Uma resposta que repete conteúdo de teste não comprova vazamento de dados reais.
  - Uma tentativa de jailbreak não demonstra, por si só, comprometimento do sistema.
  - Recusa textual do modelo não substitui o controle de permissões das ferramentas.
remediation:
  - Autorizar cada chamada de ferramenta no servidor com as permissões do usuário, não do agente.
  - Filtrar a recuperação do RAG por tenant e por permissão antes de chegar ao modelo.
  - Validar e confirmar saídas antes de ações com efeito externo.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0003, SV-AI-0002]
duplicate_of: null
```

Métodos: inspeção de permissões, fluxos de dados, configuração de ferramentas e testes adversariais controlados.

**Aprovar quando:**
- Conteúdo externo é tratado como dado não confiável.
- Instruções fornecidas por documentos não podem ampliar permissões.
- Ferramentas aplicam autorização independentemente da decisão do modelo.
- Dados entre usuários e tenants permanecem isolados.
- Saídas do modelo são validadas antes de produzir efeitos externos.

**Reprovar quando:**
- Conteúdo não confiável consegue acionar uma ferramenta privilegiada fora da política.
- Uma consulta permite acesso comprovado a dados de outro tenant.
- Saídas do modelo são executadas sem validação em um contexto que permita impacto indevido.

**Falsos positivos:**
- Uma resposta que repete conteúdo de teste não comprova vazamento de dados reais.
- Uma tentativa de jailbreak não demonstra, por si só, comprometimento do sistema.
- Recusa textual do modelo não substitui o controle de permissões das ferramentas.

---

## SV-AI-0002 — Integridade de modelos e dados de treinamento

```yaml
id: SV-AI-0002
canonical_name: Model and Training Data Integrity
display_name_pt_br: Integridade de modelos e dados de treinamento
aliases: [data poisoning, envenenamento de dados, backdoor em modelo, supply chain de modelos, model registry]
category: AI.MODEL_SECURITY
description: >
  Verifica a origem e a integridade de modelos, pesos e dados de treinamento
  ou de ajuste fino, e quem pode alterá-los no pipeline.
scope:
  asset_types: [ai_system, pipeline, dependency]
methods: [manual_review, configuration_review, dependency_analysis]
references:
  cwe: [CWE-494, CWE-1039]
  asvs: []
  wstg: []
  attack: []
  atlas: [AML.T0010, AML.T0018, AML.T0020]
  note: O ASVS 5.0.0 não tem capítulo de IA.
severity_default: high
confidence_threshold: medium
preconditions:
  - O sistema treina, ajusta, baixa ou serve modelos próprios ou de terceiros.
pass_criteria:
  - Modelos e pesos vêm de fontes definidas e têm integridade verificada (hash ou assinatura).
  - Formatos de modelo que executam código ao carregar não são aceitos de fontes não confiáveis.
  - Dados de treinamento e ajuste têm origem registrada e alteração controlada.
  - Só identidades autorizadas publicam modelos no registro usado em produção.
fail_criteria:
  - Um modelo de fonte não confiável é carregado em formato que executa código, comprovado.
  - Uma identidade não autorizada consegue publicar ou substituir o modelo de produção.
  - Dados de treinamento podem ser alterados por fonte externa sem controle, comprovado.
inconclusive_criteria:
  - O modelo é consumido como serviço de terceiro e a cadeia não é inspecionável.
  - Não há registro da origem dos dados de treinamento.
false_positive_guidance:
  - Usar modelo de terceiro não é falha; o que se avalia é origem, integridade e formato.
  - Comportamento ruim do modelo não prova envenenamento.
  - Avaliação de qualidade do modelo está fora desta regra.
remediation:
  - Fixar modelos por hash e preferir formatos que não executam código ao carregar.
  - Controlar quem escreve nos dados de treinamento e no registro de modelos.
  - Registrar a linhagem dos dados e dos modelos publicados.
requires_authorization: false
safe_by_default: true
manual_review_required: true
related_controls: [SV-AI-0001, SV-SCM-0001]
duplicate_of: null
```

Métodos: revisão manual da cadeia de modelos e dados, configuração e análise de dependências.

**Aprovar quando:**
- Modelos e pesos vêm de fontes definidas e têm integridade verificada.
- Formatos de modelo que executam código ao carregar não são aceitos de fontes não confiáveis.
- Dados de treinamento e ajuste têm origem registrada e alteração controlada.
- Só identidades autorizadas publicam modelos no registro usado em produção.

**Reprovar quando:**
- Um modelo de fonte não confiável é carregado em formato que executa código, comprovado.
- Uma identidade não autorizada consegue publicar ou substituir o modelo de produção.
- Dados de treinamento podem ser alterados por fonte externa sem controle, comprovado.

**Falsos positivos:**
- Usar modelo de terceiro não é falha; o que se avalia é origem, integridade e formato.
- Comportamento ruim do modelo não prova envenenamento.
- Avaliação de qualidade do modelo está fora desta regra.
