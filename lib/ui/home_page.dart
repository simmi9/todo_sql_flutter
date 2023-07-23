import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todomore/bloc/todo_bloc.dart';
import 'package:todomore/model/todo.dart';
import 'package:intl/intl.dart';
import 'package:todomore/ui/widgets/dismissible_card.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  //We load our Todo BLoC that is used to get
  //the stream of Todo for StreamBuilder
  final TodoBloc todoBloc = TodoBloc();
  final String title;

  //Allows Todo card to be dismissable horizontally
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark));

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
              title: const Center(child: Text("Todo App")),
              bottom: const TabBar(tabs: [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Done",
                ),
                Tab(text: "Not Done")
              ])),
          body: TabBarView(
            children: [
              SafeArea(
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 2.0, bottom: 2.0),
                      child: Container(
                          //This is where the magic starts
                          child: getTodosWidget()))),
              SafeArea(
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 2.0, bottom: 2.0),
                      child: Container(
                          //This is where the magic starts
                          child: getTodosWidget()))),
              SafeArea(
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 2.0, right: 2.0, bottom: 2.0),
                      child: Container(
                          //This is where the magic starts
                          child: getTodosWidget()))),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.grey, width: 0.3),
              )),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.indigoAccent,
                        size: 28,
                      ),
                      onPressed: () {
                        //just re-pull UI for testing purposes/ Not
                        todoBloc.getTodos();
                      }),
                  const Expanded(
                    child: Text(
                      "Todo",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'RobotoMono',
                          fontStyle: FontStyle.normal,
                          fontSize: 19),
                    ),
                  ),
                  Wrap(children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 28,
                        color: Colors.indigoAccent,
                      ),
                      onPressed: () {
                        _showTodoSearchSheet(context);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                    )
                  ])
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: FloatingActionButton(
              elevation: 5.0,
              onPressed: () {
                _showAddTodoSheet(context);
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.add,
                size: 32,
                color: Colors.indigoAccent,
              ),
            ),
          )),
    );
  }

  void _showAddTodoSheet(BuildContext context) {
    final _todoDescriptionFormController = TextEditingController();
    final _todoDueDateFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(minHeight: 350, maxHeight: 450),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w400),
                              autofocus: false,
                              decoration: const InputDecoration(
                                  hintText: 'I have to...',
                                  labelText: 'New Todo',
                                  prefixIcon:
                                      Icon(Icons.edit), //icon of text field

                                  labelStyle: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontWeight: FontWeight.w500)),
                              validator: (String? value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Empty description!';
                                  }
                                  return value.contains('')
                                      ? 'Do not use the @ char.'
                                      : null;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        height: 150,
                        child: Center(
                            child: TextField(
                          controller:
                              _todoDueDateFormController, //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: "Enter Due Date" //label text of field
                              ),
                          readOnly: true, // when true user cannot edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate: DateTime(
                                    2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              //get the picked date in the format => 2022-07-04 00:00:00.000
                              String formattedDate = DateFormat('yyyy-MM-dd')
                                  .format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                              //formatted date output using intl package =>  2022-07-04

                              _todoDueDateFormController.text =
                                  formattedDate; //set foratted date to TextField value.
                            } else {
                              print("Date is not selected");
                            }
                          },
                        )),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.save,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  final newTodo = Todo(
                                    description: _todoDescriptionFormController
                                        .value.text,
                                    dueDate:
                                        _todoDueDateFormController.value.text,
                                  );
                                  if (newTodo.description != null &&
                                      newTodo.description!.isNotEmpty) {
                                    /*Create new Todo object and make sure
                                        the Todo description is not empty,
                                        because what's the point of saving empty
                                        Todo
                                        */
                                    todoBloc.addTodo(newTodo);

                                    //dismisses the bottomsheet
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showTodoSearchSheet(BuildContext context) {
    final _todoSearchDescriptionFormController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.transparent,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 25.0, right: 15, bottom: 30),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _todoSearchDescriptionFormController,
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search for todo...',
                                labelText: 'Search *',
                                labelStyle: TextStyle(
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                              validator: (String? value) {
                                if (value != null) {
                                  return value.contains('@')
                                      ? 'Do not use the @ char.'
                                      : null;
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 15),
                            child: CircleAvatar(
                              backgroundColor: Colors.indigoAccent,
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  /*This will get all todos
                                  that contains similar string
                                  in the textform
                                  */
                                  todoBloc.getTodos(
                                      query:
                                          _todoSearchDescriptionFormController
                                              .value.text);
                                  //dismisses the bottomsheet
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget getTodosWidget() {
    /*The StreamBuilder widget,
    basically this widget will take stream of data (todos)
    and construct the UI (with state) based on the stream
    */
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot, context);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot, context) {
    /*Since most of our operations are asynchronous
    at initial state of the operation there will be no stream
    so we need to handle it if this was the case
    by showing users a processing/loading indicator*/
    if (snapshot.hasData) {
      /*Also handles whenever there's stream
      but returned returned 0 records of Todo from DB.
      If that the case show user that you have empty Todos
      */

      List<Todo>? filterDone = [];
      List<Todo>? filterNotDone = [];
      filterDone = snapshot.data?.where((e) => e.isDone == true).toList();
      filterNotDone = snapshot.data?.where((e) => e.isDone == false).toList();
      int currentTabIndex = DefaultTabController.of(context).index;
      return snapshot.data?.length != 0
          ? currentTabIndex == 0
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, itemPosition) {
                    Todo? todo = snapshot.data?[itemPosition];

                    if (todo != null) {
                      final Widget dismissibleCard = DismissibleCardOther(
                          deleteTodo: (direction) {
                            /*
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                            todoBloc.deleteTodoById(todo.id!);
                          },
                          updateTodo: (todo) {
                            //Reverse the value
                            todo.isDone = !todo.isDone;
                            /*
                          
                            This will update Todo isDone with either
                            completed or not
                          */
                            todoBloc.updateTodo(todo);
                          },
                          todo: todo);
                      return dismissibleCard;
                    }
                  },
                )
              : currentTabIndex == 1
                  ? ListView.builder(
                      itemCount: filterDone?.length,
                      itemBuilder: (context, itemPosition) {
                        Todo? todo = filterDone?[itemPosition];
                        if (todo != null) {
                          final Widget dismissibleCard = DismissibleCardOther(
                              deleteTodo: (direction) {
                                /*
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                                todoBloc.deleteTodoById(todo.id!);
                              },
                              updateTodo: (todo) {
                                //Reverse the value
                                todo.isDone = !todo.isDone;
                                /*
                          
                            This will update Todo isDone with either
                            completed or not
                          */
                                todoBloc.updateTodo(todo);
                              },
                              todo: todo);
                          return dismissibleCard;
                        }
                      },
                    )
                  : ListView.builder(
                      itemCount: filterNotDone?.length,
                      itemBuilder: (context, itemPosition) {
                        Todo? todo = filterNotDone?[itemPosition];
                        if (todo != null) {
                          final Widget dismissibleCard = DismissibleCardOther(
                              deleteTodo: (direction) {
                                /*
                    delete Todo item by ID whenever
                    the card is dismissed
                    */
                                todoBloc.deleteTodoById(todo.id!);
                              },
                              updateTodo: (todo) {
                                //Reverse the value
                                todo.isDone = !todo.isDone;
                                /*
                          
                            This will update Todo isDone with either
                            completed or not
                          */
                                todoBloc.updateTodo(todo);
                              },
                              todo: todo);
                          return dismissibleCard;
                        }
                      },
                    )
          : Container(
              child: Center(
              //this is used whenever there 0 Todo
              //in the data base
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        /*since most of our I/O operations are done
        outside the main thread asynchronously
        we may want to display a loading indicator
        to let the use know the app is currently
        processing*/
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    //pull todos again
    todoBloc.getTodos();
    return Container(
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Loading...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget noTodoMessageWidget() {
    return Container(
      child: const Text(
        "Start adding Todo...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  dispose() {
    /*close the stream in order
    to avoid memory leaks
    */
    todoBloc.dispose();
  }
}
