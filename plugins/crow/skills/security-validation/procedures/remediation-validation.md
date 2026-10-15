# Fases 6 e 7 — Correção e revalidação

## Fase 6 — Recomendar correção

Cada recomendação inclui:

- causa raiz;
- arquivo, configuração ou componente afetado;
- ação corretiva;
- controles preventivos e detectivos relevantes;
- teste de regressão;
- risco residual;
- critério de encerramento.

Correção proporcional ao risco: a menor mudança que fecha a causa raiz, não
uma reescrita. Uma reestruturação maior, quando parecer necessária, é
proposta a ele com o motivo — não feita.

**A skill recomenda; não altera o sistema por conta própria.** Aplicar uma
correção é uma tarefa separada, que só começa quando ele pedir, e segue as
convenções dele (`$crow:conventions`): branch própria, commit `fix:` por
correção, teste de regressão, nunca coautoria.

Nunca afirmar que uma correção foi aplicada se a skill apenas a recomendou.

## Fase 7 — Revalidar

Depois que uma correção existir:

1. Reexecutar a regra original, com o mesmo método e a mesma evidência de
   antes.
2. Executar testes de regressão relacionados.
3. Verificar se a mudança não criou novas falhas, inclusive em regras
   relacionadas (`related_controls`).
4. Registrar o resultado anterior e o posterior no achado (`revalidation`).
5. Encerrar o achado somente com evidência de correção ou exceção aprovada.

A revalidação não introduz alterações no sistema: ela só observa. Se for
preciso mudar algo para conseguir revalidar, perguntar antes.
