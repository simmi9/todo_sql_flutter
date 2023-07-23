# todomore

A new Flutter project.

## Getting Started

** App Features-
-Tab Bars on top all, done, not done- filtering out the todo snapshot.
-Floating action button to add
-Dismissible cards
-Forms
-Bottoms sheets


** Operations Performed- 
1) Add Todos- The floating action button + , when user clicks on it, a bottom sheet is displayed which has 2 field one for description and another for due date. 
- Both are mandatory , but if one does not enter due date , the default date  is set which is today.
2) Update Todo- a checkbox updates the todo status to done and not done.
3) Delete the Todo- we can delete the todo by swiping horizontally to a particular todo.
4) Search Todo- we can search a todo by typing the keyword of the todo, from bottom navigation bar - bottom sheet appears for the same.
5) Due date appears red if date is today.

6) get todos and get all todos, to show the list of the todos after changes.

**Architecture
Data layer- for Database access and operations, and models
Business Layer- for repository, blocs, logic
Presentation Layer- UI layer- widgets, pages  

- Using Steam Builder for continious monitoring the todo state.
- Created a sql lite database and a table in it to store the todos. 
- Created the TodoBloc ( not using event and states for this iteration) for performing operations.
- Added comments for explaination of every operation.

**steps to run-
fork/ clone the app
- make sure you have latest version of flutter installed
-  run it on android or iphone. Certain features of sqllite do not work on flutter web.
- ms setting for developer might be needed to be set.

## screen shots
add_todo.png, 
done_todo.png, 
not_done_todo.png,
search_todo.png, 
todo_All.png



