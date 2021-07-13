import 'package:flutter/cupertino.dart';

class UserId {
  final String uid;
  UserId({this.uid});
}

class UserData with ChangeNotifier {
  final String uid;
  final String apiaryName;
  final String address;

  UserData({this.uid, this.apiaryName, this.address});
}
