import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gainfromtrash/config.dart';
import 'package:gainfromtrash/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainscreen.dart';
import 'registrationscreen.dart';
import 'package:http/http.dart' as http;

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  
  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      title: const Text("Log In"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
            flex: 1,
            child: Image.asset('assets/gftonly.png',scale:1)
            ),
            Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
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
                          controller: _passEditingController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _passwordVisible,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock),
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
                        const SizedBox(height: 8,),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value){
                                setState(() {
                                  _isChecked = value!;
                                  saveremovepref(value);
                                });
                              }
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: null,
                                child: const Text('Remember Me',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                )
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 8,),
                        ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[200], //background color of button
                        elevation: 3, //elevation of button
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 113, left: 113)
                      ),
                        onPressed: loginUser,
                        child: const Text('Log In'),
                      ),
            ]),
            ))),
        )),
      ]
      )
    )
  );
  }

  void loginUser() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please fill in the login credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    String _email = _emailEditingController.text;
    String _pass = _passEditingController.text;
    http.post(Uri.parse("${Config.server}/gainfromtrash/php/login_user.php"),
        body: {"email": _email, "password": _pass}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        print(jsonResponse);
        User user = User.fromJson(jsonResponse['data']);
        print(user.phone);
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user)));
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      }
    });
  }

  void goRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen())
      );
  }

  void saveremovepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        Fluttertoast.showToast(
            msg: "Please fill in the login credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }
  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('password')) ?? '';
    if (email.isNotEmpty) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        _isChecked = true;
      });
    }
  }
}