import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketController {
  TicketController(Lecture _lecture) {
    this._lecture = _lecture;
  }
  late Lecture _lecture;
  DateTime now = new DateTime.now();
  Future<Map<String, dynamic>> getTicketData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final snapShot = await FirebaseFirestore.instance
          .collection('admin')
          .doc(user!.email)
          .collection('lecture')
          .doc(now.day.toString() +
              ":" +
              now.month.toString() +
              ":" +
              now.year.toString() +
              ":" +
              now.hour.toString() +
              ":" +
              _lecture.sem! +
              ":" +
              _lecture.subject!)
          .get();
      Map<String, dynamic> data = {};
      data = snapShot.data() ?? {} as Map<String, dynamic>;

      // List<Map<String, dynamic>> events = [];
      // for (final doc in eventSnapshot.docs) {
      //   events.add((UserEvent.fromDocument(doc)).toMap());
      // }

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
