# Handoff

> Salvo em {{AAAA-MM-DD HH:MM}} por {{ID_DO_AGENTE}}. Substituído a cada
> `$crow:context save`. Fora do git.

## Onde parou

*Uma a três linhas: o que estava sendo feito no momento em que a sessão parou.*

## Próxima ação

*Uma ação só, concreta o bastante para começar sem perguntar nada. Ex.:
"escrever o teste de `ShipmentScheduler::reschedule` para data no passado em
`tests/Unit/ShipmentSchedulerTest.php`".*

## Estado do repositório

- Branch: `{{BRANCH}}`
- Último commit: `{{HASH}} {{MENSAGEM}}`
- Arquivos não commitados:

```
{{git status --short}}
```

## Perguntas em aberto

*O que depende de decisão do Caique, e de quem mais.*

## Para retomar

```bash
# comandos para voltar ao ponto: subir ambiente, rodar o teste que estava falhando…
```

## Skill em andamento

*Vazio quando nenhuma. Numa entrevista do `$crow:analyst`: cada item da
checklist com seu estado (aberto, inferido, respondido, não se aplica,
adiado) e as respostas dadas até aqui. Numa fase do `$crow:develop`: documento,
fase, branch, cada `RF` da fase com seu estado (feito, em andamento, a fazer,
bloqueado) e o próximo `RF`. Numa validação do `$crow:security-validation`: fase
atual, escopo autorizado, regras já executadas com seus estados.*
