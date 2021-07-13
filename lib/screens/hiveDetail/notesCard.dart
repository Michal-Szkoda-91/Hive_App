import 'package:flutter/material.dart';
import 'package:wireless_hive/models/hive.dart';

class NotesCard extends StatefulWidget {
  NotesCard({
    @required this.hive,
  });

  final HiveModel hive;

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  TextEditingController _notesController = TextEditingController();
  @override
  void initState() {
    _notesController.text = widget.hive.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.orange[200],
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notatki',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ),
                    onPressed: saveNotes,
                  )
                ],
              ),
              Divider(),
              TextField(
                controller: _notesController,
                style: Theme.of(context).textTheme.headline2,
                minLines: 2,
                maxLines: 30,
                autocorrect: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveNotes() {
    //tu nalezy zapisac zmienione dane w bazie
  }
}
