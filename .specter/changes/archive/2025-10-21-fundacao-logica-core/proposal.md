# Proposal: Fundação e Lógica Core

## Intent
Estabelecer a base técnica do projeto com arquitetura limpa, configuração do banco de dados e estrutura de navegação.

## Scope
- Configuração do projeto Flutter e arquitetura (Clean Architecture: presentation/domain/data)
- Modelagem e configuração do banco de dados (5 entidades: Transaction, Account, RecurringExpense, Category, AppSettings)
- Implementação da camada de repositórios (interfaces + implementações)
- Navegação e shell do aplicativo (BottomNavigationBar com 3 abas)

## Approach
Projeto Flutter inicializado com Riverpod para state management e Isar como banco inicial (posteriormente migrado para Drift na Fase 2). Estrutura de pastas seguindo Clean Architecture desde o início.
