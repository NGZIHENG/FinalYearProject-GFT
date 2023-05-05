import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../appointment.dart';
import '../config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../picker.dart';
import '../user.dart';

class PickUpPage extends StatefulWidget {
  final Picker picker;
  const PickUpPage({super.key, required this.picker});

  @override
  State<PickUpPage> createState() => _PickUpPageState();
}

class _PickUpPageState extends State<PickUpPage> {
  List<Appointment> pickupappointmentList = <Appointment>[];
  String titlecenter = "Loading...";
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadPickUpAppointment();
  }

  @override
  void dispose() {
    pickupappointmentList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Colors.white,
    body: pickupappointmentList.isEmpty
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
              itemCount: pickupappointmentList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.green[100],
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      completeDialog(index);
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
                                'Date: ${truncateString(pickupappointmentList[index].selectedDay.toString(), 10)}',
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
                                truncateString(pickupappointmentList[index].selectedSessionType.toString(), 25),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(width: 40),
                              Text(
                                'Location: ${truncateString(pickupappointmentList[index].selectedLocation.toString(), 20)}',
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

  Future<void> loadPickUpAppointment() async {
    try {
        http.get(Uri.parse("${Config.server}/gainfromtrash/php/load_pickupappointment.php?pickerid=${widget.picker.id}"),
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
            if (extractdata['pickupappointment'] != null) {
              //check if array object is not null
              pickupappointmentList = <Appointment>[]; //complete the array object definition
                //check if homestay is not null
                extractdata['pickupappointment'].forEach((v) {
                  //traverse products array list and add to the list object array productList
                  pickupappointmentList.add(Appointment.fromJson(v)); //add each product array to the list object array productList
                });
              
              titlecenter = "Found";
            }else {
              titlecenter =
                  "No Appointment Available"; //if no data returned show title center
              pickupappointmentList.clear();
            }
          } else {
            titlecenter = "No Appointment Available";
          }
        } else {
          titlecenter = "No Appointment Available"; //status code other than 200
          pickupappointmentList.clear(); //clear productList array
        }
        setState(() {}); //refresh UI
      });
      } catch (e, stackTrace) {
        print(e.toString());
        print('Error loading appointments: $e');
        print(stackTrace);
      }
  }

  void completeDialog(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Pick Up ${truncateString(pickupappointmentList[index].selectedDay.toString(), 10)} Appointment?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your amount';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Complete",
                style: TextStyle(),
              ),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  Fluttertoast.showToast(
                  msg: "Please enter amount",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: 14.0);
                return;
                }
                Navigator.of(context).pop();
                String newamount = _amountController.text;
                updateAmount(index, newamount);
                updatePickerBalance();
                updateUserBalance(index, newamount);
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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
  
  Future<void> updateAmount(index,String newamount) async {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/completed_appointment.php"), body: {
        "appointmentid": pickupappointmentList[index].appointmentId,
        "newamount": newamount,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          loadPickUpAppointment();
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
  
  void updatePickerBalance() {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/update_pickerbalance.php"), body: {
        "pickerid": widget.picker.id,
        "pickerbalance": "pickerbalance",
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
  
  void updateUserBalance(index,String newamount) {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/update_userbalance.php"), body: {
        "userid": pickupappointmentList[index].userId,
        "newamount": newamount,
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

        
