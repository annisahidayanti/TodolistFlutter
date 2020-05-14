class TodolistListing {
  String todolistID;
  String todolistTitle;
  DateTime createDateTime;
  DateTime latestEditDateTime;
  
  TodolistListing({this.todolistID, this.todolistTitle, this.createDateTime, this.latestEditDateTime});

  factory TodolistListing.fromJson(Map<String, dynamic> item) {
    return TodolistListing(
      todolistID: item['noteID'],
      todolistTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}