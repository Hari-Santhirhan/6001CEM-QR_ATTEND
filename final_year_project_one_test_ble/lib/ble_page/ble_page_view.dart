import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/ble_page/ble_controller.dart';
import 'package:final_year_project_one/ble_page/ble_page_model.dart';
import 'package:final_year_project_one/ble_page/ble_page_viewModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../home_page/home_page_view.dart';
import '../profile_page/profile_page_view.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class BLEPageView extends StatefulWidget {
  const BLEPageView({Key? key}) : super(key: key);

  @override
  State<BLEPageView> createState() => _BLEPageViewState();
}

class _BLEPageViewState extends State<BLEPageView> {
  int _selectedIndex = 1;
  late BLEPageViewModel _blePageViewModel;

  TextEditingController classroomController = TextEditingController();
  TextEditingController technicianIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the tree
    classroomController.dispose();
    technicianIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Initializes the viewModel variable
    super.initState();
    _blePageViewModel = BLEPageViewModel();
  }

  String encryptPassword(String normalPassword) {
    final bytes = utf8.encode(normalPassword);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> connectAndCheck(BluetoothDevice device) async {
    try {
      await device.connect();
      print("Connected to ${device.name}");

      // Get a reference to the document with the specified documentId
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('ble')
          .doc(device.remoteId.toString());

      // Use the get() method to retrieve the document snapshot
      DocumentSnapshot docSnapshot = await documentReference.get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Document exists - ble device already registered
        Fluttertoast.showToast(
          msg: "This ble device has already been registered",
          toastLength: Toast.LENGTH_SHORT, // Duration
          gravity: ToastGravity.BOTTOM, // Toast position
          fontSize: 16.0, // Font size of the toast message
        );
        device.disconnect();
      } else {
        // Document does not exist
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Register BLE"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BLE Device ID: ${device.remoteId.toString()}"),
                  TextField(
                    controller: classroomController,
                    decoration: InputDecoration(labelText: "Classroom Number"),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true, // To hide the password
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    // Handle registration logic here
                    String classroom = classroomController.text;
                    String pass = encryptPassword(passwordController.text);

                    if (classroom != null &&
                        classroom != '' &&
                        classroom != "") {
                      // Create a reference to Firestore collection
                      CollectionReference collectionReference =
                          FirebaseFirestore.instance.collection('users');

                      // Perform a query to find matching id and password fields
                      QuerySnapshot querySnapshot = await collectionReference
                          .where('password', isEqualTo: pass)
                          .get();

                      // Check if any documents match the query
                      if (querySnapshot.docs.isNotEmpty) {
                        // UPDATE MODEL FOR FIRESTORE
                        _blePageViewModel.updateBleDetails(
                            device.localName.toString(),
                            device.remoteId.toString(),
                            classroom);

                        Navigator.of(context).pop(); // Close the dialog

                        device.disconnect();

                        Fluttertoast.showToast(
                          msg: "Successfully Registered",
                          toastLength: Toast.LENGTH_SHORT, // Duration
                          gravity: ToastGravity.BOTTOM, // Toast position
                          fontSize: 16.0, // Font size of the toast message
                        );
                      } else {
                        // No documents matched the query
                        Fluttertoast.showToast(
                          msg: "Incorrect Password",
                          toastLength: Toast.LENGTH_SHORT, // Duration
                          gravity: ToastGravity.BOTTOM, // Toast position
                          fontSize: 16.0, // Font size of the toast message
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please Enter Classroom Number",
                        toastLength: Toast.LENGTH_SHORT, // Duration
                        gravity: ToastGravity.BOTTOM, // Toast position
                        fontSize: 16.0, // Font size of the toast message
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    primary: Colors.blue,
                  ),
                  child: Text("Register BLE"),
                ),
                ElevatedButton(
                  onPressed: () {
                    device.disconnect();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    primary: Colors.orange,
                  ),
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error connecting to ${device.name}: $e");
    }
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageViewTech()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BLEPageView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPageTech()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "BLE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () {
                // When the bell icon is pressed
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<BluetoothController>(
            init: BluetoothController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    /*Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          "Bluetooth App",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => controller.scanDevices(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(350, 55),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: const Text(
                          "Scan",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<List<ScanResult>>(
                        stream: controller.scanResults,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final filteredResults = snapshot.data!
                                .where((data) =>
                                    data.rssi >= -35)
                                .toList();

                            if (filteredResults.isEmpty) {
                              return const Center(
                                child:
                                    Text("No devices found with RSSI >= -35"),
                              );
                            } else {
                              return SingleChildScrollView(
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: filteredResults.length,
                                    itemBuilder: (context, index) {
                                      final data = filteredResults[index];
                                      return GestureDetector(
                                        onTap: () {
                                          connectAndCheck(data.device);
                                        },
                                        child: Card(
                                          elevation: 2,
                                          child: ListTile(
                                            title: Text(data.device.name),
                                            subtitle: Text(data.device.id.id),
                                            //subtitle: Text(data.device.id.id),
                                            trailing:
                                                Text(data.rssi.toString()),
                                            //trailing: Text(data
                                            // .advertisementData.
                                            // serviceUuids.toString()),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                          } else {
                            return const Center(
                              child: Text("No devices found"),
                            );
                          }
                        }),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue, // Set selected icon color to blue
        unselectedItemColor: Colors.black, // Set unselected icon color to black
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: "BLE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
