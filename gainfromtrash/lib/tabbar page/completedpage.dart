import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appointment.dart';
import '../config.dart';
import '../user.dart';

class CompletedPage extends StatefulWidget {
  final User user;
  const CompletedPage({super.key, required this.user});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  List<Appointment> appointmentList = <Appointment>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    loadCompletedAppointment();
  }

  @override
  void dispose() {
    appointmentList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
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
      http.get(Uri.parse("${Config.server}/gainfromtrash/php/user_completedappointment.php?userid=${widget.user.id}"),
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

}
        
