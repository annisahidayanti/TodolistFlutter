import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist/models/todolist.dart';
import 'package:todolist/models/todolist_insert.dart';
import 'package:todolist/services/todolist_service.dart';

class TodolistModify extends StatefulWidget {
 
  final String todolistID;
  TodolistModify({this.todolistID});

  @override
  _TodolistModifyState createState() => _TodolistModifyState();
}

class _TodolistModifyState extends State<TodolistModify> {
  bool get isEditing => widget.todolistID != null;

  TodolistsService get todolistsService => GetIt.I<TodolistsService>();

  String errorMessage;
  Note todolist;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      todolistsService.getTodolist(widget.todolistID)
        .then((response) {
          setState(() {
            _isLoading = false;
          });

          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          todolist = response.data;
          _titleController.text = todolist.todolistTitle;
          _contentController.text = todolist.todolistContent;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit todolist' : 'Create todolist')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'todolist title'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'todolist content'
              ),
            ),

            Container(height: 16),

            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (isEditing) {
                    setState(() {
                      _isLoading = true;
                    });
                    final todolist = TodolistManipulation(
                      todolistTitle: _titleController.text,
                      todolistContent: _contentController.text
                    );
                    final result = await todolistsService.updateTodolist(widget.todolistID, todolist);
                    
                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your todolist was updated';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });

                  } else {
                    
                    setState(() {
                      _isLoading = true;
                    });
                    final todolist = TodolistManipulation(
                      todolistTitle: _titleController.text,
                      todolistContent: _contentController.text
                    );
                    final result = await todolistsService.createTodolist(todolist);
                    
                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Your todolist was created';

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(title),
                        content: Text(text),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    )
                    .then((data) {
                      if (result.data) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}