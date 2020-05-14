import 'package:flutter/foundation.dart';

class TodolistManipulation {
  String todolistTitle;
  String todolistContent;

  TodolistManipulation(
    {
      @required this.todolistTitle,
      @required this.todolistContent,
    }
  );

  Map<String, dynamic> toJson() {
    return {
      "noteTitle": todolistTitle,
      "noteContent": todolistContent
    };
  }
}