import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'picker.dart';
import 'withdrawpicker.dart';

class WithdrawalStatusScreen extends StatefulWidget {
  final Picker picker;
  const WithdrawalStatusScreen({super.key, required this.picker});

  @override
  State<WithdrawalStatusScreen> createState() => _WithdrawalStatusScreenState();
}

class _WithdrawalStatusScreenState extends State<WithdrawalStatusScreen> {
  List<WithdrawPicker> withdrawpickerList = <WithdrawPicker>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    loadWithdrawal();
  }

  @override
  void dispose() {
    withdrawpickerList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('Withdrawal History'),
      backgroundColor: Colors.green[300],
      ),
      body: withdrawpickerList.isEmpty
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
              itemCount: withdrawpickerList.length,
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
                              'Amount: ${truncateString(withdrawpickerList[index].amount.toString(), 10)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.money),
                            const SizedBox(width: 15),
                            Text(
                              'Account Number: ${truncateString(withdrawpickerList[index].bankNum.toString(), 20)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              'Bank Name: ${truncateString(withdrawpickerList[index].bankName.toString(), 20)}',
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
  
  Future<void> loadWithdrawal() async {
    try {
      http.get(Uri.parse("${Config.server}/gainfromtrash/php/load_pickerwithdrawal.php?pickerid=${widget.picker.id}"),
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
          if (extractdata['withdrawpicker'] != null) {
            //check if array object is not null
            withdrawpickerList = <WithdrawPicker>[]; //complete the array object definition
              //check if homestay is not null
              extractdata['withdrawpicker'].forEach((v) {
                //traverse products array list and add to the list object array productList
                withdrawpickerList.add(WithdrawPicker.fromJson(v)); //add each product array to the list object array productList
              });
            
            titlecenter = "Found";
          }else {
            titlecenter =
                "No Withdrawal Available"; //if no data returned show title center
            withdrawpickerList.clear();
          }
        } else {
          titlecenter = "No Withdrawal Available";
        }
      } else {
        titlecenter = "No Withdrawal Available"; //status code other than 200
        withdrawpickerList.clear(); //clear productList array
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