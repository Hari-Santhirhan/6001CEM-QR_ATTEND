import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController{

  Future<void>? scanDevices(){
    // Start scan for 5 seconds
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    // Stop scan
    // FlutterBluePlus.stopScan();
  }

  // Shows all available devices by making a getter
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
}