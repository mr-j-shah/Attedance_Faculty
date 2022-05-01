import 'package:cloud_firestore/cloud_firestore.dart';

class user {
  static final user _currentUser = user._internal();
  String? name;
  String? doj;
  String? dob;
  String? blood;
  String? department;
  String? email;
  String? phone;
  String? location;
  factory user() {
    return _currentUser;
  }

  user._internal();
}

class Lecture {
  String? subject, sem, time, date, keyid;
  bool isselect = false;
  Lecture() {}

  Lecture.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    subject = data['Subject'];
    sem = data['Semester'];
    time = data['Time'];
    date = data['Date'];
    keyid = data['Key'];
  }
}

class Attedance {
  String? enrollment, name, email;
  Attedance() {}

  Attedance.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    enrollment = data['Enrollment'];
    name = data['Name'];
    email = data['email'];
  }
}

class Subject {
  String? subjectname, subjectcode, sem;
  Subject() {}

  Subject.fromDocumentsubject(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    subjectname = data['Name'];
  }
}

class student {
  static final student _currentUser = student._internal();
  String? name;
  String? number;
  String? dob;
  String? blood;
  String? department;
  String? email;
  String? phone;
  String? location;
  factory student() {
    return _currentUser;
  }

  student._internal();
}
