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
}
