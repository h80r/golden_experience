# Proposal: Correções Críticas de UI/UX

## Intent
Corrigir bugs críticos de interface e comportamento que afetam a experiência do usuário no uso diário do aplicativo.

## Scope
- Reserve slider não deve "pular" ao carregar e deve salvar automaticamente
- Persistência do switch de captura automática de transações
- Bug de visualização do limite de crédito com valores decimais
- Símbolo R$ duplicado na criação/edição de transferências
- Valor do campo desaparecendo ao clicar em salvar na aba de notas
- Validação de valor obrigatório ao salvar transação

## Approach
Correções pontuais focadas em bugs reportados no uso diário: inicialização correta de estado, auto-save, parsing de valores decimais e validação de formulário.
