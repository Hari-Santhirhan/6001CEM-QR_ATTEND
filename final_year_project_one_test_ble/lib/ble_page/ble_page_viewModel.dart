// Function to connect to the selected device
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/ble_page/ble_page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEPageViewModel extends ChangeNotifier {
  BLEPageModel _blePageModel = BLEPageModel(
      ble_name: '',
      ble_device_id: '',
      ble_room: '');

  Future<void>? bleRegistration() async {
    // Access the Firestore collection
    final CollectionReference reportsCollection =
    FirebaseFirestore.instance.collection('ble');

    // Convert the ble model to a map
    Map<String, dynamic> reportData = _blePageModel.bleToMap();

    // Add the ble registration info into Firestore
    await reportsCollection.doc(_blePageModel.ble_device_id).set(reportData);
  }

  void updateBleDetails(
      String bleName,
      String bleID,
      String bleRoom) {
    _blePageModel.ble_name = bleName;
    _blePageModel.ble_device_id = bleID;
    _blePageModel.ble_room = bleRoom;
    bleRegistration();
  }
}
