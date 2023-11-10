import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/subject_page/subject_details_page_view.dart';
import 'package:final_year_project_one/subject_page/subject_model.dart';
import 'package:flutter/material.dart';

class SubjectPageView extends StatefulWidget {
  const SubjectPageView({Key? key}) : super(key: key);

  @override
  State<SubjectPageView> createState() => _SubjectPageViewState();
}

class _SubjectPageViewState extends State<SubjectPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Class Subjects",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectDetailsAddPageView(),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No subjects available!'),
            );
          }

          List<SubjectModel> subjects = snapshot.data!.docs
              .map((doc) => SubjectModel.fromSnapshot(doc))
              .toList();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Single column
              crossAxisSpacing: 8.0, // Adjust horizontal spacing
              mainAxisSpacing: 8.0, // Adjust vertical spacing
            ),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              SubjectModel subject = subjects[index];
              // Customize the UI as per your requirement
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Choose an Option",
                        ),
                        content: Text(
                          "Please Choose an Option",
                        ),
                        actions: [
                          TextButton(
                            child: Text('Enrol Lecturer(s)'),
                            onPressed: () {
                              Navigator.pop(context);
                              final docID = snapshot.data!.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubjectEnrolLecturersPageView(
                                    documentID: docID,
                                  ),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text('Remove Lecturer(s)'),
                            onPressed: () {
                              Navigator.pop(context);
                              final docID = snapshot.data!.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubjectRemoveLecturersPageView(
                                          documentID: docID),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text('Enrol Students'),
                            onPressed: () {
                              Navigator.pop(context);
                              final docID = snapshot.data!.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubjectEnrolStudentsPageView(
                                    documentID: docID,
                                  ),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text('Remove Students'),
                            onPressed: () {
                              Navigator.pop(context);
                              final docID = snapshot.data!.docs[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SubjectRemoveStudentsPageView(
                                          documentID: docID),
                                ),
                              );
                            },
                          ),
                          TextButton(
                            child: Text('Back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  color: Color(0xFF0075FF),
                  margin: EdgeInsets.fromLTRB(
                    30.0,
                    20.0,
                    30.0,
                    5.0,
                  ),
                  padding: EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Center(
                    child: Text(
                      '${subject.subject_code ?? ''}\n'
                      '${subject.subject_name ?? ''}\n'
                      '${subject.semester_session ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 38, // Adjust font size as needed
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
