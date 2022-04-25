import 'package:admin/attendance/attedance.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class hoempage extends StatefulWidget {
  hoempage({Key? key}) : super(key: key);

  @override
  State<hoempage> createState() => _hoempageState();
}

class _hoempageState extends State<hoempage> {
  List<Lecture> lecture = [];
  bool isError = false;
  bool isLoading = true;
  String? email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                lecture = value;
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

  Future<List<Lecture>> getEventsByType() async {
    List<Lecture> events = [];
    final snapShot = await FirebaseFirestore.instance
        .collection('admin')
        .doc(email)
        .collection('lecture')
        .get();
    for (final doc in snapShot.docs) {
      events.add(Lecture.fromDocument(doc));
    }
    return events;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        child: Card(
          margin: EdgeInsets.all(5),
          color: Colors.white70,
          child: Column(
            children: [
              Center(
                child: Text(
                  lecture[index].subject.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              Divider(
                color: Colors.black54,
                endIndent: 20,
                indent: 20,
              ),
              Center(
                child: Text(
                  "Semester  :  ${lecture[index].sem.toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Date  :  ${lecture[index].date.toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Time  :  ${lecture[index].time.toString()}",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => attend(lecture: lecture[index])));
        },
      ),
    );
  }

  int getLength() {
    return lecture.length;
  }
}
