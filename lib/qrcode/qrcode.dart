import 'dart:convert';

import 'package:admin/qrcode/qrcontroller.dart';
import 'package:admin/screens/basehome.dart';
import 'package:admin/user/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({Key? key, required this.lecture}) : super(key: key);
  final Lecture lecture;
  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  Map<String, dynamic>? data;
  @override
  void initState() {
    TicketController(widget.lecture).getTicketData().then((value) {
      data = value;
      print(data);
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        title: Text('Lecture'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              'Scan Me!',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Pacifico",
              ),
            ),
          ),
          Center(
            child: Text(
              'Ticket',
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Pacifico",
              ),
            ),
          ),
          data == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : QrImage(
                  backgroundColor: Colors.white,
                  data: jsonEncode(data),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
          Text(
            DateTime.now().toString(),
            style: TextStyle(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FlatButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => basehome()),
                  );
                },
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
