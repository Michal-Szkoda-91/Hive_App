import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/hive.dart';

import 'chartCard.dart';

class HiveDetailScreen extends StatefulWidget {
  final String userUID;
  final String apiaryId;
  final HiveModel hive;

  const HiveDetailScreen(this.hive, this.userUID, this.apiaryId);
  @override
  _HiveDetailScreenState createState() => _HiveDetailScreenState();
}

class _HiveDetailScreenState extends State<HiveDetailScreen> {
  //zmienne odpowiadajace za ustawianie danych w ulu
  String dateTime;
  bool isMotherInside;
  double temperament;
  double condition;
  TextEditingController _notesController = TextEditingController();
  String notes;

  @override
  void initState() {
    //inicjalizacja zmiennych
    dateTime = widget.hive.inspectionDate;
    isMotherInside = widget.hive.isMotherInside;
    temperament = widget.hive.temperament;
    condition = widget.hive.condition;
    notes = widget.hive.notes;
    _notesController.text = notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[900],
        title: Text(widget.hive.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(
                icon: Icon(
                  Icons.save,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: _saveHive),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/apiary.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            //kolejne karty - widgety urworzone, kazda jako parametr przyjmuje wybrany ul
            children: [
              buildInspectionDateWidget(context),
              buildContainerIsMotherInside(context),
              buildContainerTemeperament(context),
              buildContainerCondition(context),
              ChartCard(
                hive: widget.hive,
              ),
              buildContainerNotes(context),
            ],
          ),
        ),
      ),
    );
  }

  void _saveHive() {
    HiveModel model = HiveModel(
      hiveId: widget.hive.hiveId,
      name: widget.hive.name,
      apiaryID: widget.hive.apiaryID,
      humidity: widget.hive.humidity,
      humidityDate: widget.hive.humidityDate,
      tempInside: widget.hive.tempInside,
      tempInsideDate: widget.hive.tempInsideDate,
      tempOutside: widget.hive.tempOutside,
      tempOutsideDate: widget.hive.tempOutsideDate,
      weight: widget.hive.weight,
      weightDate: widget.hive.weightDate,
      isMotherInside: isMotherInside,
      inspectionDate: dateTime,
      condition: condition,
      temperament: temperament,
      notes: notes,
    );

    Provider.of<HiveListModel>(context, listen: false).updateProduct(
      hive: model,
      id: widget.hive.hiveId,
      userId: widget.userUID,
      apiaryId: widget.apiaryId,
    );
    Navigator.of(context).pop();
  }

  Container buildContainerNotes(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.deepOrange[200],
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
      ),
    );
  }

  Container buildContainerCondition(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: Colors.deepOrange[200],
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Kondycja:',
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
          ),
        ),
      ),
    );
  }

  Icon buildIcon(IconData icon, Color color) {
    return Icon(
      icon,
      size: 35,
      color: color,
    );
  }

  Container buildContainerTemeperament(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: Colors.deepOrange[200],
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Temperament:',
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
                          : null,
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainerIsMotherInside(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: Colors.deepOrange[200],
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Matka:',
                style: Theme.of(context).textTheme.headline1,
              ),
              FlutterSwitch(
                  activeColor: Colors.green,
                  value: isMotherInside,
                  onToggle: (val) {
                    setState(() {
                      isMotherInside = val;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Container buildInspectionDateWidget(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: Colors.deepOrange[200],
        margin: EdgeInsets.all(10),
        elevation: 15,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Data inspekcji:',
                style: Theme.of(context).textTheme.headline1,
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepOrange[400])),
                child: Text(
                  dateTime,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  ).then((date) {
                    setState(() {
                      dateTime =
                          DateFormat('yyyy-MM-dd').format(date).toString();
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
