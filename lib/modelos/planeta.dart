class Planeta {
  int? id;              // Identificador único do planeta (pode ser nulo para novos planetas)
  String nome;           // Nome do planeta (obrigatório)
  double tamanho;        // Tamanho do planeta em quilômetros (obrigatório)
  double distancia;      // Distância do planeta em quilômetros (obrigatório)
  String? apelido;       // Apelido do planeta (opcional)

  // Construtor principal da classe Planeta
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor nomeado para criar um objeto Planeta vazio com valores padrão
  Planeta.vazio() 
    : nome = '', 
      tamanho = 0, 
      distancia = 0.0,
      apelido = '';

  // Fábrica (factory) para criar um objeto Planeta a partir de um mapa de dados (usado ao ler do banco de dados)
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],                  // Converte o valor de 'id' para int
      nome: map['nome'],              // Nome do planeta
      tamanho: map['tamanho'],        // Tamanho em quilômetros
      distancia: map['distancia'],    // Distância em quilômetros
      apelido: map['apelido'],        // Apelido (pode ser nulo)
    );
  }

  // Método para converter um objeto Planeta em um mapa de dados (usado ao salvar no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,                // ID do planeta (pode ser nulo ao inserir um novo registro)
      'nome': nome,            // Nome do planeta
      'tamanho': tamanho,      // Tamanho do planeta
      'distancia': distancia,  // Distância do planeta
      'apelido': apelido,      // Apelido (pode ser nulo)
    };
  }
}
