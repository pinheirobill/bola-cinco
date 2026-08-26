# Bola Cinco - Fase 5: Operação e Gestão

## Objetivo

Padronizar as telas operacionais que ainda estão mais cruas e manter o mesmo vocabulário visual do restante do sistema.

Esta fase cobre os módulos que aparecem na operação diária:

- relatórios de jogo
- eventos de jogo
- suspensões
- seleções de rodada
- locais
- árbitros
- notícias
- parceiros
- financeiro
- categorias

## Leitura de UX

O risco aqui não é funcional. É consistência.

Se cada módulo ganhar um layout próprio, o usuário precisa reaprender a interface a cada tela. A fase 5 existe para evitar isso.

## Padrões que já podem ser reaproveitados

- `PageHeader`
- `SurfaceCard`
- `StatsGrid`
- `EmptyState`
- `StatusBadge`
- `MatchCard`
- `TeamCard`
- `AthleteCard`
- `StandingTable`

## Diretrizes de construção

1. Listagens densas devem usar `table`.
2. Formulários de criação/edição devem ficar dentro de `SurfaceCard`.
3. Quando houver contexto pai claro, o título precisa mostrar esse contexto.
4. Se a página mistura lista e formulário, separar visualmente em duas colunas.
5. Se o módulo pode ser consultado sem login, a ação de escrita precisa ficar condicionada.

## Ordem prática

### 1. Consolidação visual

- categorias
- financeiro
- locais
- árbitros

### 2. Consolidação operacional

- eventos de jogo
- relatórios de jogo
- suspensões
- seleções de rodada

### 3. Consolidação editorial

- notícias
- parceiros

## Critério de saída da fase

A fase 5 termina quando os módulos operacionais estiverem com:

- cabeçalhos padronizados
- cards reaproveitáveis
- formulários consistentes
- feedback de status coerente
- ausência de layouts soltos e isolados

## Próximo passo

Abrir a fase 6 para polimento final e revisão de consistência.
