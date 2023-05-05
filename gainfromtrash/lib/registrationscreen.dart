import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
    loadEula();
  }
  bool _isChecked = false;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _confirmpassEditingController = TextEditingController();
  String eula = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.white,
      ),
      body:Center(
        child:SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  const Text('Gain Now!', style:TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameEditingController,
                    keyboardType: TextInputType.text,
                    validator: (val) => val!.isEmpty || (val.length < 3)
                      ? "Name must be more than 3 words"
                      : null,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter your name',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            )
                    )
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val!.isEmpty || !val.contains("@") || !val.contains(".")
                      ? "Enter a valid email"
                      : null,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            )
                    )
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Enter your phone number',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.phone),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            )
                    )
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passEditingController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    validator: (val) => validatePassword(val.toString()),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(Icons.password),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                    suffixIcon: IconButton(
                        icon: Icon(
                        _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                        ),
                        onPressed: () {
                        setState(() {
                        _passwordVisible = !_passwordVisible;
                        });
                        },
                      ),
                    )
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordVisible,
                    controller: _confirmpassEditingController,
                    validator: (val) {
                      validatePassword(val.toString());
                      if (val != _passEditingController.text) {
                        return "Password Do Not Match";
                      } else {
                          return null;
                        }
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Enter password again',
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(Icons.password_outlined),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(width:1.0),
                              gapPadding: 10,
                            ),
                      suffixIcon: IconButton(
                        icon: Icon(
                        _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                        ),
                        onPressed: () {
                        setState(() {
                        _passwordVisible = !_passwordVisible;
                        });
                        },
                      ),
                    )
                  ),
                  const SizedBox(height: 20),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value){
                          setState(() {
                            _isChecked = value!;
                          });
                        }
                      ),
                      const Text('I Agree with '),
                      Flexible(
                        child: GestureDetector(
                          onTap: showEula,
                          child: const Text('Terms & Conditions',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          )
                        )
                      ),
                    ],
                  ),
                  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], //background color of button
                        elevation: 3, //elevation of button
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 113, left: 113)
                      ),
                        onPressed: _registerAccount,
                        child: const Text('Register'),
                  ),
                ])
              )
            )
          )
        )
      )
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return '1[A-Z], 1[a-z], 1[0-9] and >10 characters';
      } else {
        return null;
      }
    }
  }

  void _registerAccount() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String pass = _passEditingController.text;

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
      msg: "Incomplete Registration Form",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0);
    return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
      msg: "Cannot Register If Not Agree with T&C",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 14.0);
    return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
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
                _registerUser(name,email,phone,pass);
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

  loadEula() async {
    WidgetsFlutterBinding.ensureInitialized();
    eula = await rootBundle.loadString('assets/eula.txt');
  }

  showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
        
  void _registerUser(String name, String email, String phone, String pass) {
    try {
      http.post(Uri.parse("${Config.server}/gainfromtrash/php/register_user.php"),
      body: {"name": name, "email": email, "phone": phone, "password": pass, "register": "register"})
      .then((response) {
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
