# Severidade, confiança e prioridade

Três classificações diferentes, que não se substituem.

## Severidade

Níveis: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`, `INFORMATIONAL`.

`severity_default` de cada regra é o ponto de partida, não o resultado. A
severidade do achado considera:

- impacto sobre confidencialidade, integridade e disponibilidade;
- facilidade e condições de exploração;
- exposição do ativo;
- privilégios necessários;
- alcance e quantidade de dados afetados;
- existência de exploração conhecida, quando verificável;
- controles compensatórios;
- consequências de negócio e obrigações aplicáveis.

**CVSS.** Quando aplicável, registrar a versão e o vetor usados. Nunca
inventar pontuação CVSS nem atribuir severidade só pelo nome da
vulnerabilidade.

## Confiança

- `HIGH`: evidência direta e reproduzível.
- `MEDIUM`: indícios fortes, mas com alguma dependência de contexto.
- `LOW`: heurística ou sinal indireto ainda não confirmado.

Confiança não é severidade. Uma vulnerabilidade crítica pode ter baixa
confiança, e um achado de alta confiança pode ter baixo impacto.

`confidence_threshold` de cada regra é a confiança mínima para registrar
`FAIL`. Abaixo dela o achado é `INCONCLUSIVE`, com o que falta para confirmar.

## Prioridade de correção

Separada da severidade técnica.

| Prioridade | Quando |
| --- | --- |
| `P1` | exploração conhecida e ativa (por exemplo, CVE no catálogo CISA KEV) em ativo exposto, ou `CRITICAL` exposto |
| `P2` | `HIGH` exposto, ou `CRITICAL` não exposto |
| `P3` | `MEDIUM`, ou `HIGH` com controle compensatório efetivo |
| `P4` | `LOW` e `INFORMATIONAL` |

Uma vulnerabilidade explorada ativamente em um ativo exposto pode exigir
tratamento prioritário mesmo quando a pontuação técnica isolada não for a
maior. A tabela é o ponto de partida; o responsável pelo sistema pode
reordenar, e a decisão fica registrada.

## Limite de aceitação

O limite de aceitação — a partir de que severidade uma falha aberta impede a
aprovação global — é definido pelo **responsável pelo sistema**, não pela
skill. Perguntar e registrar no relatório. Sem limite definido, nenhuma falha
aberta é aceita.
