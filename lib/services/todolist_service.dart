import 'dart:convert';

import 'package:todolist/models/api_response.dart';
import 'package:todolist/models/todolist.dart';
import 'package:todolist/models/todolist_listing.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/models/todolist_insert.dart';

class TodolistsService {
  static const API = 'https://63d3ec26.ngrok.io/api';
  static const headers = {'Content-Type': 'application/json'};

  //'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471',

  Future<APIResponse<List<TodolistListing>>> getTodoList() async {
    return http.get(API + "/todolist").then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final todolist = <TodolistListing>[];
        for (var item in jsonData) {
          todolist.add(TodolistListing.fromJson(item));
        }
        return APIResponse<List<TodolistListing>>(data: todolist);
      }
      return APIResponse<List<TodolistListing>>(error: true, errorMessage: 'An error occured 1');
    })
    .catchError((handleError) {
      return APIResponse<List<TodolistListing>>(error: true, errorMessage: handleError);
    });
  }

  Future<APIResponse<Note>> getTodolist(String todolistID) {
    return http.get(API + '/todolist/' + todolistID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An error occured 2');
    })
     .catchError((handleError) {
      return APIResponse<List<TodolistListing>>(error: true, errorMessage: handleError);
    });
  }

  Future<APIResponse<bool>> createTodolist(TodolistManipulation item) {
    return http.post(API + '/todolist', headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured 3');
    })
     .catchError((handleError) {
      return APIResponse<List<TodolistListing>>(error: true, errorMessage: handleError);
    });
  }

  Future<APIResponse<bool>> updateTodolist(String todolistID, TodolistManipulation item) {
    return http.put(API + '/todolist/' + todolistID, headers: headers, body: json.encode(item.toJson())).then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured 4');
    })
     .catchError((handleError) {
      return APIResponse<List<TodolistListing>>(error: true, errorMessage: handleError);
    });
  }
}
