# IoT e OT

Nenhuma regra do conjunto mínimo obrigatório cobre esta família.
`SV-IOT-0001` e `SV-OT-0001` foram escritas para ela.

Sistemas industriais e embarcados têm uma particularidade que muda o método:
um teste ativo inofensivo para um servidor web pode **parar uma máquina**. Por
isso as duas regras abaixo são de revisão manual e de configuração por
padrão, e todo teste ativo exige janela de manutenção e autorização
específica do responsável pela operação.

---

## SV-IOT-0001 — Firmware e interfaces administrativas de dispositivos

```yaml
id: SV-IOT-0001
canonical_name: Device Firmware and Administrative Interfaces
display_name_pt_br: Firmware e interfaces administrativas de dispositivos
aliases: [IoT, firmware, credenciais padrão de fábrica, interface de depuração, UART, JTAG, atualização OTA]
category: IOT.DEVICE_SECURITY
description: >
  Verifica credenciais padrão, interfaces administrativas e de depuração
  expostas, e se o firmware pode ser atualizado com integridade verificada.
scope:
  asset_types: [iot_device]
methods: [configuration_review, manual_review]
references:
  cwe: [CWE-1188, CWE-798, CWE-1277, CWE-494]
  asvs: []
  wstg: []
  attack: []
  note: ASVS e WSTG não cobrem dispositivos; a verificação segue a documentação do fabricante e a política da organização.
severity_default: high
confidence_threshold: medium
preconditions:
  - Existe dispositivo embarcado ou IoT no escopo, com documentação ou acesso à sua configuração.
pass_criteria:
  - Credenciais de fábrica são trocadas antes da operação ou são únicas por dispositivo.
  - Interfaces administrativas exigem autenticação e não ficam expostas além da rede de gerenciamento.
  - Interfaces de depuração estão desabilitadas em produção.
  - O firmware pode ser atualizado e as atualizações têm integridade e origem verificadas.
fail_criteria:
  - Uma credencial padrão documentada dá acesso administrativo, comprovado em dispositivo de teste.
  - Uma interface administrativa é acessível sem autenticação.
  - O dispositivo aceita firmware sem verificar integridade ou origem.
inconclusive_criteria:
  - Não há dispositivo de teste e o de produção não pode ser tocado.
  - A documentação do fabricante não descreve o mecanismo de atualização.
false_positive_guidance:
  - Interface administrativa acessível só na rede de gerenciamento isolada pode ser decisão legítima.
  - Firmware antigo não prova vulnerabilidade específica; confirmar CVEs aplicáveis à versão.
  - Nunca testar credenciais em dispositivo de produção; usar dispositivo de teste.
remediation:
  - Exigir troca de credenciais no comissionamento.
  - Desabilitar interfaces de depuração e restringir a administrativa à rede de gerenciamento.
  - Adotar atualização assinada e um processo de atualização periódica.
requires_authorization: true
safe_by_default: true
manual_review_required: true
related_controls: [SV-OT-0001, SV-NET-0001, SV-CRY-0001]
duplicate_of: null
```

Métodos: revisão de configuração e documentação, com teste ativo só em dispositivo de teste.

**Aprovar quando:**
- Credenciais de fábrica são trocadas antes da operação ou são únicas por dispositivo.
- Interfaces administrativas exigem autenticação e não ficam expostas além da rede de gerenciamento.
- Interfaces de depuração estão desabilitadas em produção.
- O firmware pode ser atualizado e as atualizações têm integridade e origem verificadas.

**Reprovar quando:**
- Uma credencial padrão documentada dá acesso administrativo, comprovado em dispositivo de teste.
- Uma interface administrativa é acessível sem autenticação.
- O dispositivo aceita firmware sem verificar integridade ou origem.

**Falsos positivos:**
- Interface administrativa acessível só na rede de gerenciamento isolada pode ser decisão legítima.
- Firmware antigo não prova vulnerabilidade específica; confirmar CVEs aplicáveis à versão.
- Nunca testar credenciais em dispositivo de produção.

---

## SV-OT-0001 — Protocolos industriais e segmentação

```yaml
id: SV-OT-0001
canonical_name: Industrial Protocols and Segmentation
display_name_pt_br: Protocolos industriais e segmentação
aliases: [OT, ICS, SCADA, Modbus, DNP3, OPC UA, PLC, CLP, rede industrial]
category: OT.INDUSTRIAL_SECURITY
description: >
  Verifica se a rede industrial é separada da corporativa, se funções
  críticas de controle exigem autenticação e se protocolos sem autenticação
  ficam restritos aos segmentos necessários.
scope:
  asset_types: [ot_system, network]
methods: [configuration_review, manual_review]
references:
  cwe: [CWE-306, CWE-319]
  asvs: []
  wstg: []
  attack: []
  note: Técnicas de OT são catalogadas no ATT&CK for ICS, matriz separada da Enterprise e não fixada nesta versão da skill.
severity_default: critical
confidence_threshold: medium
preconditions:
  - Existem CLPs, SCADA, IHMs ou outros sistemas de controle industrial no escopo.
pass_criteria:
  - A rede industrial é separada da corporativa, com fluxos entre elas explícitos e mínimos.
  - Funções críticas de controle exigem autenticação ou ficam acessíveis só a partir de estações autorizadas.
  - Protocolos sem autenticação nativa ficam restritos ao segmento que precisa deles.
  - Acesso remoto de fornecedores passa por ponto controlado e registrado.
fail_criteria:
  - Um protocolo de controle é alcançável a partir da rede corporativa ou da internet, comprovado por configuração ou teste passivo.
  - Um comando de controle é aceito sem autenticação a partir de origem não autorizada, comprovado em bancada.
inconclusive_criteria:
  - Não há diagrama de rede atualizado nem acesso à configuração dos firewalls.
  - Não há bancada de teste e a planta não pode receber teste ativo.
false_positive_guidance:
  - Protocolo sem autenticação dentro de célula isolada pode ser aceitável pela política.
  - Tráfego visto em captura passiva não comprova que comandos sejam aceitos.
  - Nunca enviar comandos ou varreduras ativas a equipamentos em operação.
remediation:
  - Segmentar por zonas e conduítes, com firewall entre corporativo e industrial.
  - Restringir quem fala com os controladores e registrar o acesso remoto.
  - Usar versões autenticadas dos protocolos quando o equipamento suportar.
requires_authorization: true
safe_by_default: true
manual_review_required: true
related_controls: [SV-IOT-0001, SV-NET-0001]
duplicate_of: null
```

Métodos: revisão de arquitetura e configuração de rede, captura passiva autorizada e teste ativo só em bancada.

**Aprovar quando:**
- A rede industrial é separada da corporativa, com fluxos entre elas explícitos e mínimos.
- Funções críticas de controle exigem autenticação ou ficam acessíveis só a partir de estações autorizadas.
- Protocolos sem autenticação nativa ficam restritos ao segmento que precisa deles.
- Acesso remoto de fornecedores passa por ponto controlado e registrado.

**Reprovar quando:**
- Um protocolo de controle é alcançável a partir da rede corporativa ou da internet, comprovado por configuração ou teste passivo.
- Um comando de controle é aceito sem autenticação a partir de origem não autorizada, comprovado em bancada.

**Falsos positivos:**
- Protocolo sem autenticação dentro de célula isolada pode ser aceitável pela política.
- Tráfego visto em captura passiva não comprova que comandos sejam aceitos.
- Nunca enviar comandos ou varreduras ativas a equipamentos em operação.
