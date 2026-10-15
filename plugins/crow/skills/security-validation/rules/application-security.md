# Segurança de aplicação

Regras `SV-APP-0001` a `SV-APP-0009` são do conjunto mínimo obrigatório.
`SV-APP-0010` a `SV-APP-0017` cobrem os ataques da família "Entrada e
interpretação", "Navegador" e "Arquivos" que as obrigatórias não cobrem
sozinhas.

Cada regra traz o contrato em YAML (seção 5 da especificação) seguido dos
critérios em texto. Os dois dizem a mesma coisa; o YAML é o que os testes do
repositório validam.

---

## SV-APP-0001 — SQL Injection

```yaml
id: SV-APP-0001
canonical_name: SQL Injection
display_name_pt_br: Injeção SQL
aliases: [SQLi, injeção de SQL, blind SQL injection]
category: APP.INJECTION
description: >
  Verifica se dados não confiáveis podem alterar a estrutura
  de consultas SQL executadas pela aplicação.
scope:
  asset_types: [web_application, api, database_client]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-89]
  asvs: [V1.2.4]
  wstg: [WSTG-INPV-05]
  attack: [T1190]
severity_default: high
confidence_threshold: medium
preconditions:
  - Existe execução de consultas SQL.
  - Existe uma fonte de dados potencialmente não confiável.
pass_criteria:
  - Consultas relevantes utilizam parametrização adequada.
  - A estrutura SQL não pode ser controlada pela entrada externa.
  - Os testes de validação não demonstram alteração indevida da consulta.
fail_criteria:
  - Entrada não confiável altera a estrutura de uma consulta executável.
  - Evidência confirma acesso ou alteração não autorizada por injeção.
inconclusive_criteria:
  - O fluxo de dados não pôde ser rastreado.
  - O banco real não está disponível para teste.
  - O resultado dinâmico não diferencia a hipótese de outras causas.
false_positive_guidance:
  - Revisar a origem dos dados e a parametrização efetiva.
  - Não reprovar apenas pela presença de SQL dinâmico.
  - Verificar sanitização contextual e APIs de consulta utilizadas.
remediation:
  - Utilizar consultas parametrizadas.
  - Evitar concatenação de entradas em estruturas SQL.
  - Aplicar privilégio mínimo no usuário do banco.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0010, SV-APP-0013]
duplicate_of: null
```

Métodos: análise estática, testes dinâmicos controlados e revisão manual.

**Aprovar quando:**
- Consultas utilizam parametrização apropriada.
- Dados externos não modificam a estrutura executável da consulta.
- Os testes autorizados não demonstram injeção nos fluxos verificados.

**Reprovar quando:**
- Uma entrada não confiável altera a estrutura SQL.
- A alteração permite leitura, modificação ou execução não autorizada de operações no banco.

**Falsos positivos:**
- SQL dinâmico não implica automaticamente injeção.
- Queries parametrizadas podem coexistir com concatenação insegura em outra parte do fluxo.
- Escapar texto manualmente não deve ser considerado equivalente universal à parametrização.

---

## SV-APP-0002 — XSS e codificação de saída

```yaml
id: SV-APP-0002
canonical_name: Cross-Site Scripting and Output Encoding
display_name_pt_br: XSS e codificação de saída
aliases: [XSS, cross-site scripting, XSS refletido, XSS armazenado, DOM XSS, HTML injection]
category: APP.OUTPUT_ENCODING
description: >
  Verifica se dados não confiáveis chegam a um contexto executável do
  navegador sem a codificação ou sanitização adequada ao contexto de saída.
scope:
  asset_types: [web_application, desktop_application]
methods: [static_analysis, manual_review, dynamic_testing]
references:
  cwe: [CWE-79, CWE-116]
  asvs: [V1.2.1, V1.2.3, V1.3.1, V3.4.3]
  wstg: [WSTG-INPV-01, WSTG-INPV-02, WSTG-CLNT-01]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação renderiza conteúdo em um navegador ou webview.
  - Dados de origem externa ou de outro usuário chegam à saída.
pass_criteria:
  - Dados não confiáveis são codificados de acordo com o contexto de saída.
  - Templates e frameworks utilizam mecanismos seguros de renderização.
  - Dados externos não executam código ativo no contexto do usuário.
fail_criteria:
  - Uma entrada não confiável alcança um contexto executável sem proteção adequada.
  - Um teste autorizado confirma execução indevida de conteúdo ativo.
inconclusive_criteria:
  - O caminho do dado até a saída não pôde ser rastreado.
  - A renderização acontece em componente de terceiro não inspecionável.
false_positive_guidance:
  - Uma string contendo tags HTML não comprova XSS.
  - Sanitização válida em um contexto não garante proteção em outro.
  - Renderização textual e renderização HTML devem ser avaliadas separadamente.
remediation:
  - Usar a codificação automática do framework e evitar saídas cruas (como {!! !!}, innerHTML, v-html, x-html) com dados externos.
  - Sanitizar conteúdo rico no servidor com biblioteca baseada em lista de permissões.
  - Adotar Content-Security-Policy como defesa em profundidade.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0009]
duplicate_of: null
```

Métodos: análise estática, revisão de templates e testes dinâmicos controlados.

**Aprovar quando:**
- Dados não confiáveis são codificados de acordo com o contexto de saída.
- Templates e frameworks utilizam mecanismos seguros de renderização.
- Dados externos não executam código ativo no contexto do usuário.

**Reprovar quando:**
- Uma entrada não confiável alcança um contexto executável sem proteção adequada.
- Um teste autorizado confirma execução indevida de conteúdo ativo.

**Falsos positivos:**
- Uma string contendo tags HTML não comprova XSS.
- Sanitização válida em um contexto não garante proteção em outro.
- Renderização textual e renderização HTML devem ser avaliadas separadamente.

---

## SV-APP-0003 — Autorização por objeto e função

```yaml
id: SV-APP-0003
canonical_name: Object and Function Level Authorization
display_name_pt_br: Autorização por objeto e função
aliases: [IDOR, BOLA, BFLA, broken access control, isolamento multi-tenant]
category: APP.AUTHORIZATION
description: >
  Verifica se cada operação valida no servidor a autorização sobre o objeto
  e sobre a função solicitados, inclusive entre tenants.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, manual_review, dynamic_testing]
references:
  cwe: [CWE-639, CWE-285, CWE-862, CWE-863]
  asvs: [V8.2.1, V8.2.2, V8.3.1, V8.4.1]
  wstg: [WSTG-ATHZ-02, WSTG-ATHZ-03, WSTG-ATHZ-04]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - Existem recursos pertencentes a usuários, grupos ou tenants distintos, ou funções com níveis de privilégio diferentes.
  - Há pelo menos duas identidades de teste com permissões diferentes, para o teste dinâmico.
pass_criteria:
  - Cada operação valida a autorização no servidor.
  - Recursos pertencentes a outros usuários ou tenants não podem ser acessados indevidamente.
  - Operações administrativas exigem privilégios explícitos.
fail_criteria:
  - A troca de identificadores ou parâmetros permite acesso não autorizado.
  - Uma identidade com privilégio inferior executa operações restritas.
inconclusive_criteria:
  - Não há identidades de teste com permissões distintas.
  - A política de compartilhamento não está documentada.
false_positive_guidance:
  - A existência de IDs sequenciais não comprova IDOR.
  - Acesso permitido por política de compartilhamento documentada não é falha.
  - Ocultar botões no frontend não substitui autorização no servidor.
remediation:
  - Buscar todo registro através da verificação de autorização, nunca confiando no id recebido.
  - Centralizar as regras de autorização em políticas no servidor.
  - Escopar consultas pelo tenant e pelo dono do recurso.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-API-0001, SV-IDN-0001]
duplicate_of: null
```

Métodos: análise de rotas e políticas, testes dinâmicos com identidades distintas.

**Aprovar quando:**
- Cada operação valida a autorização no servidor.
- Recursos pertencentes a outros usuários ou tenants não podem ser acessados indevidamente.
- Operações administrativas exigem privilégios explícitos.

**Reprovar quando:**
- A troca de identificadores ou parâmetros permite acesso não autorizado.
- Uma identidade com privilégio inferior executa operações restritas.

**Falsos positivos:**
- A existência de IDs sequenciais não comprova IDOR.
- Acesso permitido por política de compartilhamento documentada não é falha.
- Ocultar botões no frontend não substitui autorização no servidor.

---

## SV-APP-0004 — Autenticação e gestão de sessões

```yaml
id: SV-APP-0004
canonical_name: Authentication and Session Management
display_name_pt_br: Autenticação e gestão de sessões
aliases: [session hijacking, session fixation, roubo de sessão, JWT, cookie de sessão]
category: APP.SESSION
description: >
  Verifica a proteção de credenciais, o ciclo de vida das sessões e dos
  tokens e a segurança dos fluxos de login, recuperação e alteração de
  credenciais.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-287, CWE-384, CWE-613, CWE-598, CWE-916]
  asvs: [V3.3.4, V7.2.1, V7.2.4, V7.3.1, V7.4.1, V9.1.1, V11.4.2, V14.2.1]
  wstg: [WSTG-ATHN-01, WSTG-ATHN-04, WSTG-SESS-01, WSTG-SESS-02, WSTG-SESS-03, WSTG-SESS-06, WSTG-SESS-07]
  attack: [T1539, T1550.004]
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação autentica usuários ou mantém sessões.
pass_criteria:
  - Credenciais são protegidas em trânsito e armazenadas de forma apropriada.
  - Sessões possuem expiração e invalidação adequadas ao risco.
  - Tokens e cookies são tratados segundo seus mecanismos de autenticação.
  - Fluxos de login, recuperação e alteração de credenciais são protegidos.
fail_criteria:
  - Uma falha permite contornar autenticação, assumir uma conta ou reutilizar uma sessão invalidada.
  - Segredos de autenticação são expostos em logs, URLs ou respostas não autorizadas.
inconclusive_criteria:
  - O provedor de identidade é externo e não pôde ser inspecionado.
  - Não há conta de teste para exercitar os fluxos.
false_positive_guidance:
  - Um cookie sem determinada flag deve ser avaliado conforme seu uso e contexto.
  - JWT não é automaticamente seguro ou inseguro por sua simples presença.
  - A expiração de token e a revogação de sessão são propriedades diferentes.
remediation:
  - Armazenar senhas com função de derivação lenta e aprovada.
  - Gerar novo identificador de sessão no login e invalidar a sessão no logout e na expiração.
  - Validar assinatura e algoritmo de tokens autocontidos com lista de permissões.
  - Nunca transmitir segredos de autenticação em URLs.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-IDN-0002, SV-IDN-0003, SV-IDN-0004, SV-APP-0009]
duplicate_of: null
```

Métodos: revisão de código, configuração e testes dinâmicos.

**Aprovar quando:**
- Credenciais são protegidas em trânsito e armazenadas de forma apropriada.
- Sessões possuem expiração e invalidação adequadas ao risco.
- Tokens e cookies são tratados segundo seus mecanismos de autenticação.
- Fluxos de login, recuperação e alteração de credenciais são protegidos.

**Reprovar quando:**
- Uma falha permite contornar autenticação, assumir uma conta ou reutilizar uma sessão invalidada.
- Segredos de autenticação são expostos em logs, URLs ou respostas não autorizadas.

**Falsos positivos:**
- Um cookie sem determinada flag deve ser avaliado conforme seu uso e contexto.
- JWT não é automaticamente seguro ou inseguro por sua simples presença.
- A expiração de token e a revogação de sessão são propriedades diferentes.

---

## SV-APP-0005 — CSRF

```yaml
id: SV-APP-0005
canonical_name: Cross-Site Request Forgery
display_name_pt_br: Falsificação de requisição entre sites
aliases: [CSRF, XSRF, session riding]
category: APP.SESSION
description: >
  Verifica se operações que alteram estado estão protegidas contra
  requisições autenticadas originadas por terceiros.
scope:
  asset_types: [web_application]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-352]
  asvs: [V3.3.2, V3.5.1, V3.5.2, V3.5.3]
  wstg: [WSTG-SESS-05]
  attack: []
severity_default: medium
confidence_threshold: medium
preconditions:
  - A autenticação é enviada automaticamente pelo navegador (cookie ou equivalente).
  - Existem operações que alteram estado.
pass_criteria:
  - Operações sensíveis possuem proteção apropriada contra requisições originadas por terceiros.
  - A autorização e a validação de origem são realizadas no servidor quando aplicáveis.
  - O mecanismo é consistente com o modelo de autenticação utilizado.
fail_criteria:
  - Uma requisição indevida de origem externa consegue realizar uma operação autenticada e não autorizada.
inconclusive_criteria:
  - O modelo de autenticação não pôde ser determinado.
  - Não foi possível executar a requisição de origem cruzada no ambiente autorizado.
false_positive_guidance:
  - Operações exclusivamente de leitura podem ter requisitos diferentes.
  - Tokens CSRF não substituem autorização.
  - CORS e CSRF são controles diferentes.
remediation:
  - Usar token anti-CSRF do framework em toda operação que altera estado.
  - Definir SameSite nos cookies de sessão conforme o uso.
  - Não usar GET para operações que alteram estado.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0004, SV-APP-0016]
duplicate_of: null
```

Métodos: revisão de fluxos de estado, cookies e testes dinâmicos.

**Aprovar quando:**
- Operações sensíveis possuem proteção apropriada contra requisições originadas por terceiros.
- A autorização e a validação de origem são realizadas no servidor quando aplicáveis.
- O mecanismo é consistente com o modelo de autenticação utilizado.

**Reprovar quando:**
- Uma requisição indevida de origem externa consegue realizar uma operação autenticada e não autorizada.

**Falsos positivos:**
- Operações exclusivamente de leitura podem ter requisitos diferentes.
- Tokens CSRF não substituem autorização.
- CORS e CSRF são controles diferentes.

---

## SV-APP-0006 — SSRF

```yaml
id: SV-APP-0006
canonical_name: Server-Side Request Forgery
display_name_pt_br: Falsificação de requisição do lado do servidor
aliases: [SSRF, acesso a metadados de nuvem via servidor]
category: APP.API_SECURITY
description: >
  Verifica se uma entrada controlada pelo usuário pode fazer o servidor
  acessar destinos de rede não autorizados, inclusive recursos internos e
  serviços de metadados.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-918]
  asvs: [V1.3.6, V13.2.5, V15.3.2]
  wstg: [WSTG-INPV-19]
  attack: [T1552.005]
severity_default: high
confidence_threshold: medium
preconditions:
  - O servidor faz requisições de rede cujo destino depende, total ou parcialmente, de dados externos.
pass_criteria:
  - Destinos externos são validados conforme uma política explícita.
  - A aplicação restringe acesso a recursos internos e metadados sensíveis.
  - Redirecionamentos e resolução de nomes não permitem contornar as restrições.
fail_criteria:
  - Uma entrada controlada pelo usuário faz o servidor acessar destinos não autorizados e a condição é comprovada.
inconclusive_criteria:
  - Não há destino controlado disponível para confirmar a requisição de saída.
  - A política de destinos permitidos não está definida.
false_positive_guidance:
  - Uma URL fornecida pelo usuário não comprova SSRF.
  - Clientes HTTP com destino configurável podem ser legítimos.
  - Testes devem usar destinos controlados, sem consultar serviços internos reais fora do escopo autorizado.
remediation:
  - Validar destino contra lista de permissões de protocolos, domínios e portas.
  - Bloquear faixas internas e endereços de metadados após a resolução de nome.
  - Não seguir redirecionamentos, ou revalidar cada salto.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-CLD-0001, SV-APP-0012]
duplicate_of: null
```

Métodos: rastreamento estático dos destinos de rede e testes controlados.

**Aprovar quando:**
- Destinos externos são validados conforme uma política explícita.
- A aplicação restringe acesso a recursos internos e metadados sensíveis.
- Redirecionamentos e resolução de nomes não permitem contornar as restrições.

**Reprovar quando:**
- Uma entrada controlada pelo usuário faz o servidor acessar destinos não autorizados e a condição é comprovada.

**Falsos positivos:**
- Uma URL fornecida pelo usuário não comprova SSRF.
- Clientes HTTP com destino configurável podem ser legítimos.
- Testes devem usar destinos controlados, sem consultar serviços internos reais fora do escopo autorizado.

---

## SV-APP-0007 — Path Traversal e acesso a arquivos

```yaml
id: SV-APP-0007
canonical_name: Path Traversal and File Access
display_name_pt_br: Travessia de caminho e acesso a arquivos
aliases: [directory traversal, path traversal, LFI, local file inclusion, leitura arbitrária de arquivos, escrita arbitrária de arquivos]
category: APP.FILE_HANDLING
description: >
  Verifica se a manipulação de caminhos permite ler, sobrescrever ou executar
  arquivos fora do diretório autorizado.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-22, CWE-59]
  asvs: [V5.3.2]
  wstg: [WSTG-ATHZ-01]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - Caminhos ou nomes de arquivo são construídos a partir de dados externos.
pass_criteria:
  - Caminhos são resolvidos e limitados ao diretório permitido.
  - Identificadores de arquivo são validados no servidor.
  - Permissões impedem leitura ou escrita fora do escopo autorizado.
fail_criteria:
  - A manipulação de um caminho permite ler, sobrescrever ou executar arquivos não autorizados.
inconclusive_criteria:
  - O caminho final depende de configuração de ambiente não disponível.
  - O sistema de arquivos de teste não reproduz links simbólicos ou diferenças de sistema operacional do ambiente real.
false_positive_guidance:
  - A ocorrência de `../` em uma string não comprova exploração.
  - Normalização textual sem verificação do caminho resolvido pode ser insuficiente.
  - Links simbólicos e diferenças de sistema operacional devem ser considerados.
remediation:
  - Usar identificadores internos em vez de nomes de arquivo enviados pelo usuário.
  - Resolver o caminho canônico e verificar que ele está dentro do diretório base.
  - Restringir permissões do processo ao diretório necessário.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0008, SV-APP-0017]
duplicate_of: null
```

Métodos: análise de caminhos, revisão de permissões e testes dinâmicos controlados.

**Aprovar quando:**
- Caminhos são resolvidos e limitados ao diretório permitido.
- Identificadores de arquivo são validados no servidor.
- Permissões impedem leitura ou escrita fora do escopo autorizado.

**Reprovar quando:**
- A manipulação de um caminho permite ler, sobrescrever ou executar arquivos não autorizados.

**Falsos positivos:**
- A ocorrência de `../` em uma string não comprova exploração.
- Normalização textual sem verificação do caminho resolvido pode ser insuficiente.
- Links simbólicos e diferenças de sistema operacional devem ser considerados.

---

## SV-APP-0008 — Upload e processamento de arquivos

```yaml
id: SV-APP-0008
canonical_name: File Upload and Processing
display_name_pt_br: Upload e processamento de arquivos
aliases: [unrestricted file upload, upload de webshell, processamento de documentos]
category: APP.FILE_HANDLING
description: >
  Verifica se arquivos enviados são validados em tipo, tamanho, destino e
  permissões, não são executados e são processados com limites de recursos.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-434]
  asvs: [V5.2.1, V5.2.2, V5.3.1, V5.4.3]
  wstg: [WSTG-BUSL-08, WSTG-BUSL-09]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação aceita arquivos enviados por usuários ou sistemas externos.
pass_criteria:
  - Tipo, tamanho, destino e permissões são validados.
  - Arquivos enviados não são executados por padrão.
  - O processamento utiliza bibliotecas suportadas e limites de recursos.
  - O armazenamento e a entrega respeitam as regras de autorização.
fail_criteria:
  - Um arquivo não confiável pode executar código, sobrescrever dados indevidos ou provocar exposição comprovada.
inconclusive_criteria:
  - A configuração do servidor que serve os arquivos não pôde ser inspecionada.
  - O processamento ocorre em serviço externo não acessível.
false_positive_guidance:
  - A extensão do arquivo não determina sozinha seu conteúdo.
  - A presença de upload não significa vulnerabilidade.
  - Um bloqueio por MIME declarado não comprova validação do conteúdo real.
remediation:
  - Validar conteúdo real, extensão e tamanho no servidor.
  - Armazenar fora da raiz pública, com nome gerado internamente e sem permissão de execução.
  - Entregar arquivos através de verificação de autorização.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0007, SV-APP-0017, SV-RES-0001]
duplicate_of: null
```

Métodos: análise estática, configuração e testes com arquivos de amostra inofensivos.

**Aprovar quando:**
- Tipo, tamanho, destino e permissões são validados.
- Arquivos enviados não são executados por padrão.
- O processamento utiliza bibliotecas suportadas e limites de recursos.
- O armazenamento e a entrega respeitam as regras de autorização.

**Reprovar quando:**
- Um arquivo não confiável pode executar código, sobrescrever dados indevidos ou provocar exposição comprovada.

**Falsos positivos:**
- A extensão do arquivo não determina sozinha seu conteúdo.
- A presença de upload não significa vulnerabilidade.
- Um bloqueio por MIME declarado não comprova validação do conteúdo real.

---

## SV-APP-0009 — Configuração de segurança e headers

```yaml
id: SV-APP-0009
canonical_name: Security Configuration and Headers
display_name_pt_br: Configuração de segurança e headers
aliases: [security misconfiguration, headers de segurança, CSP, HSTS, modo debug exposto]
category: APP.CLIENT_SECURITY
description: >
  Verifica se transporte, cookies, headers, políticas de conteúdo e
  configurações de produção correspondem aos requisitos de segurança, sem
  expor depuração ou informação sensível.
scope:
  asset_types: [web_application, api]
methods: [configuration_review, dynamic_testing]
references:
  cwe: [CWE-693, CWE-209, CWE-215, CWE-614, CWE-1004]
  asvs: [V3.3.1, V3.4.1, V3.4.4, V13.4.2, V13.4.5, V13.4.6, V16.5.1]
  wstg: [WSTG-CONF-02, WSTG-CONF-05, WSTG-CONF-07, WSTG-ERRH-01, WSTG-ERRH-02]
  attack: []
severity_default: medium
confidence_threshold: high
preconditions:
  - A aplicação responde por HTTP.
pass_criteria:
  - HTTPS e políticas de transporte são apropriados ao ambiente.
  - Cookies, headers e políticas de conteúdo correspondem aos fluxos da aplicação.
  - Endpoints de debug e informações sensíveis não estão expostos indevidamente.
  - Configurações de produção não dependem de padrões inseguros.
fail_criteria:
  - Uma configuração expõe informação sensível ou permite um comportamento contrário ao requisito de segurança documentado.
inconclusive_criteria:
  - Só o ambiente de desenvolvimento estava disponível e a configuração de produção não pôde ser inspecionada.
false_positive_guidance:
  - A ausência de um header não possui o mesmo impacto em todos os sistemas.
  - CORS permissivo não significa automaticamente acesso a dados autenticados.
  - CSP deve ser avaliada considerando as origens, diretivas e recursos realmente utilizados.
remediation:
  - Desligar modo debug e páginas de erro detalhadas em produção.
  - Definir HSTS, X-Content-Type-Options e Content-Security-Policy conforme os recursos usados.
  - Marcar cookies sensíveis com Secure e HttpOnly.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0002, SV-APP-0015, SV-APP-0016]
duplicate_of: null
```

Métodos: inspeção de configuração e testes HTTP.

**Aprovar quando:**
- HTTPS e políticas de transporte são apropriados ao ambiente.
- Cookies, headers e políticas de conteúdo correspondem aos fluxos da aplicação.
- Endpoints de debug e informações sensíveis não estão expostos indevidamente.
- Configurações de produção não dependem de padrões inseguros.

**Reprovar quando:**
- Uma configuração expõe informação sensível ou permite um comportamento contrário ao requisito de segurança documentado.

**Falsos positivos:**
- A ausência de um header não possui o mesmo impacto em todos os sistemas.
- CORS permissivo não significa automaticamente acesso a dados autenticados.
- CSP deve ser avaliada considerando as origens, diretivas e recursos realmente utilizados.

---

## SV-APP-0010 — NoSQL Injection

```yaml
id: SV-APP-0010
canonical_name: NoSQL Injection
display_name_pt_br: Injeção NoSQL
aliases: [NoSQLi, injeção de operador, MongoDB injection]
category: APP.INJECTION
description: >
  Verifica se dados não confiáveis podem introduzir operadores ou alterar a
  lógica de consultas a bancos NoSQL, caches ou mecanismos de busca.
scope:
  asset_types: [web_application, api, database_client]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-943]
  asvs: [V1.2.4]
  wstg: [WSTG-INPV-05]
  attack: [T1190]
  note: No WSTG v4.2 a injeção NoSQL é a subseção 5.6 do teste WSTG-INPV-05.
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação consulta banco NoSQL, cache ou mecanismo de busca.
  - Parte da consulta deriva de entrada externa.
pass_criteria:
  - Valores externos entram na consulta como valores tipados, nunca como operadores ou estruturas.
  - A estrutura da consulta é fixada pelo código.
  - Os testes autorizados não demonstram alteração da lógica da consulta.
fail_criteria:
  - Uma entrada externa injeta operadores (como $ne, $gt, $where) ou altera a lógica da consulta executada.
  - Evidência confirma leitura ou alteração de dados fora do esperado por essa via.
inconclusive_criteria:
  - O driver ou ODM não pôde ser identificado.
  - O fluxo entre a entrada e a consulta não pôde ser rastreado.
false_positive_guidance:
  - Consulta montada com objeto não implica injeção se os valores são tipados e validados.
  - SQL Injection e NoSQL Injection são regras diferentes; não reaproveitar a evidência de uma para a outra.
  - Operadores fixados no código não são controlados pelo usuário.
remediation:
  - Validar tipo e formato de cada campo antes de usá-lo na consulta.
  - Rejeitar objetos onde se espera valor escalar.
  - Desabilitar a execução de JavaScript no servidor do banco quando não for necessária.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0001]
duplicate_of: null
```

Métodos: análise estática, testes dinâmicos controlados e revisão manual.

**Aprovar quando:**
- Valores externos entram na consulta como valores tipados, nunca como operadores ou estruturas.
- A estrutura da consulta é fixada pelo código.
- Os testes autorizados não demonstram alteração da lógica da consulta.

**Reprovar quando:**
- Uma entrada externa injeta operadores ou altera a lógica da consulta executada.
- Há evidência de leitura ou alteração de dados fora do esperado por essa via.

**Falsos positivos:**
- Consulta montada com objeto não implica injeção se os valores são tipados e validados.
- SQL Injection e NoSQL Injection são regras diferentes; a evidência de uma não serve para a outra.
- Operadores fixados no código não são controlados pelo usuário.

---

## SV-APP-0011 — Server-Side Template Injection

```yaml
id: SV-APP-0011
canonical_name: Server-Side Template Injection
display_name_pt_br: Injeção de template no servidor
aliases: [SSTI, template injection, injeção de expressão]
category: APP.INJECTION
description: >
  Verifica se entrada não confiável pode ser interpretada como template ou
  expressão por um motor de templates no servidor.
scope:
  asset_types: [web_application, api]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-1336]
  asvs: [V1.3.7]
  wstg: [WSTG-INPV-18]
  attack: [T1190]
severity_default: critical
confidence_threshold: medium
preconditions:
  - A aplicação usa motor de templates no servidor.
  - Existe possibilidade de o conteúdo do template, e não apenas os dados, derivar de entrada externa.
pass_criteria:
  - Templates são definidos pelo código ou por administradores autorizados, nunca montados a partir de entrada externa.
  - Dados externos são passados ao template como variáveis, não concatenados ao seu texto.
  - Quando templates de usuário são necessários, rodam em modo sandbox com recursos limitados.
fail_criteria:
  - Uma entrada externa é avaliada como expressão do motor de templates e o resultado da avaliação é observado.
inconclusive_criteria:
  - O motor de templates não pôde ser identificado.
  - O resultado da avaliação não é observável e não há canal seguro para confirmá-lo.
false_positive_guidance:
  - Delimitadores de template refletidos literalmente na saída não comprovam avaliação.
  - XSS e SSTI são diferentes, porque a avaliação precisa acontecer no servidor.
  - Templates editáveis por administradores podem ser decisão legítima, avaliada conforme a política.
remediation:
  - Nunca montar templates a partir de entrada externa.
  - Passar dados como contexto do template.
  - Usar o modo sandbox do motor quando templates de usuário forem requisito.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0002, SV-APP-0013]
duplicate_of: null
```

Métodos: análise estática, testes dinâmicos controlados e revisão manual.

**Aprovar quando:**
- Templates são definidos pelo código ou por administradores autorizados, nunca montados a partir de entrada externa.
- Dados externos são passados ao template como variáveis, não concatenados ao texto dele.
- Templates de usuário, quando são requisito, rodam em sandbox com recursos limitados.

**Reprovar quando:**
- Uma entrada externa é avaliada como expressão do motor de templates e o resultado é observado.

**Falsos positivos:**
- Delimitadores de template refletidos literalmente na saída não comprovam avaliação.
- XSS e SSTI são diferentes: a avaliação precisa acontecer no servidor.
- Templates editáveis por administradores podem ser decisão legítima, avaliada conforme a política.

---

## SV-APP-0012 — XXE e expansão de entidades XML

```yaml
id: SV-APP-0012
canonical_name: XML External Entity Processing
display_name_pt_br: Processamento de entidade externa XML
aliases: [XXE, XML injection, billion laughs, expansão de entidades]
category: APP.INJECTION
description: >
  Verifica se parsers XML que processam dados não confiáveis resolvem
  entidades externas ou expandem entidades recursivamente.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, configuration_review, dynamic_testing]
references:
  cwe: [CWE-611, CWE-776]
  asvs: [V1.5.1]
  wstg: [WSTG-INPV-07]
  attack: []
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação faz parsing de XML, SVG, DOCX, XLSX ou outro formato baseado em XML de origem externa.
pass_criteria:
  - Resolução de entidades externas e DTD está desabilitada nos parsers usados com dados externos.
  - Expansão de entidades é limitada.
  - Os testes autorizados não demonstram resolução de entidade externa.
fail_criteria:
  - Um documento enviado faz o parser resolver uma entidade externa, comprovado por leitura de arquivo, requisição de saída a destino controlado ou erro revelador.
  - Um documento enviado provoca expansão de entidades que esgota recursos em ambiente controlado.
inconclusive_criteria:
  - A configuração efetiva do parser depende de versão de biblioteca não identificada.
  - Não há destino controlado para observar a requisição de saída.
false_positive_guidance:
  - Aceitar XML não implica XXE; o que importa é a configuração do parser.
  - Várias bibliotecas modernas já desabilitam entidades externas por padrão; confirmar a versão em uso.
  - Teste de expansão só em ambiente controlado e com carga limitada.
remediation:
  - Desabilitar DTD e entidades externas em todos os parsers que recebem dados externos.
  - Preferir formatos mais simples quando XML não for necessário.
  - Manter bibliotecas de parsing atualizadas.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0006, SV-APP-0008]
duplicate_of: null
```

Métodos: análise estática, revisão de configuração e testes dinâmicos controlados.

**Aprovar quando:**
- Resolução de entidades externas e DTD está desabilitada nos parsers usados com dados externos.
- Expansão de entidades é limitada.
- Os testes autorizados não demonstram resolução de entidade externa.

**Reprovar quando:**
- Um documento enviado faz o parser resolver uma entidade externa, comprovado por leitura de arquivo, requisição de saída a destino controlado ou erro revelador.
- Um documento enviado provoca expansão de entidades que esgota recursos em ambiente controlado.

**Falsos positivos:**
- Aceitar XML não implica XXE; o que importa é a configuração do parser.
- Bibliotecas modernas muitas vezes já desabilitam entidades externas por padrão; confirmar a versão em uso.
- Teste de expansão só em ambiente controlado e com carga limitada.

---

## SV-APP-0013 — Command Injection

```yaml
id: SV-APP-0013
canonical_name: OS Command Injection
display_name_pt_br: Injeção de comando do sistema operacional
aliases: [command injection, OS command injection, shell injection, RCE por comando]
category: APP.INJECTION
description: >
  Verifica se dados não confiáveis podem alterar comandos do sistema
  operacional executados pela aplicação.
scope:
  asset_types: [web_application, api, desktop_application, pipeline]
methods: [static_analysis, dynamic_testing, manual_review]
references:
  cwe: [CWE-78, CWE-77]
  asvs: [V1.2.5]
  wstg: [WSTG-INPV-12]
  attack: [T1190, T1059]
severity_default: critical
confidence_threshold: medium
preconditions:
  - A aplicação executa processos ou comandos do sistema operacional.
  - Algum argumento deriva de entrada externa.
pass_criteria:
  - Processos são executados com a lista de argumentos separada, sem passar por shell.
  - Argumentos externos são validados contra lista de permissões.
  - Os testes autorizados não demonstram execução de comando adicional.
fail_criteria:
  - Uma entrada externa altera o comando executado ou acrescenta outro, comprovado por efeito observável e inofensivo.
inconclusive_criteria:
  - A chamada passa por biblioteca cujo comportamento de escape não pôde ser verificado.
  - Não há efeito observável seguro para confirmar a execução.
false_positive_guidance:
  - Executar processos não é falha por si só.
  - Argumentos fixos no código não são controlados pelo usuário.
  - Escape manual não equivale a passar argumentos separados sem shell.
remediation:
  - Usar APIs que recebem o executável e a lista de argumentos separadamente.
  - Evitar shell; quando inevitável, validar contra lista de permissões.
  - Executar com o menor privilégio possível.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0001, SV-APP-0011, SV-HOST-0001]
duplicate_of: null
```

Métodos: análise estática, testes dinâmicos controlados e revisão manual.

**Aprovar quando:**
- Processos são executados com a lista de argumentos separada, sem passar por shell.
- Argumentos externos são validados contra lista de permissões.
- Os testes autorizados não demonstram execução de comando adicional.

**Reprovar quando:**
- Uma entrada externa altera o comando executado ou acrescenta outro, comprovado por efeito observável e inofensivo.

**Falsos positivos:**
- Executar processos não é falha por si só.
- Argumentos fixos no código não são controlados pelo usuário.
- Escape manual não equivale a passar argumentos separados sem shell.

---

## SV-APP-0014 — Desserialização insegura

```yaml
id: SV-APP-0014
canonical_name: Insecure Deserialization
display_name_pt_br: Desserialização insegura
aliases: [deserialization of untrusted data, object injection, PHP object injection, gadget chain]
category: APP.INJECTION
description: >
  Verifica se a aplicação desserializa dados não confiáveis em formatos que
  permitem instanciar tipos arbitrários ou executar código.
scope:
  asset_types: [web_application, api, desktop_application]
methods: [static_analysis, manual_review, dynamic_testing]
references:
  cwe: [CWE-502]
  asvs: [V1.5.2]
  wstg: []
  attack: [T1190]
  note: O WSTG v4.2 não tem cenário específico para desserialização.
severity_default: critical
confidence_threshold: medium
preconditions:
  - A aplicação desserializa dados que podem vir de fora do seu limite de confiança (cookies, parâmetros, filas, arquivos).
pass_criteria:
  - Dados não confiáveis não são desserializados em formatos nativos que instanciam objetos arbitrários.
  - Quando necessário, a desserialização usa lista de permissões de tipos.
  - Dados serializados que precisam voltar ao servidor têm integridade verificada.
fail_criteria:
  - Um dado controlado externamente é desserializado em formato que instancia tipos arbitrários e a cadeia de exploração é demonstrada com efeito inofensivo.
inconclusive_criteria:
  - Há desserialização de dado externo, mas nenhuma cadeia de gadgets pôde ser demonstrada com segurança.
  - A origem do dado serializado não pôde ser determinada.
false_positive_guidance:
  - JSON com tipos simples não é desserialização insegura.
  - Dado serializado que nunca sai do servidor não é controlado pelo usuário.
  - Ausência de gadget conhecido não torna o padrão seguro; registrar como INCONCLUSIVE com recomendação.
remediation:
  - Trocar formatos nativos por JSON com esquema validado.
  - Restringir tipos permitidos na desserialização.
  - Assinar dados serializados que trafegam pelo cliente.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0013]
duplicate_of: null
```

Métodos: análise estática, revisão manual e testes dinâmicos controlados.

**Aprovar quando:**
- Dados não confiáveis não são desserializados em formatos nativos que instanciam objetos arbitrários.
- Quando necessário, a desserialização usa lista de permissões de tipos.
- Dados serializados que precisam voltar ao servidor têm integridade verificada.

**Reprovar quando:**
- Um dado controlado externamente é desserializado em formato que instancia tipos arbitrários e a cadeia de exploração é demonstrada com efeito inofensivo.

**Falsos positivos:**
- JSON com tipos simples não é desserialização insegura.
- Dado serializado que nunca sai do servidor não é controlado pelo usuário.
- Ausência de gadget conhecido não torna o padrão seguro; registrar como `INCONCLUSIVE` com recomendação.

---

## SV-APP-0015 — Clickjacking

```yaml
id: SV-APP-0015
canonical_name: Clickjacking
display_name_pt_br: Sequestro de clique
aliases: [UI redressing, framing, clickjacking]
category: APP.CLIENT_SECURITY
description: >
  Verifica se páginas com ações sensíveis podem ser embutidas em frames de
  origens não autorizadas.
scope:
  asset_types: [web_application]
methods: [configuration_review, dynamic_testing]
references:
  cwe: [CWE-1021]
  asvs: [V3.4.6]
  wstg: [WSTG-CLNT-09]
  attack: []
severity_default: medium
confidence_threshold: high
preconditions:
  - A aplicação tem páginas com ações sensíveis acessíveis a usuários autenticados.
pass_criteria:
  - As respostas definem a diretiva frame-ancestors (ou X-Frame-Options) restringindo quem pode embutir a página.
  - Páginas com ações sensíveis não podem ser carregadas em frame de origem não autorizada.
fail_criteria:
  - Uma página com ação sensível é carregada em frame de origem não autorizada e a ação pode ser acionada nesse contexto.
inconclusive_criteria:
  - Os headers variam por rota ou proxy e nem todas as rotas sensíveis puderam ser verificadas.
false_positive_guidance:
  - Página pública sem ação sensível embutível pode ser intencional.
  - Widgets feitos para serem embutidos são decisão legítima quando documentados.
  - Ausência de header em resposta de API que não renderiza documento não é clickjacking.
remediation:
  - Definir Content-Security-Policy frame-ancestors com as origens permitidas.
  - Manter X-Frame-Options para navegadores antigos quando necessário.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0009]
duplicate_of: null
```

Métodos: revisão de configuração e testes dinâmicos.

**Aprovar quando:**
- As respostas definem `frame-ancestors` (ou `X-Frame-Options`) restringindo quem pode embutir a página.
- Páginas com ações sensíveis não podem ser carregadas em frame de origem não autorizada.

**Reprovar quando:**
- Uma página com ação sensível é carregada em frame de origem não autorizada e a ação pode ser acionada nesse contexto.

**Falsos positivos:**
- Página pública sem ação sensível embutível pode ser intencional.
- Widgets feitos para serem embutidos são decisão legítima quando documentados.
- Ausência de header em resposta de API que não renderiza documento não é clickjacking.

---

## SV-APP-0016 — CORS

```yaml
id: SV-APP-0016
canonical_name: Cross-Origin Resource Sharing Policy
display_name_pt_br: Política de compartilhamento entre origens
aliases: [CORS, CORS permissivo, Access-Control-Allow-Origin]
category: APP.CLIENT_SECURITY
description: >
  Verifica se a política CORS permite que origens não confiáveis leiam
  respostas autenticadas ou acionem funções sensíveis.
scope:
  asset_types: [web_application, api]
methods: [configuration_review, dynamic_testing]
references:
  cwe: [CWE-942]
  asvs: [V3.4.2]
  wstg: [WSTG-CLNT-07]
  attack: []
severity_default: medium
confidence_threshold: high
preconditions:
  - A aplicação responde a requisições de outras origens com headers CORS.
pass_criteria:
  - Access-Control-Allow-Origin é fixo ou validado contra lista de permissões.
  - Credenciais só são permitidas para origens confiáveis.
  - Origem refletida sem validação não ocorre em respostas com dados autenticados.
fail_criteria:
  - Uma origem não confiável lê uma resposta autenticada com dados que não deveria ver.
inconclusive_criteria:
  - A política varia por ambiente e só um ambiente pôde ser verificado.
false_positive_guidance:
  - CORS permissivo não significa automaticamente acesso a dados autenticados.
  - Allow-Origin * sem credenciais em recurso público é legítimo.
  - CORS e CSRF são controles diferentes.
remediation:
  - Validar a origem contra lista de permissões explícita.
  - Não refletir a origem recebida com Allow-Credentials true.
  - Separar recursos públicos dos autenticados.
requires_authorization: false
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0005, SV-APP-0009]
duplicate_of: null
```

Métodos: revisão de configuração e testes dinâmicos.

**Aprovar quando:**
- `Access-Control-Allow-Origin` é fixo ou validado contra lista de permissões.
- Credenciais só são permitidas para origens confiáveis.
- Origem refletida sem validação não ocorre em respostas com dados autenticados.

**Reprovar quando:**
- Uma origem não confiável lê uma resposta autenticada com dados que não deveria ver.

**Falsos positivos:**
- CORS permissivo não significa automaticamente acesso a dados autenticados.
- `Allow-Origin: *` sem credenciais em recurso público é legítimo.
- CORS e CSRF são controles diferentes.

---

## SV-APP-0017 — Extração de arquivos compactados

```yaml
id: SV-APP-0017
canonical_name: Archive Extraction
display_name_pt_br: Extração de arquivos compactados
aliases: [Zip Slip, zip bomb, bomba de descompressão, symlink em arquivo compactado]
category: APP.FILE_HANDLING
description: >
  Verifica se a extração de arquivos compactados respeita o diretório de
  destino, ignora caminhos e links fornecidos pelo arquivo e limita o tamanho
  descompactado.
scope:
  asset_types: [web_application, api, desktop_application, pipeline]
methods: [static_analysis, dynamic_testing]
references:
  cwe: [CWE-22, CWE-409]
  asvs: [V5.2.3, V5.2.5, V5.3.3]
  wstg: []
  attack: []
  note: O WSTG v4.2 não tem cenário específico para extração de arquivos compactados.
severity_default: high
confidence_threshold: medium
preconditions:
  - A aplicação extrai arquivos compactados de origem externa.
pass_criteria:
  - O caminho de cada entrada é resolvido e verificado dentro do diretório de destino.
  - Links simbólicos dentro do arquivo são rejeitados ou tratados com segurança.
  - Tamanho descompactado e número de arquivos são limitados antes ou durante a extração.
fail_criteria:
  - Um arquivo compactado de teste grava fora do diretório de destino.
  - Um arquivo compactado de teste, com limites seguros, esgota recursos além do aprovado em ambiente controlado.
inconclusive_criteria:
  - A extração ocorre em biblioteca ou serviço cujo comportamento não pôde ser verificado.
false_positive_guidance:
  - Aceitar arquivos compactados não é falha por si só.
  - Bibliotecas que já validam caminhos devem ter a versão confirmada.
  - Teste de bomba de descompressão só em ambiente controlado, com arquivo pequeno e limite baixo.
remediation:
  - Validar o caminho resolvido de cada entrada antes de gravar.
  - Rejeitar links simbólicos e caminhos absolutos.
  - Impor limite de tamanho descompactado, de taxa de compressão e de número de arquivos.
requires_authorization: true
safe_by_default: true
manual_review_required: false
related_controls: [SV-APP-0007, SV-APP-0008, SV-RES-0001]
duplicate_of: null
```

Métodos: análise estática e testes dinâmicos com arquivos inofensivos.

**Aprovar quando:**
- O caminho de cada entrada é resolvido e verificado dentro do diretório de destino.
- Links simbólicos dentro do arquivo são rejeitados ou tratados com segurança.
- Tamanho descompactado e número de arquivos são limitados.

**Reprovar quando:**
- Um arquivo compactado de teste grava fora do diretório de destino.
- Um arquivo compactado de teste, com limites seguros, esgota recursos além do aprovado em ambiente controlado.

**Falsos positivos:**
- Aceitar arquivos compactados não é falha por si só.
- Bibliotecas que já validam caminhos devem ter a versão confirmada.
- Teste de bomba de descompressão só em ambiente controlado, com arquivo pequeno e limite baixo.
