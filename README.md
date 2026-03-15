# Task Radar

O **Task Radar** é um sistema de gestão de tarefas (**TODO LIST**) avançado, desenvolvido em Flutter, com foco em alta performance, robustez técnica e experiência do utilizador. Este projeto foi concebido para ser uma solução escalável, testável e com suporte completo ao funcionamento offline.

O sistema integra o consumo da API pública DummyJSON com uma camada de persistência local baseada em SQLite e Secure Storage, gerindo fluxos complexos de autenticação JWT e permissões de acesso diferenciadas (Admin/Moderator).

---

## 📖 Documentação Técnica e Arquitetura

Para detalhes aprofundados sobre as decisões de engenharia, padrões de projeto aplicados (MVVM + BLoC), princípios SOLID respeitados e o roadmap detalhado de segurança e observabilidade, aceda ao guia completo:

👉 **[VEJA O GUIA DE CONTRIBUIÇÃO E ARQUITETURA (CONTRIBUTING.md)](CONTRIBUTING.md)**

---

### Comandos de Execução

**Configuração Inicial**
Instalar Dependências: flutter pub get
Gerar Código (DI e Mocks): flutter pub run build_runner build --delete-conflicting-outputs

**Execução da App**
Rodar com variáveis de ambiente: flutter run --dart-define-from-file=env.json

**Execução de Testes**
Validar regras de negócio e mapeamentos: flutter test -x integration

---

**Ariel Sardinha** *Engenheiro de Software*