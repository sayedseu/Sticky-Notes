import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stickynotes/model/note.dart';

class NoteDetails extends StatelessWidget {
  final Note note;

  NoteDetails(this.note);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(note.date, style: TextStyle(fontStyle: FontStyle.italic)),
              SizedBox(
                height: 8,
              ),
              Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
              Divider(
                color: Colors.green,
              ),
              SizedBox(
                height: 8,
              ),
              Text(note.description,
                  style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}
