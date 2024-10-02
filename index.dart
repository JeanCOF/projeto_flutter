import 'package:flutter/material.dart';

void main() => runApp(BankApp());

class BankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banco Bancário', // Alterado o nome para "Banco Bancário"
      theme: ThemeData(
        primaryColor: Colors.red[800], // Cor principal alterada para vermelho
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.red[800], // Vermelho como cor principal
          secondary: Colors.black, // Preto para cor secundária
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[800], // Cor de fundo do AppBar em vermelho
        ),
        scaffoldBackgroundColor: Colors.white, // Fundo da aplicação em branco
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.red[800], // Botão de ação flutuante em vermelho
          foregroundColor: Colors.white, // Texto e ícones em branco
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Fundo da barra de navegação em preto
          selectedItemColor: Colors.red[800], // Ícone selecionado em vermelho
          unselectedItemColor: Colors.white, // Ícones não selecionados em branco
        ),
      ),
      home: Dashboard(), // Mantido o Dashboard
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
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
              MaterialPageRoute(builder: (context) => FormularioContato())
            ).then((contatoCriado) {
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
                  final contatoCriado = Contato(nome, telefone, email, endereco, cpf);
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

  Editor({required this.controlador, required this.rotulo, required this.dica});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: dica,
        ),
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
