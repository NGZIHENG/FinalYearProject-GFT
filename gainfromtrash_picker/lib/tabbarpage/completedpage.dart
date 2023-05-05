import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appointment.dart';
import '../config.dart';
import '../picker.dart';

class CompletedPage extends StatefulWidget {
  final Picker picker;
  const CompletedPage({super.key, required this.picker});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  List<Appointment> completedappointmentList = <Appointment>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    loadCompletedAppointment();
  }

  @override
  void dispose() {
    completedappointmentList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Colors.white,
    body: completedappointmentList.isEmpty
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
              itemCount: completedappointmentList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.green[100],
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'Date: ${truncateString(completedappointmentList[index].selectedDay.toString(), 10)}',
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
                              truncateString(completedappointmentList[index].selectedSessionType.toString(), 25),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'Location: ${truncateString(completedappointmentList[index].selectedLocation.toString(), 20)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
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
  
  Future<void> loadCompletedAppointment() async {
    try {
      http.get(Uri.parse("${Config.server}/gainfromtrash/php/load_completedappointment.php?pickerid=${widget.picker.id}"),
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
          if (extractdata['completedappointment'] != null) {
            //check if array object is not null
            completedappointmentList = <Appointment>[]; //complete the array object definition
              //check if homestay is not null
              extractdata['completedappointment'].forEach((v) {
                //traverse products array list and add to the list object array productList
                completedappointmentList.add(Appointment.fromJson(v)); //add each product array to the list object array productList
              });
            
            titlecenter = "Found";
          }else {
            titlecenter =
                "No Appointment Available"; //if no data returned show title center
            completedappointmentList.clear();
          }
        } else {
          titlecenter = "No Appointment Available";
        }
      } else {
        titlecenter = "No Appointment Available"; //status code other than 200
        completedappointmentList.clear(); //clear productList array
      }
      setState(() {}); //refresh UI
    });
    } catch (e, stackTrace) {
      print(e.toString());
      print('Error loading appointments: $e');
      print(stackTrace);
    }
  }
        
}