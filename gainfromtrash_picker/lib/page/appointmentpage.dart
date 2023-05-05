import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../appointment.dart';
import '../config.dart';
import '../picker.dart';


class AppointmentPage extends StatefulWidget {
  final Picker picker;
  const AppointmentPage({super.key, required this.picker});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Appointment> allappointmentList = <Appointment>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    loadAllAppointment();
  }

  @override
  void dispose() {
    allappointmentList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Pick Up Appointment', style:TextStyle(color: Colors.green[300])),
        centerTitle: true,
      backgroundColor: Colors.white,
      ),
      body: allappointmentList.isEmpty
      ? Center(
          child: Text(titlecenter,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
          )
        )
      : Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: allappointmentList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.green[100],
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      acceptDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 40),
                              Text(
                                'Date: ${truncateString(allappointmentList[index].selectedDay.toString(), 10)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(width: 15),
                              Text(
                                truncateString(allappointmentList[index].selectedSessionType.toString(), 25),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(width: 40),
                              Text(
                                'Location: ${truncateString(allappointmentList[index].selectedLocation.toString(), 20)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str";
    } else {
      return str;
    }
  }

  Future<void> loadAllAppointment() async {
    try {
      http.get(Uri.parse("${Config.server}/gainfromtrash/php/load_allappointment.php"),
      ).then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          print(jsondata);
          if (extractdata['allappointment'] != null) {
            //check if array object is not null
            allappointmentList = <Appointment>[]; //complete the array object definition
              //check if homestay is not null
              extractdata['allappointment'].forEach((v) {
                //traverse products array list and add to the list object array productList
                allappointmentList.add(Appointment.fromJson(v)); //add each product array to the list object array productList
              });
            
            titlecenter = "Found";
          }else {
            titlecenter =
                "No Appointment Available"; //if no data returned show title center
            allappointmentList.clear();
          }
        } else {
          titlecenter = "No Appointment Available";
        }
      } else {
        titlecenter = "No Appointment Available"; //status code other than 200
        allappointmentList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
    } catch (e, stackTrace) {
      print(e.toString());
      print('Error loading appointments: $e');
      print(stackTrace);
    }
  }
  
  void acceptDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Accept ${truncateString(allappointmentList[index].selectedDay.toString(), 10)} Appointment?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                acceptAppointment(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
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
  
  void acceptAppointment(int index) {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/accept_appointment.php"), body: {
        "appointmentid": allappointmentList[index].appointmentId,
        "pickerid": widget.picker.id,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          loadAllAppointment();
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
      });
    } catch (e) {
      print("An exception was thrown: $e");
    }
  }
}