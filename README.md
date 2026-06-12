# Cidadania Ativa

Plataforma desenvolvida para o registro e monitoramento de denúncias urbanas, como problemas de iluminação pública, acúmulo de lixo, bueiros entupidos e calçadas danificadas.

O projeto é estruturado em um único repositório dividido em três partes essenciais:
* Banco de Dados: MySQL executado via Docker.
* Back-end (API): Desenvolvido em Java com Spring Boot.
* Front-end (Mobile): Desenvolvido em Flutter para dispositivos Android.

## Tecnologias utilizadas

### Back-end e Infraestrutura
* Java 17
* Spring Boot (Data JPA, Web)
* Maven
* Docker e Docker Compose
* MySQL 8.0

### Front-end Mobile
* Flutter e Dart
* Provider
* HTTP
* File Picker

## Pré-requisitos

Para rodar o projeto completo, é necessário ter instalado:
1. Git
2. Docker Desktop
3. Java JDK 17
4. IntelliJ IDEA (ou outra IDE de preferência para Java)
5. Flutter SDK (configurado e validado via comando `flutter doctor`)
6. Android Studio (com um emulador instalado)

## Como rodar o projeto integrado

Siga a ordem dos passos abaixo para iniciar todo o ambiente local:

### 1. Clonar o repositório
Abra o terminal e clone o projeto na sua máquina:
```bash
git clone https://github.com
cd CidadaniaAtiva
```

### 2. Subir o Banco de Dados (Docker)
Na pasta raiz do projeto, execute o comando para iniciar o container do MySQL em segundo plano:
```bash
docker compose up -d
```
O banco de dados será exposto localmente na porta 3306 com o usuário 'root' e a senha 'admin'. O schema 'cidadania_db' será gerado automaticamente.

### 3. Rodar o Back-end (Java Spring Boot)
1. Abra a pasta raiz do projeto no IntelliJ IDEA.
2. Aguarde o download das dependências do Maven descritas no arquivo pom.xml.
3. Certifique-se de que o arquivo src/main/resources/application.properties está apontando para o seu banco local na porta 3306.
4. Execute a classe principal CidadaniaAtivaApplication.java.
5. O servidor iniciará na porta 8080 e o Hibernate criará as tabelas do banco de dados automaticamente.

### 4. Rodar o Aplicativo Mobile (Flutter)
Antes de iniciar o aplicativo móvel, é necessário ajustar o IP de destino para a comunicação com a API do Spring Boot.

1. Abra o arquivo mobile/lib/core/services/postagem_service.dart.
2. No método baseUrl, configure o endereço conforme o seu cenário de teste:
   * Se for usar o Emulador Android: Mantenha o IP padrão do emulador: 'http://10.0.2'.
   * Se for usar um Celular Físico conectado via cabo USB: Altere para o IP do seu computador na rede Wi-Fi (exemplo: 'http://192.168.18').

Com o IP configurado, execute os comandos no terminal:
```bash
cd mobile
flutter pub get
flutter run
```

## Estrutura de pastas do repositório

```text
CidadaniaAtiva/
  ├── mobile/                  # Código-fonte do aplicativo Flutter (Front-end)
  │    ├── assets/images/      # Imagens locais e mocks do app
  │    └── lib/                # Arquivos Dart (telas, modelos, serviços)
  ├── src/                     # Código-fonte da API Java Spring Boot (Back-end)
  ├── docker-compose.yml       # Arquivo de configuração do container MySQL
  ├── pom.xml                  # Dependências do projeto Maven (Java)
  └── README.md                # Documentação do repositório
```

## Comandos úteis de manutenção

* Verificar o status do container do banco: `docker compose ps`
* Parar o banco de dados mantendo os registros salvos: `docker compose down`
* Apagar todos os dados do banco para testes limpos: `docker compose down -v`
* Limpar o cache do projeto Flutter: `flutter clean`
