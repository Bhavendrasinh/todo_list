class Todo {
  int id;

  String title;
  String description;
  String date;

  bool isDone = false;

  Todo({this.id, this.title, this.description, this.date, this.isDone = false});
  factory Todo.fromDatabaseJson(Map<String, dynamic> data) => Todo(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        date: data['date'],
        isDone: data['is_done'] == 0 ? false : true,
      );
  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "title": this.title,
        "description": this.description,
        "date": this.date,
        "is_done": this.isDone == false ? 0 : 1,
      };
}
