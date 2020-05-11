import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stickynotes/animation/scale_route.dart';
import 'package:stickynotes/app/session_manager.dart';
import 'package:stickynotes/model/note.dart';
import 'package:stickynotes/model/user.dart';
import 'package:stickynotes/service/note_service.dart';
import 'package:stickynotes/ui/edit_note_page.dart';
import 'package:stickynotes/ui/note_item_tile.dart';
import 'package:stickynotes/ui/plcae_holder_view.dart';

class NoteModel extends Model {
  List<Note> noteList;

  NoteModel({Stream<List<Note>> stream}) {
    stream.listen((notes) {
      this.noteList = notes;
      notifyListeners();
    });
  }
}

class HomePage extends StatelessWidget {
  final NoteService noteService;
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage(this.noteService);

  void _insert(Note note) async {
    final response = await noteService.insert(note);
    if (response > 0) {
      _showSnackBar("Saving Successful");
      noteService.notifyDataSetChange();
    } else
      _showSnackBar("Saving Unsuccessful");
  }

  void _delete(int id) async {
    final response = await noteService.delete(id);
    if (response > 0) {
      _showSnackBar("Deleting Successful");
      noteService.notifyDataSetChange();
    } else
      _showSnackBar("Deleting Unsuccessful");
  }

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                sessionManager.logoutUser();
              })
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context,
              ScaleRoute(page: EditNote(userId: user.id, onInsert: _insert)));
        },
      ),
    );
  }

  Widget _buildContent() {
    return ScopedModelDescendant<NoteModel>(builder: (context, child, model) {
      if (model.noteList != null) {
        if (model.noteList.length > 0) {
          return ListView.builder(
            itemCount: model.noteList.length,
            itemBuilder: (context, index) {
              return NoteItemTile(
                  note: model.noteList[index],
                  onDelete: _delete,
                  key: Key('${model.noteList[index]}'));
            },
          );
        } else
          return PlaceholderView();
      } else
        return Center(child: CircularProgressIndicator());
    });
  }

  void _showSnackBar(String message) {
    final snackbar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
