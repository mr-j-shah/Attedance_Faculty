import 'package:admin/attendance/studentprof.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class attend extends StatefulWidget {
  attend({Key? key, required this.lecture}) : super(key: key);
  final Lecture lecture;
  @override
  State<attend> createState() => _attendState();
}

class _attendState extends State<attend> {
  List<Attedance> student = [];
  bool isError = false;
  bool isLoading = true;
  String? email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendace'),
      ),
      body: isError
          ? Center(
              child: Text('Error'),
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(2),
                  itemCount: getLength(),
                  itemBuilder: _itemBuilder,
                ),
    );
  }

  @override
  void initState() {
    getEventsByType()
        .then((value) => {
              setState(() {
                student = value;
                isLoading = false;
              })
            })
        .onError((error, stackTrace) {
      print(error);
      print(stackTrace);
      setState(() {
        isError = true;
      });
      throw error!;
    });
    super.initState();
  }

  Future<List<Attedance>> getEventsByType() async {
    List<Attedance> events = [];
    final snapShot = await FirebaseFirestore.instance
        .collection('admin')
        .doc(email)
        .collection('lecture')
        .doc(widget.lecture.date.toString() +
            ":" +
            widget.lecture.keyid.toString() +
            ":" +
            widget.lecture.sem.toString() +
            ":" +
            widget.lecture.subject.toString())
        .collection('Attend')
        .get();
    for (final doc in snapShot.docs) {
      events.add(Attedance.fromDocument(doc));
    }
    return events;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          child: Card(
            margin: EdgeInsets.all(5),
            color: Colors.white70,
            child: Center(
              child: InkWell(
                child: Text(
                  student[index].enrollment.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => profilepage(
                //         email: student[index].enrollment.toString(),
                //       ),
                //     ),
                //   );
                // },
              ),
            ),
          ),
        ),
      ),
    );
  }

  int getLength() {
    return student.length;
  }
}
