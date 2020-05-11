import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stickynotes/model/note.dart';

class EditNote extends StatefulWidget {
  EditNote({Key key, this.userId, this.onInsert}) : super(key: key);
  final int userId;
  final ValueChanged<Note> onInsert;
  static final String _date = DateFormat("yMMMMEEEEd").format(DateTime.now());
  static final _formKey = GlobalKey<FormState>();

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  static String _title, _description;

  void _validateAndSave(BuildContext context) {
    final currentState = EditNote._formKey.currentState;
    if (currentState.validate()) {
      currentState.save();
      print(_title);
      Note note = Note(
          userId: widget.userId,
          title: _title,
          description: _description,
          date: EditNote._date);
      widget.onInsert(note);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _validateAndSave(context);
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: EditNote._formKey,
              child: Column(
                children: <Widget>[
                  Text(EditNote._date),
                  TextFormField(
                    key: Key("title"),
                    decoration: InputDecoration(
                        labelText: "Title *", border: InputBorder.none),
                    onSaved: (value) => _title = value,
                    validator: (value) =>
                        value.isEmpty ? "Please give a title" : null,
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    autovalidate: true,
                    key: Key("description"),
                    decoration: InputDecoration(
                        hintText: "Descriptions...", border: InputBorder.none),
                    onSaved: (value) => _description = value,
                    maxLines: 9999,
                    keyboardType: TextInputType.multiline,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
