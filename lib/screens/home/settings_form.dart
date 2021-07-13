import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/user.dart';
import 'package:wireless_hive/services/database.dart';
import 'package:wireless_hive/shared/constants.dart';
import 'package:wireless_hive/shared/loading.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form valued
  String _currentApiaryName;
  String _currentAddress;
  String _uid;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your apiary settings',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.apiaryName,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'please enter a name' : null,
                    onChanged: (val) =>
                        setState(() => _currentApiaryName = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userData.address,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'please enter an address' : null,
                    onChanged: (val) => setState(() => _currentAddress = val),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[700]),
                      ),
                      child: Text(
                        'update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentApiaryName ?? snapshot.data.apiaryName,
                              _currentAddress ?? userData.address,
                              _uid ?? '');
                          Navigator.pop(context);
                        }
                      }),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[700]),
                      ),
                      child: Text(
                        'delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await DatabaseService(uid: user.uid).deleteUserData(
                            _currentApiaryName, _currentAddress);
                        return DatabaseService(uid: user.uid)
                            .updateUserData('apiaryName', 'address', 'uid');
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
