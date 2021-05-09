import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _textoSalvo = "Nada Salvo";
  TextEditingController _controllerCampo = TextEditingController();

  _salvar() async{
    String valorDigitado = _controllerCampo.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nome", valorDigitado);

    print("Operação (salvar) : $valorDigitado");

  }

  _recuperar() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("nome") ?? "SemValor";
    });

    print("Operação (Recuperar) : $_textoSalvo");
  }

  _remover() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("nome");
    print("Operação (Removido)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              _textoSalvo,
              style: TextStyle(
                fontSize: 20
              ),
            ),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Digite Algo",
              ),
              style: TextStyle(
                fontSize: 20
              ),
              controller: _controllerCampo,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: _salvar,
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                ),
                TextButton(
                    onPressed: _recuperar,
                    child: Text(
                        "Recuperar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue
                  ),
                ),
                TextButton(
                  onPressed: _remover,
                  child: Text(
                    "Remover",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue
                  ),
                ),
              ],
            )

          ],
      )
      ),
    );
  }
}
