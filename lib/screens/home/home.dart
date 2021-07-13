import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/apiary.dart';
import 'package:wireless_hive/screens/addApiary/add_apiary_screen.dart';
import 'package:wireless_hive/screens/home/apiary_list.dart';
import 'package:wireless_hive/services/auth.dart';
import 'package:wireless_hive/services/database.dart';

class Home extends StatelessWidget {
  final String userUid;
  final AuthService _auth = AuthService();

  Home({this.userUid});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Apiary>>.value(
      value: DatabaseService().apiary,
      initialData: [],
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          title: Text('Twoje pasieki'),
          backgroundColor: Colors.deepOrange[900],
          elevation: 0.0,
          actions: [
            TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  Text(
                    'Wyloguj',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/apiary.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ApiaryList(
              userUid: userUid,
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.blueGrey[700],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddApiaryScreen(userUid),
              ),
            );
          },
        ),
      ),
    );
  }
}
