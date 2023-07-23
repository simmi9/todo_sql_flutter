import 'package:flutter/material.dart';
import 'package:todomore/model/todo.dart';

class DismissibleCardOther extends StatelessWidget {
  final Function(int) deleteTodo;
  final Function(Todo) updateTodo;
  final Todo todo;
  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  const DismissibleCardOther(
      {super.key,
      required this.deleteTodo,
      required this.updateTodo,
      required this.todo});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.redAccent,
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Deleting",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      onDismissed: (_dismissDirection) => deleteTodo(todo.id!),
      direction: _dismissDirection,
      key: ObjectKey(todo),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          color: Colors.white,
          child: ListTile(
            leading: InkWell(
              onTap: () => updateTodo(todo),
              child: Container(
                //decoration: BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: todo.isDone
                      ? const Icon(
                          Icons.done,
                          size: 26.0,
                          color: Colors.indigoAccent,
                        )
                      : const Icon(
                          Icons.check_box_outline_blank,
                          size: 26.0,
                          color: Colors.tealAccent,
                        ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      todo.description,
                      style: TextStyle(
                          fontSize: 16.5,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "   ${todo.dueDate}",
                      style: TextStyle(
                          fontSize: 16.5,
                          color: Colors.green,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
