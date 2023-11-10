import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/student_info_page/selected_user_view.dart';
import 'package:flutter/material.dart';

class DetailedUserViewAdmin extends StatefulWidget {
  final String userRole;
  final String detailedAdminEmail;
  final String detailedAdminPassword;
  const DetailedUserViewAdmin({
    Key? key,
    required this.userRole,
    required this.detailedAdminEmail,
    required this.detailedAdminPassword,
  }) : super(key: key);

  @override
  State<DetailedUserViewAdmin> createState() => _DetailedUserViewAdminState();
}

class _DetailedUserViewAdminState extends State<DetailedUserViewAdmin> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "${widget.userRole} View",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "Please Select a ${widget.userRole}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Filter documents that contain lecturers in subject_lecturers
                  final filteredDocs = snapshot.data!.docs.where((document) {
                    final lecturers = document['role'];
                    return lecturers.contains(widget.userRole);
                  }).toList();
                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = filteredDocs[index];
                      final userName = document['name'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectedUserView(
                                selectedName: userName,
                                selectedID: document['id'].toString(),
                                selectedEmail: document['email'].toString(),
                                selectedAdminEmail: widget.detailedAdminEmail,
                                selectedAdminPassword: widget.detailedAdminPassword,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          height: 120.0, // Set the height
                          width: 300.0, // Set the width
                          child: Container(
                            color: Colors.blueAccent,
                            child: Center(
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 38, 0, 0),
                                      child: Text(
                                        "${userName}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
