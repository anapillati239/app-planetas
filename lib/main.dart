import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart'; // Importa a tela para inclusão e edição de planetas
import 'controles/controle_planeta.dart'; // Importa o controlador responsável pelas operações no banco de dados
import 'modelos/planeta.dart'; // Importa o modelo de dados "Planeta"

void main() {
  runApp(const MyApp()); // Ponto de entrada da aplicação
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a bandeira de debug
      title: 'Planetas', // Define o título do aplicativo
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Define o tema do app baseado em uma cor
        useMaterial3: true, // Habilita o uso do Material Design 3
      ),
      home: const MyHomePage(title: 'App - Planetas'), // Define a tela inicial
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title; // Título da página principal

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Instancia o controlador para gerenciar os planetas
  List<Planeta> _planetas = []; // Lista de planetas que será exibida na interface

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); // Carrega a lista de planetas ao iniciar a tela
  }

  // Atualiza a lista de planetas lendo do banco de dados
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  // Abre a tela para inclusão de um novo planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true, // Indica que a operação é de inclusão
          planeta: Planeta.vazio(), // Cria um planeta vazio para ser preenchido
          onFinalizado: _atualizarPlanetas, // Atualiza a lista ao finalizar a operação
        ),
      ),
    );
  }

  // Abre a tela para alteração de um planeta existente
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false, // Indica que a operação é de edição
          planeta: planeta, // Passa o planeta selecionado para edição
          onFinalizado: _atualizarPlanetas, // Atualiza a lista ao finalizar a operação
        ),
      ),
    );
  }

  // Exclui o planeta pelo seu ID e atualiza a lista
  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _atualizarPlanetas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Aplica a cor inversa definida no tema
        title: Text(widget.title), // Exibe o título da aplicação na barra superior
      ),
      body: ListView.builder(
        itemCount: _planetas.length, // Número de planetas na lista
        itemBuilder: (context, index) {
          final planeta = _planetas[index]; // Recupera cada planeta da lista
          return ListTile(
            title: Text(planeta.nome), // Exibe o nome do planeta
            subtitle: Text(planeta.apelido ?? ''), // Exibe o apelido, se existir
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit), // Ícone de edição
                  onPressed: () => _alterarPlaneta(context, planeta), // Chama a função de editar
                ),
                IconButton(
                  icon: const Icon(Icons.delete), // Ícone de exclusão
                  onPressed: () => _excluirPlaneta(planeta.id!), // Chama a função de excluir
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incluirPlaneta(context), // Chama a função para adicionar um novo planeta
        tooltip: 'Adicionar Planeta', // Texto de dica ao passar o cursor no botão
        child: const Icon(Icons.add), // Ícone de adição
      ),
    );
  }
}
