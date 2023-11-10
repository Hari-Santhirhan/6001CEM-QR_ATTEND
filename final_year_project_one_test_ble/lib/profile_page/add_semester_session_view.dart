import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project_one/profile_page/add_semester_session_viewModel.dart';
import 'package:flutter/material.dart';

class AddSemSessionPageView extends StatefulWidget {
  const AddSemSessionPageView({Key? key}) : super(key: key);

  @override
  State<AddSemSessionPageView> createState() => _AddSemSessionPageViewState();
}

class _AddSemSessionPageViewState extends State<AddSemSessionPageView> {
  TextEditingController startSemController = TextEditingController();
  TextEditingController endSemController = TextEditingController();
  SemesterSessionPageViewModel _semesterSessionPageViewModel =
      SemesterSessionPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF0075FF),
        title: Text(
          "Semester Session",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                  controller: startSemController,
                  decoration: InputDecoration(
                    hintText: "Semester Session Start (e.g., AUG2023)",
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: endSemController,
                  decoration: InputDecoration(
                    hintText: "Semester Session End (e.g., DEC2023)",
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Add Subjects
                    String startSession = startSemController.text;
                    String endSession = endSemController.text;

                    try {
                      _semesterSessionPageViewModel.addSemSession(
                        startSession,
                        endSession,
                        context,
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16),
                    minimumSize:
                        Size(200, 50), // Adjust
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
