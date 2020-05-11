import 'package:flutter/material.dart';
import 'package:stickynotes/animation/scale_rotate_route.dart';
import 'package:stickynotes/model/note.dart';
import 'package:stickynotes/ui/details_page.dart';

class NoteItemTile extends StatelessWidget {
  final Note note;
  final ValueChanged<int> onDelete;
  final Key key;

  NoteItemTile({this.note, this.onDelete, this.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      background: Container(
        color: Colors.green,
      ),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => onDelete(note.id),
      child: InkWell(
        onTap: () {
          Navigator.push(context, ScaleRotateRoute(page: NoteDetails(note)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                '${note.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${note.date}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                  child: Text('${note.title[0].toUpperCase()}',
                      style: TextStyle(fontSize: 20))),
            ),
            Divider(color: Colors.green)
          ],
        ),
      ),
    );
  }
}
