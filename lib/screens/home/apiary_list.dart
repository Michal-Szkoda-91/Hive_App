import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wireless_hive/models/apiary.dart';
import 'package:wireless_hive/screens/home/apiary_tile.dart';

class ApiaryList extends StatefulWidget {
  final String userUid;

  const ApiaryList({Key key, this.userUid}) : super(key: key);
  @override
  _ApiaryListState createState() => _ApiaryListState();
}

class _ApiaryListState extends State<ApiaryList> {
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ApiaryModelList>(context).getApiary(widget.userUid);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final apiary = Provider.of<ApiaryModelList>(context).apiaryModelList ?? [];
    return ListView.builder(
      itemCount: apiary.length,
      itemBuilder: (context, index) {
        return ApiaryTile(
          apiary: apiary[index],
          userId: widget.userUid,
        );
      },
    );
  }
}
