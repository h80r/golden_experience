# Proposal: Padronização e Melhorias de UX

## Intent
Padronizar a formatação de valores monetários e melhorar a experiência do usuário em inputs e seleções.

## Scope
- `CurrencyFormatter` utility para formatação monetária brasileira consistente (R$ 99.990,99) em todo o app
- Permitir seleção de datas futuras em transações
- Auto-capitalização (`TextCapitalization.sentences`) em todos os campos de texto
- Consistência visual de dropdowns com o design system dark

## Approach
Utility centralizado de formatação/parsing de moeda; ajustes pontuais em widgets de input existentes (date picker, text fields, `CustomDropdown`) para alinhamento visual e de comportamento.
