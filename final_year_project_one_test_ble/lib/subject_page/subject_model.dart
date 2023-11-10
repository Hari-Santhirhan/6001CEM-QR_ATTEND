import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectModel {
  String subject_name;
  String subject_code;
  String semester_session;

  SubjectModel({
    required this.subject_name,
    required this.subject_code,
    required this.semester_session,
  });

  Map<String, dynamic> toMapSubject() {
    return {
      'subject_name': subject_name,
      'subject_code': subject_code,
      'semester_session': semester_session,
    };
  }

  factory SubjectModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SubjectModel(
      subject_name: data['subject_name'],
      subject_code: data['subject_code'],
      semester_session: data['semester_session'],
    );
  }
}