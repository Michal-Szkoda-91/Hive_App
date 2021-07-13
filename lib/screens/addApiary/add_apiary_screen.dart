import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/apiary.dart';

class AddApiaryScreen extends StatefulWidget {
  final String uderUid;

  const AddApiaryScreen(this.uderUid);
  @override
  _AddApiaryScreenState createState() => _AddApiaryScreenState();
}

class _AddApiaryScreenState extends State<AddApiaryScreen> {
  TextEditingController _nameControler = TextEditingController();
  TextEditingController _adressControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[400],
      appBar: AppBar(
        title: Text('Utwórz pasiekę'),
        backgroundColor: Colors.deepOrange[900],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _nameControler,
                decoration: InputDecoration(
                  hintText: 'Nazwa pasieki',
                ),
              ),
              TextField(
                controller: _adressControler,
                decoration: InputDecoration(
                  hintText: 'Adres',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Buttons(
                widget: widget,
                nameControler: _nameControler,
                adressControler: _adressControler,
                context: context,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final AddApiaryScreen widget;
  final TextEditingController nameControler;
  final TextEditingController adressControler;
  final BuildContext context;

  const Buttons(
      {this.widget, this.nameControler, this.adressControler, this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey)),
          onPressed: _cancel,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Anuluj',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueGrey)),
          onPressed: () {
            if (nameControler.text == '' || adressControler.text == '') {
              showAlertDialog(context);
            } else {
              Provider.of<ApiaryModelList>(context, listen: false).saveApiary(
                  widget.uderUid, nameControler.text, adressControler.text);
              _cancel();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _cancel() {
    nameControler.text = '';
    adressControler.text = '';
    Navigator.of(context).pop();
  }

  showAlertDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nie udało się dodać pasieki!'),
          content: Text('Uzupelnij nazwę oraz adres!'),
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
