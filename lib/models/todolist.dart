class Note {
  
  String todolistID;
  String todolistTitle;
  String todolistContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;
  
  Note({this.todolistID, this.todolistTitle, this.todolistContent, this.createDateTime, this.latestEditDateTime});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      todolistID: item['todolistID'],
      todolistTitle: item['todolistTitle'],
      todolistContent: item['todolistContent'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}