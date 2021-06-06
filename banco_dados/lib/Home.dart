import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async{
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.db");

    var bd = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
        db.execute(sql);
      }
    );

    return bd;
    //print("aberto: "+bd.isOpen.toString());
  }
  
  _salvar() async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario ={
      "nome" : "Amanda Ferrari",
      "idade" : 22
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id");
  }

  _listarUsuarios() async{
    Database bd = await _recuperarBancoDados();
    //String sql = "SELECT * FROM usuarios WHERE nome = 'Davi Silva'";
    //String sql = "SELECT * FROM usuarios WHERE idade >= 25 AND idade <= 30";
    //String sql = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46";
    //String sql = "SELECT * FROM usuarios WHERE idade in (18,30)";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%Silva%'";
    //String filtro = "am";
    //String sql = "SELECT * FROM usuarios WHERE nome LIKE '%"+filtro+"%'";
    //String sql = "SELECT * FROM usuarios ORDER BY UPPER(nome)  DESC ";//ASC e DESC
    //String sql = "SELECT * FROM usuarios ORDER BY idade  DESC LIMIT 3";
    String sql = "SELECT * FROM usuarios";
    List usuarios = await bd.rawQuery(sql);

    for(var usuario in usuarios){
      print("item id: "+usuario['id'].toString()+
          " nome: "+usuario['nome']+
          " idade: "+usuario['idade'].toString()
      );
    }
    //print("usuarios: "+usuarios.toString());
  }

  _listarUsuarioPeloId(int id) async{
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
      "usuarios",
      columns: ["id","nome","idade"],
      //where: "id = ? AND nome = ? AND idade = ?",
      //whereArgs: [id,"Amanda Ferrari",22]
      where: "id = ?",
      whereArgs: [id]
    );

    for(var usuario in usuarios){
      print("item id: "+usuario['id'].toString()+
          " nome: "+usuario['nome']+
          " idade: "+usuario['idade'].toString()
      );
    }
  }

  _excluirUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
      where: "id = ?",
      whereArgs: [id]
    );
    print("Item quantidade removida: $retorno");
  }
  _excluirUsuarios() async{
    Database bd = await _recuperarBancoDados();
    int retorno = await bd.delete(
        "usuarios",
        where: "nome = ? AND idade = ?",
        whereArgs: ["Amanda Ferrari",22]
    );
    print("Item quantidade removida: $retorno");
  }

  _atualizarUsuario(int id) async{
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario ={
      "nome" : "Davi Francisco da Silva",
      "idade" : 26
    };

    int retorno = await bd.update(
        "usuarios",
        dadosUsuario,
        where: "id = ?",
        whereArgs: [id]
    );
    print("Item quantidade atualizada: $retorno");
  }

  @override
  Widget build(BuildContext context) {
    //_salvar();
    //_listarUsuarioPeloId(11);
    //_atualizarUsuario(1);
    //_excluirUsuario(2);
    _excluirUsuarios();
    _listarUsuarios();
    return Container();
  }
}
