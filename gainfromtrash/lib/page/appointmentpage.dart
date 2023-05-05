import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../user.dart';

enum SessionType {Morning, Afternoon}

class AppointmentPage extends StatefulWidget {
  final User user;
  const AppointmentPage({super.key, required this.user});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  _AppointmentPageState(){
    _selectedLocation = _locationList[0];
  }

  DateTime _selectedDay = DateTime.now();
  final _locationList = ["MAS","TNB","TRADEWIND","PROTON","PETRONAS","GRANTT","SIMEDARBY","TM","MISC","BSN","YAB","MUAMALAT","BANKRAKYAT","SME"];
  String? _selectedLocation;
  SessionType? _selectedSessionType = SessionType.Morning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: Text('Pick Up Appointment', style:TextStyle(color: Colors.green[300])),
      centerTitle: true,
      backgroundColor: Colors.white,
      ),
      body: content(),
    );
  }

  Widget content(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            TableCalendar(
              rowHeight:40,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              focusedDay: _selectedDay, 
              firstDay: DateTime.utc(2020,3,30), 
              lastDay: DateTime.utc(2030,3,30),
              onDaySelected: _onDaySelected,
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 121, 230, 152),
                  shape: BoxShape.circle
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle
                ),
              ),
            ),
            Text("Selected Day = ${_selectedDay.toString().split(" ")[0]}"),
            const SizedBox(height: 20),
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.all(5),
                child: SizedBox(
                  width: 320,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: 
                        const Text('Choose Pick Up Session', 
                        style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: RadioListTile<SessionType>(
                              value:SessionType.Morning,
                              groupValue: _selectedSessionType,
                              dense: true,
                              title: const Text("8-11am"),
                              tileColor: const Color.fromARGB(255, 206, 243, 209),
                              activeColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                              ),
                              onChanged: (SessionType? value) {
                                setState(() {
                                  _selectedSessionType = value;
                                });
                                _onSessionTypeSelected(value); // pass nullable value to function
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: RadioListTile<SessionType>(
                              value:SessionType.Afternoon,
                              groupValue: _selectedSessionType,
                              title: const Text("1-4pm"),
                              dense: true,
                              tileColor: const Color.fromARGB(255, 206, 243, 209),
                              activeColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)
                              ),
                              onChanged: (SessionType? value) {
                                setState(() {
                                  _selectedSessionType = value;
                                });
                                _onSessionTypeSelected(value); // pass nullable value to function
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),
                ), 
              ),
            ),
    
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: const EdgeInsets.all(5),
                child: SizedBox(
                  width: 320,
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: 
                        const Text('Choose Pick Up Location', 
                        style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),

                      DropdownButton(
                        hint: const Text('Select a location'),
                        value: _selectedLocation,
                        items: _locationList.map(
                          (e) {
                            return DropdownMenuItem(child: Text(e),value: e);
                          }
                        ).toList(),
                        onChanged: _onLocationSelected,
                      ),
                      
                    ],
                  ),
                ), 
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[200], //background color of button
                  elevation: 3, //elevation of button
                  padding: const EdgeInsets.only(top: 10, bottom: 10, right: 110, left: 110)
                ),
                onPressed: confirmBooking,
                child: const Text('Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  void _onSessionTypeSelected(SessionType? selectedSessionType) {
    setState(() {
      _selectedSessionType = selectedSessionType;
    });
  }

  void _onLocationSelected(String? selectedLocation) {
    setState(() {
      _selectedLocation = selectedLocation;
    });
  }

  void confirmBooking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Book this slot?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                saveBooking();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void saveBooking(){
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/book_appointment.php"), body: {
	    "userid": widget.user.id,
      "selectedDay": _selectedDay.toString(),
      "selectedSessionType": _selectedSessionType.toString(),
      "selectedLocation": _selectedLocation ?? '',
	    }).then((response) {
      var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }

        //print(response.body);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}