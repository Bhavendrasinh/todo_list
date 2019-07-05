import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../page/addItem.dart';
import '../model/itemModel.dart';
import '../Data/itemBloc.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoList();
  }
}

class _TodoList extends State<TodoList> {
  @override
  void initState() {
    super.initState();
  }

  final TodoBloc todoBloc = TodoBloc();
  final DismissDirection _dismissDirection = DismissDirection.horizontal;
  Color mainColor = const Color(0xff3C3261);

  Widget getTodosWidget() {
    return StreamBuilder(
      stream: todoBloc.todos,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        return getTodoCardWidget(snapshot);
      },
    );
  }

  Widget getTodoCardWidget(AsyncSnapshot<List<Todo>> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data.length != 0
          ? ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Todo todo = snapshot.data[itemPosition];
                final Widget dismissibleCard = new Dismissible(
                    background: Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Deleting",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                    onDismissed: (direction) {
                      todoBloc.deleteTodoById(todo.id);
                    },
                    direction: _dismissDirection,
                    key: new ObjectKey(todo),
                    child: Slidable(
                      delegate: new SlidableDrawerDelegate(),
                      actionExtentRatio: 0.25,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side:
                                BorderSide(color: Colors.grey[200], width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Colors.white,
                          child: ListTile(
                              leading: InkWell(
                                onTap: () {
                                  todo.isDone = !todo.isDone;

                                  todoBloc.updateTodo(todo);
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: todo.isDone
                                        ? Icon(
                                            Icons.done,
                                            size: 26.0,
                                            color: Colors.indigoAccent,
                                          )
                                        : Icon(
                                            Icons.check_box_outline_blank,
                                            size: 26.0,
                                            color: Colors.tealAccent,
                                          ),
                                  ),
                                ),
                              ),
                              title: GestureDetector(
                                onTap: () {
                                  print(todo.id);
                                },
                                child: new Column(
                                 
                                  children: [
                                    new Text(
                                      todo.title,
                                      style: new TextStyle(
                                        
                                          fontSize: 15.0,
                                          fontFamily: 'Arvo',
                                          fontWeight: FontWeight.bold,
                                          color: mainColor,
                                          decoration: todo.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    new Text(
                                      todo.description,
                                      maxLines: 3,
                                      style: new TextStyle(
                                          color: const Color(0xff8785A4),
                                          fontFamily: 'Arvo',
                                          decoration: todo.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    ),
                                    new Text(
                                      todo.date,
                                      style: new TextStyle(
                                          color: const Color(0xff8785A4),
                                          fontFamily: 'Arvo',
                                          decoration: todo.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                    )
                                  ],
                                ),
                              ))),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: 'Edit',
                            color: Colors.black45,
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddItem(
                                      todo.id,
                                      todo.title,
                                      todo.description,
                                      todo.date,
                                      todo.isDone),
                                ),
                              ).then(
                                (bool value) {
                                  if (value) {
                                    loadingData();

                                    print('Value Print:' + value.toString());
                                  }
                                },
                              );
                            }),
                        new IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              todoBloc.deleteTodoById(todo.id);
                              print('Delete');
                            }),
                      ],
                    ));
                return dismissibleCard;
              },
            )
          : Container(
              child: Center(
              child: noTodoMessageWidget(),
            ));
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget loadingData() {
    todoBloc.getTodos();
    return Container(
      child: Center(
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
      child: Text(
        "Start adding Item...",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Center(
          child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
              child: Container(child: getTodosWidget()))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddItem(null, null, null, null, null),
            ),
          ).then(
            (bool value) {
              if (value) {
                loadingData();
                todoBloc.getTodos();
                print('Value Print:' + value.toString());
              }
            },
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
