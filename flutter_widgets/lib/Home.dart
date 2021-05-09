import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _lista = ["Davi", "Francisco","Maria","João"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Widgets"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: _lista.length,
                itemBuilder: (context, index){
                final item = _lista[index];

                  return Dismissible(
                    background: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.edit, color: Colors.white,)
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete, color: Colors.white,)
                        ],
                      ),
                    ),
                    //direction: DismissDirection.horizontal,
                    onDismissed: (direction){
                      if(direction == DismissDirection.endToStart){
                        print("Direção: ${direction.toString()}");
                      }else if(direction == DismissDirection.startToEnd){
                        print("Direção: ${direction.toString()}");
                      }

                      setState(() {
                        _lista.removeAt(index);
                      });

                    },
                      key: Key(item),
                      child: ListTile(
                        title: Text(item),
                      )
                  );
                }
            )
            ),
          ],
        ),
      ),
    );
  }
}
