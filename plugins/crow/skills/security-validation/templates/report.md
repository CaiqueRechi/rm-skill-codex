# Template do relatório

Preencher em `docs/security/<AAAA-MM-DD>-<escopo>.md` no projeto avaliado.
Todas as seções ficam no relatório; uma seção sem conteúdo diz por quê.

A conclusão é baseada **exclusivamente** na cobertura e nas evidências. Nunca
escrever "sem vulnerabilidades", "sistema seguro" ou equivalente: escrever
quais controles foram verificados, por quais métodos e com quais limitações.

~~~~markdown
# Relatório de Validação de Segurança — <escopo>

## Identificação

- Execução: <AAAA-MM-DD-escopo>
- Data: <AAAA-MM-DD>
- Executado por: <id do agente>
- Escopo: <ativos avaliados>
- Ambiente: <desenvolvimento | homologação | produção>
- Versão da skill: crow <versão do plugin> · security-validation <versão do catálogo>
- Referências utilizadas: ASVS 5.0.0 · WSTG v4.2 · ATT&CK Enterprise v20.0 · CWE 4.20 · ATLAS v2026.09 · <CIS Benchmark e versão, se usado> · CISA KEV consultado em <data>
- Autorização dinâmica: <quem autorizou, alvos, janela, testes permitidos e proibidos — ou "não concedida: só análise estática">
- Limite de aceitação: <definido pelo responsável — ou "não definido: nenhuma falha aberta é aceita">

## Resumo

| | Quantidade |
| --- | --- |
| Ativos avaliados | |
| Regras aplicáveis | |
| Regras aprovadas (`PASS`) | |
| Regras reprovadas (`FAIL`) | |
| Regras inconclusivas (`INCONCLUSIVE`) | |
| Regras não testadas (`NOT_TESTED`) | |
| Regras não aplicáveis (`NOT_APPLICABLE`) | |
| Erros de execução (`ERROR`) | |
| Achados suprimidos (`SUPPRESSED`) | |

**Status global:** `PASS` | `FAIL` | `INCONCLUSIVE` — <uma linha com o motivo>

## Cobertura

- Análise estática: <o que foi lido e com que ferramentas>
- Testes dinâmicos: <o que foi testado, ou "não autorizado">
- Dependências: <manifestos e lockfiles analisados, base consultada>
- Configurações: <o que foi inspecionado>
- Áreas não avaliadas: <o que ficou de fora e por quê>

### Estado por regra

| Regra | Nome | Estado | Método | Observação |
| --- | --- | --- | --- | --- |

## Achados

### <FIND-0001> <título>

- Regra: <SV-…>
- Estado:
- Severidade:
- Confiança:
- Prioridade:
- Ativo:
- Evidência: <local, linha, passo — redigida>
- Impacto:
- Causa raiz:
- Referências: <CWE, ASVS, WSTG, ATT&CK — só os da regra ou verificados>
- Correção recomendada:
- Teste de regressão:
- Limitações:
- Revisão de falso positivo: <concluída | pendente> — <motivo>

## Exceções

| Regra | Ativo | Justificativa | Aprovado por | Em | Válido até | Risco residual |
| --- | --- | --- | --- | --- | --- | --- |

## Riscos residuais

- <riscos que permanecem após a avaliação>

## Conclusão

<Resultado baseado exclusivamente na cobertura e nas evidências. Quais
controles foram verificados, por quais métodos, com quais limitações. Se o
status global não é PASS, quais condições impediram a aprovação.>
~~~~

## Status global

- `PASS` somente quando todos os requisitos obrigatórios do escopo foram
  verificados e os critérios de aceitação foram satisfeitos.
- `FAIL` quando há falha aberta acima do limite de aceitação.
- `INCONCLUSIVE` nos demais casos — inclusive quando há regra aplicável
  `NOT_TESTED`, `ERROR` ou `INCONCLUSIVE`.
