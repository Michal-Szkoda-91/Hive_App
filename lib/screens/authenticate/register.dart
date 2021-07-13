import 'package:flutter/material.dart';
import 'package:wireless_hive/services/auth.dart';
import 'package:wireless_hive/shared/constants.dart';
import 'package:wireless_hive/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepOrange[900],
              elevation: 0.0,
              title: Text('Rejestracja'),
              actions: [
                TextButton.icon(
                    icon: Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      'Zaloguj się',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      widget.toggleView();
                    })
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/apiary.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Wpisz email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Hasło'),
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Hasło powinno mieć minimum 6 znaków'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueGrey[700]),
                      ),
                      child: Text(
                        'Utwórz konto',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = _auth.registerWithEmailAndPassword(
                              email, password);
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'Wprowadź prawidłowy adres email';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(
                          color: Colors.redAccent[700], fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
