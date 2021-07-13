import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class Apiary {
  final String apiaryId;
  final String apiaryName;
  final String address;
  final String uid;

  Apiary({this.apiaryId, this.apiaryName, this.address, this.uid});
}

class ApiaryModelList with ChangeNotifier {
  List<Apiary> _apiaryModelList = [];

  List<Apiary> get apiaryModelList {
    return [..._apiaryModelList];
  }

  Future<void> saveApiary(
      String userUid, String apiaryName, String apiaryAddress) async {
    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        '/$userUid/apiary.json');
    await post(url,
        body: json.encode({
          'apiaryName': apiaryName,
          'address': apiaryAddress,
        }));
    getApiary(userUid);
    notifyListeners();
  }

  Future<void> getApiary(String userUid) async {
    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        '/$userUid/apiary.json');
    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Apiary> loadedApiary = [];
      extractedData.forEach((apiaryId, data) {
        loadedApiary.add(
          Apiary(
            apiaryId: apiaryId,
            apiaryName: data['apiaryName'],
            address: data['address'],
          ),
        );
        _apiaryModelList = [];
        _apiaryModelList = loadedApiary;
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteApiary(String userUid, String apiaryID) async {
    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        ' /$userUid/apiary/$apiaryID.json');
    final existingApiary =
        _apiaryModelList.indexWhere((element) => element.apiaryId == apiaryID);
    var existnigModel = _apiaryModelList[existingApiary];
    _apiaryModelList.removeAt(existingApiary);
    notifyListeners();
    final response = await delete(url);
    if (response.statusCode >= 400) {
      _apiaryModelList.insert(existingApiary, existnigModel);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existnigModel = null;
  }
}
