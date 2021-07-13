import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class HiveModel {
  final String hiveId;
  final String name;
  final String apiaryID;
  final String inspectionDate;
  List<double> tempInside = [];
  List<double> tempInsideDate = [];
  List<double> humidity = [];
  List<double> humidityDate = [];
  List<double> weight = [];
  List<double> weightDate = [];
  List<double> tempOutside = [];
  List<double> tempOutsideDate = [];
  final bool isMotherInside;
  final double temperament;
  final double condition;
  final String notes;

  HiveModel({
    this.hiveId,
    this.name,
    this.apiaryID,
    this.inspectionDate,
    this.tempInside,
    this.tempInsideDate,
    this.humidity,
    this.humidityDate,
    this.weight,
    this.weightDate,
    this.tempOutside,
    this.tempOutsideDate,
    this.isMotherInside,
    this.temperament,
    this.condition,
    this.notes,
  });
}

class HiveListModel with ChangeNotifier {
  List<HiveModel> _hiveListModel = [];

  List<HiveModel> get hiveList {
    return [..._hiveListModel];
  }

  Future<void> saveHive(
      String userUid,
      String apiaryID,
      String hiveName,
      String inspectionDate,
      bool isMotherInside,
      double temperament,
      double condition,
      String notes) async {
    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        '/$userUid/apiary/$apiaryID/hive.json');
    await post(url,
        body: json.encode({
          'hiveName': hiveName,
          'inspectionDate': inspectionDate,
          'tempInside': [],
          'tempInsideDate': [],
          'humidity': [],
          'humidityDate': [],
          'weight': [],
          'weightDate': [],
          'tempOutside': [],
          'tempOutsideDate': [],
          'isMotherInside': isMotherInside,
          'temperament': temperament,
          'condition': condition,
          'notes': notes,
        }));
    getHive(userUid, apiaryID);
    notifyListeners();
  }

  Future<void> getHive(String userUid, String apiaryID) async {
    _hiveListModel = [];

    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        '/$userUid/apiary/$apiaryID/hive.json');

    try {
      final response = await get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<HiveModel> loadedHive = [];

      extractedData.forEach(
        (hiveID, data) {
          loadedHive.add(
            HiveModel(
              hiveId: hiveID,
              name: data['hiveName'],
              inspectionDate: data['inspectionDate'],
              isMotherInside: data['isMotherInside'],
              temperament: data['temperament'],
              condition: data['condition'],
              notes: data['notes'],
            ),
          );
        },
      );
      _hiveListModel = [];
      _hiveListModel = loadedHive;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteHive(
      String userUid, String apiaryID, String hiveID) async {
    var url = Uri.https(
        'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
        '/$userUid/apiary/$apiaryID/hive/$hiveID.json');
    final existingHive =
        _hiveListModel.indexWhere((element) => element.hiveId == hiveID);
    var existingModel = _hiveListModel[existingHive];
    _hiveListModel.removeAt(existingHive);
    notifyListeners();
    final response = await delete(url);
    if (response.statusCode >= 400) {
      _hiveListModel.insert(existingHive, existingModel);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingModel = null;
  }

  Future<void> updateProduct(
      {String id, HiveModel hive, String userId, String apiaryId}) async {
    final hiveIndex = _hiveListModel.indexWhere((hive) => hive.hiveId == id);
    if (hiveIndex >= 0) {
      var url = Uri.https(
          'wireless-hive-default-rtdb.europe-west1.firebasedatabase.app',
          '/$userId/apiary/$apiaryId/hive.json');
      await patch(url,
          body: json.encode({
            'hiveName': hive.name,
            'inspectionDate': hive.inspectionDate,
            'tempInside': hive.tempInside,
            'tempInsideDate': hive.tempInsideDate,
            'humidity': hive.humidity,
            'humidityDate': hive.humidityDate,
            'weight': hive.weight,
            'weightDate': hive.weightDate,
            'tempOutside': hive.tempOutside,
            'tempOutsideDate': hive.tempOutsideDate,
            'isMotherInside': hive.isMotherInside,
            'temperament': hive.temperament,
            'condition': hive.condition,
            'notes': hive.notes,
          }));
      _hiveListModel[hiveIndex] = hive;
      notifyListeners();
    } else {
      throw HttpException('Could not update product.');
    }
  }

  Future<void> getDetectorDataToHive(String hiveID) async {
    //Temperatura wewnatrz
    List<double> tempInsideTemporary = [];
    List<double> tempInsideDateTemporary = [];
    //wilgotnosc
    List<double> humidityTemporary = [];
    List<double> humidityDateTemporary = [];
    //waga
    List<double> weightTemporary = [];
    List<double> weightDateTemporary = [];
    //temperatura na zewnatrz
    List<double> tempOutsideTemporary = [];
    List<double> tempOutsideDateTemporary = [];

    final responseTempInside = await get(Uri.parse(
        'https://api.thingspeak.com/channels/1255834/fields/1.json?results=10'));
    final responseHumidity = await get(Uri.parse(
        'https://api.thingspeak.com/channels/1255834/fields/2.json?results=10'));
    final responseWeight = await get(Uri.parse(
        'https://api.thingspeak.com/channels/1255834/fields/5.json?results=10'));
    final responseTempOutside = await get(Uri.parse(
        'https://api.thingspeak.com/channels/1255834/fields/3.json?results=10'));

    //pobranie listy temperatur oraz czasow, ostatnie 10 wpisow
    dynamic valueTemInside = json.decode(responseTempInside.body);
    dynamic valueHumidity = json.decode(responseHumidity.body);
    dynamic valueWeight = json.decode(responseWeight.body);
    dynamic valueTemOutside = json.decode(responseTempOutside.body);

    Map<String, dynamic> mapTempInside = valueTemInside;
    Map<String, dynamic> mapHumidity = valueHumidity;
    Map<String, dynamic> mapWeight = valueWeight;
    Map<String, dynamic> mapTempOutside = valueTemOutside;
    for (var i = 0; i < 10; i++) {
      //Temperatura wewnatrz
      tempInsideTemporary
          .add(double.parse(mapTempInside['feeds'][i]['field1']));
      tempInsideDateTemporary.add(double.parse(mapTempInside['feeds'][i]
              ['created_at']
          .toString()
          .split('T')[1]
          .substring(0, 2)));
      //wilgotnosc
      humidityTemporary.add(double.parse(mapHumidity['feeds'][i]['field2']));
      humidityDateTemporary.add(double.parse(mapHumidity['feeds'][i]
              ['created_at']
          .toString()
          .split('T')[1]
          .substring(0, 2)));

      //wwaga
      weightTemporary.add(double.parse(
          mapWeight['feeds'][i]['field5'].toString().substring(0, 4)));
      weightDateTemporary.add(double.parse(mapWeight['feeds'][i]['created_at']
          .toString()
          .split('T')[1]
          .substring(0, 2)));

      //temperatura na zewnatrz
      tempOutsideTemporary
          .add(double.parse(mapTempOutside['feeds'][i]['field3']));
      tempOutsideDateTemporary.add(double.parse(mapTempOutside['feeds'][i]
              ['created_at']
          .toString()
          .split('T')[1]
          .substring(0, 2)));
    }

    //zapis do modelu ula
    _hiveListModel.forEach((element) {
      if (element.hiveId == hiveID) {
        //temp wewnatrz
        element.tempInside = tempInsideTemporary;
        element.tempInsideDate = tempInsideDateTemporary;
        //wilgotnosc
        element.humidity = humidityTemporary;
        element.humidityDate = humidityDateTemporary;
        //waga
        element.weight = weightTemporary;
        element.weightDate = weightDateTemporary;
        //temp na zewnatrz
        element.tempOutside = tempOutsideTemporary;
        element.tempOutsideDate = tempOutsideDateTemporary;
      }
    });
    notifyListeners();
  }
}
