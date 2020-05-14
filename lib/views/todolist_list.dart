import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:todolist/models/api_response.dart';
import 'package:todolist/models/todolist_listing.dart';
import 'package:todolist/services/todolist_service.dart';
import 'package:todolist/views/todolist_delete.dart';

import 'todolist_modify.dart';

class TodolistList extends StatefulWidget {
  @override
  _TodolistListState createState() => _TodolistListState();
}

class _TodolistListState extends State<TodolistList> {
  TodolistsService get service => GetIt.I<TodolistsService>();
    
      APIResponse<List<TodolistListing>> _apiResponse;
      bool _isLoading = false;
    
      String formatDateTime(DateTime dateTime) {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    
      @override
      void initState() {
        _fetchTodolists();
        super.initState();
      }
    
      _fetchTodolists() async {
        setState(() {
          _isLoading = true;
        });
    
        _apiResponse = await service.getTodoList();
    
        setState(() {
          _isLoading = false;
        });
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('List of todolists')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => TodolistModify()))
                    .then((_) {
                      _fetchTodolists();
                    });
              },
              child: Icon(Icons.add),
            ),
            body: Builder(
              builder: (_) {
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
    
                if (_apiResponse.error) {
                  return Center(child: Text(_apiResponse.errorMessage));
                }
    
                return ListView.separated(
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.green),
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: ValueKey(_apiResponse.data[index].todolistID),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {},
                      confirmDismiss: (direction) async {
                        final result = await showDialog(
                            context: context, builder: (_) => TodolistDelete());
                        print(result);
                        return result;
                      },
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.only(left: 16),
                        child: Align(
                          child: Icon(Icons.delete, color: Colors.white),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          _apiResponse.data[index].todolistTitle,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        subtitle: Text(
                            'Last edited on ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TodolistModify(
                                  todolistID: _apiResponse.data[index].todolistID))).then((data) {
                                    _fetchTodolists();
                                  });
                        },
                      ),
                    );
                  },
                  itemCount: _apiResponse.data.length,
                );
              },
            ));
      }
    }
  

