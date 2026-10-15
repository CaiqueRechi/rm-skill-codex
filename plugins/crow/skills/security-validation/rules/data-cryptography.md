# Dados e criptografia

`SV-DATA-0001` e `SV-CRY-0001` são do conjunto mínimo obrigatório.
`SV-DATA-0002` cobre integridade, retenção e privacidade, da família "Dados".

---

## SV-DATA-0001 — Segredos e dados sensíveis

```yaml
id: SV-DATA-0001
canonical_name: Secrets and Sensitive Data Exposure
display_name_pt_br: Segredos e dados sensíveis
aliases: [hard-coded credentials, segredo no repositório, vazamento de dados, dados sensíveis em log, sensitive data exposure]
category: DATA.CONFIDENTIALITY
description: >
  Verifica se segredos e dados sensíveis estão fora do código e do
  repositório, protegidos em trânsito, em repouso e no processamento, e
  ausentes de logs e respostas desnecessárias.
scope:
  asset_types: [web_application, api, repository, pipeline, cloud, container]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-798, CWE-312, CWE-319, CWE-532]
  asvs: [V13.3.1, V13.3.4, V13.4.1, V14.2.1, V16.2.5]
  wstg: [WSTG-INFO-05, WSTG-CONF-04, WSTG-CRYP-03]
  attack: [T1552.001]
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem segredos (chaves, tokens, senhas, strings de conexão) ou dados sensíveis no sistema.
pass_criteria:
  - Segredos não estão embutidos indevidamente no código ou repositório.
  - Dados sensíveis são protegidos em trânsito, em repouso e durante o processamento conforme os requisitos.
  - Logs e respostas não revelam informações desnecessárias.
  - Acesso e retenção seguem as políticas definidas.
fail_criteria:
  - Uma credencial ativa ou informação protegida é exposta a uma identidade não autorizada.
  - Segredos são registrados ou transmitidos em locais proibidos pela política aplicável.
inconclusive_criteria:
  - Não há autorização para analisar o histórico do repositório.
  - Não é possível confirmar se a credencial encontrada está ativa sem usá-la.
false_positive_guidance:
  - Strings semelhantes a tokens podem ser dados de teste ou identificadores públicos.
  - Uma variável de ambiente não constitui armazenamento seguro automaticamente.
  - A detecção de segredo deve ser acompanhada de validação contextual sem divulgar seu conteúdo.
remediation:
  - Mover segredos para um cofre ou gerenciador de segredos e rotacionar os expostos.
  - Remover segredos do histórico apenas com autorização e depois de rotacioná-los.
  - Mascarar dados sensíveis em logs e retornar só os campos necessários.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-DEV-0001, SV-MON-0001, SV-CRY-0001]
duplicate_of: null
```

Métodos: inspeção estática, análise de histórico quando autorizado, configuração e testes de respostas.

**Aprovar quando:**
- Segredos não estão embutidos indevidamente no código ou repositório.
- Dados sensíveis são protegidos em trânsito, em repouso e durante o processamento conforme os requisitos.
- Logs e respostas não revelam informações desnecessárias.
- Acesso e retenção seguem as políticas definidas.

**Reprovar quando:**
- Uma credencial ativa ou informação protegida é exposta a uma identidade não autorizada.
- Segredos são registrados ou transmitidos em locais proibidos pela política aplicável.

**Falsos positivos:**
- Strings semelhantes a tokens podem ser dados de teste ou identificadores públicos.
- Uma variável de ambiente não constitui armazenamento seguro automaticamente.
- A detecção de segredo deve ser acompanhada de validação contextual sem divulgar seu conteúdo.

Nunca testar se uma credencial encontrada funciona usando-a contra o serviço:
isso é uso de credencial, não validação. Registrar como `INCONCLUSIVE` quanto à
atividade e recomendar a rotação.

---

## SV-DATA-0002 — Integridade, retenção e privacidade

```yaml
id: SV-DATA-0002
canonical_name: Data Integrity, Retention and Privacy
display_name_pt_br: Integridade, retenção e privacidade de dados
aliases: [LGPD, GDPR, retenção de dados, minimização de dados, metadados de arquivos, integridade de dados]
category: DATA.PRIVACY
description: >
  Verifica se dados pessoais e sensíveis seguem a classificação, a retenção e
  o compartilhamento definidos, e se dados críticos têm integridade
  verificável.
scope:
  asset_types: [web_application, api, database, cloud, backup_system]
methods: [manual_review, configuration_review, static_analysis]
references:
  cwe: [CWE-359, CWE-212, CWE-354]
  asvs: [V14.2.3, V14.2.4, V14.2.7, V14.2.8]
  wstg: [WSTG-BUSL-03]
  attack: []
severity_default: medium
confidence_threshold: medium
preconditions:
  - O sistema trata dados pessoais ou dados cuja alteração indevida tem impacto.
  - Existe, ou deveria existir, uma classificação de dados e uma política de retenção.
pass_criteria:
  - Dados pessoais estão classificados e cada categoria tem prazo de retenção e base de tratamento definidos.
  - Dados vencidos são excluídos ou anonimizados conforme a política.
  - Dados sensíveis não são enviados a terceiros não previstos, como rastreadores.
  - Metadados sensíveis de arquivos enviados são removidos quando a política exige.
  - Dados críticos têm integridade verificada quando trafegam ou são armazenados fora do controle do sistema.
fail_criteria:
  - Dados pessoais são enviados a terceiro não autorizado, comprovado.
  - Dados vencidos permanecem acessíveis contra a política documentada.
  - Uma alteração indevida em dado crítico não é detectada onde a política exige verificação de integridade.
inconclusive_criteria:
  - Não existe classificação de dados nem política de retenção para comparar.
  - O armazenamento real não pôde ser inspecionado.
false_positive_guidance:
  - Guardar dados por obrigação legal (fiscal, trabalhista) não é retenção indevida.
  - Anonimização e pseudonimização são diferentes; avaliar o que a política exige.
  - Ausência de política é achado de governança, registrado como INCONCLUSIVE com recomendação, não como FAIL técnico.
remediation:
  - Classificar dados e definir retenção e base de tratamento por categoria.
  - Automatizar exclusão ou anonimização ao fim do prazo.
  - Remover metadados de arquivos e revisar integrações com terceiros.
requires_authorization: false
safe_by_default: true
manual_review_required: true
related_controls: [SV-DATA-0001, SV-REC-0001]
duplicate_of: null
```

Métodos: revisão manual de políticas e fluxos de dados, revisão de configuração e análise estática.

**Aprovar quando:**
- Dados pessoais estão classificados e cada categoria tem prazo de retenção e base de tratamento definidos.
- Dados vencidos são excluídos ou anonimizados conforme a política.
- Dados sensíveis não são enviados a terceiros não previstos, como rastreadores.
- Metadados sensíveis de arquivos enviados são removidos quando a política exige.
- Dados críticos têm integridade verificada quando trafegam ou ficam fora do controle do sistema.

**Reprovar quando:**
- Dados pessoais são enviados a terceiro não autorizado, comprovado.
- Dados vencidos permanecem acessíveis contra a política documentada.
- Uma alteração indevida em dado crítico não é detectada onde a política exige verificação de integridade.

**Falsos positivos:**
- Guardar dados por obrigação legal (fiscal, trabalhista) não é retenção indevida.
- Anonimização e pseudonimização são diferentes; avaliar o que a política exige.
- Ausência de política é achado de governança — `INCONCLUSIVE` com recomendação, não `FAIL` técnico.

---

## SV-CRY-0001 — Criptografia e certificados

```yaml
id: SV-CRY-0001
canonical_name: Cryptography and Certificates
display_name_pt_br: Criptografia e certificados
aliases: [criptografia fraca, validação de certificado, gestão de chaves, RNG inseguro, padding oracle]
category: APP.CRYPTOGRAPHY
description: >
  Verifica algoritmos, parâmetros, validação de certificados, proteção e
  rotação de chaves e a geração de números aleatórios.
scope:
  asset_types: [web_application, api, desktop_application, network, iot_device]
methods: [static_analysis, configuration_review, manual_review]
references:
  cwe: [CWE-327, CWE-326, CWE-295, CWE-330, CWE-321]
  asvs: [V11.2.1, V11.3.2, V11.5.1, V12.1.1, V12.3.2]
  wstg: [WSTG-CRYP-01, WSTG-CRYP-02, WSTG-CRYP-04]
  attack: [T1557]
severity_default: high
confidence_threshold: medium
preconditions:
  - O sistema usa criptografia, TLS, assinaturas, hashes ou valores aleatórios com finalidade de segurança.
pass_criteria:
  - Algoritmos e parâmetros são adequados ao uso.
  - Certificados e nomes de host são validados.
  - Chaves privadas são protegidas e sua rotação é definida.
  - A geração de números aleatórios e os mecanismos criptográficos utilizam implementações apropriadas.
fail_criteria:
  - Uma implementação aceita certificados inválidos indevidamente.
  - Um segredo criptográfico é exposto.
  - Uma falha demonstrada compromete confidencialidade, integridade ou autenticação.
inconclusive_criteria:
  - A criptografia é feita por componente ou hardware não inspecionável.
  - A política criptográfica da organização não está definida.
false_positive_guidance:
  - O nome de um algoritmo isoladamente não demonstra uma implementação correta ou incorreta.
  - Uma cifra legada pode existir por compatibilidade, mas precisa ser avaliada conforme a política e o contexto.
  - O scanner não deve declarar criptografia segura apenas porque detectou HTTPS.
remediation:
  - Usar bibliotecas criptográficas mantidas e modos autenticados.
  - Nunca desabilitar validação de certificado ou de nome de host.
  - Guardar chaves em cofre ou módulo de segurança e definir rotação.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-NET-0001, SV-DATA-0001]
duplicate_of: null
```

Métodos: inspeção de código, configuração TLS e revisão da gestão de chaves.

**Aprovar quando:**
- Algoritmos e parâmetros são adequados ao uso.
- Certificados e nomes de host são validados.
- Chaves privadas são protegidas e sua rotação é definida.
- A geração de números aleatórios e os mecanismos criptográficos utilizam implementações apropriadas.

**Reprovar quando:**
- Uma implementação aceita certificados inválidos indevidamente.
- Um segredo criptográfico é exposto.
- Uma falha demonstrada compromete confidencialidade, integridade ou autenticação.

**Falsos positivos:**
- O nome de um algoritmo isoladamente não demonstra uma implementação correta ou incorreta.
- Uma cifra legada pode existir por compatibilidade, mas precisa ser avaliada conforme a política e o contexto.
- O scanner não deve declarar criptografia segura apenas porque detectou HTTPS.
