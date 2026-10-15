# Testes seguros

## Nunca executar automaticamente

- Exploração destrutiva ou alteração de dados de produção.
- Testes de negação de serviço contra sistemas reais.
- Exclusão de dados, criptografia de arquivos ou interrupção de serviços.
- Persistência, instalação de backdoors ou evasão de controles de segurança.
- Extração de credenciais, dados pessoais ou informações confidenciais.
- Movimentação lateral ou execução de código em ativos não autorizados.
- Testes contra terceiros sem autorização explícita.
- Ações irreversíveis ou que possam afetar usuários reais.

Essas atividades não são necessárias para a validação padrão. Quando uma
hipótese de risco não puder ser confirmada com segurança, registrar a
limitação e propor um teste controlado em ambiente isolado.

## Como provar sem causar dano

A prova de uma falha é o **menor efeito observável e inofensivo** que
demonstra a condição. Nunca o efeito máximo.

| Para provar | Use | Nunca |
| --- | --- | --- |
| Injeção SQL | consulta que altera só o resultado de uma condição (verdadeiro/falso) | leitura de tabelas, `DROP`, `UPDATE` |
| Execução de comando | comando sem efeito colateral cuja saída ou atraso é observável | shell reverso, download de binário |
| SSRF | destino controlado por você que registra a chegada | serviço interno real, metadados de nuvem de produção |
| XSS | payload que só exibe um marcador | roubo de cookie, requisição a terceiros |
| Upload | arquivo de amostra inofensivo | webshell funcional |
| Path traversal | arquivo sabidamente público e inofensivo | arquivos de configuração com segredos |
| Autorização | registros criados pelas próprias contas de teste | registros de usuários reais |
| Disponibilidade | carga pequena, crescente, com parada no limite definido | estresse até cair |
| Credencial encontrada | registrar onde está, redigida | testar se funciona usando-a |

## Evidência

- Evidência sensível é sempre **redigida**: token, senha, chave, dado pessoal
  aparecem mascarados (`token: ****9f2a`), nunca inteiros.
- A evidência mostra o suficiente para reproduzir — local, condição, passo —
  e nada além disso.
- Dados obtidos por acidente durante um teste não são copiados para o
  relatório; registrar que o acesso foi possível e descartar o conteúdo.

## Parada

Parar imediatamente e avisar quando:

- um teste produz efeito maior que o esperado (erro 5xx inesperado, lentidão,
  dado alterado);
- um alvo responde e não estava no escopo;
- aparece dado real de terceiros;
- ele pede.

Registrar o que aconteceu no relatório, na regra afetada, como `ERROR` ou
`INCONCLUSIVE`, com o motivo.
