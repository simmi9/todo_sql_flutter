import 'package:intl/intl.dart';

class Todo {
  int? id;
  String description;
  bool isDone = false;
  String? dateCreated;
  String? dueDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Todo(
      {this.id,
      this.description = "k",
      this.isDone = false,
      this.dateCreated,
      this.dueDate});
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        id: data['id'],
        description: data['description'],
        isDone: data['is_done'] == 0 ? false : true,
        dueDate: data['dueDate'],
      );
  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "description": this.description,
        "is_done": this.isDone == false ? 0 : 1,
        "dueDate": this.dueDate,
      };
}
