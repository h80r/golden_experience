# Proposal: Segunda Iteração - UX e Refinamentos

## Intent
Melhorar a experiência do usuário com onboarding guiado, gestão completa de transações e padronização de inputs numéricos.

## Scope
- Welcome tour / onboarding inicial (5 telas: boas-vindas, configurações, conta padrão, categorias, conclusão)
- Listagem de transações com CRUD completo (filtros, swipe actions, edição/exclusão com reversão de saldo)
- Widget `CurrencyTextField` reutilizável para entrada monetária com vírgula, aplicado em todo o app

## Approach
Onboarding com package de introdução de slides, persistindo flag `hasCompletedOnboarding`. Nova tela de transações dedicada com filtros por período/conta/categoria. Padronização de inputs monetários brasileiros (vírgula decimal).
