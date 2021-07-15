import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userattendence_admin_pannel/Login/login.dart';
import 'package:userattendence_admin_pannel/User%20information/userinformation.dart';

import 'Date Time Picker/customdatetimepicker.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CustomPicker? _customPicker;
  var date = DateTime.now();
  CollectionReference users =
      FirebaseFirestore.instance.collection('attendence');
  List<String> monthname = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customPicker = CustomPicker();
  }

  @override
  Widget build(BuildContext context) {
    String year = _customPicker!.currentTime.year.toString();
    String month = monthname[_customPicker!.currentTime.month - 1];
    String day = _customPicker!.currentTime.day.toString();
    String dayname = DateFormat('EEEE').format(date);
    String dateanddayname = "${dayname},${day}";
    int time = _customPicker!.currentTime.hour;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('email').then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Loginpage(),
                        ));
                  });
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ],
          elevation: 1.0,
          centerTitle: true,
          title: Text(
            "All User Attendence",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 200.0,
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              padding: EdgeInsets.all(10.0),
              child: Text(
                "${month}, ${day}, ${dayname}",
                style: TextStyle(fontFamily: 'Balsamiq Sans', fontSize: 16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 100.0,
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Today Attendence",
                  style: TextStyle(fontSize: 18.0, fontFamily: 'Balsamiq Sans'),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 500.0,
                width: 800.0,
                child: Card(
                  child: FutureBuilder<QuerySnapshot>(
                    future: users.get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: [
                            Container(
                              child: DataTable(
                                  columns: [
                                    DataColumn(
                                        label: Text("User Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text("Month",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text("Day",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text("Attendence",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: snapshot.data!.docs
                                      .map(
                                        (e) => DataRow(
                                          cells: [
                                            DataCell(Text(e.id), onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInformation(
                                                      documents: e.id,
                                                    ),
                                                  ));
                                            }),
                                            DataCell(Text(e['month']),
                                                onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInformation(
                                                      documents: e.id,
                                                    ),
                                                  ));
                                            }),
                                            DataCell(
                                                Text(
                                                    "${e['date']}, ${e['dayname']}"),
                                                onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInformation(
                                                      documents: e.id,
                                                    ),
                                                  ));
                                            }),
                                            DataCell(Text("${e['attendence']}"),
                                                onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInformation(
                                                      documents: e.id,
                                                    ),
                                                  ));
                                            }),
                                          ],
                                        ),
                                      )
                                      .toList()),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('There was an error...');
                      } else {
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
