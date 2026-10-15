# Fase 5 — Correlação e triagem de falsos positivos

## Correlacionar

Para cada achado:

1. Associar a regra canônica.
2. Correlacionar resultados de ferramentas diferentes.
3. Identificar o ativo e o fluxo de dados afetado.
4. Verificar se existe evidência suficiente.
5. Separar causa raiz de sintomas.
6. Identificar controles compensatórios.
7. Remover duplicatas sem perder evidências.
8. Determinar status, severidade, confiança e prioridade.

## Evidência mínima

Todo achado tem pelo menos:

- regra identificada;
- ativo afetado;
- método de detecção;
- evidência técnica suficiente;
- justificativa do risco;
- limitações conhecidas;
- recomendação.

Com código-fonte, incluir arquivo e linha sempre que possível. Nunca incluir
tokens, senhas ou dados pessoais.

## Triagem

1. Confirmar se o ativo está no escopo.
2. Verificar se o código ou configuração realmente está ativo (não é código
   morto, exemplo, teste ou configuração de outro ambiente).
3. Rastrear origem, transformação e destino dos dados.
4. Avaliar autenticação, autorização e controles compensatórios.
5. Reproduzir de forma segura, quando autorizado.
6. Registrar o motivo da confirmação ou do descarte.
7. Manter o histórico da decisão.

Consultar o `false_positive_guidance` da regra em todo achado. Um achado
cuja triagem não terminou fica com `false_positive_review.status: pending` e
não entra como `FAIL` confirmado.

## Supressões

Uma supressão precisa conter:

- identificador da regra;
- ativo ou caminho específico;
- justificativa técnica;
- responsável pela aprovação;
- data de aprovação;
- prazo de validade;
- risco residual;
- evidência associada.

Não aceitar supressões globais sem justificativa. Não transformar uma
supressão em aprovação de segurança: o estado é `SUPPRESSED`, nunca `PASS`.
Quando a exceção expirar, reavaliar o controle.

A skill **não aprova supressões**. Ela registra a que ele aprovar, com os
campos acima, e lembra quando expira.

## Erros

Se uma ferramenta falhar, retornar `ERROR`, registrar a causa e informar os
controles afetados. Uma execução interrompida nunca é interpretada como
ausência de vulnerabilidades.
