# Proposal: O Fluxo Crítico - Registro de Gasto

## Intent
Implementar o fluxo core do produto - o registro rápido de gastos com interface de calculadora e bottom sheet de detalhes.

## Scope
- UI da calculadora (overlay fullscreen) e bottom sheet de detalhes do gasto
- Estado (StateNotifier/Riverpod) para o formulário de registro
- Use case para adicionar transação, orquestrando persistência e atualização de saldo/limite
- Integração fim-a-fim: FAB → Calculadora → Bottom Sheet → Notifier → Use Case → Repository → Database

## Approach
Componentes reutilizáveis (PrimaryButton, SecondaryButton, CustomTextField, CustomDropdown) seguindo o design system. Nota: a calculadora overlay foi posteriormente removida na Fase 5 (F5-T3) em favor de um campo de input direto.
