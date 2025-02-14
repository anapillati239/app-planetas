import 'package:sqflite/sqflite.dart'; // Biblioteca para manipulação de banco de dados SQLite
import 'package:path/path.dart'; // Biblioteca para manipular caminhos de arquivos

import '../modelos/planeta.dart'; // Importa o modelo Planeta

class ControlePlaneta {
  static Database? _bd; // Armazena a instância do banco de dados

  // Getter para acessar o banco de dados. Se o banco já estiver instanciado, retorna a instância existente.
  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    // Se não houver uma instância existente, inicializa o banco de dados
    _bd = await _initBD('planetas_db');
    return _bd!;
  }

  // Método para inicializar o banco de dados, especificando o caminho e a versão
  Future<Database> _initBD(String localArquivo) async {
    final caminhoBD = await getDatabasesPath(); // Obtém o caminho padrão para o armazenamento de bancos de dados
    final caminho = join(caminhoBD, localArquivo); // Cria o caminho completo para o arquivo do banco de dados
    return await openDatabase(
      caminho, // Caminho do banco de dados
      version: 1, // Versão do banco de dados
      onCreate: _criarBD, // Método chamado ao criar o banco pela primeira vez
    );
  }

  // Método chamado para criar a estrutura inicial do banco de dados
  Future<void> _criarBD(Database bd, int versao) async {
    const sql = '''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Identificador único para cada planeta
        nome TEXT NOT NULL,                    -- Nome do planeta (obrigatório)
        tamanho REAL NOT NULL,                 -- Tamanho do planeta em km (obrigatório)
        distancia REAL NOT NULL,               -- Distância do planeta em km (obrigatório)
        apelido TEXT                           -- Apelido do planeta (opcional)
      )
    ''';
    await bd.execute(sql); // Executa o comando SQL para criar a tabela
  }

  // Método para ler todos os planetas do banco de dados e retornar uma lista de objetos Planeta
  Future<List<Planeta>> lerPlanetas() async {
    final db = await bd; // Obtém a instância do banco de dados
    final resultado = await db.query('planetas'); // Consulta todos os registros da tabela "planetas"
    // Converte cada resultado em um objeto Planeta e retorna como uma lista
    return resultado.map((map) => Planeta.fromMap(map)).toList();
  }

  // Método para inserir um novo planeta no banco de dados
  Future<int> inserirPlaneta(Planeta planeta) async {
    final bd = await this.bd;
    // Insere o mapa de dados do planeta na tabela "planetas" e retorna o ID gerado
    return await bd.insert('planetas', planeta.toMap());
  }

  // Método para alterar os dados de um planeta existente no banco de dados
  Future<int> alterarPlaneta(Planeta planeta) async {
    final db = await bd;
    // Atualiza o registro do planeta identificado pelo ID
    return await db.update(
      'planetas',
      planeta.toMap(), // Converte o objeto Planeta em um mapa de dados
      where: 'id = ?', // Condição para identificar o registro a ser alterado
      whereArgs: [planeta.id], // Argumento para substituir o "?" na cláusula where
    );
  }

  // Método para excluir um planeta do banco de dados pelo ID
  Future<int> excluirPlaneta(int id) async {
    final db = await bd;
    // Exclui o registro com o ID especificado
    return await db.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }
}
