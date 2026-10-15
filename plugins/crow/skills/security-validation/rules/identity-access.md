# Identidade e acesso

`SV-IDN-0001` é do conjunto mínimo obrigatório. `SV-IDN-0002` a `SV-IDN-0004`
cobrem brute force, credential stuffing, MFA e recuperação de credenciais, da
família "Identidade".

---

## SV-IDN-0001 — Privilégios e identidade

```yaml
id: SV-IDN-0001
canonical_name: Privilege and Identity Management
display_name_pt_br: Privilégios e identidade
aliases: [privilégio mínimo, least privilege, escalonamento de privilégios, contas órfãs, segregação de funções]
category: IDENTITY.PRIVILEGE
description: >
  Verifica se identidades humanas e de serviço possuem apenas os privilégios
  necessários, se credenciais obsoletas são revogadas e se operações
  privilegiadas são limitadas e auditáveis.
scope:
  asset_types: [web_application, api, operating_system, cloud, repository]
methods: [configuration_review, manual_review, dynamic_testing]
references:
  cwe: [CWE-269, CWE-250]
  asvs: [V7.4.2, V8.2.1, V8.3.3, V8.4.2]
  wstg: [WSTG-IDNT-01, WSTG-ATHZ-03]
  attack: [T1078, T1068]
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem identidades com níveis de privilégio diferentes.
  - Há acesso de leitura às políticas, papéis ou diretórios, ou identidades de teste.
pass_criteria:
  - Identidades possuem apenas os privilégios necessários.
  - Credenciais e contas obsoletas são tratadas conforme a política.
  - Operações privilegiadas são limitadas e auditáveis.
  - A segregação de funções e os fluxos de aprovação estão preservados.
fail_criteria:
  - Uma identidade consegue executar uma ação proibida.
  - Permissões excessivas possibilitam uma escalada de privilégios demonstrada.
  - Uma credencial desativada permanece utilizável quando deveria ter sido revogada.
inconclusive_criteria:
  - As permissões efetivas dependem de herança ou condições que não puderam ser avaliadas.
  - A política de privilégios não está documentada.
false_positive_guidance:
  - Uma permissão ampla pode ser necessária para uma função operacional específica.
  - A avaliação deve considerar permissões efetivas, herança e condições de política.
  - A existência de uma conta de serviço não constitui falha por si só.
remediation:
  - Reduzir permissões ao necessário para cada papel.
  - Revogar credenciais e encerrar sessões de contas desativadas.
  - Exigir aprovação e registro para operações privilegiadas.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0003, SV-CLD-0001, SV-HOST-0001]
duplicate_of: null
```

Métodos: revisão de políticas, configurações IAM, diretórios e testes de permissões autorizados.

**Aprovar quando:**
- Identidades possuem apenas os privilégios necessários.
- Credenciais e contas obsoletas são tratadas conforme a política.
- Operações privilegiadas são limitadas e auditáveis.
- A segregação de funções e os fluxos de aprovação estão preservados.

**Reprovar quando:**
- Uma identidade consegue executar uma ação proibida.
- Permissões excessivas possibilitam uma escalada de privilégios demonstrada.
- Uma credencial desativada permanece utilizável quando deveria ter sido revogada.

**Falsos positivos:**
- Uma permissão ampla pode ser necessária para uma função operacional específica.
- A avaliação deve considerar permissões efetivas, herança e condições de política.
- A existência de uma conta de serviço não constitui falha por si só.

---

## SV-IDN-0002 — Brute force e credential stuffing

```yaml
id: SV-IDN-0002
canonical_name: Brute Force and Credential Stuffing Protection
display_name_pt_br: Proteção contra força bruta e credential stuffing
aliases: [brute force, força bruta, credential stuffing, password spraying, enumeração de contas]
category: IDENTITY.CREDENTIALS
description: >
  Verifica se os fluxos de autenticação limitam tentativas automatizadas,
  rejeitam senhas sabidamente vazadas e não revelam quais contas existem.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-307, CWE-204]
  asvs: [V6.2.12, V6.3.1, V6.3.8]
  wstg: [WSTG-ATHN-02, WSTG-ATHN-03, WSTG-IDNT-04]
  attack: [T1110, T1110.001, T1110.004]
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação autentica usuários com segredo conhecido (senha, PIN, código).
pass_criteria:
  - Tentativas de autenticação são limitadas por conta e por origem.
  - Senhas novas são verificadas contra uma base de senhas vazadas.
  - Respostas de falha não distinguem conta inexistente de senha errada.
  - Contas padrão estão ausentes ou desativadas.
fail_criteria:
  - Um teste limitado e autorizado demonstra tentativas ilimitadas contra uma conta de teste.
  - A resposta, o tempo ou o código de status revela se uma conta existe.
inconclusive_criteria:
  - A limitação é feita por componente externo (WAF, proxy) que não pôde ser inspecionado.
  - O teste dinâmico não foi autorizado e o código não mostra a limitação.
false_positive_guidance:
  - Ausência de bloqueio de conta não é falha se há limitação por taxa equivalente, já que bloqueio rígido pode virar negação de serviço.
  - Diferença de tempo pequena e inconsistente não comprova enumeração.
  - Nunca testar contra contas reais; usar apenas contas de teste.
remediation:
  - Limitar tentativas por conta e por IP com atraso progressivo.
  - Verificar senhas contra base de senhas vazadas no cadastro e na troca.
  - Usar mensagens e tempos de resposta uniformes.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0004, SV-IDN-0003, SV-BIZ-0002]
duplicate_of: null
```

Métodos: análise estática, revisão de configuração e testes dinâmicos limitados contra contas de teste.

**Aprovar quando:**
- Tentativas de autenticação são limitadas por conta e por origem.
- Senhas novas são verificadas contra uma base de senhas vazadas.
- Respostas de falha não distinguem conta inexistente de senha errada.
- Contas padrão estão ausentes ou desativadas.

**Reprovar quando:**
- Um teste limitado e autorizado demonstra tentativas ilimitadas contra uma conta de teste.
- A resposta, o tempo ou o código de status revela se uma conta existe.

**Falsos positivos:**
- Ausência de bloqueio de conta não é falha se há limitação por taxa equivalente — bloqueio rígido pode virar negação de serviço.
- Diferença de tempo pequena e inconsistente não comprova enumeração.
- Nunca testar contra contas reais; apenas contas de teste.

---

## SV-IDN-0003 — Autenticação multifator

```yaml
id: SV-IDN-0003
canonical_name: Multi-Factor Authentication
display_name_pt_br: Autenticação multifator
aliases: [MFA, 2FA, autenticação em dois fatores, TOTP, MFA fatigue]
category: IDENTITY.CREDENTIALS
description: >
  Verifica se o segundo fator é exigido onde a política manda, não pode ser
  contornado, tem códigos de uso único com validade definida e pode ser
  revogado.
scope:
  asset_types: [web_application, api, cloud]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-308]
  asvs: [V6.3.3, V6.5.1, V6.5.5, V6.5.6]
  wstg: []
  attack: [T1111, T1621]
  note: O WSTG v4.2 não tem cenário específico para MFA.
severity_default: high
confidence_threshold: medium
preconditions:
  - A política do sistema exige MFA para algum perfil ou operação, ou o sistema oferece MFA.
pass_criteria:
  - O segundo fator é exigido em todos os caminhos de autenticação cobertos pela política.
  - Códigos de uso único são aceitos uma única vez e expiram.
  - Tentativas de segundo fator são limitadas.
  - Fatores podem ser revogados em caso de perda.
fail_criteria:
  - Um caminho de autenticação concede sessão completa sem o segundo fator exigido pela política.
  - Um código de uso único é aceito mais de uma vez ou depois de expirado.
inconclusive_criteria:
  - O MFA é feito por provedor externo não inspecionável.
  - A política de quando o MFA é exigido não está documentada.
false_positive_guidance:
  - Sistema sem exigência de MFA na política não reprova por não ter MFA; registrar como recomendação.
  - Lembrar dispositivo por período definido pode ser decisão legítima de política.
  - Fluxos de recuperação são avaliados em SV-IDN-0004.
remediation:
  - Exigir o segundo fator em todos os caminhos, inclusive APIs e canais alternativos.
  - Invalidar códigos após o uso e definir validade curta.
  - Limitar tentativas e alertar o usuário sobre solicitações de MFA inesperadas.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0004, SV-IDN-0002, SV-IDN-0004]
duplicate_of: null
```

Métodos: análise estática, revisão de configuração e testes dinâmicos com contas de teste.

**Aprovar quando:**
- O segundo fator é exigido em todos os caminhos de autenticação cobertos pela política.
- Códigos de uso único são aceitos uma única vez e expiram.
- Tentativas de segundo fator são limitadas.
- Fatores podem ser revogados em caso de perda.

**Reprovar quando:**
- Um caminho de autenticação concede sessão completa sem o segundo fator exigido pela política.
- Um código de uso único é aceito mais de uma vez ou depois de expirado.

**Falsos positivos:**
- Sistema cuja política não exige MFA não reprova por não ter MFA; vira recomendação.
- Lembrar o dispositivo por período definido pode ser decisão legítima de política.
- Fluxos de recuperação são avaliados em `SV-IDN-0004`.

---

## SV-IDN-0004 — Recuperação e redefinição de credenciais

```yaml
id: SV-IDN-0004
canonical_name: Credential Recovery and Reset
display_name_pt_br: Recuperação e redefinição de credenciais
aliases: [reset de senha, esqueci minha senha, password reset, pergunta secreta, account takeover por recuperação]
category: IDENTITY.CREDENTIALS
description: >
  Verifica se os fluxos de recuperação e troca de credenciais não permitem
  assumir a conta de outra pessoa nem contornar fatores de autenticação.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-640, CWE-620]
  asvs: [V6.3.7, V6.4.2, V6.4.3, V6.4.4]
  wstg: [WSTG-ATHN-08, WSTG-ATHN-09]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - Existe fluxo de recuperação de acesso ou de troca de credenciais.
pass_criteria:
  - Tokens de recuperação são aleatórios, de uso único, com validade curta e ligados à conta.
  - A recuperação não contorna o MFA habilitado.
  - A troca de senha exige a senha atual ou reautenticação.
  - O usuário é notificado de alterações nas credenciais.
  - Perguntas secretas não são usadas.
fail_criteria:
  - Um teste com contas de teste demonstra redefinir a credencial de outra conta.
  - Um token de recuperação é reutilizável, previsível ou continua válido após o uso.
  - A recuperação concede acesso completo sem o segundo fator habilitado.
inconclusive_criteria:
  - O envio do token depende de canal externo não observável no ambiente de teste.
false_positive_guidance:
  - Link de recuperação enviado por e-mail é prática comum; avaliar validade, uso único e vínculo com a conta.
  - Mensagem genérica no pedido de recuperação é proteção, não falha de usabilidade.
  - Redefinição iniciada por administrador é legítima se não revela nem define a senha do usuário.
remediation:
  - Gerar tokens com gerador criptograficamente seguro, de uso único e validade curta.
  - Exigir o segundo fator também na recuperação.
  - Notificar o usuário e encerrar outras sessões após a troca.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0004, SV-IDN-0003]
duplicate_of: null
```

Métodos: análise estática, testes dinâmicos com contas de teste e revisão manual.

**Aprovar quando:**
- Tokens de recuperação são aleatórios, de uso único, com validade curta e ligados à conta.
- A recuperação não contorna o MFA habilitado.
- A troca de senha exige a senha atual ou reautenticação.
- O usuário é notificado de alterações nas credenciais.
- Perguntas secretas não são usadas.

**Reprovar quando:**
- Um teste com contas de teste demonstra redefinir a credencial de outra conta.
- Um token de recuperação é reutilizável, previsível ou continua válido após o uso.
- A recuperação concede acesso completo sem o segundo fator habilitado.

**Falsos positivos:**
- Link de recuperação por e-mail é prática comum; o que se avalia é validade, uso único e vínculo com a conta.
- Mensagem genérica no pedido de recuperação é proteção, não falha.
- Redefinição iniciada por administrador é legítima se não revela nem define a senha do usuário.
