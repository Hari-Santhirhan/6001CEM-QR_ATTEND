import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class QrCodePageView extends StatefulWidget {
  final String subjectName;
  final String subjectCode;
  final String semesterSession;
  final String classRoom;
  final String generatedQrTime;
  const QrCodePageView({
    Key? key,
    required this.subjectName,
    required this.subjectCode,
    required this.semesterSession,
    required this.classRoom,
    required this.generatedQrTime,
  }) : super(key: key);

  @override
  State<QrCodePageView> createState() => _QrCodePageViewState();
}

class _QrCodePageViewState extends State<QrCodePageView> {
  String bleDeviceId = ""; // Variable to store ble_device_id
  String qrSessionId = DateTime.now().millisecondsSinceEpoch.toString();
  List<dynamic> subjectStudents = [];
  // List<String> studentNames = [];
  List<String> studentNames2 = [];
  List<String> studentEmails2 = [];
  List<String> absentEmails2 = [];
  int lateCounter = 0;
  int scanCounter = 0;

  @override
  void initState() {
    super.initState();
    fetchBleDeviceId();
    fetchSubStudents();
  }

  // void checkForAbsent() async {
  //   final CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('attendance');
  //   final DocumentReference documentRef = collectionReference.doc(qrSessionId);
  //
  //   try {
  //     DocumentSnapshot snapshot = await documentRef.get();
  //
  //     if (!snapshot.exists) {
  //       return; // Document doesn't exist, nothing to check.
  //     }
  //
  //     Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  //
  //     if (data == null) {
  //       return; // Data is null, nothing to check.
  //     }
  //
  //     // Iterate over the fields in the document
  //     for (int b = 0; b < studentNames2.length; b++) {
  //       dynamic fieldValue = data[studentNames2[b]];
  //
  //       if (fieldValue is List &&
  //           fieldValue.length > 1 &&
  //           fieldValue[0] == studentEmails2[b] &&
  //           fieldValue[1] == "Absent") {}
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> warningLetter(String studentName) async {
    List<String> dateTime = [];
    String userEmail = "";
    String userName = "";

    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('attendance');

    QuerySnapshot querySnapshot = await collectionReference
        .where('subject_code', isEqualTo: widget.subjectCode)
        .where('subject_name', isEqualTo: widget.subjectName)
        .where('semester_session', isEqualTo: widget.semesterSession)
        .orderBy('time_created', descending: true)
        .get();

    try {
      var currentEmail;
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data != null) {
          var values = data.values.toList();
          print(values);

          if (values.length > 5) {

            for (int c = 0; c < values.length; c++){
              if (values.elementAt(c) is List){
                if (values[c][2] == "Absent"){
                  dateTime.add(values[5].toString());
                  currentEmail = values.elementAt(c);
                  userEmail = currentEmail[0];
                }
              }
            }
          }
        }
      }

      // Now, outside the loop, you can access the last userEmail
      if (userEmail != null) {
        print('Email: $userEmail');
      } else {
        print('No email found.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    try {
      // Query for the document with the specified user email
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: userEmail).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot userDoc = querySnapshot.docs.first;
        userName = userDoc['name'];
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }

    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('warning');

    // Data to add (a map of key-value pairs)
    Map<String, dynamic> data = {
      'student_name': userName,
      'student_email': userEmail.toString(),
      'subject_code': widget.subjectCode,
      'subject_name': widget.subjectName,
      'semester_session': widget.semesterSession,
      'warning_msg': "This warning letter has been auto-generated for the "
              "user $userName for the email address $userEmail. You have "
              "missed 5 classes for the subject ${widget.subjectCode} "
              "${widget.subjectName} for the dates:\n" +
          dateTime[4] +
          ",\n" +
          dateTime[3] +
          ", \n" +
          dateTime[2] +
          ",\n" +
          dateTime[1] +
          ", and \n" +
          dateTime[0],
    };

    try {
      await collectionRef.add(data);
      print('Data added to Firestore successfully!');
    } catch (e) {
      print('Error adding data to Firestore: $e');
    }

    print("PASS DONE 3");
  }

  Future<void> updateAttendance() async {
    final CollectionReference subjectsCollection =
        FirebaseFirestore.instance.collection('subjects');

    try {
      // Query the document with the subject code and name
      QuerySnapshot querySnapshot = await subjectsCollection
          .where('subject_code', isEqualTo: widget.subjectCode)
          .where('subject_name', isEqualTo: widget.subjectName)
          .where('semester_session', isEqualTo: widget.semesterSession)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference subjectDocument =
            querySnapshot.docs.first.reference;
        final Map<String, dynamic>? subjectData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (subjectData != null &&
            subjectData.containsKey('subject_students')) {
          final List<dynamic> subjectStudents = subjectData['subject_students'];

          for (int i = 0; i < subjectStudents.length; i++) {
            final Map<String, dynamic> studentInfo = subjectStudents[i];
            final String studentEmail = studentInfo['email'];

            if (studentEmails2.contains(studentEmail)) {
              // Update the 'scan' field for the matching student email
              int scanCount = studentInfo['scan'] ?? 0;
              scanCount++; // Increment the 'scan' count by 1
              scanCounter = scanCounter;
              subjectStudents[i]['scan'] = scanCount;
            }
          }
          // Update subject document with the modified 'subject_students' field
          await subjectDocument.update({'subject_students': subjectStudents});
          print("PASS DONE 2");
        }
      }
    } catch (e) {
      print('ERROR LATE: $e');
    }
  }

  Future<void> updateLateCount() async {
    final CollectionReference subjectsCollection =
        FirebaseFirestore.instance.collection('subjects');

    try {
      // Query the document with the subject code and name
      QuerySnapshot querySnapshot = await subjectsCollection
          .where('subject_code', isEqualTo: widget.subjectCode)
          .where('subject_name', isEqualTo: widget.subjectName)
          .where('semester_session', isEqualTo: widget.semesterSession)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentReference subjectDocument =
            querySnapshot.docs.first.reference;
        final Map<String, dynamic>? subjectData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        if (subjectData != null &&
            subjectData.containsKey('subject_students')) {
          final List<dynamic> subjectStudents = subjectData['subject_students'];

          for (int i = 0; i < subjectStudents.length; i++) {
            final Map<String, dynamic> studentInfo = subjectStudents[i];
            final String studentEmail = studentInfo['email'];

            if (absentEmails2.contains(studentEmail)) {
              // Update the 'late' field for the matching student email
              int lateCount = studentInfo['late'] ?? 0;
              lateCount++; // Increment the 'late' count by 1
              lateCounter = lateCount;
              subjectStudents[i]['late'] = lateCount;
            }

            if (lateCounter == 5) {
              // Call the function to generate warning letter
              String studentName = studentNames2[i];
              await warningLetter(studentName);
              print("PASS DONE 4");
            }
          }
          // Update subject document with the modified 'subject_students' field
          await subjectDocument.update({'subject_students': subjectStudents});
          print("PASS DONE");
        }
      }
      await updateAttendance();
    } catch (e) {
      print('ERROR LATE: $e');
    }
  }

  void updateIfAbsent() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('attendance');
    final DocumentReference documentRef = collectionReference.doc(qrSessionId);

    try {
      DocumentSnapshot snapshot = await documentRef.get();

      if (!snapshot.exists) {
        return; // Document doesn't exist, nothing to update.
      }

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        return; // Data is null, nothing to update.
      }

      // Iterate over the student names and update as needed
      for (int i = 0; i < studentNames2.length; i++) {
        String name = studentNames2[i];
        String email = "";
        String studentID = "";
        if (data.containsKey(name) &&
            data[name] is List &&
            data[name].isEmpty) {
          email = studentEmails2[i];

          final CollectionReference collectionReference2 =
              FirebaseFirestore.instance.collection('users');

          try{
            QuerySnapshot querySnapshot = await collectionReference2
                .where('email', isEqualTo: email)
                .get();

            final Map<String, dynamic>? userData2 =
                querySnapshot.docs.first.data() as Map<String, dynamic>?;

            studentID = userData2!['id'];

          }catch(e){}

          await documentRef.update({
            name: [
              email,
              studentID,
              "Absent",
              "Done",
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            ],
          });
          absentEmails2.add(studentEmails2[i]);
        }
      }
      await updateLateCount();
    } catch (e) {
      print('Error: $e');
    }
  }

  // void updateIfEmpty() async {
  //   // Get a reference to the Firestore collection and document
  //   final CollectionReference collectionRef =
  //       FirebaseFirestore.instance.collection('attendance');
  //   final DocumentReference documentRef = collectionRef.doc(qrSessionId);
  //
  //   try {
  //     // Get the document data
  //     DocumentSnapshot snapshot = await documentRef.get();
  //
  //     // Check and update each user array
  //     Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  //
  //     if (data != null) {
  //       data.forEach((key, value) async {
  //         if (value is List<dynamic> && value.isEmpty) {
  //           // If the array is empty, update it with a new value
  //           await documentRef.update({
  //             key: ['Absent']
  //           });
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print('Error updating document: $e');
  //   }
  // }

  void getStudentNames2(List<String> stringValues) async {
    try {
      for (int a = 0; a < stringValues.length; a++) {
        QuerySnapshot userSnapshot2 = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: stringValues[a])
            .get();
        if (userSnapshot2.docs.isNotEmpty) {
          QueryDocumentSnapshot userDocument2 = userSnapshot2.docs.first;
          String userName = userDocument2['name'];
          String userEmail = userDocument2['email'];

          studentNames2.add(userName);
          studentEmails2.add(userEmail);
        }
      }
      setStudents2(stringValues);
    } catch (e) {}
  }

  // void getStudentNames(List<String> stringValues) async {
  //   try {
  //     // Create a list to store the student names
  //     print(stringValues);
  //     // Loop through each email in the subjectStudents array
  //     for (String email in stringValues) {
  //       // Query the 'users' collection to get the document with the matching email
  //       QuerySnapshot userSnapshot = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('email', isEqualTo: email)
  //           .get();
  //
  //       // Check if there is a matching document
  //       if (userSnapshot.docs.isNotEmpty) {
  //         QueryDocumentSnapshot userDocument = userSnapshot.docs.first;
  //
  //         // Retrieve the user's name from the matching document
  //         String userName = userDocument['name'];
  //
  //         // Add the user's name to the list
  //         studentNames.add(userName);
  //       } else {
  //         // Handle the case where no matching user document is found for the email
  //         // You can add an error message or take appropriate action here
  //         print('No matching user document found for email: $email');
  //       }
  //     }
  //
  //     // Now you have the names of the students in the studentNames list
  //     print('Student Names: $studentNames');
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  //
  //   setStudents(stringValues);
  // }

  void setStudents2(List<String> stringValues) async {
    try {
      // Reference to the Firestore document using sessionId as the document ID
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('attendance').doc(qrSessionId);

      // Create a map to update the document
      Map<String, dynamic> dataToUpdate = {
        'subject_name': widget.subjectName,
        'subject_code': widget.subjectCode,
        'semester_session': widget.semesterSession,
        'classroom_number': widget.classRoom,
        'time_created':
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      };

      // Add the arrays to the map with specific field names
      for (int i = 0; i < studentNames2.length; i++) {
        dataToUpdate['' + studentNames2[i]] = [];
      }

      // Update the Firestore document or create it if it doesn't exist
      await docRef.set(dataToUpdate, SetOptions(merge: true));

      print('Document updated or created successfully');
    } catch (e) {}
  }

  // To set the student details with the attendance to check when scanning
  // void setStudents(List<String> stringValues) async {
  //   try {
  //     // Reference to the Firestore document using sessionId as the document ID
  //     DocumentReference docRef =
  //         FirebaseFirestore.instance.collection('attendance').doc(qrSessionId);
  //
  //     // Create a map to update the document
  //     Map<String, dynamic> dataToUpdate = {
  //       'subject_name': widget.subjectName,
  //       'subject_code': widget.subjectCode,
  //       'semester_session': widget.semesterSession,
  //       'classroom_number': widget.classRoom,
  //     };
  //
  //     // Add the arrays to the map with specific field names
  //     for (int i = 0; i < studentNames.length; i++) {
  //       dataToUpdate['' + studentNames[i]] = [];
  //     }
  //
  //     // Update the Firestore document or create it if it doesn't exist
  //     await docRef.set(dataToUpdate, SetOptions(merge: true));
  //
  //     print('Document updated or created successfully');
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  // Fetch all students registered for this subject
  void fetchSubStudents() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .where('subject_code', isEqualTo: widget.subjectCode)
          .where('semester_session', isEqualTo: widget.semesterSession)
          .get();

      // Check if there is a matching document
      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Retrieve the array field from the matching document
        subjectStudents = documentSnapshot['subject_students'];

        if (subjectStudents != null && subjectStudents.isNotEmpty) {
          // Filter the array to include only the elements that are of type String
          List<String> stringValues = subjectStudents
              .map((student) => student['email'] as String)
              .where((email) => email != null)
              .toList();

          // getStudentNames(stringValues);
          getStudentNames2(stringValues);


        } else {
          print('The "subject_students" field is empty or not an array.');
        }
      } else {
        print('No matching document found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void fetchSubStudents() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('subjects')
  //         .where('subject_code', isEqualTo: widget.subjectCode)
  //         .where('semester_session', isEqualTo: widget.semesterSession)
  //         .get();
  //
  //     // Check if there is a matching document
  //     if (querySnapshot.docs.isNotEmpty) {
  //       QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  //
  //       // Retrieve the array field from the matching document
  //       subjectStudents = List.from(documentSnapshot['subject_students'] ?? []);
  //
  //       print('Subject Students: $subjectStudents'); // Print the retrieved data
  //
  //       getStudentNames();
  //     } else {
  //       print('No matching document found');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Fetch ble_device_id from Firestore

  void fetchBleDeviceId() async {
    // Reference to Firestore collection 'ble'
    final CollectionReference bleCollection =
        FirebaseFirestore.instance.collection('ble');

    try {
      // Query Firestore to find documents where ble_room matches classRoom
      QuerySnapshot querySnapshot = await bleCollection
          .where('ble_room', isEqualTo: widget.classRoom)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If documents are found, get the ble_device_id from the first document
        String deviceId = querySnapshot.docs[0].get('ble_device_id');
        setState(() {
          bleDeviceId = deviceId; // Update the state variable
        });
      } else {
        // Handle the case where no matching document is found
        setState(() {
          bleDeviceId = "No matching device found"; // Set a default value
        });
      }
    } catch (e) {
      print("Error fetching data from Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "${widget.subjectCode}",
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
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: QrImageView(
                data: "${widget.subjectCode}"
                    "\n${widget.subjectName}"
                    "\n${widget.semesterSession}"
                    "\n${widget.classRoom}"
                    "\n${bleDeviceId}"
                    "\n${widget.generatedQrTime}"
                    "\n${qrSessionId}",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  // updateIfEmpty();
                  updateIfAbsent();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 300,
                  height: 150,
                  color: Color(0xFF00FFE0),
                  child: Center(
                    child: Text(
                      "End Attendance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
