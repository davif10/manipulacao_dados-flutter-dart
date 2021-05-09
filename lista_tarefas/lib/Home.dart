import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];
  Map<String, dynamic> _ultimoTarefaRemovida = Map();
  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa(){
    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();
    _controllerTarefa.text = "";
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async{
    try{

      final arquivo = await _getFile();
      return arquivo.readAsString();
    }catch(e){
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then( (dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
  }

  Widget criarItemLista(context, index){
    //final item = _listaTarefas[index]["titulo"]+index.toString();
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        //recuperar último item excluído
        _ultimoTarefaRemovida = _listaTarefas[index];
        //Remove item da lista
        _listaTarefas.removeAt(index);
        _salvarArquivo();
        
        //snackbar
        final snackbar = SnackBar(
            content: Text("Tarefa removida!"),
          //duration: Duration(seconds: 5),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: "Desfazer",
            textColor: Colors.white,
            onPressed: (){
              //Recuperar a tarefa
              setState(() {
                _listaTarefas.insert(index, _ultimoTarefaRemovida);
              });
              _salvarArquivo();
            },
          ),

        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete,
            color:Colors.white,
            ),
          ],
        ),
      ),
      child: CheckboxListTile(
        title: Text(_listaTarefas[index]['titulo']),
        value: _listaTarefas[index]['realizada'],
        onChanged: (valorAlterado){
          setState(() {
            _listaTarefas[index]['realizada'] = valorAlterado;
          });

          _salvarArquivo();

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("itens: "+ DateTime.now().millisecondsSinceEpoch.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: (){
            showDialog(context: context,
                builder: (context){

                    return AlertDialog(
                      title: Text("Adicionar Tarefa"),
                      content:  TextField(
                        controller: _controllerTarefa,
                        decoration: InputDecoration(
                          labelText: "Digite sua tarefa"
                        ),
                        onChanged: (text){

                        },
                      ),
                      actions: [
                        TextButton(
                            child: Text("Cancelar"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text("Salvar"),
                          onPressed: (){
                            _salvarTarefa();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                }
            );
        },
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                  itemBuilder: criarItemLista
              ),
          ),
        ],
      ),
    );
  }

}
