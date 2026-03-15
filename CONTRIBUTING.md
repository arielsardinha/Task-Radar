## Documentação Técnica — Task Radar

Este documento detalha as decisões de engenharia, os padrões de projeto aplicados e os princípios de SOLID que sustentam o Task Radar. O foco do desenvolvimento foi construir um sistema altamente desacoplado, testável e preparado para crescimento escalável.

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

## Roadmap de Melhorias e Evolução Técnica

Considerando o escopo deste desafio técnico, algumas implementações de nível enterprise foram mapeadas para serem executadas em uma oportunidade com maior disponibilidade de tempo. Estas melhorias visam elevar o patamar de segurança, manutenibilidade e observabilidade da plataforma.

#### Segurança Avançada (Conformidade OWASP MASVS)

Para garantir a integridade dos dados e a proteção contra ameaças externas, o roadmap inclui:

- Proteção contra Engenharia Reversa: Implementação de ofuscação de código (R8/ProGuard) e técnicas de Anti-Tampering para dificultar a descompilação.
FreeRasp (https://pub.dev/packages/freerasp)

- Detecção de Root e Jailbreak: Adição de camadas de verificação para impedir a execução do app em dispositivos comprometidos.
Firebase APP Check (https://firebase.google.com/docs/app-check?hl=pt-br)
safe_device (https://gemini.google.com/app/5c5039e221210e5b?hl=pt-BR)

- Firebase App Check: Proteção dos recursos de backend garantindo que apenas instâncias legítimas do aplicativo acessem a API.

- Autenticação Biométrica: Integração com Local Authentication (digital/FaceID) para reforçar a segurança do acesso local. Uma opção é o uso da biblioteca: 
local_auth (https://pub.dev/packages/local_auth)


- SSL Pinning: Embora não aplicável em APIs públicas abertas, em um ambiente restrito seria implementada a validação de certificados para mitigar ataques de Man-in-the-Middle (MitM). Uma sugestão é o uso do http_certificate_pinning (https://pub.dev/packages/http_certificate_pinning)

#### Refinamentos Arquiteturais

Para reduzir ainda mais a complexidade e aumentar o desacoplamento:

- Gateway Pattern: Migração da lógica de comunicação direta com APIs externas para Gateways especializados. Isso isola completamente a infraestrutura de rede, permitindo que os Repositories lidem apenas com modelos de domínio e regras de negócio puras.

- Desacoplamento do AuthInterceptor: Refatoração para que o interceptor dependa de uma abstração de gerenciamento de tokens, removendo qualquer acoplamento direto com repositórios de autenticação.

- Microsoft Clarity: Integração para análise de comportamento do usuário através de mapas de calor e gravações de sessão, permitindo melhorias contínuas baseadas em dados reais de uso.

- Firebase Crashlytics: Monitoramento avançado de falhas, com logs customizados e rastreio de estados que precedem um crash.

- Elevação da Cobertura: Expansão da suíte de testes para atingir >90% de cobertura..

- SonarQube: Integração no pipeline para análise estática contínua, detecção de code smells, vulnerabilidades e monitoramento rigoroso de débitos técnicos.

- CI/CD com Fastlane: Automação completa do ciclo de vida, desde a execução de testes e linting até o deploy automatizado para ambientes de staging e lojas (TestFlight/Play Store).