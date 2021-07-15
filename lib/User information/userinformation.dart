import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:userattendence_admin_pannel/Date%20Time%20Picker/customdatetimepicker.dart';

class UserInformation extends StatefulWidget {
  final String documents;
  UserInformation({Key? key, required this.documents}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  CustomPicker? _customPicker;
  var date = DateTime.now();
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
    String absent = "A";
    String present = "P";
    String? attendence;
    bool selectbutton = false;
    String year = _customPicker!.currentTime.year.toString();
    String month = monthname[_customPicker!.currentTime.month - 1];
    String day = _customPicker!.currentTime.day.toString();
    String dayname = DateFormat('EEEE').format(date);
    String dateanddayname = "${dayname},${day}";
    int time = _customPicker!.currentTime.hour;
    CollectionReference users = FirebaseFirestore.instance
        .collection('attendence')
        .doc(widget.documents)
        .collection('year')
        .doc(year)
        .collection('month')
        .doc(month)
        .collection('date');

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.documents,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
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
            height: 20.0,
          ),
          Center(
            child: Container(
                height: 500.0,
                width: 800.0,
                child: Card(
                  child: FutureBuilder<QuerySnapshot>(
                    future: users.orderBy("date", descending: false).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                          child: Container(
                            child: ListView(
                              children: [
                                Container(
                                  child: DataTable(
                                      columns: [
                                        DataColumn(
                                            label: Text("User Id",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text("Year",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text("Month",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text("Day",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text("date",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text("attendence",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                      rows: snapshot.data!.docs
                                          .map((e) => DataRow(
                                                cells: [
                                                  DataCell(Text(e['userid'])),
                                                  DataCell(Text(e['year'])),
                                                  DataCell(Text(e['month'])),
                                                  DataCell(Text(e['dayname'])),
                                                  DataCell(Text(e['date'])),
                                                  DataCell(
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text(e['attendence']),
                                                          IconButton(
                                                              onPressed: () =>
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return AlertDialog(
                                                                          title:
                                                                              Text("Edit Attendence"),
                                                                          actions: [
                                                                            FlatButton(
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    FirebaseFirestore.instance.collection('attendence').doc(widget.documents).collection('year').doc(e['year']).collection('month').doc(e['month']).collection('date').doc(e.id).update({
                                                                                      "attendence": attendence!
                                                                                    })
                                                                                      ..then((result) {
                                                                                        print("new USer true");
                                                                                      }).catchError((onError) {
                                                                                        print("onError");
                                                                                      });

                                                                                    e['date'] ==
                                                                                            day
                                                                                        ? FirebaseFirestore.instance.collection('attendence').doc(widget.documents).update({
                                                                                            "attendence": attendence!
                                                                                          }).then((result) {
                                                                                            print("new USer true");
                                                                                          }).catchError((onError) {
                                                                                            print("onError");
                                                                                          })
                                                                                        : null;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Confirm")),
                                                                          ],
                                                                          content:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            height:
                                                                                30.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.indigoAccent,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              attendence = e['attendence'] == present ? "A" : "P",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }),
                                                              icon: Icon(
                                                                  Icons.edit)),
                                                        ],
                                                      ),
                                                      onTap: () {}),
                                                ],
                                              ))
                                          .toList()),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('There was an error...');
                      } else {
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
