import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter/services.dart';
import '../Data/itemBloc.dart';
import '../model/itemModel.dart';
import 'package:date_format/date_format.dart';

class AddItem extends StatefulWidget {
  final id;
  final title;
  final description;
  final date;
  final idDone;

  AddItem(this.id, this.title, this.description, this.date, this.idDone);
  @override
  State<StatefulWidget> createState() {
    return _AddItem();
  }
}

class _ItemData {
  String title = '';
  String desc = '';
}

class _AddItem extends State<AddItem> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _ItemData _item = new _ItemData();

  String _date = "YYYY-MM-DD";

  final TodoBloc todoBloc = TodoBloc();
  @override
  void initState() {
    if (widget.id != null) {
      _date = widget.date;
    }

    super.initState();
  }

  String _validateTitle(String value) {
    if (value.length == 0) {
      return 'The Title must be at Enter';
    }

    return null;
  }

  String _validateDesc(String value) {
    if (value.trim().length == 0) {
      return 'The Short Description must be at Enter';
    }

    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      final newTodo = Todo(
          title: _item.title, description: _item.desc, date: _date.toString());
      if (newTodo.description.isNotEmpty) {
        todoBloc.addTodo(newTodo);
      }
      Navigator.pop(context, true);
      //  print('Printing the login data.');
      print('Title: ${_item.title}');
      print('Description: ${_item.desc}');
      print('Date: $_date');
    }
  }

  void update() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      final newTodo = Todo(
          title: _item.title,
          description: _item.desc,
          date: _date.toString(),
          id: widget.id,
          isDone: widget.idDone);
      if (newTodo.description.isNotEmpty) {
        todoBloc.updateTodo(newTodo);
        Navigator.pop(context, true);
      }

      print('Update');
      print('Title: ${_item.title}');
      print('Description: ${_item.desc}');
      print('Date: $_date');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Item'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    initialValue: widget.id == null ? '' : widget.title,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'Title', labelText: 'Title'),
                    validator: this._validateTitle,
                    onSaved: (String value) {
                      this._item.title = value;
                    }),
                new TextFormField(
                    initialValue: widget.id == null ? '' : widget.description,
                    decoration: new InputDecoration(
                        hintText: 'Description',
                        labelText: 'Enter your Description'),
                    validator: this._validateDesc,
                    onSaved: (String value) {
                      this._item.desc = value;
                    }),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1950, 3, 5),
                          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          DateTime _datee = date;
                          // _date =
                          _date = formatDate(_datee, [yyyy, '-', mm, '-', dd]);
                        });

                        print('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.blue),
                    )),
                new Text("Date:$_date"),
                new Container(
                  width: screenSize.width,
                  child: widget.id == null
                      ? new RaisedButton(
                          child: new Text(
                            'Save',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: this.submit,
                          color: Colors.green,
                        )
                      : new RaisedButton(
                          child: new Text(
                            'Update',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: this.update,
                          color: Colors.green,
                        ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }
}
