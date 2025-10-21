# Clean Architecture - Previsor Financeiro

Este projeto segue os princípios da **Clean Architecture** para garantir separação de responsabilidades, testabilidade e manutenibilidade do código.

## Estrutura de Pastas

```
lib/
├── core/                    # Funcionalidades compartilhadas
│   ├── constants/          # Constantes da aplicação
│   ├── errors/             # Definições de erros customizados
│   └── utils/              # Utilitários e helpers
│
├── data/                    # Camada de Dados (Frameworks & Drivers)
│   ├── datasources/        # Fontes de dados (Isar, API, etc)
│   ├── models/             # Modelos de dados com serialização
│   └── repositories/       # Implementações concretas dos repositórios
│
├── domain/                  # Camada de Domínio (Regras de Negócio)
│   ├── entities/           # Entidades puras do domínio
│   ├── repositories/       # Interfaces dos repositórios
│   └── usecases/           # Casos de uso da aplicação
│
├── presentation/            # Camada de Apresentação (UI)
│   ├── providers/          # Providers do Riverpod
│   ├── screens/            # Telas da aplicação
│   └── widgets/            # Widgets reutilizáveis
│
└── main.dart               # Entry point da aplicação
```

## Fluxo de Dados

```
Presentation (UI)
    ↓ (usa)
Providers (Riverpod)
    ↓ (chama)
Use Cases (Domain)
    ↓ (usa)
Repository Interfaces (Domain)
    ↑ (implementa)
Repository Implementations (Data)
    ↓ (usa)
Data Sources (Data)
    ↓ (acessa)
External (Isar Database, APIs)
```

## Camadas

### 1. Domain (Domínio)
- **Entidades**: Classes que representam os objetos de negócio
- **Repositórios (Interfaces)**: Contratos para acesso a dados
- **Use Cases**: Lógica de negócio da aplicação
- **Regra**: Esta camada não pode depender de nenhuma outra camada

### 2. Data (Dados)
- **Models**: Extensões das entidades com serialização
- **Repositories (Implementações)**: Implementação concreta das interfaces
- **Data Sources**: Acesso direto ao Isar, APIs, etc
- **Regra**: Depende apenas da camada Domain

### 3. Presentation (Apresentação)
- **Screens**: Páginas da aplicação
- **Widgets**: Componentes reutilizáveis
- **Providers**: Gerenciamento de estado com Riverpod
- **Regra**: Depende apenas da camada Domain

### 4. Core (Núcleo)
- **Constantes**: Valores fixos da aplicação
- **Errors**: Exceções customizadas
- **Utils**: Funções auxiliares
- **Regra**: Pode ser usado por todas as camadas

## Princípios

1. **Dependency Rule**: Dependências sempre apontam para dentro (Domain é o centro)
2. **Single Responsibility**: Cada classe tem uma única responsabilidade
3. **Interface Segregation**: Interfaces específicas e pequenas
4. **Dependency Inversion**: Dependa de abstrações, não de implementações

## Stack Tecnológica

- **Flutter**: Framework UI
- **Riverpod**: Gerenciamento de estado
- **Isar**: Banco de dados local
- **Build Runner**: Geração de código
