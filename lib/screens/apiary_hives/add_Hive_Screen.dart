import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/hive.dart';

class AddHiveScreen extends StatefulWidget {
  final String apiaryId;
  final String userUid;

  const AddHiveScreen(this.apiaryId, this.userUid);
  @override
  _AddHiveScreenState createState() => _AddHiveScreenState();
}

class _AddHiveScreenState extends State<AddHiveScreen> {
  //zmienne dodawane do utworzonego ula
  TextEditingController _nameControler = TextEditingController();
  String dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  bool isMotherInside = false;
  double temperament = 0;
  double condition = 0;
  String notes = 'Wpisz notatki';
  TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _notesController.text = notes;
    return Scaffold(
      backgroundColor: Colors.deepOrange[400],
      appBar: AppBar(
        title: Text('Dodaj nowy UL'),
        backgroundColor: Colors.deepOrange[900],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameControler,
                  decoration: InputDecoration(
                    hintText: 'Nazwa ula',
                  ),
                ),
                SizedBox(height: 20),
                buildRowCalendar(context),
                SizedBox(height: 20),
                buildRowMotherInside(),
                SizedBox(height: 20),
                buildRowTemperament(context),
                SizedBox(height: 20),
                buildRowCondition(context),
                SizedBox(height: 20),
                buildCardNotes(context),
                SizedBox(height: 20),
                Buttons(
                  ctx: context,
                  apiaryId: widget.apiaryId,
                  userUid: widget.userUid,
                  nameControler: _nameControler,
                  dateTime: dateTime,
                  isMotherInside: isMotherInside,
                  temperament: temperament,
                  condition: condition,
                  notes: notes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//metoda pozwalajaca dodawac notatki
  Card buildCardNotes(BuildContext context) {
    return Card(
      color: Colors.orange[100],
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
                  onPressed: () {
                    setState(() {
                      notes = _notesController.text;
                      _notesController.text = '';
                    });
                  },
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
    );
  }

//metoda pozwalajaca ustawic kondycje
  Row buildRowCondition(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Kondycja: ',
          softWrap: true,
          style: Theme.of(context).textTheme.headline2,
        ),
        FittedBox(
          child: Slider(
            activeColor: condition == 0.0
                ? Colors.red
                : condition == 1
                    ? Colors.yellow
                    : condition == 2
                        ? Colors.green
                        : null,
            max: 2,
            min: 0,
            divisions: 2,
            // value: widget.hive.conditions,
            value: condition,
            onChanged: (val) {
              setState(
                () {
                  condition = val;
                },
              );
            },
          ),
        ),
        condition == 0.0
            ? buildIcon(Icons.sentiment_dissatisfied, Colors.red)
            : condition == 1
                ? buildIcon(Icons.sentiment_neutral, Colors.yellow)
                : condition == 2
                    ? buildIcon(Icons.sentiment_satisfied, Colors.green)
                    : null
      ],
    );
  }

  Icon buildIcon(IconData icon, Color color) {
    return Icon(
      icon,
      size: 35,
      color: color,
    );
  }

//metoda pozwalajaca ustawic temperament
  Row buildRowTemperament(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Temperament: ',
          softWrap: true,
          style: Theme.of(context).textTheme.headline2,
        ),
        FittedBox(
          child: Slider(
            activeColor: temperament == 0.0
                ? Colors.red
                : temperament == 1
                    ? Colors.yellow
                    : temperament == 2
                        ? Colors.green
                        : null,
            max: 2,
            min: 0,
            divisions: 2,
            value: temperament,
            onChanged: (val) {
              setState(
                () {
                  temperament = val;
                },
              );
            },
          ),
        ),
        temperament == 0.0
            ? buildIcon(Icons.sentiment_dissatisfied, Colors.red)
            : temperament == 1
                ? buildIcon(Icons.sentiment_neutral, Colors.yellow)
                : temperament == 2
                    ? buildIcon(Icons.sentiment_satisfied, Colors.green)
                    : null
      ],
    );
  }

//metoda oznaczania czy w ulu jest matka
  Row buildRowMotherInside() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Czy jest matka w ulu?',
          style: TextStyle(fontSize: 18),
        ),
        FlutterSwitch(
            activeColor: Colors.orange[600],
            // value: widget.hive.isMotherInside == 1 ? true : false,
            value: isMotherInside,
            onToggle: (val) {
              setState(() {
                isMotherInside = val;
              });
            }),
      ],
    );
  }

//wyswietlanie i dodawanie daty inspeckji
  Row buildRowCalendar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2050),
            ).then((date) {
              setState(() {
                dateTime = DateFormat('yyyy-MM-dd').format(date).toString();
              });
            });
          },
          child: Text(
            'Data inspekcji',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          dateTime,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  final String userUid;
  final String apiaryId;
  final TextEditingController nameControler;
  final BuildContext ctx;
  final String dateTime;
  final bool isMotherInside;
  final double temperament;
  final double condition;
  final String notes;

  const Buttons({
    this.nameControler,
    this.ctx,
    this.userUid,
    this.apiaryId,
    this.dateTime,
    this.isMotherInside,
    this.temperament,
    this.condition,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
          onPressed: _cancel,
          child: Text(
            'Anuluj',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange)),
          onPressed: () {
            if (nameControler.text == '') {
              showAlertDialog(ctx);
            } else {
              Provider.of<HiveListModel>(ctx, listen: false).saveHive(
                userUid,
                apiaryId,
                nameControler.text,
                dateTime,
                isMotherInside,
                temperament,
                condition,
                notes,
              );
              _cancel();
            }
            //
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _cancel() {
    nameControler.text = '';
    Navigator.of(ctx).pop();
  }

  showAlertDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nie udało się dodać ula!'),
          content: Text('Uzupelnij nazwę'),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
