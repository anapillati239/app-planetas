import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart'; // Importa o controlador para operações no banco de dados
import 'package:myapp/modelos/planeta.dart'; // Importa o modelo de dados Planeta

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir; // Indica se a tela está no modo de inclusão ou edição
  final Planeta planeta; // Planeta que será incluído ou editado
  final Function() onFinalizado; // Função chamada ao concluir a operação

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário
  final TextEditingController _nomeController = TextEditingController(); // Controller para o campo "Nome"
  final TextEditingController _tamanhoController = TextEditingController(); // Controller para o campo "Tamanho"
  final TextEditingController _distanciaController = TextEditingController(); // Controller para o campo "Distância"
  final TextEditingController _apelidoController = TextEditingController(); // Controller para o campo "Apelido"
  final ControlePlaneta _controlePlaneta = ControlePlaneta(); // Instancia o controlador para manipular os dados

  late Planeta _planeta; // Planeta que será manipulado nesta tela

  @override
  void initState() {
    super.initState();
    _planeta = widget.planeta; // Inicializa o planeta com o valor recebido via parâmetro
    // Preenche os campos do formulário com os valores atuais do planeta
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
  }

  // Função para inserir um novo planeta no banco de dados
  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  // Função para alterar um planeta existente no banco de dados
  Future<void> _alterarPlaneta() async {
    if (_planeta.id != null) {
      await _controlePlaneta.alterarPlaneta(_planeta);
    }
  }

  // Função chamada ao enviar o formulário
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Salva os valores inseridos no formulário

      // Verifica se é uma inclusão ou alteração e chama a função correspondente
      if (widget.isIncluir) {
        await _inserirPlaneta();
      } else {
        await _alterarPlaneta();
      }

      // Exibe uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Dados do planeta foram ${widget.isIncluir ? 'incluídos' : 'alterados'} com sucesso!'),
        ),
      );
      Navigator.of(context).pop(); // Fecha a tela atual
      widget.onFinalizado(); // Chama a função de atualização da lista
    }
  }

  @override
  void dispose() {
    // Descarta os controllers ao finalizar a tela para evitar vazamentos de memória
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'), // Título da tela
        elevation: 4, // Elevação para sombra na AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // Define o padding ao redor do formulário
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de texto para o nome do planeta
                _buildTextField('Nome', _nomeController,
                    'Informe o nome do planeta (mínimo 4 caracteres)', (value) {
                  _planeta.nome = value!;
                }, minLength: 4),
                const SizedBox(height: 10), // Espaçamento entre os campos
                // Campo de texto para o tamanho do planeta
                _buildTextField('Tamanho (em km)', _tamanhoController,
                    'Informe o tamanho do planeta', (value) {
                  _planeta.tamanho = double.parse(value!);
                }, isNumber: true),
                const SizedBox(height: 10),
                // Campo de texto para a distância do planeta
                _buildTextField('Distância (em km)', _distanciaController,
                    'Informe a distância do planeta', (value) {
                  _planeta.distancia = double.parse(value!);
                }, isNumber: true),
                const SizedBox(height: 10),
                // Campo de texto para o apelido do planeta
                _buildTextField('Apelido', _apelidoController, null, (value) {
                  _planeta.apelido = value;
                }),
                const SizedBox(height: 20),
                // Botões de "Cancelar" e "Salvar"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(), // Fecha a tela ao cancelar
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm, // Chama a função para salvar o formulário
                      child: const Text('Salvar'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função para construir campos de texto reutilizáveis
  Widget _buildTextField(String label, TextEditingController controller,
      String? errorMessage, Function(String?) onSaved,
      {bool isNumber = false, int minLength = 0}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, // Label do campo
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text, // Define o tipo de teclado (numérico ou texto)
      autovalidateMode: AutovalidateMode.onUserInteraction, // Valida o campo enquanto o usuário digita
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage ?? 'Campo obrigatório'; // Validação para campo vazio
        }
        if (minLength > 0 && value.length < minLength) {
          return 'Mínimo de $minLength caracteres'; // Validação para tamanho mínimo
        }
        if (isNumber && double.tryParse(value) == null) {
          return 'Insira um valor numérico válido'; // Validação para número
        }
        return null;
      },
      onSaved: onSaved, // Salva o valor no objeto Planeta
    );
  }
}
