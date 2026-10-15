# Referências

Fontes normativas e técnicas da skill. A versão de cada uma fica fixada aqui e
é registrada no manifesto de cada execução (ver
[templates/report.md](../templates/report.md)).

## Versões fixadas

Consulta feita em **2026-10-15**. O hash é o SHA-256 do artefato oficial
baixado para conferir os identificadores.

| Fonte | Versão | Artefato conferido | SHA-256 |
| --- | --- | --- | --- |
| OWASP ASVS | 5.0.0 (publicada em 2025-05-30) | `OWASP_Application_Security_Verification_Standard_5.0.0_en.flat.json` (release `v5.0.0_release`) | `8201b20eec2908c3380ac600c91c8ba746346fbb808859366abb232027532311` |
| OWASP WSTG | v4.2 (estável, publicada em 2020-12-03; a 5.0 está em desenvolvimento) | `checklist/checklist.json` da tag `v4.2` | `12e11356b02fc9d6ea1b65554145e14dfdffceb9829ff9d93edf14d3654bdf3c` |
| OWASP API Security Top 10 | 2023 | página da edição 2023 | — |
| MITRE ATT&CK Enterprise | v20.0 (publicada em 2026-10-13) | `enterprise-attack-20.0.json` (attack-stix-data) | `81113ba98afa2928f3dcff62022539f7ce30c315c32e14422f11ff95ce534352` |
| MITRE CWE | 4.20 | `1000.csv.zip` (visão de pesquisa) | `6a3d52a7d164d98eb24ca3228039dcd98461379d225dfd395474c0d007537791` |
| MITRE ATLAS | v2026.09 (publicada em 2026-09-15) | `dist/ATLAS.yaml` da tag `v2026.09` | `c9c23971d0db07e2782423d795a20e78d5c2c9bcdc78fc67e24530657daaec41` |
| NIST SP 800-115 | Final, 2008-09-30 | página da publicação | — |
| NIST Cybersecurity Framework | 2.0 | página do CSF | — |
| NIST SSDF | SP 800-218, versão 1.1 | página do projeto | — |
| CIS Benchmarks | por produto; fixar a versão do benchmark usado em cada execução | — | — |
| CISA KEV | catálogo vivo; registrar a data da consulta em cada execução | — | — |

## Fontes

### OWASP

- ASVS: https://owasp.org/www-project-application-security-verification-standard/
- Repositório e versões do ASVS: https://github.com/OWASP/ASVS
- Web Security Testing Guide: https://owasp.org/www-project-web-security-testing-guide/
- WSTG estável: https://wstg.owasp.org/
- API Security Top 10: https://api-security.owasp.org/ — o endereço
  `https://owasp.org/www-project-api-security/` redirecionava para uma página 404
  em 2026-10-15
- Cheat Sheet Series: https://cheatsheetseries.owasp.org/

ASVS é a fonte dos **requisitos de verificação**; WSTG, das **metodologias e
cenários de teste**. O Top 10 não é um catálogo exaustivo e não é usado como tal.

### MITRE

- ATT&CK Enterprise: https://attack.mitre.org/
- Técnicas: https://attack.mitre.org/techniques/
- Táticas: https://attack.mitre.org/tactics/
- ATLAS, para ameaças a sistemas de IA: https://atlas.mitre.org/

ATT&CK mapeia **comportamento adversário**; não substitui a classificação de
vulnerabilidades. Uma regra só cita uma técnica quando a relação é direta —
a maioria não cita nenhuma.

### CWE, CVE e NVD

- CWE: https://cwe.mitre.org/
- CVE: https://www.cve.org/
- NVD: https://nvd.nist.gov/

CWE identifica **classes de fraquezas**. CVE identifica **vulnerabilidades
divulgadas** em produtos específicos. CVSS descreve severidade técnica e não
substitui a avaliação de risco contextual.

### NIST

- SP 800-115: https://csrc.nist.gov/pubs/sp/800/115/final
- Cybersecurity Framework: https://www.nist.gov/cyberframework
- Secure Software Development Framework: https://csrc.nist.gov/Projects/ssdf

### Outras

- CIS Benchmarks: https://www.cisecurity.org/cis-benchmarks
- CISA Known Exploited Vulnerabilities: https://www.cisa.gov/known-exploited-vulnerabilities-catalog

## Política de atualização

- Fixar a versão de cada referência utilizada.
- Registrar a data de consulta e, quando possível, o hash do artefato importado.
- Não atualizar regras automaticamente sem revisão.
- Validar identificadores externos antes de adicioná-los ao catálogo.
- Marcar referências descontinuadas sem apagar o histórico.
- Registrar alterações incompatíveis no versionamento da skill.

Exemplo do porquê: no ATT&CK v20.0 a técnica `T1562` (Impair Defenses) e todas
as suas subtécnicas foram **revogadas**; `T1562` foi substituída por `T1685`
(Disable or Modify Tools). Um catálogo que citasse `T1562` sem conferir estaria
apontando para um identificador morto.

## Identificadores verificados

Todo identificador externo citado por uma regra está nas tabelas abaixo,
conferido no artefato oficial da versão fixada. Os testes do repositório
recusam uma regra que cite um identificador fora destas tabelas — para
acrescentar um, confira-o na fonte e inclua-o aqui primeiro.

Regras sem requisito ASVS (host, nuvem, containers, CI/CD, IA, IoT/OT, backup)
são deliberadas: o ASVS cobre aplicações. Para esses domínios, a verificação
segue CIS Benchmarks e as políticas da organização, registradas na execução.

### CWE 4.20

| ID | Nome oficial |
| --- | --- |
| `CWE-22` | Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal') |
| `CWE-59` | Improper Link Resolution Before File Access ('Link Following') |
| `CWE-77` | Improper Neutralization of Special Elements used in a Command ('Command Injection') |
| `CWE-78` | Improper Neutralization of Special Elements used in an OS Command ('OS Command Injection') |
| `CWE-79` | Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting') |
| `CWE-89` | Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection') |
| `CWE-116` | Improper Encoding or Escaping of Output |
| `CWE-117` | Improper Output Neutralization for Logs |
| `CWE-204` | Observable Response Discrepancy |
| `CWE-209` | Generation of Error Message Containing Sensitive Information |
| `CWE-212` | Improper Removal of Sensitive Information Before Storage or Transfer |
| `CWE-215` | Insertion of Sensitive Information Into Debugging Code |
| `CWE-223` | Omission of Security-relevant Information |
| `CWE-250` | Execution with Unnecessary Privileges |
| `CWE-269` | Improper Privilege Management |
| `CWE-284` | Improper Access Control |
| `CWE-285` | Improper Authorization |
| `CWE-287` | Improper Authentication |
| `CWE-295` | Improper Certificate Validation |
| `CWE-306` | Missing Authentication for Critical Function |
| `CWE-307` | Improper Restriction of Excessive Authentication Attempts |
| `CWE-308` | Use of Single-factor Authentication |
| `CWE-312` | Cleartext Storage of Sensitive Information |
| `CWE-319` | Cleartext Transmission of Sensitive Information |
| `CWE-321` | Use of Hard-coded Cryptographic Key |
| `CWE-326` | Inadequate Encryption Strength |
| `CWE-327` | Use of a Broken or Risky Cryptographic Algorithm |
| `CWE-330` | Use of Insufficiently Random Values |
| `CWE-352` | Cross-Site Request Forgery (CSRF) |
| `CWE-354` | Improper Validation of Integrity Check Value |
| `CWE-359` | Exposure of Private Personal Information to an Unauthorized Actor |
| `CWE-362` | Concurrent Execution using Shared Resource with Improper Synchronization ('Race Condition') |
| `CWE-367` | Time-of-check Time-of-use (TOCTOU) Race Condition |
| `CWE-384` | Session Fixation |
| `CWE-400` | Uncontrolled Resource Consumption |
| `CWE-409` | Improper Handling of Highly Compressed Data (Data Amplification) |
| `CWE-434` | Unrestricted Upload of File with Dangerous Type |
| `CWE-472` | External Control of Assumed-Immutable Web Parameter |
| `CWE-494` | Download of Code Without Integrity Check |
| `CWE-502` | Deserialization of Untrusted Data |
| `CWE-530` | Exposure of Backup File to an Unauthorized Control Sphere |
| `CWE-532` | Insertion of Sensitive Information into Log File |
| `CWE-598` | Use of HTTP Request With Sensitive Query String |
| `CWE-611` | Improper Restriction of XML External Entity Reference |
| `CWE-613` | Insufficient Session Expiration |
| `CWE-614` | Sensitive Cookie in HTTPS Session Without 'Secure' Attribute |
| `CWE-620` | Unverified Password Change |
| `CWE-639` | Authorization Bypass Through User-Controlled Key |
| `CWE-640` | Weak Password Recovery Mechanism for Forgotten Password |
| `CWE-668` | Exposure of Resource to Wrong Sphere |
| `CWE-693` | Protection Mechanism Failure |
| `CWE-732` | Incorrect Permission Assignment for Critical Resource |
| `CWE-770` | Allocation of Resources Without Limits or Throttling |
| `CWE-776` | Improper Restriction of Recursive Entity References in DTDs ('XML Entity Expansion') |
| `CWE-778` | Insufficient Logging |
| `CWE-798` | Use of Hard-coded Credentials |
| `CWE-799` | Improper Control of Interaction Frequency |
| `CWE-829` | Inclusion of Functionality from Untrusted Control Sphere |
| `CWE-837` | Improper Enforcement of a Single, Unique Action |
| `CWE-841` | Improper Enforcement of Behavioral Workflow |
| `CWE-862` | Missing Authorization |
| `CWE-863` | Incorrect Authorization |
| `CWE-915` | Improperly Controlled Modification of Dynamically-Determined Object Attributes |
| `CWE-916` | Use of Password Hash With Insufficient Computational Effort |
| `CWE-918` | Server-Side Request Forgery (SSRF) |
| `CWE-942` | Permissive Cross-domain Security Policy with Untrusted Domains |
| `CWE-943` | Improper Neutralization of Special Elements in Data Query Logic |
| `CWE-1004` | Sensitive Cookie Without 'HttpOnly' Flag |
| `CWE-1021` | Improper Restriction of Rendered UI Layers or Frames |
| `CWE-1039` | Inadequate Detection or Handling of Adversarial Input Perturbations in Automated Recognition Mechanism |
| `CWE-1188` | Initialization of a Resource with an Insecure Default |
| `CWE-1277` | Firmware Not Updateable |
| `CWE-1327` | Binding to an Unrestricted IP Address |
| `CWE-1333` | Inefficient Regular Expression Complexity |
| `CWE-1336` | Improper Neutralization of Special Elements Used in a Template Engine |
| `CWE-1357` | Reliance on Insufficiently Trustworthy Component |
| `CWE-1395` | Dependency on Vulnerable Third-Party Component |
| `CWE-1426` | Improper Validation of Generative AI Output |
| `CWE-1427` | Improper Neutralization of Input Used for LLM Prompting |

### ASVS 5.0.0

| Requisito | Seção oficial |
| --- | --- |
| `V1.2.1` | V1.2 Injection Prevention |
| `V1.2.3` | V1.2 Injection Prevention |
| `V1.2.4` | V1.2 Injection Prevention |
| `V1.2.5` | V1.2 Injection Prevention |
| `V1.3.1` | V1.3 Sanitization |
| `V1.3.6` | V1.3 Sanitization |
| `V1.3.7` | V1.3 Sanitization |
| `V1.3.12` | V1.3 Sanitization |
| `V1.5.1` | V1.5 Safe Deserialization |
| `V1.5.2` | V1.5 Safe Deserialization |
| `V2.3.1` | V2.3 Business Logic Security |
| `V2.3.2` | V2.3 Business Logic Security |
| `V2.3.3` | V2.3 Business Logic Security |
| `V2.3.4` | V2.3 Business Logic Security |
| `V2.4.1` | V2.4 Anti-automation |
| `V2.4.2` | V2.4 Anti-automation |
| `V3.3.1` | V3.3 Cookie Setup |
| `V3.3.2` | V3.3 Cookie Setup |
| `V3.3.4` | V3.3 Cookie Setup |
| `V3.4.1` | V3.4 Browser Security Mechanism Headers |
| `V3.4.2` | V3.4 Browser Security Mechanism Headers |
| `V3.4.3` | V3.4 Browser Security Mechanism Headers |
| `V3.4.4` | V3.4 Browser Security Mechanism Headers |
| `V3.4.6` | V3.4 Browser Security Mechanism Headers |
| `V3.5.1` | V3.5 Browser Origin Separation |
| `V3.5.2` | V3.5 Browser Origin Separation |
| `V3.5.3` | V3.5 Browser Origin Separation |
| `V3.6.1` | V3.6 External Resource Integrity |
| `V4.1.4` | V4.1 Generic Web Service Security |
| `V5.2.1` | V5.2 File Upload and Content |
| `V5.2.2` | V5.2 File Upload and Content |
| `V5.2.3` | V5.2 File Upload and Content |
| `V5.2.5` | V5.2 File Upload and Content |
| `V5.3.1` | V5.3 File Storage |
| `V5.3.2` | V5.3 File Storage |
| `V5.3.3` | V5.3 File Storage |
| `V5.4.3` | V5.4 File Download |
| `V6.2.12` | V6.2 Password Security |
| `V6.3.1` | V6.3 General Authentication Security |
| `V6.3.3` | V6.3 General Authentication Security |
| `V6.3.7` | V6.3 General Authentication Security |
| `V6.3.8` | V6.3 General Authentication Security |
| `V6.4.2` | V6.4 Authentication Factor Lifecycle and Recovery |
| `V6.4.3` | V6.4 Authentication Factor Lifecycle and Recovery |
| `V6.4.4` | V6.4 Authentication Factor Lifecycle and Recovery |
| `V6.5.1` | V6.5 General Multi-factor authentication requirements |
| `V6.5.5` | V6.5 General Multi-factor authentication requirements |
| `V6.5.6` | V6.5 General Multi-factor authentication requirements |
| `V7.2.1` | V7.2 Fundamental Session Management Security |
| `V7.2.4` | V7.2 Fundamental Session Management Security |
| `V7.3.1` | V7.3 Session Timeout |
| `V7.4.1` | V7.4 Session Termination |
| `V7.4.2` | V7.4 Session Termination |
| `V8.2.1` | V8.2 General Authorization Design |
| `V8.2.2` | V8.2 General Authorization Design |
| `V8.2.3` | V8.2 General Authorization Design |
| `V8.3.1` | V8.3 Operation Level Authorization |
| `V8.3.3` | V8.3 Operation Level Authorization |
| `V8.4.1` | V8.4 Other Authorization Considerations |
| `V8.4.2` | V8.4 Other Authorization Considerations |
| `V9.1.1` | V9.1 Token source and integrity |
| `V11.2.1` | V11.2 Secure Cryptography Implementation |
| `V11.3.2` | V11.3 Encryption Algorithms |
| `V11.4.2` | V11.4 Hashing and Hash-based Functions |
| `V11.5.1` | V11.5 Random Values |
| `V12.1.1` | V12.1 General TLS Security Guidance |
| `V12.2.1` | V12.2 HTTPS Communication with External Facing Services |
| `V12.3.1` | V12.3 General Service to Service Communication Security |
| `V12.3.2` | V12.3 General Service to Service Communication Security |
| `V13.2.4` | V13.2 Backend Communication Configuration |
| `V13.2.5` | V13.2 Backend Communication Configuration |
| `V13.3.1` | V13.3 Secret Management |
| `V13.3.4` | V13.3 Secret Management |
| `V13.4.1` | V13.4 Unintended Information Leakage |
| `V13.4.2` | V13.4 Unintended Information Leakage |
| `V13.4.5` | V13.4 Unintended Information Leakage |
| `V13.4.6` | V13.4 Unintended Information Leakage |
| `V14.2.1` | V14.2 General Data Protection |
| `V14.2.3` | V14.2 General Data Protection |
| `V14.2.4` | V14.2 General Data Protection |
| `V14.2.7` | V14.2 General Data Protection |
| `V14.2.8` | V14.2 General Data Protection |
| `V15.2.1` | V15.2 Security Architecture and Dependencies |
| `V15.2.2` | V15.2 Security Architecture and Dependencies |
| `V15.2.4` | V15.2 Security Architecture and Dependencies |
| `V15.3.1` | V15.3 Defensive Coding |
| `V15.3.2` | V15.3 Defensive Coding |
| `V15.3.3` | V15.3 Defensive Coding |
| `V15.4.2` | V15.4 Safe Concurrency |
| `V16.2.1` | V16.2 General Logging |
| `V16.2.5` | V16.2 General Logging |
| `V16.3.1` | V16.3 Security Events |
| `V16.3.2` | V16.3 Security Events |
| `V16.4.1` | V16.4 Log Protection |
| `V16.4.2` | V16.4 Log Protection |
| `V16.5.1` | V16.5 Error Handling |
| `V16.5.2` | V16.5 Error Handling |

### WSTG v4.2

| Teste | Nome oficial |
| --- | --- |
| `WSTG-INPV-01` | Testing for Reflected Cross Site Scripting |
| `WSTG-CLNT-01` | Testing for DOM-Based Cross Site Scripting |
| `WSTG-ATHN-01` | Testing for Credentials Transported over an Encrypted Channel |
| `WSTG-SESS-01` | Testing for Session Management Schema |
| `WSTG-ATHZ-01` | Testing Directory Traversal File Include |
| `WSTG-ERRH-01` | Testing for Improper Error Handling |
| `WSTG-IDNT-01` | Test Role Definitions |
| `WSTG-APIT-01` | Testing GraphQL |
| `WSTG-CRYP-01` | Testing for Weak Transport Layer Security |
| `WSTG-CONF-01` | Test Network Infrastructure Configuration |
| `WSTG-BUSL-01` | Test Business Logic Data Validation |
| `WSTG-INPV-02` | Testing for Stored Cross Site Scripting |
| `WSTG-ATHZ-02` | Testing for Bypassing Authorization Schema |
| `WSTG-SESS-02` | Testing for Cookies Attributes |
| `WSTG-CONF-02` | Test Application Platform Configuration |
| `WSTG-ERRH-02` | Testing for Stack Traces |
| `WSTG-ATHN-02` | Testing for Default Credentials |
| `WSTG-CRYP-02` | Testing for Padding Oracle |
| `WSTG-BUSL-02` | Test Ability to Forge Requests |
| `WSTG-ATHZ-03` | Testing for Privilege Escalation |
| `WSTG-SESS-03` | Testing for Session Fixation |
| `WSTG-ATHN-03` | Testing for Weak Lock Out Mechanism |
| `WSTG-CRYP-03` | Testing for Sensitive Information Sent via Unencrypted Channels |
| `WSTG-BUSL-03` | Test Integrity Checks |
| `WSTG-ATHZ-04` | Testing for Insecure Direct Object References |
| `WSTG-ATHN-04` | Testing for Bypassing Authentication Schema |
| `WSTG-IDNT-04` | Testing for Account Enumeration and Guessable User Account |
| `WSTG-CONF-04` | Review Old Backup and Unreferenced Files for Sensitive Information |
| `WSTG-CRYP-04` | Testing for Weak Encryption |
| `WSTG-BUSL-04` | Test for Process Timing |
| `WSTG-INPV-05` | Testing for SQL Injection |
| `WSTG-SESS-05` | Testing for Cross Site Request Forgery |
| `WSTG-CONF-05` | Enumerate Infrastructure and Application Admin Interfaces |
| `WSTG-BUSL-05` | Test Number of Times a Function Can Be Used Limits |
| `WSTG-INFO-05` | Review Webpage Content for Information Leakage |
| `WSTG-SESS-06` | Testing for Logout Functionality |
| `WSTG-BUSL-06` | Testing for the Circumvention of Work Flows |
| `WSTG-SESS-07` | Testing Session Timeout |
| `WSTG-CONF-07` | Test HTTP Strict Transport Security |
| `WSTG-INPV-07` | Testing for XML Injection |
| `WSTG-CLNT-07` | Testing Cross Origin Resource Sharing |
| `WSTG-BUSL-07` | Test Defenses Against Application Misuse |
| `WSTG-BUSL-08` | Test Upload of Unexpected File Types |
| `WSTG-ATHN-08` | Testing for Weak Security Question Answer |
| `WSTG-BUSL-09` | Test Upload of Malicious Files |
| `WSTG-CLNT-09` | Testing for Clickjacking |
| `WSTG-ATHN-09` | Testing for Weak Password Change or Reset Functionalities |
| `WSTG-CONF-09` | Test File Permission |
| `WSTG-CONF-11` | Test Cloud Storage |
| `WSTG-INPV-12` | Testing for Command Injection |
| `WSTG-INPV-18` | Testing for Server-side Template Injection |
| `WSTG-INPV-19` | Testing for Server-Side Request Forgery |

### ATT&CK Enterprise v20.0

| Técnica | Nome oficial |
| --- | --- |
| `T1046` | Network Service Discovery |
| `T1053` | Scheduled Task/Job |
| `T1059` | Command and Scripting Interpreter |
| `T1068` | Exploitation for Privilege Escalation |
| `T1070` | Indicator Removal |
| `T1078` | Valid Accounts |
| `T1110` | Brute Force |
| `T1110.001` | Password Guessing |
| `T1110.004` | Credential Stuffing |
| `T1111` | Multi-Factor Authentication Interception |
| `T1190` | Exploit Public-Facing Application |
| `T1195.001` | Compromise Software Dependencies and Development Tools |
| `T1195.002` | Compromise Software Supply Chain |
| `T1490` | Inhibit System Recovery |
| `T1499` | Endpoint Denial of Service |
| `T1499.003` | Application Exhaustion Flood |
| `T1499.004` | Application or System Exploitation |
| `T1530` | Data from Cloud Storage |
| `T1539` | Steal Web Session Cookie |
| `T1543` | Create or Modify System Process |
| `T1550.004` | Web Session Cookie |
| `T1552.001` | Credentials In Files |
| `T1552.005` | Cloud Instance Metadata API |
| `T1557` | Adversary-in-the-Middle |
| `T1610` | Deploy Container |
| `T1611` | Escape to Host |
| `T1621` | Multi-Factor Authentication Request Generation |
| `T1685` | Disable or Modify Tools |

### ATLAS v2026.09

| Técnica | Nome oficial |
| --- | --- |
| `AML.T0010` | AI Supply Chain Compromise |
| `AML.T0018` | Manipulate AI Model |
| `AML.T0020` | Poison Training Data |
| `AML.T0051` | LLM Prompt Injection |
| `AML.T0053` | AI Agent Tool Invocation |
| `AML.T0057` | LLM Data Leakage |
