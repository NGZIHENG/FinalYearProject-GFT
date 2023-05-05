import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../appointment.dart';
import '../config.dart';
import '../user.dart';

class PendingPage extends StatefulWidget {
  final User user;
  const PendingPage({super.key, required this.user});

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  List<Appointment> appointmentList = <Appointment>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    loadAppointment();
  }

  @override
  void dispose() {
    appointmentList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: appointmentList.isEmpty
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
              itemCount: appointmentList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.green[100],
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onLongPress: () {
                      deleteDialog(index);
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
                                'Date: ${truncateString(appointmentList[index].selectedDay.toString(), 10)}',
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
                                truncateString(appointmentList[index].selectedSessionType.toString(), 25),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(width: 40),
                              Text(
                                'Location: ${truncateString(appointmentList[index].selectedLocation.toString(), 20)}',
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
          const Text('Long Press To Delete Appointment!',style: TextStyle(fontSize: 10)),
          const SizedBox(height: 10),
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
  
  Future<void> loadAppointment() async {
    try {
      http.get(Uri.parse("${Config.server}/gainfromtrash/php/load_appointment.php?userid=${widget.user.id}"),
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
          if (extractdata['appointment'] != null) {
            //check if array object is not null
            appointmentList = <Appointment>[]; //complete the array object definition
              //check if homestay is not null
              extractdata['appointment'].forEach((v) {
                //traverse products array list and add to the list object array productList
                appointmentList.add(Appointment.fromJson(v)); //add each product array to the list object array productList
              });
            
            titlecenter = "Found";
          }else {
            titlecenter =
                "No Appointment Available"; //if no data returned show title center
            appointmentList.clear();
          }
        } else {
          titlecenter = "No Appointment Available";
        }
      } else {
        titlecenter = "No Appointment Available"; //status code other than 200
        appointmentList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
    } catch (e, stackTrace) {
      print(e.toString());
      print('Error loading appointments: $e');
      print(stackTrace);
    }
    
  }
  
  deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete ${truncateString(appointmentList[index].selectedDay.toString(), 10)} Appointment?",
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
                deleteAppointment(index);
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
  
  void deleteAppointment(int index) {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/delete_appointment.php"), body: {
        "appointmentid": appointmentList[index].appointmentId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          loadAppointment();
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