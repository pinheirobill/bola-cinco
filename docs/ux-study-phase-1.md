# Bola Cinco - Fase 1: Estudo de UX e Arquitetura de Telas

## Objetivo

Esta fase não implementa telas novas. O objetivo é entender o sistema, organizar o domínio em experiências de uso e definir a base para construir interfaces com daisyUI e componentes reutilizáveis, evitando recriação de código.

## Leitura do sistema

O produto está estruturado em dois contextos:

1. **Portal público**
   - visão geral do campeonato
   - classificação
   - jogos
   - times
   - atletas
   - notícias e destaques

2. **Área autenticada**
   - dashboard operacional
   - gestão de campeonatos
   - equipes e atletas
   - jogos, eventos e relatórios
   - disciplina e suspensões
   - financeiro
   - parceiros e comunicação

O campeonato é a unidade central de navegação. Quase tudo depende de `Championship` como contexto pai.

## Mapa funcional do domínio

### Núcleo

- `Championship`
- `Category`
- `StandingRow`

### Operação esportiva

- `Team`
- `Athlete`
- `Match`
- `MatchEvent`
- `MatchReport`
- `Suspension`
- `RoundSelection`

### Gestão administrativa

- `Entity`
- `Invoice`
- `Venue`
- `Referee`
- `Partner`
- `NewsItem`

### Acesso e colaboração

- `User`
- `TeamMembership`
- `ChampionshipMembership`

## Inventário de telas existente

### Público

- Portal inicial
- Lista de campeonatos
- Detalhe do campeonato
- Lista de jogos
- Detalhe de jogo
- Lista de equipes
- Detalhe de equipe
- Lista de atletas
- Detalhe de atleta
- Lista de entidades
- Detalhe de entidade

### Interno

- Dashboard
- Wizard do campeonato
  - dados
  - formato e regras
  - equipes
- Financeiro
- Classificação
- Páginas de gestão já previstas nas rotas
  - venues
  - referees
  - news_items
  - partners
  - match_reports
  - match_events
  - suspensions
  - round_selections
  - championship_memberships
  - team_memberships
  - active_championship
  - championship_engagement

## Leitura de UX

### O que já está bom

- O sistema já usa linguagem visual compatível com daisyUI.
- Já existe uma estrutura de shell com navbar, sidebar, cards, tables e badges.
- O wizard de campeonato já indica um fluxo de configuração em etapas.

### O que falta consolidar

- Padronização de páginas de listagem.
- Padronização de páginas de detalhe.
- Padronização de formulários.
- Padronização de estados vazios.
- Padronização de feedback de status.
- Biblioteca base de componentes para evitar repetição.

## Padrão visual recomendado

Manter o que já existe como base:

- Tailwind CSS
- daisyUI
- cards com borda suave
- tables para dados densos
- badges para estados
- alerts para feedback
- steps para fluxos guiados

O sistema já está num bom ponto para virar um design system leve, pragmático e consistente.

## Biblioteca de componentes sugerida

### Shell

- `AppNavbar`
- `AppSidebar`
- `PageHeader`
- `PageSection`

### Estados e feedback

- `StatusBadge`
- `EmptyState`
- `AlertBlock`
- `LoadingSkeleton`

### Listagem e síntese

- `DataTable`
- `StatsGrid`
- `CardGrid`
- `FilterBar`

### Domínio

- `ChampionshipHero`
- `ChampionshipStepper`
- `TeamCard`
- `AthleteRow`
- `MatchCard`
- `StandingTable`
- `NewsCard`
- `PartnerCard`
- `SuspensionCard`
- `InvoiceCard`

### Ação e interação

- `ConfirmDialog`
- `DrawerForm`
- `SidePanel`
- `TabNavigation`

## Prioridade de construção

### Fase 2 - Arquitetura de informação

Definir a estrutura de navegação e os fluxos principais.

### Fase 3 - Biblioteca base

Criar os componentes reutilizáveis mais usados pela interface.

### Fase 4 - Telas núcleo

Construir ou padronizar:

- dashboard
- campeonato
- jogos
- times
- atletas

### Fase 5 - Operação e gestão

Construir ou padronizar:

- eventos de jogo
- relatório de jogo
- suspensões
- seleção de rodada
- financeiro
- parceiros
- notícias
- locais
- árbitros

### Fase 6 - Polimento

- acessibilidade
- responsividade
- consistência de estados
- microinterações úteis
- revisão final de densidade visual

## Regras de decisão

- Não criar componente se ele aparecer só uma vez.
- Se a mesma estrutura aparecer em 2 ou 3 telas, vira componente.
- Se o dado for denso, priorizar `table`.
- Se o dado for sintético, priorizar `card`.
- Se o usuário precisar executar fluxo, priorizar `steps`, `tabs` ou `drawer`.
- Se a tela depender de contexto do campeonato, ela deve receber esse contexto de forma explícita.

## Resultado esperado desta fase

Ao final da fase 1, o projeto deve ter:

- entendimento claro do domínio
- inventário das telas
- mapa das prioridades
- lista de componentes reutilizáveis
- estratégia de construção por fase

Isso evita retrabalho e permite desenhar as telas com uma lógica única para o sistema inteiro.
