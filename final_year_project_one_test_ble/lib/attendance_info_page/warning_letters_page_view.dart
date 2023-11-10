import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/attendance_info_page/warning_letter_detailed_page_view.dart';
import 'package:flutter/Material.dart';

class WarningLettersPageView extends StatefulWidget {
  final String studentEmailLetter;
  const WarningLettersPageView({
    Key? key,
    required this.studentEmailLetter,
  }) : super(key: key);

  @override
  State<WarningLettersPageView> createState() => _WarningLettersPageViewState();
}

class _WarningLettersPageViewState extends State<WarningLettersPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Warning Letters",
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
              // BEFORE 1st Square
              height: 20,
            ),
            Center(
              child: Text(
                "Click to View",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              // BEFORE 1st Square
              height: 20,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('warning')
                    .where(
                      'student_email',
                      isEqualTo: widget.studentEmailLetter,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final letters = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: letters.length,
                    itemBuilder: (context, index) {
                      final letter = letters[index];
                      final letterSession = letter['semester_session'];
                      final letterEmail = letter['student_email'];
                      final letterName = letter['student_name'];
                      final letterSubCode = letter['subject_code'];
                      final letterSubName = letter['subject_name'];
                      final letterMsg = letter['warning_msg'];

                      return GestureDetector(
                        onTap: () {
                          // For Viewing Warning Letter
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WarningLetterDetailedView(
                                  letter: letter,
                                  letterSession: letterSession,
                                  letterEmail: letterEmail,
                                  letterName: letterName,
                                  letterSubCode: letterSubCode,
                                  letterSubName: letterSubName,
                                  letterMsg: letterMsg),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                          ),
                          margin: EdgeInsets.fromLTRB(40, 8, 40, 8),
                          padding: EdgeInsets.all(16.0),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                letterSubCode +
                                    "\n" +
                                    letterSubName +
                                    "\n" +
                                    letterSession,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
              // BEFORE 2nd Square
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
