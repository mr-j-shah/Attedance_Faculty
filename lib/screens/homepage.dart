import 'package:admin/attendance/attedance.dart';
import 'package:admin/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';

class hoempage extends StatefulWidget {
  hoempage({Key? key}) : super(key: key);

  @override
  State<hoempage> createState() => _hoempageState();
}

class _hoempageState extends State<hoempage> {
  List<Lecture> lecture = [];
  bool isotherselect = true;
  bool isError = false;
  bool isLoading = true;
  int selectcount = -1;
  DateTime today = new DateTime.now();
  String? date = DateTime.now().day.toString() +
      ":" +
      DateTime.now().month.toString() +
      ":" +
      DateTime.now().year.toString();
  DateTime? selectdate = new DateTime.now();
  String? email = FirebaseAuth.instance.currentUser!.email;
  CollectionReference users = FirebaseFirestore.instance.collection('admin');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectcount >= 0
          ? FloatingActionButton(
              onPressed: () {
                deleteUser(lecture[selectcount]);
                isotherselect = true;
              },
              tooltip: 'Increment Counter',
              child: const Icon(Icons.delete),
            )
          : null,
      body: isError
          ? Center(
              child: Text('Error'),
            )
          : Column(children: [
              Container(
                padding: const EdgeInsets.only(top: 11, bottom: 11),
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
                child: FlutterDatePickerTimeline(
                  startDate: DateTime(
                      int.parse(today.year.toString()),
                      int.parse(today.month.toString()),
                      int.parse(today.day.toString()) - 30),
                  endDate: DateTime(
                      int.parse(today.year.toString()),
                      int.parse(today.month.toString()),
                      int.parse(today.day.toString())),
                  initialSelectedDate: DateTime(
                      int.parse(today.year.toString()),
                      int.parse(today.month.toString()),
                      int.parse(today.day.toString())),
                  onSelectedDateChange: (dateTime) async {
                    setState(() {
                      selectcount = -1;
                      selectdate = dateTime;
                      date = selectdate!.day.toString() +
                          ":" +
                          selectdate!.month.toString() +
                          ":" +
                          selectdate!.year.toString();
                      print(date);
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
                    });
                  },
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(2),
                        itemCount: getLength(),
                        itemBuilder: _itemBuilder,
                      ),
                    )
            ]),
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
        .where("Date", isEqualTo: date)
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
          shape: lecture[index].isselect
              ? RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Container(
            margin: EdgeInsets.all(7),
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
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => attend(lecture: lecture[index])));
        },
        onLongPress: isotherselect
            ? () {
                setState(() {
                  lecture[index].isselect = !lecture[index].isselect;
                  if (lecture[index].isselect == true) {
                    selectcount = index;
                    print(selectcount);
                    isotherselect = false;
                  } else {
                    selectcount = -1;
                    print(selectcount);
                    isotherselect = true;
                  }
                });
              }
            : () {},
      ),
    );
  }

  int getLength() {
    return lecture.length;
  }

  String getdetails(Lecture lecture) {
    String doc = date.toString() +
        ':' +
        lecture.keyid.toString() +
        ':' +
        lecture.sem.toString() +
        ':' +
        lecture.subject.toString();
    return doc;
  }

  Future<void> deleteUser(Lecture lecturedata) {
    return users
        .doc(email)
        .collection('lecture')
        .doc(getdetails(lecturedata))
        .delete()
        .then(
          (value) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              //45064C
              // backgroundColor: Color(0xFFF45064C),
              title: Text('Delete'),
              content: Text('Lecture Delete Sucessfully!'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    setState(() {
                      selectcount = -1;
                      isotherselect = true;
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
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ),
        )
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
