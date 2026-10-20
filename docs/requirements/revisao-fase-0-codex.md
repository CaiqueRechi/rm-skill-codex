# Revisão do codex-crow — Fase 0

| | |
| --- | --- |
| Data | 2026-10-20 |
| Solicitante | Caique Rechi Mehret |
| Cobertura | 100% — 0 decisões em aberto |
| Status | Implementado |

## 1. Objetivo

Aplicar à edição Codex as correções da Fase 0 já entregues no `claude-crow`,
sem alterar as adaptações próprias da plataforma: chamadas `$crow:...`,
metadados em `agents/openai.yaml` e empacotamento PowerShell.

O escopo inclui a identidade canônica `codex-crow`, instruções de migração, a
política única de downloads e instalações, validações negativas no CI e a
versão 2.1.0. O teste de referências externas do projeto Claude não tem
equivalente neste repositório e, portanto, não foi criado artificialmente.

## 2. Regras de negócio

### RN-01 — Identidade canônica

O repositório e o marketplace se chamam `codex-crow`; o plugin continua
`crow`. As tags continuam no formato `crow-vX.Y.Z`.

### RN-02 — Nome aposentado apenas no histórico

`rm-skill-codex` só pode aparecer nas seções de migração do README, neste
documento, na rastreabilidade, no histórico de testes e na própria regra que
faz essa validação.

### RN-03 — Migração explícita

Quem já usa o marketplace antigo remove a referência, adiciona
`CaiqueRechi/codex-crow`, instala `crow@codex-crow` e abre uma nova conversa.

### RN-04 — Consentimento para downloads e instalações

- Imagens com versão fixa e lockfiles já declarados pelo projeto são listados
  antes do primeiro download e recebem uma única autorização para a lista.
- Dependência, imagem, versão, Dockerfile, ferramenta ou download novo pede
  autorização individual, com versão, origem, motivo e alternativa.
- Uma recusa permanece válida; a skill segue sem o item ou registra o bloqueio.

### RN-05 — Uma fonte literal para a política

O texto mora em `.github/installation-policy.md`, aparece palavra por palavra
em `develop` e `build`, e é conferido pelo empacotamento.

## 3. Requisitos funcionais

### RF-01 — Renomear marketplace e referências ativas

Atualizar marketplace, manifesto, README, links, caminhos de release e a
referência ao repositório-fonte `claude-crow`.

### RF-02 — Documentar a migração

Adicionar os comandos para remover o marketplace anterior, adicionar o novo,
reinstalar o plugin e recarregar as skills em uma nova conversa.

### RF-03 — Recusar o nome antigo fora do histórico

O empacotamento percorre os arquivos rastreados e falha com arquivo e linha
quando encontra o nome aposentado em uso ativo.

### RF-04 — Compartilhar a política

Substituir a regra antiga de `develop`, inserir o mesmo bloco em `build` e
ajustar o fluxo de `build up` para pedir a autorização antes dos downloads.

### RF-05 — Validar e empacotar a política

O CI falha se uma das skills divergir e inclui a fonte da política no ZIP.

### RF-06 — Publicar a versão 2.1.0

`VERSION`, manifesto, exemplos de release e documentação devem concordar.

## 4. Critérios de aceite

- As seis skills passam no validador de skills do Codex.
- O plugin e o marketplace passam nos validadores do Codex.
- O pacote `crow-v2.1.0.zip` contém marketplace, manifesto e política.
- Uma divergência plantada na política é rejeitada.
- Um uso ativo plantado de `rm-skill-codex` é rejeitado com arquivo e linha.
- A instalação remota por `CaiqueRechi/codex-crow` fica pendente até o rename
  do repositório no GitHub e o merge desta branch.

## 5. Fora do escopo

- Renomear o repositório no GitHub.
- Alterações de consumo de tokens além da Fase 0.
- Portar melhorias posteriores de ambiente da skill `build` que não fazem
  parte desta política.

## 6. Decisões em aberto

Nenhuma.
