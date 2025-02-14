## 🌍 App de Cadastro de Planetas
Este projeto Flutter é um aplicativo simples de Cadastro de Planetas, que permite ao usuário adicionar, editar, listar e excluir planetas utilizando um banco de dados SQLite.

## 🛠️ Tecnologias Utilizadas
Flutter: Framework para a criação da interface de usuário.
Dart: Linguagem de programação.
SQLite: Banco de dados local para persistência dos dados.
## 📁 Estrutura do Projeto
bash
Copiar
Editar
.
├── lib
│   ├── modelos
│   │   └── planeta.dart      # Modelo de dados para o planeta
│   ├── controles
│   │   └── controle_planeta.dart # Controle para gerenciar operações no banco de dados
│   ├── telas
│   │   └── tela_planeta.dart # Tela de cadastro/edição de planetas
│   └── main.dart             # Arquivo principal do aplicativo
└── README.md                 # Documentação do projeto
## 🚀 Funcionalidades
Listagem de Planetas: Exibe uma lista com os planetas cadastrados.
Adicionar Planeta: Permite cadastrar um novo planeta.
Editar Planeta: Permite modificar os dados de um planeta existente.
Excluir Planeta: Remove um planeta da lista.
## 📂 Descrição dos Arquivos Principais
## planeta.dart
Modelo de dados do planeta:
Contém as propriedades id, nome, tamanho, distancia e apelido.
Métodos para converter o objeto Planeta para e de um map (usado no SQLite).
## controle_planeta.dart
Responsável pelo gerenciamento dos dados:
Banco de Dados SQLite: Criação, inserção, atualização, exclusão e leitura de dados.
Operações assíncronas usando o pacote sqflite.
## tela_planeta.dart
Tela para adicionar ou editar um planeta:
Utiliza um formulário para entrada de dados.
Validação dos campos para garantir dados consistentes.
## main.dart
Ponto de entrada do aplicativo:
Configuração básica do MaterialApp.
Tela principal que exibe a lista de planetas e permite interações com o usuário.
## 📸 Capturas de Tela (opcional)
Adicione aqui algumas imagens do aplicativo funcionando, se desejar.
Exemplo: Tela de listagem, tela de cadastro, etc.
