# Fases 1 a 3 — alvo, ativos e análise estática

## Fase 1 — Identificar o alvo

Coletar, lendo primeiro e perguntando só o que não estiver escrito em
`CONTEXT.md`, `ARCHITECTURE.md`, `docs/requirements/` ou no código:

- tipo de ativo e ambiente;
- linguagens, frameworks e versões;
- arquitetura e integrações;
- identidades e níveis de privilégio disponíveis para teste;
- dados sensíveis envolvidos;
- requisitos de negócio e segurança;
- escopo autorizado (ver [policies/authorization.md](../policies/authorization.md));
- restrições operacionais;
- critérios de aceitação e de interrupção, incluindo o limite de aceitação
  (ver [policies/severity.md](../policies/severity.md)).

Se o escopo de um teste dinâmico não estiver autorizado, não executar o teste.
A análise estática continua dentro das permissões concedidas.

## Fase 2 — Descobrir os ativos

Inventariar e registrar no relatório, com o que **não pôde** ser inspecionado:

- código-fonte e configuração;
- rotas, endpoints e contratos de API;
- dependências e lockfiles;
- bancos, filas, caches e armazenamento;
- identidades, políticas e contas de serviço;
- containers, manifests e infraestrutura como código;
- pipelines, artefatos e registros;
- fluxos de dados sensíveis;
- componentes de IA e ferramentas conectadas.

Com o inventário, decidir para cada regra do catálogo se ela se aplica. Uma
regra só é `NOT_APPLICABLE` quando a ausência do componente foi **demonstrada**
("não há parser XML: nenhuma dependência nem chamada encontrada"), nunca
suposta.

## Fase 3 — Análise estática

Para cada regra aplicável:

1. Localizar as fontes de dados não confiáveis e os pontos onde chegam
   (consulta, comando, template, arquivo, saída HTML, requisição de saída).
2. Rastrear o caminho entre os dois e o que acontece no meio: validação,
   parametrização, codificação, autorização.
3. Comparar com `pass_criteria` e `fail_criteria` da regra.
4. Registrar o resultado como **achado candidato**, não como vulnerabilidade
   confirmada. A presença de um padrão suspeito não basta.

Verificações por tipo:

| Verificação | O que olhar |
| --- | --- |
| Padrões de código inseguros | concatenação em consultas e comandos, saídas cruas, `eval`, desserialização nativa |
| Dependências | lockfiles contra base de vulnerabilidades; CVEs no catálogo CISA KEV primeiro |
| Segredos | chaves, tokens e senhas no código, na configuração e — com autorização — no histórico |
| Configuração e IaC | debug em produção, headers, CORS, buckets, IAM, manifests |
| Permissões e políticas | papéis, políticas IAM, RBAC, permissões de workflow |
| Autorização e lógica de negócio | onde cada rota verifica quem pode o quê; onde o servidor recalcula valores |
| Artefatos | integridade e origem de pacotes, imagens e modelos |

## Ferramentas

Usar as ferramentas que **já existem** no ambiente ou no projeto (o
`composer audit`, o `npm audit`, um Semgrep ou Gitleaks já configurado).
Instalar uma ferramenta nova é uma alteração no ambiente dele: perguntar antes.

Resultado de ferramenta é **indício**, nunca prova absoluta. Todo alerta passa
pela triagem de [false-positive-triage.md](false-positive-triage.md) antes de
virar `FAIL`. Ferramenta que falha é `ERROR`, nunca "sem achados".
