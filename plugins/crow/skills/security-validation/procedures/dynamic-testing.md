# Fase 4 — Análise dinâmica

Só com escopo autorizado e registrado, conforme
[policies/authorization.md](../policies/authorization.md), e dentro de
[policies/safe-testing.md](../policies/safe-testing.md).

## Antes do primeiro teste

1. Confirmar que o alvo está na lista autorizada e que a janela está aberta.
2. Confirmar as identidades de teste. Credenciais nunca entram no relatório.
3. Definir, para cada teste, o efeito observável inofensivo que vai provar a
   hipótese e o critério de parada.

## O que testar

Executar apenas testes autorizados, com limites explícitos:

| Teste | Regras |
| --- | --- |
| Autenticação e sessão | `SV-APP-0004`, `SV-IDN-0002`, `SV-IDN-0003`, `SV-IDN-0004` |
| Autorização entre usuários e tenants de teste | `SV-APP-0003`, `SV-API-0001`, `SV-IDN-0001` |
| Entradas e saídas | `SV-APP-0001`, `SV-APP-0002`, `SV-APP-0010` a `SV-APP-0014` |
| Headers, cookies, TLS e CORS | `SV-APP-0009`, `SV-APP-0015`, `SV-APP-0016`, `SV-CRY-0001` |
| Upload com arquivos inofensivos | `SV-APP-0008`, `SV-APP-0017` |
| Exposição de endpoints | `SV-API-0001`, `SV-NET-0001` |
| Limites de recursos em carga controlada | `SV-RES-0001`, `SV-RES-0002`, `SV-BIZ-0002` |
| Invariantes e concorrência com dados fictícios | `SV-BIZ-0001` |
| Isolamento de agentes e ferramentas de IA | `SV-AI-0001` |

Não usar dados reais de terceiros como carga de teste. Não executar testes
destrutivos por padrão.

## Durante

- Uma hipótese por teste. Anotar requisição, resposta relevante (redigida) e
  conclusão.
- Testes de autorização sempre em pares: a mesma operação com a identidade
  dona e com a identidade sem direito. Sem o par, o resultado não diferencia
  "bloqueado" de "não existe".
- Resultado que não diferencia a hipótese de outras causas é `INCONCLUSIVE`,
  não `FAIL`.
- Ao atingir um critério de parada, parar e avisar.

## Depois

Cada resultado dinâmico entra na correlação da fase 5, junto com o achado
estático da mesma regra quando existir — os dois juntos valem mais que
qualquer um sozinho.
