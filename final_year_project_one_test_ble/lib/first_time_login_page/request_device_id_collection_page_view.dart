import 'dart:convert';
import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RequestDeviceID extends StatefulWidget {
  final studentEmailRequest;
  const RequestDeviceID({
    Key? key,
    required this.studentEmailRequest,
  }) : super(key: key);

  @override
  State<RequestDeviceID> createState() => _RequestDeviceIDState();
}

class _RequestDeviceIDState extends State<RequestDeviceID> {
  static const _androidIdPlugin = AndroidId();
  var _androidId = 'Unknown';
  late String deviceID;

  @override
  void initState() {
    super.initState();
    _initAndroidId();
  }

  Future<void> searchDocumentByDeviceId() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference usersCollection = firestore.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where(
            'email',
            isEqualTo: widget.studentEmailRequest,
          )
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference documentReference =
            querySnapshot.docs[0].reference;

        final Map<String, dynamic> dataToUpdate = {
          'imei':
              deviceID,
        };
        try {
          await documentReference.update(dataToUpdate);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Device ID Collected!!!"),
                content: Text("Your new device has been successfully "
                    "registered to the system!"),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print('Error updating document field: $e');
        }
      }
    } catch (e) {
      print('Error searching for documents: $e');
    }
  }

  Future<void> _initAndroidId() async {
    String androidId;
    try {
      androidId = await _androidIdPlugin.getId() ?? 'Unknown ID';
    } on PlatformException {
      androidId = 'Failed to get Android ID.';
    }

    _androidId = androidId;
    final bytesAndroidID = utf8.encode(_androidId);
    final hashAndroidID = sha256.convert(bytesAndroidID);
    deviceID = hashAndroidID.toString();

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0075FF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                // BEFORE Title
                height: 20,
              ),
              Center(
                // For the QR ATTEND Title with Image
                child: Container(
                  width: 175,
                  height: 145,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: [
                            Text(
                              // QR
                              "QR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.black.withOpacity(0.5),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ],
                                ),
                                child: Image(
                                  image: AssetImage('assets/QR.PNG'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        // QR
                        "ATTEND",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black.withOpacity(0.5),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                // AFTER Title
                height: 5,
              ),
              Align(
                // For the Login Text
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                  child: Text(
                    "Request Device ID",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          )
                        ]),
                  ),
                ),
              ),
              SizedBox(
                // AFTER Login Text
                height: 10,
              ),
              Center(
                child: Container(
                  // Login Container
                  width: 320,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(17, 40, 17, 0),
                        child: Text(
                          "By clicking accept, you agree to allow the "
                          "app to collect your device ID.\n\n"
                          "If you do not agree to this, you may click "
                          "on the 'Back to Profile Page' button "
                          "to decline",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        // To set the width and height of the button
                        width: 200,
                        height: 50,
                        child: FloatingActionButton.extended(
                          // Login Button
                          onPressed: () {
                            // When the button is pressed
                            _initAndroidId();
                            searchDocumentByDeviceId();
                          },
                          backgroundColor: Color(0xFF0075FF),
                          label: Text(
                            "Accept",
                            style: TextStyle(fontSize: 25),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Back to Profile Page",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
