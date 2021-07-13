import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/hive.dart';
import 'package:wireless_hive/screens/hiveDetail/hive_detail.dart';

class HiveTile extends StatelessWidget {
  final HiveModel hive;
  final String apiaryID;
  final String userID;

  const HiveTile({this.hive, this.apiaryID, this.userID});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blueGrey[50],
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            child: ListTile(
              title: Text(hive.name),
              trailing: IconButton(
                icon: Icon(
                  Icons.house_siding,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                onPressed: () => _navigateToHiveDetailScreen(context, hive),
              ),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Usuń',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                Provider.of<HiveListModel>(context, listen: false)
                    .deleteHive(userID, apiaryID, hive.hiveId);
              },
            ),
          ],
        ),
      ),
    );
  }

  //funkcja nawigujaca do ekranu zawierajacego liste ulow z danej pasieki
  void _navigateToHiveDetailScreen(BuildContext ctx, HiveModel hive) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (context) {
        return HiveDetailScreen(hive, userID, apiaryID);
      }),
    );
  }
}
