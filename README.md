# Task Radar

O **Task Radar** é um sistema de gestão de tarefas (**TODO LIST**) avançado, desenvolvido em Flutter Mobile, com foco em alta performance, robustez técnica e experiência do utilizador. Este projeto foi concebido para ser uma solução escalável, testável e com suporte completo ao funcionamento offline.

O sistema integra o consumo da API pública DummyJSON com uma camada de persistência local baseada em SQLite e Secure Storage, gerindo fluxos complexos de autenticação JWT e permissões de acesso diferenciadas (Admin/Moderator).

---

## 📖 Documentação Técnica e Arquitetura

Para detalhes aprofundados sobre as decisões de engenharia, padrões de projeto aplicados (MVVM + BLoC), princípios SOLID respeitados e o roadmap detalhado de segurança e observabilidade, separamos um link com o guia completo:

👉 **[VEJA O GUIA DE CONTRIBUIÇÃO E ARQUITETURA (CONTRIBUTING.md)](CONTRIBUTING.md)**

---

### Comandos de Execução

**Configuração Inicial**

#### Instalar Dependências: 
```dart
flutter pub get
```

Gerar Código (DI e Mocks): 
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Execução da App**
Rodar com variáveis de ambiente: 
```bash
flutter run --dart-define-from-file=env.json
```

**Execução de Testes**
Validar regras de negócio e mapeamentos: 
```bash
flutter test -x integration
```

---

**Ariel Sardinha** *Engenheiro de Software*