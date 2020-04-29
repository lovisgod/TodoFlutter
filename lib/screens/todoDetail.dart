import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

final List<String>choices = const <String> [
 'Save Todo & Back',
 'Delete Todo',
 'Back to List'
];

DbHelper dbHelper = DbHelper();
const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack= 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);
  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(todo);
  }

}


class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priotity = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text =todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
       title: Text(todo.title),
       actions: <Widget>[
         PopupMenuButton<String>(
           onSelected: select,
          itemBuilder: (BuildContext context) {
            return choices.map((String choice) {
                return PopupMenuItem<String>(
                   value: choice,
                      child: Text(choice),
                );
             }).toList();
         },
        )
       ],
      ),
                 body: Padding(
                   padding: EdgeInsets.only(
                           top: 35.0,
                           right: 10.0,
                           left: 10.0
                     ), 
                   child: ListView(
                     children: <Widget> [Column(
                     children: <Widget>[
                     TextField(
                       onChanged: (value) => this.updateTitle(),
                       controller: titleController,
                       style: textStyle,
                       decoration: InputDecoration(
                         labelText: "Title",
                         labelStyle: textStyle,
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5.0)
                           )
                       ),
                     ),
                      Padding(
                        padding: EdgeInsets.only(
                           top: 15.0,
                           bottom: 15.0
                     ), 
                        child: TextField(
                       onChanged: (value) => this.updateDescription(),   
                       controller: descriptionController,
                       style: textStyle,
                       decoration: InputDecoration(
                         labelText: "Description",
                         labelStyle: textStyle,
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5.0)
                           )
                       ),
                     )),
                      ListTile( title: DropdownButton<String>(
                        items: _priorities.map((String value) {
                           return DropdownMenuItem<String>(
                             value: value,
                             child: Text(value)
                           );
                         }).toList(), 
                         style: textStyle,
                         value: getPriority(todo.priority),
                         onChanged: (String value) {
                           updatePriority(value);
                         }
                       )
                       ),
                   ]
                 )
                 ]
                 ),
                 )
               );
             }
           
            //  void _onDropDownChanged(String value) {
            //          setState(() {
            //            _priotity = value;
            //          });
            //  }
           
           
           
             void select(String value) async {
               int result;
               switch (value) {
                 case mnuSave :
                   save();
                   break;
                 case mnuDelete:
                 Navigator.pop(context, true);
                  if(todo.id == null) {
                    return;
                  }
                  result = await dbHelper.deleteTodo(todo.id);
                  if (result!= 0) {
                    AlertDialog alertDialog = AlertDialog(
                      title: Text("Delete Todo"),
                      content: Text("The Todo has been deleted"),
                    );
                    showDialog(
                      context: context,
                      builder: (_) {
                        return alertDialog;
                      }
                    );
                  }
                   break;
                 case mnuBack :
                   Navigator.pop(context, true);
                   break;
                 default:
               }
  }

          void save() {
            todo.date = new DateFormat.yMd().format(DateTime.now());
            if (todo.id !=null){
              dbHelper.updateTodo(todo);
            }
            else{
              dbHelper.insertTodo(todo);
            }
            Navigator.pop(context, true);
          }

          void updatePriority(String value) {
            switch (value) {
              case "High":
                todo.priority = 1;
                break;
              case "Medium":
               todo.priority = 2;
               break;
              case "Low":
               todo.priority = 3;
               break; 
            }
            setState(() {
              _priotity = value;
            });
          }

        String getPriority(int value) {
          return _priorities[value-1];
        }

        void updateTitle() {
          todo.title = titleController.text;
        }

        void updateDescription() {
          todo.description = descriptionController.text;
        }
}