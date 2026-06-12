# Cidadania Ativa

O **Cidadania Ativa** é um aplicativo desenvolvido em Flutter para registrar denúncias urbanas, como buracos, iluminação pública, lixo acumulado, bueiros entupidos, calçadas quebradas e outros problemas da cidade.

O projeto possui navegação entre as telas de início, postagens, nova denúncia e sobre, seguindo o visual definido no protótipo.

## Tecnologias utilizadas

* Flutter
* Dart
* Provider
* HTTP
* File Picker
* Android Emulator

## Pré-requisitos

Antes de rodar o projeto, é necessário ter instalado:

* Flutter SDK
* Dart SDK
* Android Studio
* Emulador Android configurado
* Git
* Visual Studio Code ou Android Studio

Para verificar se o Flutter está configurado corretamente, rode:

```bash
flutter doctor
```

## Como rodar o projeto

### 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

Depois entre na pasta do projeto:

```bash
cd CidadaniaAtiva
```

### 2. Entrar na pasta do app mobile

```bash
cd mobile
```

### 3. Instalar as dependências

```bash
flutter pub get
```

### 4. Rodar o projeto

Com um emulador Android aberto, rode:

```bash
flutter run
```

## Comandos úteis

Para limpar o projeto:

```bash
flutter clean
```

Para baixar as dependências novamente:

```bash
flutter pub get
```

Para rodar novamente:

```bash
flutter run
```

## Estrutura principal do projeto

```txt
mobile/
  assets/
    images/
  lib/
    core/
      constants/
      services/
    models/
    screens/
    widgets/
```

## Principais telas

* **Início:** apresenta o projeto, estatísticas e categorias.
* **Postagens:** lista denúncias recentes e denúncias criadas pelo usuário.
* **Nova Denúncia:** permite cadastrar uma nova denúncia com título, categoria, local, descrição e imagem.
* **Sobre:** apresenta informações sobre o projeto.

## Observação

O aplicativo pode funcionar localmente mesmo sem backend ativo. As denúncias criadas durante a execução aparecem na tela de postagens enquanto o app estiver rodando.
