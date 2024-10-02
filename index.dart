import 'package:flutter/material.dart';

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Bancário', // Nome atualizado
      theme: ThemeData(
        primaryColor: Colors.red[800], // Cor principal alterada para vermelho
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.red[800],
          secondary: Colors.black, // Cor secundária preto
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[800],
        ),
        scaffoldBackgroundColor: Colors.white, // Fundo branco
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red[800], // Botão em vermelho
          foregroundColor: Colors.white, // Ícones e texto brancos
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Barra de navegação preta
          selectedItemColor: Colors.red[800], // Item selecionado vermelho
          unselectedItemColor: Colors.white, // Não selecionado branco
        ),
      ),
      home: Dashboard(), // Dashboard é a tela principal
    );
  }
}

// Classe principal do Dashboard
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ListaTransferencia(),
    ListaContatos(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Transferências',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contatos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Tela de Transferências
class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Transferências', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push<Transferencia>(
            context,
            MaterialPageRoute(builder: (context) {
              return FormularioTransferencia();
            }),
          );
          future.then((transferenciaRecebida) {
            if (transferenciaRecebida != null) {
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            }
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Colors.red[800]),
        title: Text(_transferencia.valor.toString()), // Exibe o valor
        subtitle: Text(_transferencia.numeroConta.toString()), // Exibe a conta
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando Transferência',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            controlador: _controladorCampoNumeroConta,
            rotulo: 'Número da Conta',
            dica: '0000',
          ),
          Editor(
            controlador: _controladorCampoValor,
            rotulo: 'Valor',
            dica: '0.00',
            icone: Icons.monetization_on,
          ),
          ElevatedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criaTransferencia(context, _controladorCampoNumeroConta,
                  _controladorCampoValor);
            },
          ),
        ],
      ),
    );
  }

  void _criaTransferencia(
      BuildContext context,
      TextEditingController controladorCampoNumeroConta,
      TextEditingController controladorCampoValor) {
    final int? numeroConta = int.tryParse(controladorCampoNumeroConta.text);
    final double? valor = double.tryParse(controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta}';
  }
}

// Tela de Lista de Contatos com botão de adicionar
class ListaContatos extends StatefulWidget {
  final List<Contato> _contatos = [];

  @override
  State<StatefulWidget> createState() {
    return ListaContatosState();
  }
}

class ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        itemCount: widget._contatos.length,
        itemBuilder: (context, indice) {
          final contato = widget._contatos[indice];
          return ListTile(
            leading: Icon(Icons.person, color: Colors.blueGrey),
            title: Text(contato.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Telefone: ${contato.telefone}'),
                Text('E-mail: ${contato.email}'),
                Text('Endereço: ${contato.endereco}'),
                Text('CPF: ${contato.cpf}'),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(thickness: 2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text('Adicionar Contato'),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormularioContato()))
                .then((contatoCriado) {
              if (contatoCriado != null) {
                setState(() {
                  widget._contatos.add(contatoCriado);
                });
              }
            });
          },
        ),
      ),
    );
  }
}

// Formulário para adicionar contato
class FormularioContato extends StatelessWidget {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorEndereco = TextEditingController();
  final TextEditingController _controladorCpf = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Contato', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorNome,
              rotulo: 'Nome',
              dica: 'Nome completo',
            ),
            Editor(
              controlador: _controladorTelefone,
              rotulo: 'Telefone',
              dica: 'Digite o telefone',
            ),
            Editor(
              controlador: _controladorEmail,
              rotulo: 'E-mail',
              dica: 'Digite o e-mail',
            ),
            Editor(
              controlador: _controladorEndereco,
              rotulo: 'Endereço',
              dica: 'Digite o endereço',
            ),
            Editor(
              controlador: _controladorCpf,
              rotulo: 'CPF',
              dica: 'Digite o CPF',
            ),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                final String nome = _controladorNome.text;
                final String telefone = _controladorTelefone.text;
                final String email = _controladorEmail.text;
                final String endereco = _controladorEndereco.text;
                final String cpf = _controladorCpf.text;

                if (nome.isNotEmpty &&
                    telefone.isNotEmpty &&
                    email.isNotEmpty &&
                    endereco.isNotEmpty &&
                    cpf.isNotEmpty) {
                  final contatoCriado =
                      Contato(nome, telefone, email, endereco, cpf);
                  Navigator.pop(context, contatoCriado);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Editor para campos de texto
class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;

  Editor(
      {required this.controlador,
      required this.rotulo,
      required this.dica,
      this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: dica,
          icon: icone != null ? Icon(icone) : null,
        ),
        keyboardType: icone == Icons.monetization_on
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
      ),
    );
  }
}

// Modelo de Contato
class Contato {
  final String nome;
  final String telefone;
  final String email;
  final String endereco;
  final String cpf;

  Contato(this.nome, this.telefone, this.email, this.endereco, this.cpf);
}
