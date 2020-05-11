import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stickynotes/service/note_service.dart';
import 'package:stickynotes/ui/home_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteService = Provider.of<NoteService>(context, listen: false);
    return ScopedModel<NoteModel>(
      model: NoteModel(stream: noteService.noteStream),
      child: HomePage(noteService),
    );
  }
}
