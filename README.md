# My App

Aplicativo desenvolvido em Flutter com funcionalidades de consulta de clima, geolocalização e gerenciamento de cidades favoritas.

---

# Descrição

O projeto foi desenvolvido utilizando Flutter e Dart, com foco em consumo de API, geolocalização e armazenamento local de dados.  
O aplicativo permite consultar informações climáticas de cidades, utilizar localização automática via GPS e salvar cidades favoritas.

---

# Funcionalidades

- Consulta de clima em tempo real
- Busca de cidades
- Geolocalização automática
- Sistema de favoritos
- Armazenamento local de dados
- Interface responsiva
- Consumo de API externa

---

# Tecnologias Utilizadas

- Flutter
- Dart
- Material Design
- API HTTP
- Shared Preferences
- Geolocator

---

# Dependências do Projeto

## Dependências principais

- Flutter SDK
- cupertino_icons ^1.0.8
- http ^1.2.0
- shared_preferences ^2.2.3
- geolocator ^13.0.1

## Dependências de desenvolvimento

- flutter_test
- flutter_lints ^6.0.0

---

# Função de cada dependência

| Dependência | Função |
|---|---|
| flutter | Base principal do projeto Flutter |
| cupertino_icons | Ícones no estilo iOS |
| http | Requisições HTTP e consumo de APIs |
| shared_preferences | Armazenamento local de dados |
| geolocator | Acesso à localização/GPS |
| flutter_test | Testes automatizados |
| flutter_lints | Padronização e análise de código |

---

# Estrutura do Projeto

```text
lib/
├── main.dart
├── widgets/
├── controllers/
├── view/

---

# Ambiente de Desenvolvimento

- Flutter SDK 3.x
- Dart SDK 3.11.4

---

# Permissões Utilizadas

O aplicativo utiliza as seguintes permissões:

- Internet
- Localização/GPS

---

# Plataformas Suportadas

- Android
- Web
- Windows

---

# Como Executar o Projeto

## 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

## 2. Entrar na pasta do projeto

```bash
cd my_app
```

## 3. Instalar as dependências

```bash
flutter pub get
```

## 4. Executar o projeto

```bash
flutter run
```

---

# Comandos Úteis

## Atualizar dependências

```bash
flutter pub get
```

## Ver dependências instaladas

```bash
flutter pub deps
```

## Ver pacotes desatualizados

```bash
flutter pub outdated
```

---

# Arquitetura Utilizada

O projeto utiliza separação de responsabilidades em:

- Screens
- Widgets
- Controllers
- Services
- Models

Essa estrutura facilita manutenção, organização e escalabilidade do sistema.

---

# API Utilizada

- OpenWeather API

---

# Objetivo do Projeto

O objetivo do projeto é praticar desenvolvimento mobile com Flutter, consumo de APIs, manipulação de estado, armazenamento local e utilização de recursos nativos como GPS.

---

# Autor

Desenvolvido por Kawan.