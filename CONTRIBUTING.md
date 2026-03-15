## Documentação Técnica — Task Radar

Este documento detalha as decisões de engenharia, os padrões de projeto aplicados e os princípios de SOLID que sustentam o Task Radar. O foco do desenvolvimento foi construir um sistema altamente desacoplado, testável e preparado para crescimento escalável.

## Arquitetura e Motivação

Este projeto segue o guia oficial de arquitetura Flutter com adaptação para o padrão MVVM, utilizando o BLoC como ViewModel, conforme os requisitos do desafio.

- Referência: https://docs.flutter.dev/app-architecture/guide
- Motivação: A escolha visa manter uma rigorosa separação de responsabilidades, garantir a previsibilidade de estado através de fluxos reativos e assegurar alta testabilidade das regras de negócio independentemente da interface.

## Padrões de Projeto (Design Patterns)

A aplicação de padrões de design foi fundamental para garantir que o código seja modular e fácil de manter.

#### Repository Pattern

- Abstrações: TaskRepository, AuthRepository, UserRepository.

- Implementação: As classes concretas residem na camada data/repositories.

- Benefício: Desacopla as regras de negócio dos detalhes de persistência ou rede, permitindo que a lógica de domínio permaneça agnóstica à fonte de dados.

#### Factory Method

- Uso: Implementado em Task.create para construção consistente de tarefas locais.

- Mapeamento: Centralizado em factories como fromDummyjson, fromSqliteRow e fromStorageJson.

- Benefício: Centraliza as regras de criação e conversão de entidades, facilitando a manutenção quando contratos de APIs externas ou esquemas de banco de dados mudam.

#### Adapter Pattern

- Componentes: HttpServiceAdapter, RequestAdapter, ResponseAdapter.

- Benefício: Padroniza a fronteira de comunicação HTTP. Isso reduz a dependência direta da UI ou das regras de negócio com bibliotecas de rede específicas (como Dio ou Http), facilitando trocas de infraestrutura com impacto mínimo.

#### Dependency Injection (DI)

- Ferramenta: get_it configurado no arquivo bindings.dart como Composition Root.

- Benefício: Injeção centralizada que permite o gerenciamento eficiente do ciclo de vida dos objetos e facilita o "swap" de dependências durante a execução de testes automatizados.

- Mediator Pattern

- Aplicação: Utilizado para gerenciar a comunicação entre diferentes módulos ou estados globais sem criar acoplamento direto entre eles.

- Benefício: Garante que os componentes permaneçam independentes e focados em suas próprias responsabilidades, delegando a coordenação para um mediador central.

#### Princípios SOLID

O sistema foi desenvolvido respeitando os princípios SOLID para garantir escalabilidade e desacoplamento:

## Roadmap de Melhorias

Para um ambiente de produção escalável, os seguintes pontos foram mapeados:

- Observabilidade: Integração com Firebase Crashlytics para monitoramento de falhas e logs em tempo real.

- CI/CD: Implementação de automação via Fastlane para padronizar o deploy e submissão para as lojas.

- Qualidade: Integração com SonarQube para análise estática de código e monitoramento de débitos técnicos.

- Segurança: Implementação de SSL Pinning em cenários de API restrita para mitigar ataques de Man-in-the-Middle.

## Execução do Projeto

Siga os comandos abaixo para configurar e executar o ambiente localmente:

Setup Inicial
Instalar Dependências: flutter pub get
Gerar Código (DI e Mocks):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Execução do App
Rodar com variáveis de ambiente: 
```bash 
flutter run --dart-define-from-file=env.json 
```

Execução de Testes
Validar regras e mapeamentos: 
```bash
flutter test -x integration

flutter test --coverage --dart-define-from-file=env.json --dart-define=LOGIN_USERNAME=emilys --dart-define=LOGIN_PASSWORD=emilyspass
```