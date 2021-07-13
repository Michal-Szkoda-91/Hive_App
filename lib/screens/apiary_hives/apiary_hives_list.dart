import 'package:flutter/material.dart';
import 'package:wireless_hive/models/apiary.dart';

import 'add_Hive_Screen.dart';
import 'hiveList.dart';

class ApiaryHivesList extends StatelessWidget {
  final Apiary apiary;
  final String uid;
  ApiaryHivesList(this.apiary, this.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text('Twoje ule - ' + apiary.apiaryName),
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/apiary.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: HiveList(uid, apiary.apiaryId),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.blueGrey[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHiveScreen('MT2_GNQAYXf_jH1MdN5', uid),
            ),
          );
        },
      ),
    );
  }
}
