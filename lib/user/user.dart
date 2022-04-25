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
  String? subject, sem, time, date;
  Lecture() {}

  Lecture.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    subject = data['Subject'];
    sem = data['Semester'];
    time = data['Time'];
    date = data['Date'];
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
