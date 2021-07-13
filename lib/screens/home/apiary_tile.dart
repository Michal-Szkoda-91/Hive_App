import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/apiary.dart';
import 'package:wireless_hive/screens/apiary_hives/apiary_hives_list.dart';

class ApiaryTile extends StatelessWidget {
  final String userId;
  final Apiary apiary;
  ApiaryTile({this.apiary, this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blueGrey[100],
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            child: ListTile(
              leading: CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.blueGrey,
                backgroundImage: AssetImage('assets/vector_bg.jpg'),
              ),
              title: Text(apiary.apiaryName),
              subtitle: Text(apiary.address),
              trailing: IconButton(
                icon: Icon(
                  Icons.format_list_bulleted,
                  size: 30,
                  color: Colors.blueGrey[800],
                ),
                onPressed: () => _navigateToHiveListScreen(context, apiary),
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Usuń',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                Provider.of<ApiaryModelList>(context, listen: false)
                    .deleteApiary(
                  userId,
                  apiary.apiaryId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //funkcja nawigujaca do ekranu zawierajacego liste ulow z danej pasieki
  void _navigateToHiveListScreen(BuildContext ctx, Apiary apiary) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (context) {
        return ApiaryHivesList(apiary, userId);
      }),
    );
  }
}
