import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../picker.dart';

class CashWithdrawalPage extends StatefulWidget {
  final Picker picker;
  const CashWithdrawalPage({super.key, required this.picker});

  @override
  State<CashWithdrawalPage> createState() => _CashWithdrawalPageState();
}

class _CashWithdrawalPageState extends State<CashWithdrawalPage> {
  @override
  void initState() {
    super.initState();
  }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountEditingController = TextEditingController();
  final TextEditingController _bankNumEditingController = TextEditingController();
  final TextEditingController _bankNameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Cash Withdrawal', style:TextStyle(color: Colors.green[300])),
        centerTitle: true,
      backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Available Balance:', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 300,
                      height: 70,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                const Text('RM', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 100),
                                Text(
                                  widget.picker.balance.toString(),
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ), 
                  ),
                  const SizedBox(height: 30),
                  const Text('Withdraw', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: 350,
                        height: 130,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children:[
                            const Text('Amount', 
                            style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              const SizedBox(height: 20),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text('RM', style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _amountEditingController,
                                      validator: (val) => val!.isEmpty
                                      ? "Please enter amount."
                                      : null,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter amount',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width:1.0),
                                          gapPadding: 10,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width:1.0),
                                          gapPadding: 10,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      // add controller or onChanged here
                                    ),
                                  ),
                                ],
                              )
                            ]
                          ),
                        ),
                      ), 
                  ),
                  const SizedBox(height: 5),
                  Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.all(5),
                    child: SizedBox(
                      width: 350,
                      height: 220,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children:[
                          const Text('Bank Account', 
                          style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Account Number', style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _bankNumEditingController,
                                    validator: (val) => val!.isEmpty
                                    ? "Please enter a account number."
                                    : null,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Account Number',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.0),
                                        gapPadding: 10,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.0),
                                        gapPadding: 10,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text('Bank Name', style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 45),
                                Expanded(
                                  child: TextFormField(
                                    controller: _bankNameEditingController,
                                    validator: (val) => val!.isEmpty
                                    ? "Please enter a bank name."
                                    : null,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Bank Name',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.0),
                                        gapPadding: 10,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width:1.0),
                                        gapPadding: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]
                        ),
                      ),
                    ), 
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200], //background color of button
                      elevation: 3, //elevation of button
                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 110, left: 110)
                    ),
                    onPressed: confirmWithdraw,
                    child: const Text('Withdraw'),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmWithdraw() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
      msg: "Incomplete Form",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0);
    return;
    }

    double availableBalance = double.parse(widget.picker.balance.toString());
    double enteredAmount = double.parse(_amountEditingController.text);
    
    if (enteredAmount > availableBalance) {
      Fluttertoast.showToast(
        msg: "You don't have sufficient balance!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Withdraw",
            style: TextStyle(),
          ),
          content: const Text("Information Correct?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                cashWithdraw();
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

  void cashWithdraw(){
    String amount = _amountEditingController.text;
    String bankNum = _bankNumEditingController.text;
    String bankName = _bankNameEditingController.text;

    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/cash_withdrawpicker.php"), body: {
        "pickerid": widget.picker.id,
        "amount": amount, 
        "bankNum": bankNum, 
        "bankName": bankName, 
        "withdrawpicker": "withdrawpicker",
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