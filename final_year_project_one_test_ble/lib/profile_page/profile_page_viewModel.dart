import 'package:final_year_project_one/profile_page/add_semester_session_view.dart';
import 'package:final_year_project_one/subject_page/subject_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePageViewModel extends ChangeNotifier {
  void LogOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  void GoToSubject(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectPageView(),
      ),
    );
  }

  void GoToAddSemSession(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contex) => AddSemSessionPageView(),
      ),
    );
  }
}
