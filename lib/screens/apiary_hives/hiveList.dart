import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/hive.dart';

import 'hiveTile.dart';

class HiveList extends StatefulWidget {
  final String userUid;
  final String apiaryID;

  const HiveList(this.userUid, this.apiaryID);
  @override
  _HiveListState createState() => _HiveListState();
}

class _HiveListState extends State<HiveList> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<HiveListModel>(context, listen: false)
          .getHive(widget.userUid, widget.apiaryID);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var hiveList = Provider.of<HiveListModel>(context).hiveList ?? [];
    return ListView.builder(
      itemCount: hiveList.length,
      itemBuilder: (context, index) {
        return HiveTile(
          hive: hiveList[index],
          apiaryID: widget.apiaryID,
          userID: widget.userUid,
        );
      },
    );
  }
}
