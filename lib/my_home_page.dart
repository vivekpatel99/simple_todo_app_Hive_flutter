import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_db_example/note_model.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title;
  String newNote;
  Note note;

  final notesBox = Hive.box<Note>('notes');

  void _addNote(Note inputNote) {
    notesBox.add(Note(title: inputNote.title, note: inputNote.note));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    notesBox.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Note taking app using Hive'),
      ),
      body: ListView.builder(
          itemCount: notesBox.length,
          itemBuilder: (BuildContext context, int index) {
            final note = notesBox.get(index);
            print('yahoo');
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.note),
              onLongPress: () {
                notesBox.deleteAt(index);
                print('Note is deleted');
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _simpleDialog(),
        tooltip: 'AddNewNote',
        child: Icon(Icons.add),
      ),
    );
  }

  _simpleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('New Note'),
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => title = value,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Write a Note',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => newNote = value,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              print('button clicked');
                              note = Note(title: title, note: newNote);
                              _addNote(note);
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                          FlatButton(
                            color: Colors.blue,
                            onPressed: () {},
                            child: Text('Cancel'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    notesBox.close();
    super.dispose();
  }
}
