
# PC Remote Control

Sistema de controle remoto de computadores por meio de um aplicativo mobile, permitindo executar comandos e gerenciar funções do computador à distância.

---

## Sobre o projeto

O **PC Remote Control** é um sistema desenvolvido para permitir o controle de computadores Windows utilizando um aplicativo mobile.

A solução é composta por três aplicações independentes que trabalham em conjunto: um aplicativo Desktop desenvolvido em C#, um aplicativo Mobile desenvolvido em Flutter e uma API desenvolvida em PHP, responsável pela comunicação e gerenciamento dos comandos.

O sistema permite que o usuário envie solicitações pelo celular para executar ações no computador, como desligamento, reinicialização, controle de volume e execução de comandos de teclado.

## Objetivos

- Permitir o controle remoto de computadores por meio de dispositivos móveis.
- Facilitar o gerenciamento de funções básicas do computador.
- Possibilitar o desligamento e a reinicialização à distância.
- Oferecer controle remoto do volume do sistema.
- Implementar temporizadores para execução de comandos.
- Permitir o gerenciamento de diferentes computadores por meio de códigos de identificação.
- Explorar tecnologias de comunicação entre aplicações mobile, desktop e servidores.

## Funcionalidades

### Aplicativo Desktop (C#)

A aplicação Desktop é responsável por receber e executar os comandos enviados pelo aplicativo mobile.

| Funcionalidade | Descrição |
|---|---|
| Execução em segundo plano | Mantém a aplicação ativa na bandeja do sistema. |
| Inicialização automática | Configura a inicialização do aplicativo junto ao Windows. |
| Identificação do computador | Utiliza um código de identificação para reconhecer o computador. |
| Consulta ao servidor | Verifica periodicamente se existem novos comandos disponíveis. |
| Desligamento remoto | Executa o desligamento do computador. |
| Reinicialização remota | Reinicia o computador remotamente. |
| Controle de volume | Permite aumentar ou diminuir o volume do sistema. |
| Comando de teclado | Permite executar comandos específicos, como a tecla Espaço. |

### Aplicativo Mobile (Flutter)

O aplicativo Mobile funciona como a interface de controle do sistema, permitindo que o usuário envie comandos ao computador.

| Funcionalidade | Descrição |
|---|---|
| Gerenciamento de computadores | Permite cadastrar diferentes códigos de identificação. |
| Identificação personalizada | Permite atribuir nomes aos computadores cadastrados. |
| Seleção de dispositivo | Permite selecionar qual computador receberá os comandos. |
| Desligamento remoto | Solicita o desligamento do computador selecionado. |
| Reinicialização remota | Solicita a reinicialização do computador. |
| Controle de volume | Permite aumentar ou diminuir o volume. |
| Comando de teclado | Permite enviar o comando correspondente à tecla Espaço. |
| Temporizador | Programa a execução de um comando após determinado intervalo. |

### API (PHP)

A API é responsável pela comunicação entre o aplicativo mobile, o banco de dados e a aplicação Desktop.

| Funcionalidade | Descrição |
|---|---|
| Recebimento de comandos | Recebe as solicitações enviadas pelo aplicativo mobile. |
| Armazenamento | Registra os comandos no banco de dados MySQL. |
| Identificação | Associa os comandos ao código do computador correspondente. |
| Gerenciamento de solicitações | Permite consultar e controlar o estado dos comandos enviados. |
| Comunicação com o Desktop | Disponibiliza os comandos para consulta pela aplicação instalada no computador. |

## Tecnologias utilizadas

| Tecnologia | Aplicação |
|---|---|
| C# | Desenvolvimento da aplicação Desktop. |
| Windows Forms | Interface e gerenciamento da aplicação Windows. |
| .NET | Plataforma de execução da aplicação Desktop. |
| Flutter | Desenvolvimento do aplicativo Mobile. |
| Dart | Linguagem de programação do aplicativo Mobile. |
| PHP | Desenvolvimento da API e processamento das requisições. |
| MySQL | Armazenamento e gerenciamento dos comandos. |
| Apache | Servidor responsável pela execução da API. |
| HTTP | Comunicação entre o aplicativo Mobile e a API. |
| NAudio | Gerenciamento do volume de áudio do Windows. |
| Newtonsoft.Json | Desserialização e interpretação de dados JSON. |

## Arquitetura do projeto

O sistema é dividido em três componentes principais.

```text
+-------------------------------+
|       APLICATIVO MOBILE       |
|                               |
|           Flutter             |
|             Dart              |
|                               |
| - Envio de comandos           |
| - Gerenciamento de IDs        |
| - Temporizadores              |
+---------------+---------------+
                |
                | HTTP POST
                |
                v
+-------------------------------+
|              API              |
|                               |
|             PHP               |
|                               |
| - Recebimento de comandos     |
| - Processamento de solicitações|
| - Comunicação com o MySQL     |
+---------------+---------------+
                |
                v
+-------------------------------+
|          BANCO DE DADOS        |
|                               |
|             MySQL             |
|                               |
| - Identificação dos PCs       |
| - Armazenamento de comandos   |
| - Controle de solicitações   |
+---------------+---------------+
                ^
                |
                | Consulta periódica
                |
+---------------+---------------+
|        APLICATIVO DESKTOP     |
|                               |
|              C#               |
|         Windows Forms         |
|                               |
| - Execução em segundo plano   |
| - Consulta de comandos        |
| - Execução de ações no Windows|
| - Controle de volume           |
+-------------------------------+
```

### Fluxo de funcionamento

1. O usuário seleciona um computador cadastrado no aplicativo Mobile.
2. O usuário escolhe o comando que deseja executar.
3. O aplicativo Flutter envia uma requisição HTTP para a API.
4. A API recebe a solicitação e registra o comando no banco de dados.
5. A aplicação Desktop consulta o servidor periodicamente utilizando o código de identificação do computador.
6. Ao identificar um comando válido, a aplicação Desktop executa a ação correspondente no Windows.

**Observação:** o fluxo acima representa a arquitetura planejada. A implementação dos endpoints de consulta precisa estar compatível com o formato de resposta esperado pelo aplicativo C#.

## Estrutura do projeto

O repositório está organizado em três partes independentes:

```text
PC-Remote-Control/
│
├── desktop/
│   └── AppCSharp/
│       ├── Forms/
│       ├── Program.cs
│       ├── Form1.cs
│       └── AppCSharp.csproj
│
├── mobile/
│   └── app_mobile/
│       ├── lib/
│       ├── android/
│       ├── assets/
│       ├── pubspec.yaml
│       └── ...
│
├── api/
│   ├── conecta.php
│   ├── recebe.php
│   └── desligar.php
│
├── docs/
│   └── screenshots/
│
├── .gitignore
└── README.md
```

Os nomes e diretórios podem ser adaptados conforme a organização real dos arquivos de cada aplicação.

## Como executar o projeto

### Pré-requisitos

Antes de executar o sistema, é necessário possuir:

**Aplicativo Desktop:**
- Windows 10 ou superior.
- Visual Studio ou outra IDE compatível com C#.
- .NET compatível com a versão utilizada no projeto.
- Dependências NAudio e Newtonsoft.Json.

**Aplicativo Mobile:**
- Flutter SDK.
- Dart SDK.
- Android Studio ou Visual Studio Code.
- Dispositivo Android ou emulador.

**API:**
- PHP.
- Apache.
- MySQL.
- Servidor configurado para receber requisições HTTP.

### 1. Clonar o repositório

```bash
git clone https://github.com/SEU-USUARIO/PC-Remote-Control.git
```

### 2. Acessar a pasta

```bash
cd PC-Remote-Control
```

### 3. Configurar o banco de dados

- Criar um banco de dados MySQL.
- Criar a tabela responsável pelo armazenamento dos comandos.
- Configurar as credenciais de acesso no arquivo de conexão da API.
- Configurar o servidor Apache para disponibilizar os arquivos PHP.

A estrutura da tabela utilizada pela aplicação deve contemplar os campos necessários para identificar os comandos, como:

| Campo | Descrição |
|---|---|
| id | Identificador do comando. |
| codigo | Código de identificação do computador. |
| acao | Comando solicitado pelo usuário. |
| enviado | Indicador de processamento do comando. |
| timestamp | Data e horário do registro. |

### 4. Configurar o aplicativo Mobile

Acesse a pasta do Flutter:

```bash
cd mobile/app_mobile
```

Instale as dependências:

```bash
flutter pub get
```

Verifique os dispositivos disponíveis:

```bash
flutter devices
```

Execute o aplicativo:

```bash
flutter run
```

### 5. Configurar o aplicativo Desktop

Abra a solução ou o arquivo `.csproj` do projeto C# utilizando o Visual Studio.

Restaure as dependências necessárias e compile a aplicação.

Após a compilação, execute o aplicativo no computador Windows que deseja controlar.

Na primeira execução, será solicitado o código de identificação gerado pelo aplicativo Mobile.

### 6. Configurar a comunicação

Para que o sistema funcione corretamente:

- O aplicativo Mobile deve estar configurado com o endereço da API.
- A aplicação Desktop deve consultar o endpoint responsável pela disponibilização dos comandos.
- Os códigos de identificação devem corresponder entre as aplicações.
- O servidor deve possuir acesso ao banco de dados MySQL.
- O computador deve possuir conexão com a internet para consultar o servidor.

## Segurança

Como o sistema permite executar comandos diretamente no computador, algumas medidas de segurança são importantes:

- Proteger a comunicação entre as aplicações.
- Validar os códigos de identificação dos computadores.
- Proteger as credenciais de acesso ao banco de dados.
- Utilizar consultas preparadas para interagir com o MySQL.
- Evitar a exposição de informações sensíveis no código-fonte.
- Restringir o acesso aos comandos a usuários autorizados.

As credenciais de banco de dados devem ser armazenadas em variáveis de ambiente ou configurações privadas, nunca diretamente nos arquivos publicados no GitHub.

## Possíveis melhorias

Algumas melhorias que podem ser implementadas futuramente:

- Implementação de autenticação mais robusta entre dispositivos.
- Comunicação em tempo real utilizando WebSockets.
- Interface para acompanhamento do status dos computadores.
- Histórico de comandos executados.
- Confirmação de execução das solicitações.
- Gerenciamento de múltiplos computadores.
- Melhorias na interface do aplicativo Mobile.

## Considerações finais

O PC Remote Control foi desenvolvido com o propósito de facilitar o gerenciamento e o controle de computadores por meio de dispositivos móveis.

A integração entre C#, Flutter, PHP e MySQL demonstra a aplicação de diferentes tecnologias em um único sistema, envolvendo desenvolvimento Desktop, Mobile, Back-end e comunicação entre aplicações.

O projeto explora conceitos de integração de sistemas, comunicação HTTP, gerenciamento de banco de dados e execução de processos no Windows.

---

**PC Remote Control**

Projeto de controle remoto de computadores desenvolvido com C#, Flutter, PHP e MySQL.
