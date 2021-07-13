import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/user.dart';
import 'package:wireless_hive/screens/authenticate/autenticate.dart';
import 'package:wireless_hive/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId>(context);
    // return either Home or Autenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home(userUid: user.uid);
    }
  }
}
