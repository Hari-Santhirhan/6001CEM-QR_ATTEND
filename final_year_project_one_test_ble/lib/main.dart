import 'package:final_year_project_one/about_us_page/about_us_page_view.dart';
import 'package:final_year_project_one/attendance_info_page/attendance_info_page_view.dart';
import 'package:final_year_project_one/firebase_options.dart';
import 'package:final_year_project_one/login_page/login_page_view.dart';
import 'package:final_year_project_one/login_page/login_page_viewModel.dart';
import 'package:final_year_project_one/profile_page/profile_page_view.dart';
import 'package:final_year_project_one/scan_attendance_page_student/scan_attendance_page_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'home_page/home_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  // Initialize Firebase
  runApp(
    QR_Attend(),
  );
}

class QR_Attend extends StatelessWidget {
  const QR_Attend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPageView(),
    );
  }
}
