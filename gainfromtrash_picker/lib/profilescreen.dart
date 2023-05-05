import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'loginscreen.dart';
import 'picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';
import 'welcomescreen.dart';

class ProfileScreen extends StatefulWidget {
  final Picker picker;
  const ProfileScreen({super.key, required this.picker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final df = DateFormat('dd/MM/yyyy');
  bool isDisable = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  Random random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.picker.id == "0") {
      isDisable = true;
    } else {
      isDisable = false;
    }
    _nameController.text = widget.picker.name.toString();
    _phoneController.text = widget.picker.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('Profile'),
      backgroundColor: Colors.green[300],
    ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              child: Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(widget.picker.name.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 8),
                          child: Divider(
                            color: Colors.blueGrey,
                            height: 2,
                            thickness: 2.0,
                          ),
                        ),
                        Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.3),
                            1: FractionColumnWidth(0.7)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              const Icon(Icons.email),
                              Text(widget.picker.email.toString()),
                            ]),
                            TableRow(children: [
                              const Icon(Icons.phone),
                              Text(widget.picker.phone.toString()),
                            ]),
                            widget.picker.regdate.toString() == ""
                                ? TableRow(children: [
                                    const Icon(Icons.date_range),
                                    Text(df.format(DateTime.parse(
                                        widget.picker.regdate.toString())))
                                  ])
                                : TableRow(children: [
                                    const Icon(Icons.date_range),
                                    Text(df.format(DateTime.now()))
                                  ]),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )  
            )
          ),
          Flexible(
            flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.green[300],
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text("PROFILE SETTINGS",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            shrinkWrap: true,
                            children: [
                              ElevatedButton.icon(
                                onPressed: isDisable ? null : updateNameDialog,
                                icon: const Icon(
                                  Icons.person,
                                  size: 24.0,
                                ),
                                label: const Text('UPDATE NAME'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 73, 91, 73)),
                                ),
                              ),
                              const Divider(
                                height: 8,
                              ),
                              ElevatedButton.icon(
                                onPressed: isDisable ? null : updatePhoneDialog,
                                icon: const Icon(
                                  Icons.phone,
                                  size: 24.0,
                                ),
                                label: const Text('UPDATE PHONE NUMBER'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 73, 91, 73)),
                                ),
                              ),
                              const Divider(
                                height: 8,
                              ),
                              ElevatedButton.icon(
                                onPressed: isDisable ? null : changePassDialog,
                                icon: const Icon(
                                  Icons.password,
                                  size: 24.0,
                                ),
                                label: const Text('UPDATE PASSWORD'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 73, 91, 73)),
                                ),
                              ),
                              const Divider(
                                height: 8,
                              ),
                              ElevatedButton.icon(
                                onPressed: isDisable ? null : logoutDialog,
                                icon: const Icon(
                                  Icons.logout_rounded,
                                  size: 24.0,
                                ),
                                label: const Text('LOGOUT'),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 243, 93, 83)),
                                ),
                              ),
                            ]
                        )
                    ),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }

  void updateNameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update Name?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newname = _nameController.text;
                updateName(newname);
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

  void updateName(String newname) {
    http.post(Uri.parse("${Config.server}/gainfromtrash/php/update_picker.php"),
        body: {
          "pickerid": widget.picker.id,
          "newname": newname,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.picker.name = newname;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void updatePhoneDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update Phone Number?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phoneController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newphone = _phoneController.text;
                updatePhone(newphone);
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

  void updatePhone(String newphone) {
    http.post(Uri.parse("${Config.server}/gainfromtrash/php/update_picker.php"),
        body: {
          "pickerid": widget.picker.id,
          "newphone": newphone,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {
          widget.picker.phone = newphone;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update Password?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changePass();
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

  void changePass() {
    http.post(Uri.parse("${Config.server}/gainfromtrash/php/update_picker.php"),
        body: {
          "pickerid": widget.picker.id,
          "oldpass": _oldpasswordController.text,
          "newpass": _newpasswordController.text,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        setState(() {});
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(),
          ),
          content: const Text("Are your sure"),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                await prefs.setBool('remember', false);
                Picker picker = Picker(
                  id: "0",
                  email: "unregistered@email.com",
                  name: "unregistered",
                  address: "na",
                  phone: "0123456789",
                  regdate: "0",
                  balance: "0",
                );
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => const WelcomeScreen()));
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


}