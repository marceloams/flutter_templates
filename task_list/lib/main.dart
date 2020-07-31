import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //controller to get task input
  final _toDoController = TextEditingController();

  // task list
  List _toDoList = [];

  //info about deleted item
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  //method load list from data at initialization
  @override
  void initState() {
    super.initState();

    //load data
    _readData().then((data){
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  //method add task
  void _addToDo(){
    setState(() {
      //Map<index = String, content = dynamic>
      Map<String, dynamic> newToDo = Map();

      //add title from to do input
      newToDo["title"] = _toDoController.text;

      //clear to do input
      _toDoController.text = "";

      //add done status
      newToDo["done"] = false;

      //add new to do to the list
      _toDoList.add(newToDo);

      //save list
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            labelText: "New Task",
                            labelStyle: TextStyle(color: Colors.deepPurple)
                        ),
                        controller: _toDoController,
                    )
                ),
                RaisedButton(
                  color: Colors.deepPurple,
                  child: Text("Add"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded (
            child: RefreshIndicator(
              onRefresh: _refresh,
              child:  ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem,
              ),
            ),
          )
        ],
      ),
    );
  }

  //shows items from the list
  Widget buildItem(context, index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()), //key has to be unique
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0), //to put icon on the left
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd, //direction of the action
      child: CheckboxListTile( //item that will be deleted
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["done"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["done"] ?
          Icons.check : Icons.error),
        ),
        onChanged: (c) {
          setState(() {
            //change task done index
            _toDoList[index]["done"] = c;
            //save list
            _saveData();
          });
        },
      ),
      onDismissed: (direction){ //action to do on delete
        setState(() {
          //save info about deleted item
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;

          //remove from the list
          _toDoList.removeAt(index);

          //save updated list
          _saveData();

          //info that the item has been deleted and undo option
          final snack = SnackBar(
            content: Text("Task \"${_lastRemoved["title"]}\" deleted!"),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos,_lastRemoved); //insert deleted item
                  _saveData(); //save updated list
                });
              },
            ),
            duration: Duration(seconds: 3),
          );

          //if has old snack bar removes it
          Scaffold.of(context).removeCurrentSnackBar();

          //shows snack
          Scaffold.of(context).showSnackBar(snack);
        });
      }
    );
  }

  //refresh list of items when scroll
  Future<Null> _refresh() async {

    //wait 1 sec to execute
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      //order list based on done or not done
      _toDoList.sort((a, b){
        if(a["done"] && !b["done"]) return 1;
        else if(!a["done"] && b["done"]) return -1;
        else return 0;
      });

      //save ordered list
      _saveData();
    });

    return null;
  }

  //get directory path
  Future<File> _getFile() async {
    //get the path
    final directory = await getApplicationDocumentsDirectory();

    //return the path
    return File("${directory.path}/data.json");
  }

  //save tasks
  Future<File> _saveData() async {
    //convert list in json
    String data = json.encode(_toDoList);

    //get file
    final file = await _getFile();

    //save the list in json
    return file.writeAsString(data);
  }

  //read tasks
  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
