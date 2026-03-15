# CONTRIBUTING

## O que entregar

1. Codigo-fonte completo do projeto Flutter commitado na branch `main`.
2. Documentacao neste arquivo com:
   - Arquitetura escolhida e justificativa.
   - Explicacao da estrutura de pastas.
   - Instrucoes para build e execucao.
   - Motivacoes para mudancas de design.
   - Boas praticas e padroes utilizados.

---

## 1) Arquitetura escolhida e justificativa

Este projeto segue o guia oficial de arquitetura Flutter com adaptacao para **MVVM**, usando **BLoC como ViewModel**, conforme requisito do desafio:

- Referencia: https://docs.flutter.dev/app-architecture/guide
- Motivacao: manter separacao de responsabilidades, previsibilidade de estado e alta testabilidade.

### Mapeamento MVVM no projeto

- **View**
  - Widgets e telas em `lib/modules/**`.
  - Ex.: `LoginScreen`, `HomeScreen`, `TasksScreen`, `ProfileScreen`, `UsersScreen`.

- **ViewModel (BLoC)**
  - Blocs, eventos e estados em `lib/modules/**/bloc`.
  - Ex.: `LoginBloc`, `HomeBloc`, `TasksBloc`, `ProfileBloc`, `UsersBloc`.
  - Responsavel por orquestrar fluxo de estado, regras de apresentacao e chamadas para a camada de dados.

- **Model**
  - Entidades de dominio em `lib/domain` (`Task`, `User`).
  - Repositorios e fontes de dados em `lib/data`.
  - Persistencia local via SQLite e secure storage.

### Por que essa arquitetura foi escolhida

1. **Escalabilidade**: novos modulos podem ser adicionados mantendo o mesmo padrao de organizacao.
2. **Testabilidade**: BLoCs e repositorios podem ser testados isoladamente com mocks.
3. **Baixo acoplamento**: UI nao conhece detalhes de HTTP/SQLite.
4. **Manutencao facilitada**: regras ficam centralizadas em BLoCs e repositorios.

---

## 2) Estrutura de pastas

Resumo das principais pastas em `lib/`:

- `lib/main.dart`
  - Bootstrap da aplicacao, providers globais e configuracao do `MaterialApp.router`.

- `lib/bindings.dart`
  - Composition Root / DI com `get_it`.
  - Registro de `Dio`, `HttpServiceAdapter`, `Storage`, `Database` e repositorios.

- `lib/routes/`
  - `router_config.dart`: configuracao central do GoRouter.
  - `routes.dart`: constantes de rotas.
  - `modules/*_router.dart`: roteamento por modulo.

- `lib/modules/`
  - Features da app (login, splash, home, tasks, users, profile).
  - Cada modulo contem UI + BLoC (event/state/bloc).

- `lib/data/`
  - `network/`: adaptador HTTP (`HttpServiceAdapter`).
  - `interceptors/`: interceptador de auth e refresh token.
  - `repositories/`: implementacoes de acesso a dados.
  - `storage/`: secure storage e modelos de persistencia.
  - `adapter/`: Request/Response adapters para desacoplar infra.

- `lib/domain/`
  - Entidades de negocio (`Task`, `User`) e regras de conversao.

- `lib/global/providers/`
  - Providers de estado global (usuario autenticado, tema, conectividade).

- `lib/theme/`
  - Definicoes de temas light/dark e extensoes semanticas.

Resumo de testes:

- `test/modules/**`: testes de widgets e blocs por feature.
- `test/data/**`: testes de camada de dados.
- `test/integration_test/**`: cenarios de integracao.

---

## 3) Build e execucao

## Requisitos

- Flutter 3.41.4
- Dart 3.11.1
- DevTools 2.54.1

## Variaveis de ambiente

Criar/usar `env.json` na raiz com:

```json
{
  "BASE_URL_DUMMYJSON": "https://dummyjson.com"
}
```

Observacao sobre versionamento de ambiente:

- Neste desafio tecnico, o arquivo `env.json` **nao foi adicionado ao `.gitignore`** de forma intencional.
- Motivo: facilitar reproducao do cenario de avaliacao e execucao dos testes que dependem de configuracao de ambiente.

## Instalar dependencias

```bash
flutter pub get
```

## Rodar em debug

```bash
flutter run --dart-define-from-file=env.json
```

## Build de release (exemplo Android)

```bash
flutter build apk --release --dart-define-from-file=env.json
```

## Rodar testes unitarios e de widget

```bash
flutter test --coverage -x integration
```

## Rodar testes que fazem chamadas reais para API (com ambiente e credenciais)

```bash
flutter test --coverage --dart-define-from-file=env.json --dart-define=LOGIN_USERNAME=emilys --dart-define=LOGIN_PASSWORD=emilyspass
```

## Rodar testes sem os cenarios que batem na API

- Quando nao quiser executar os testes que dependem de ambiente/API, use a flag `-x` para excluir esse grupo.
- Exemplo:

```bash
flutter test --coverage --dart-define-from-file=env.json -x integration
```

## Geracao de mocks (quando necessario)

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 4) Motivacoes de mudancas no design

As seguintes decisoes de UX/UI foram adotadas para melhorar a experiencia mantendo os requisitos funcionais do desafio:

1. **Loading com Skeletonizer**
   - Aplicado em telas para reduzir percepcao de latencia e manter estabilidade visual.

2. **Indicador global de conectividade offline**
   - Icone flutuante em todas as telas para informar indisponibilidade de rede de forma imediata.

3. **Login offline**
   - Botao exibido quando sem conectividade, com uso do usuario previamente salvo localmente.

4. **Validacao de formularios**
   - Uso de `validatorless` para padronizar validacoes e feedback ao usuario.

5. **Navegacao baseada em role**
   - Moderator nao visualiza recursos de admin, melhorando clareza e seguranca no client.

---

## 5) Persistencia local e offline-first

Como a API DummyJSON nao persiste escrita, o projeto aplica estrategia offline-first:

1. Cache local em SQLite para tarefas.
2. Operacoes de create/update/delete refletidas localmente.
3. Leitura combinando fonte remota + local para manter continuidade.
4. Login offline usando usuario salvo em tabela local (`logged_user`).

---

## 6) Padroes de projeto identificados

### 6.1 Repository Pattern

- Abstracoes: `TaskRepository`, `AuthRepository`, `UserRepository`.
- Implementacoes concretas na camada `data/repositories`.
- Beneficio: desacopla regras de negocio de detalhes de persistencia/rede.

### 6.2 Factory Method

- `Task.create(...)` para construcao consistente de tarefas locais.
- Factories de mapeamento (`fromDummyjson`, `fromSqliteRow`, `fromStorageJson`).
- Beneficio: centraliza regras de criacao e conversao de entidades.

### 6.3 Adapter Pattern

- `HttpServiceAdapter`, `RequestAdapter`, `ResponseAdapter`.
- Beneficio: padroniza fronteira HTTP e reduz dependencia direta da UI/regras com a lib de rede.

### 6.4 Interceptor Pattern

- `AuthInterceptor` para anexar token e aplicar refresh automatico.
- Beneficio: encapsula comportamento transversal de autenticacao.

### 6.5 Dependency Injection / Service Locator

- `get_it` no arquivo `bindings.dart` como composition root.
- Beneficio: injecao centralizada, facilidade de swap de dependencias e testes.

### 6.6 Observer / Reactive State

- `Bloc` (streams de estado) e `ChangeNotifier` (providers globais).
- Beneficio: atualizacao reativa de UI com estado previsivel.

### 6.7 Command-like Events no BLoC

- Eventos (`TasksEventLoad`, `LoginEventSubmit`, etc.) representam intencoes de usuario.
- Beneficio: fluxo explicito de acao -> transicao de estado.

---

## 7) SOLID aplicado

1. **S - Single Responsibility Principle**
   - Views focadas em renderizacao.
   - BLoCs focados em fluxo de estado.
   - Repositorios focados em acesso a dados.

2. **O - Open/Closed Principle**
   - Novos eventos/estados podem ser adicionados sem alterar contratos externos principais.

3. **L - Liskov Substitution Principle**
   - Consumidores trabalham com interfaces (`TaskRepository`, `AuthRepository`, `UserRepository`).

4. **I - Interface Segregation Principle**
   - Interfaces pequenas e orientadas a caso de uso (ex.: `Storage`, `HttpServiceAdapter`).

5. **D - Dependency Inversion Principle**
   - Camadas de orquestracao dependem de abstracoes, e as implementacoes sao injetadas via DI.

---

## 8) Boas praticas adotadas

1. Estados imutaveis com `copyWith`.
2. Uso de `sealed`/`final class` para maior seguranca de modelagem.
3. Debounce de busca para reduzir ruido de requisicoes/filtragens.
4. Timeouts + retry na camada HTTP para resiliencia.
5. Tratamento de erro com mensagens amigaveis para o usuario.
6. Testes automatizados de widget e camada de dados com mocks.
7. Chaves (`Key`) em widgets para tornar testes mais robustos.
8. Separacao clara de configuracao de tema, rotas e injecao de dependencias.

---

## 9) Credenciais de teste

```txt
username: emilys
password: emilyspass
```

---

## 10) Notas finais

- O projeto prioriza legibilidade, modularidade e evolucao incremental.
- Para evolucoes futuras, caminhos naturais sao:
  - consolidar sincronizacao bidirecional completa de tarefas;
  - expandir cobertura de testes de integracao;
  - reforcar regras de acesso por rota com guard centralizado.
