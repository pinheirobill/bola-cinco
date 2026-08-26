# Bola Cinco - Fase 2: Arquitetura de Informação e Fluxos

## Objetivo

Definir como o usuário navega pelo sistema antes de criar componentes novos.

Esta fase organiza:

- navegação global
- hierarquia das telas
- fluxos por perfil
- prioridade de construção
- pontos de reutilização para a fase 3

## Princípio central

O `Championship` é o contexto principal.

Quase todas as telas devem responder a uma pergunta simples:

- este conteúdo pertence a qual campeonato?

Se a resposta não estiver clara, a tela precisa explicitar o campeonato no topo ou no filtro.

## Perfis de uso

### Público

- consulta campeonatos
- consulta classificação
- consulta jogos
- consulta times
- consulta atletas
- consulta notícias

### Administrador

- gerencia campeonato
- ajusta formato e regras
- acompanha times e atletas
- acompanha jogos e relatórios
- acompanha disciplina e financeiro

### Gestor de time

- vê times e atletas do seu contexto
- acompanha calendário
- acompanha status de inscrição e financeiro
- acompanha jogos e punições

### Leitor

- consulta dados publicados
- navega sem ações críticas

## Estrutura global

### Camada pública

1. Portal
2. Lista de campeonatos
3. Detalhe do campeonato
4. Classificação
5. Jogos
6. Times
7. Atletas
8. Notícias

### Camada autenticada

1. Dashboard
2. Campeonato ativo
3. Operação esportiva
4. Financeiro
5. Disciplina
6. Comunicação
7. Cadastros auxiliares

## Fluxo principal por perfil

### Público

Portal -> campeonato -> classificação / jogos / times / atletas -> detalhe

### Administrador

Dashboard -> campeonato ativo -> wizard do campeonato -> gestão operacional

### Gestor de time

Portal autenticado -> painel do time -> atletas -> jogos -> status do elenco

## Navegação sugerida

### Menu principal

- Portal
- Dashboard
- Campeonatos
- Classificação
- Jogos
- Times
- Atletas
- Financeiro
- Disciplina
- Comunicação

### Submenu do campeonato

- Dados
- Formato e regras
- Equipes
- Classificação
- Jogos
- Relatórios
- Suspensões
- Rodadas

### Submenu do time

- Resumo
- Atletas
- Jogos
- Financeiro
- Histórico

## Hierarquia de telas

### Tela de visão geral

Mostra o estado do sistema em alto nível.

Exemplos:

- portal
- dashboard
- visão do campeonato

### Tela de listagem

Mostra coleção de registros.

Exemplos:

- campeonatos
- times
- atletas
- jogos
- suspensões
- notícias

### Tela de detalhe

Mostra um registro com contexto operacional.

Exemplos:

- campeonato
- time
- atleta
- jogo
- entidade

### Tela de formulário

Edita dados de um registro ou de um fluxo.

Exemplos:

- cadastro de campeonato
- cadastro de time
- cadastro de atleta
- relatório de jogo

## Padrões de layout

### Padrão A - Visão geral

- hero ou header forte
- estatísticas
- cards de destaque
- listas curtas de recentes

Uso:

- portal
- dashboard
- detalhe de campeonato

### Padrão B - Listagem densa

- título
- descrição curta
- tabela
- ações por linha

Uso:

- jogos
- equipes
- atletas
- entidades

### Padrão C - Detalhe operacional

- cabeçalho com nome e status
- métricas rápidas
- seções por área
- blocos laterais de apoio

Uso:

- time
- jogo
- campeonato

### Padrão D - Wizard

- steps
- formulário principal
- resumo lateral

Uso:

- campeonato
- futuros fluxos de cadastro complexo

## Decisões de navegação

- Não misturar visão pública com administração na mesma página sem separação visual clara.
- Não criar submenu solto se o contexto principal já resolver a navegação.
- Se o fluxo tiver mais de 3 estados, usar `steps` ou `tabs`.
- Se o usuário precisar comparar vários registros, usar tabela.
- Se o usuário precisar decidir rapidamente, usar cards resumidos.

## Oportunidades de componente

### Shell

- navbar global
- sidebar
- breadcrumb
- page header

### Listagem

- table wrapper
- empty state
- filter bar
- pagination bar

### Resumo

- stat card
- status badge
- section card

### Domínio

- championship header
- championship stepper
- team summary card
- athlete summary card
- match summary card

## Ordem de construção

### Fase 2

Fechar IA e fluxo.

### Fase 3

Extrair componentes base.

### Fase 4

Padronizar telas núcleo.

### Fase 5

Padronizar módulos operacionais.

### Fase 6

Polimento visual e consistência.

## Critério de saída da fase 2

A fase 2 termina quando existir:

- mapa de navegação aprovado
- hierarquia das telas definida
- prioridade dos módulos clara
- lista objetiva de componentes para a fase 3

## Próximo passo

Abrir a fase 3 e começar a montar a biblioteca base de componentes com daisyUI.
