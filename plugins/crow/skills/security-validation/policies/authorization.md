# Autorização

Nenhum teste dinâmico roda sem escopo autorizado. A análise estática pode
seguir dentro das permissões concedidas, mesmo sem autorização dinâmica.

## O que é análise estática aqui

Ler o que já está disponível sem tocar em nenhum sistema em execução: código,
configuração, manifestos, lockfiles, infraestrutura como código, workflows,
documentação. Rodar ferramentas locais de leitura (SAST, SCA, secret scanning)
sobre esses arquivos também é estático.

Analisar o histórico do repositório só com autorização explícita: o histórico
pode conter segredos e dados de outras pessoas.

## O que exige autorização dinâmica

Qualquer interação com um sistema em execução: requisições HTTP de teste,
login com contas de teste, upload de arquivo de amostra, varredura de portas,
teste de carga, restauração de backup, chamada a API administrativa de nuvem.

## Registro da autorização

Antes do primeiro teste dinâmico, registrar no relatório, na seção
**Identificação**, com a resposta dele, nunca com uma suposição:

| Item | Exemplo |
| --- | --- |
| Quem autorizou | Caique, em 2026-10-15 |
| Alvos | `https://homolog.exemplo.com.br`, API `v2` |
| Ambiente | homologação |
| Janela | 2026-10-15, das 14h às 18h |
| Identidades de teste | `teste-vendedor`, `teste-admin` (credenciais fora do relatório) |
| Testes permitidos | autenticação, autorização, upload, headers |
| Testes proibidos | carga, qualquer coisa contra produção |
| Critério de parada | qualquer erro 5xx inesperado, ou pedido dele |

O que não estiver listado não está autorizado.

## Regras

- **Produção nunca é alvo padrão.** Só com autorização explícita para aquele
  alvo, aquela janela e aqueles testes.
- **Sistemas de terceiros nunca são alvo** sem autorização explícita do
  dono — inclusive APIs externas que o sistema consome e serviços de nuvem
  fora da conta autorizada.
- **Autorização não se estende.** Autorização para homologação não vale para
  produção; autorização de hoje não vale amanhã; autorização para um host não
  vale para os vizinhos dele.
- **Contas e dados de teste.** Nunca usar conta ou dado real de terceiros como
  carga ou alvo de teste.
- **Na dúvida, não testa.** Registrar a regra como `NOT_TESTED` com o motivo
  "escopo dinâmico não autorizado" e propor o teste controlado.
