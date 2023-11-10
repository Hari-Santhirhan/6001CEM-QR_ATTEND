import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/scan_attendance_page_student/qr_result_page.dart';
import 'package:final_year_project_one/scan_attendance_page_student/scan_attendance_page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:android_id/android_id.dart';
import 'package:intl/intl.dart';
import '../attendance_info_page/attendance_info_page_view.dart';
import '../home_page/home_page_view.dart';
import '../profile_page/profile_page_view.dart';

class ScanAttendancePageView extends StatefulWidget {
  final String studentEmailScan;
  final String studentNameScan;
  const ScanAttendancePageView({
    Key? key,
    required this.studentEmailScan,
    required this.studentNameScan,
  }) : super(key: key);

  @override
  State<ScanAttendancePageView> createState() => _ScanAttendancePageViewState();
}

class _ScanAttendancePageViewState extends State<ScanAttendancePageView> {
  int _selectedIndex = 1;
  bool isScanCompleted = false;
  // Variable to track whether the BLE NOT detected message has been shown
  bool notDetectedMessageShown = false;
  int i = 0;
  static const _androidIdPlugin = AndroidId();
  var _androidId = 'Unknown';
  late String deviceID; // device id (no longer using imei)
  late String subCode; // subject code
  late String subName; // subject name
  late String roomNumber; // classroom number
  late String generatedTime; // time when qr code was created by lecturer
  late String sessionId; // unique id for firebase document id
  late String scanTime; // time when qr code was scanned by student

  ScanAttendancePageModel scanAttendancePageModel = ScanAttendancePageModel(
    studentEmail: '',
    timeTaken: '',
    attendanceStatus: '',
    scanStatus: '',
  );

  @override
  void initState() {
    super.initState();
    _initAndroidId();
  }

  Future<void> checkAndSubmit() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('users');
    try {
      QuerySnapshot querySnapshot = await collectionReference
          .where('imei', isEqualTo: deviceID)
          .where('email', isEqualTo: widget.studentEmailScan)
          .get();

      // if NOT matched
      if (querySnapshot.docs.isEmpty) {
        Fluttertoast.showToast(
          msg: "Registered Device NOT Matched!!!",
          toastLength: Toast.LENGTH_SHORT, // Duration of the toast
          gravity: ToastGravity.BOTTOM, // Toast gravity
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.white, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        return;
      }

      scanAttendancePageModel.studentEmail = widget.studentEmailScan;

      final Map<String, dynamic>? userData2 =
          querySnapshot.docs.first.data() as Map<String, dynamic>?;

      String studentID = userData2!['id'];

      // if MATCHED, then add attendance info to firestore
      scanTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      scanAttendancePageModel.timeTaken = scanTime;

      // Parse the time1 and time2 strings into DateTime objects
      DateTime dateTime1 = DateFormat('yyyy-MM-dd HH:mm:ss').parse(scanTime);
      DateTime dateTime2 =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(generatedTime);

      // Calculate the difference in minutes
      Duration difference = dateTime1.difference(dateTime2);

      // Convert the difference to minutes
      int differenceInMinutes = difference.inMinutes;

      // Check if the difference is less than 1 (minute), which indicates being on time
      if (differenceInMinutes < 1) {
        scanAttendancePageModel.attendanceStatus = "On Time";
      } else {
        // If the difference is less than 1, then the student is late
        scanAttendancePageModel.attendanceStatus =
            "Late by " + (differenceInMinutes - 1).toString() + " minute(s)";
      }

      scanAttendancePageModel.scanStatus = "Done";

      // Map<String, dynamic> takeAttendanceData =
      //     scanAttendancePageModel.takeAttendanceMap();

      // Access the Firestore collection 'attendance'
      CollectionReference attendanceCollection =
          FirebaseFirestore.instance.collection('attendance');

      // Access the specific document using sessionID
      DocumentReference documentReference = attendanceCollection.doc(sessionId);

      List<String> attendanceInfo = [
        scanAttendancePageModel.studentEmail,
        studentID,
        scanAttendancePageModel.attendanceStatus,
        scanAttendancePageModel.scanStatus,
        scanAttendancePageModel.timeTaken,
      ];

      // Update the document
      documentReference.update({
        '' + widget.studentNameScan: FieldValue.arrayUnion(attendanceInfo),
      }).then((_) {
        print('Values added to the array field successfully.');
      }).catchError((error) {
        print('Error adding values to array field: $error');
      });

      Fluttertoast.showToast(
        msg: "Attendance Successful for ${subCode}${subName}"
            "\nGenerated at ${dateTime2}\nScanned at ${dateTime1}",
        toastLength: Toast.LENGTH_SHORT, // Duration of the toast
        gravity: ToastGravity.BOTTOM, // Toast gravity
        backgroundColor: Colors.black, // Background color of the toast
        textColor: Colors.white, // Text color of the toast message
        fontSize: 16.0, // Font size of the toast message
      );
    } catch (e) {
      print(e);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initAndroidId() async {
    String androidId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      androidId = await _androidIdPlugin.getId() ?? 'Unknown ID';
    } on PlatformException {
      androidId = 'Failed to get Android ID.';
    }

    _androidId = androidId;
    final bytesAndroidID = utf8.encode(_androidId);
    final hashAndroidID = sha256.convert(bytesAndroidID);
    deviceID = hashAndroidID.toString();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onItemTapped(int index) {
    // Handle navigation based on the index
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageView(
            studentEmailHome: widget.studentEmailScan,
            studentNameHome: widget.studentNameScan,
          ),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanAttendancePageView(
            studentEmailScan: widget.studentEmailScan,
            studentNameScan: widget.studentNameScan,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceInfoPageView(
            studentEmailInfo: widget.studentEmailScan,
            studentNameInfo: widget.studentNameScan,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePageView(
            studentEmailProfile: widget.studentEmailScan,
            studentNameProfile: widget.studentNameScan,
          ),
        ),
      );
    }
  }

  Future<void> scanDevices(String bleDeviceID) async {
    // Start scan for 5 seconds
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // Variable to keep track of whether the device is found
    bool deviceFound = false;

    // Listen for scan results and filter for the target device
    await for (final scanResult in FlutterBluePlus.scanResults) {
      deviceFound = false;
      notDetectedMessageShown = false;
      for (final result in scanResult) {
        if (result.device.id.toString() == bleDeviceID && result.rssi >= -50) {
          FlutterBluePlus.stopScan();
          // Found the target device, stop scanning here
          deviceFound = true;
          checkAndSubmit();
          break; // Exit the inner loop when the device is found
        }
      }

      if (deviceFound) {
        i++;
        Fluttertoast.showToast(
          msg: "BLE DETECTED!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Exit the outer loop when the device is found
         break;
      }
      // else if (!deviceFound && !notDetectedMessageShown) {
      //   notDetectedMessageShown = true;
      //   Fluttertoast.showToast(
      //     msg: "BLE NOT DETECTED\n$bleDeviceID",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0,
      //   );
      // }
    }
  }


  void checkStudent(
    String code,
    String name,
    String session,
    String roomNum,
    String bleID,
  ) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('subjects');
    try {
      bool enrolCheck = false;

      QuerySnapshot querySnapshot = await collectionReference
          .where('subject_code', isEqualTo: code)
          .where('subject_name', isEqualTo: name)
          .where('semester_session', isEqualTo: session)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final Map<String, dynamic>? subjectData =
        querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (subjectData != null &&
            subjectData.containsKey('subject_students')) {
          final List<dynamic> subjectStudents = subjectData['subject_students'];

          for (int i = 0; i < subjectStudents.length; i++) {
            final Map<String, dynamic> studentInfo = subjectStudents[i];
            final String studentEmail = studentInfo['email'];

            if (studentEmail == widget.studentEmailScan){
              enrolCheck = true;
              break;
            }
          }
        }
      }

      if (enrolCheck == false) {
        Fluttertoast.showToast(
          msg: "You are NOT enrolled in this subject!",
          toastLength: Toast.LENGTH_SHORT, // Duration of the toast
          gravity: ToastGravity.BOTTOM, // Toast gravity
          backgroundColor: Colors.black, // Background color of the toast
          textColor: Colors.white, // Text color of the toast message
          fontSize: 16.0, // Font size of the toast message
        );
        return;
      }

      subCode = code;
      subName = name;
      roomNumber = roomNum;

      // If the student is enrolled, then proceed to scan the BLE
      scanDevices(bleID);
    } catch (e) {
      print("ERROR CHECK ERROR ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Scan Attendance",
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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Please scan the QR code",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "BLE detection will begin once the scan has started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // if (isScanCompleted == false) {
              //   String code = barcode.rawValue ?? '---';
              //   isScanCompleted = true;
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => QrResultPage(
              //         closeScreen: closeScreen,
              //         code: code,
              //       ),
              //     ),
              //   );
              // }
              flex: 4,
              child: MobileScanner(
                allowDuplicates: true,
                onDetect: (barcode, args) {
                  if (isScanCompleted == false) {
                    isScanCompleted = true;
                    try {
                      String qrCode = barcode.rawValue ?? '---';
                      List<String> qrCodeLines = qrCode.split('\n');

                      if (qrCodeLines.length >= 3) {
                        String subjectCode = qrCodeLines[0];
                        String subjectName = qrCodeLines[1];
                        String semSession = qrCodeLines[2];
                        String classRoom = qrCodeLines[3];
                        String bleID = qrCodeLines[4];
                        generatedTime = qrCodeLines[5];
                        sessionId = qrCodeLines[6];

                        checkStudent(
                          subjectCode,
                          subjectName,
                          semSession,
                          classRoom,
                          bleID,
                        );
                      } else {
                        print("Invalid QR code data");
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Please make sure the QR code is in the scan box",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
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
            icon: Icon(Icons.qr_code_sharp),
            label: "Take Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_sharp),
            label: "Attendance Info",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
