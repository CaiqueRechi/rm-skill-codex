# Rede e host

`SV-NET-0001` e `SV-HOST-0001` são do conjunto mínimo obrigatório. Cobrem as
famílias "Infraestrutura" e "Host" do catálogo.

---

## SV-NET-0001 — Rede e protocolos

```yaml
id: SV-NET-0001
canonical_name: Network and Protocol Security
display_name_pt_br: Rede e protocolos
aliases: [portas expostas, serviços inseguros, segmentação, TLS de transporte, DNS, man-in-the-middle]
category: NETWORK.PROTOCOL
description: >
  Verifica se os serviços expostos correspondem ao inventário aprovado, se
  protocolos e versões atendem à política e se a segmentação limita os
  fluxos ao necessário.
scope:
  asset_types: [network, operating_system, cloud, container]
methods: [configuration_review, dynamic_testing, manual_review]
references:
  cwe: [CWE-319, CWE-1327]
  asvs: [V12.1.1, V12.2.1, V12.3.1, V13.2.4]
  wstg: [WSTG-CONF-01, WSTG-CRYP-01]
  attack: [T1557, T1046]
severity_default: medium
confidence_threshold: medium
preconditions:
  - Existe inventário de serviços aprovados, ou ele pode ser montado a partir da configuração.
  - Os testes de conectividade estão no escopo autorizado.
pass_criteria:
  - Serviços expostos correspondem ao inventário aprovado.
  - Protocolos e versões atendem à política de segurança.
  - Segmentação e regras de acesso limitam os fluxos necessários.
  - Certificados, DNS e mecanismos de confiança são verificados.
fail_criteria:
  - Um serviço não autorizado está acessível.
  - Um fluxo de rede proibido é permitido.
  - Uma configuração permite interceptação ou acesso indevido demonstrado.
inconclusive_criteria:
  - Não existe inventário aprovado para comparar.
  - O teste só pôde ser feito de um ponto da rede, que não representa todos os segmentos.
false_positive_guidance:
  - Uma porta aberta não comprova vulnerabilidade.
  - Um serviço legítimo pode usar uma porta não convencional.
  - Um teste de conectividade isolado não comprova a identidade do serviço.
remediation:
  - Fechar serviços fora do inventário e restringir a origem dos permitidos.
  - Desabilitar protocolos e versões fora da política.
  - Segmentar a rede pelo fluxo necessário e não pela conveniência.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-CRY-0001, SV-HOST-0001, SV-OT-0001]
duplicate_of: null
```

Métodos: análise de configuração, inventário de ativos e testes de conectividade autorizados.

**Aprovar quando:**
- Serviços expostos correspondem ao inventário aprovado.
- Protocolos e versões atendem à política de segurança.
- Segmentação e regras de acesso limitam os fluxos necessários.
- Certificados, DNS e mecanismos de confiança são verificados.

**Reprovar quando:**
- Um serviço não autorizado está acessível.
- Um fluxo de rede proibido é permitido.
- Uma configuração permite interceptação ou acesso indevido demonstrado.

**Falsos positivos:**
- Uma porta aberta não comprova vulnerabilidade.
- Um serviço legítimo pode usar uma porta não convencional.
- Um teste de conectividade isolado não comprova a identidade do serviço.

---

## SV-HOST-0001 — Sistema operacional e execução

```yaml
id: SV-HOST-0001
canonical_name: Operating System and Execution Security
display_name_pt_br: Sistema operacional e execução
aliases: [hardening, elevação de privilégios local, persistência, patches, permissões de arquivo, tarefas agendadas]
category: HOST.PRIVILEGE
description: >
  Verifica privilégios de serviços e processos, configurações críticas,
  patches e a proteção de arquivos, tarefas e serviços privilegiados em
  Windows, Linux e macOS.
scope:
  asset_types: [operating_system]
methods: [configuration_review, manual_review]
references:
  cwe: [CWE-250, CWE-732]
  asvs: []
  wstg: [WSTG-CONF-09]
  attack: [T1068, T1543, T1053]
  note: O ASVS cobre aplicações; para o sistema operacional a verificação segue o CIS Benchmark da versão em uso.
severity_default: high
confidence_threshold: medium
preconditions:
  - Há acesso de leitura à configuração do sistema operacional, ou um inventário de patches.
pass_criteria:
  - Serviços e processos possuem privilégios adequados.
  - Configurações críticas atendem à política.
  - Patches e mecanismos de proteção são verificados.
  - Arquivos, tarefas e serviços privilegiados não podem ser alterados por identidades indevidas.
fail_criteria:
  - Um usuário sem privilégios consegue executar uma ação privilegiada não autorizada.
  - Uma configuração permite persistência ou execução indevida comprovada.
inconclusive_criteria:
  - Não há acesso à configuração efetiva do host.
  - A política ou o benchmark de referência não foi definido.
false_positive_guidance:
  - Uma versão antiga não prova, sozinha, a presença de uma vulnerabilidade específica.
  - Uma permissão aparentemente ampla deve ser avaliada no contexto do sistema operacional.
  - A ausência de alertas de EDR não comprova ausência de malware.
remediation:
  - Executar serviços com contas dedicadas e sem privilégio administrativo.
  - Corrigir permissões de arquivos, serviços e tarefas privilegiadas.
  - Aplicar patches dentro do prazo definido e o benchmark adotado.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-IDN-0001, SV-APP-0013, SV-NET-0001]
duplicate_of: null
```

Métodos: inspeção de configuração, permissões, serviços e inventário de patches.

**Aprovar quando:**
- Serviços e processos possuem privilégios adequados.
- Configurações críticas atendem à política.
- Patches e mecanismos de proteção são verificados.
- Arquivos, tarefas e serviços privilegiados não podem ser alterados por identidades indevidas.

**Reprovar quando:**
- Um usuário sem privilégios consegue executar uma ação privilegiada não autorizada.
- Uma configuração permite persistência ou execução indevida comprovada.

**Falsos positivos:**
- Uma versão antiga não prova, sozinha, a presença de uma vulnerabilidade específica.
- Uma permissão aparentemente ampla deve ser avaliada no contexto do sistema operacional.
- A ausência de alertas de EDR não comprova ausência de malware.
