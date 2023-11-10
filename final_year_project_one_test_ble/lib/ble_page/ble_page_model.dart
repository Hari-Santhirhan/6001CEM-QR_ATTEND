class BLEPageModel {
  String ble_name;
  String ble_device_id;
  String ble_room;

  BLEPageModel(
      {required this.ble_name,
      required this.ble_device_id,
      required this.ble_room});

  Map<String, dynamic> bleToMap() {
    return {
      'ble_name': ble_name,
      'ble_device_id': ble_device_id,
      'ble_room': ble_room,
    };
  }
}
