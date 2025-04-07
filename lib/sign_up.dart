import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final String uid;
  const SignUp({super.key, required this.uid});

  @override
  State<SignUp> createState() => _SignUpState();
}

Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id ?? "unknown_android_device";
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? "unknown_ios_device";
  } else {
    return "unsupported_platform";
  }
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("sign up")),
      body: Center(
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Enter user name",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "password",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(onPressed: () async {
                String sessionid = await getDeviceId();
                final pref = await SharedPreferences.getInstance();
                pref.setString('sessionid', sessionid);
                FirebaseFirestore.instance.collection("users").doc(widget.uid).set({
                  "username": usernameController.text,
                  "password": passwordController.text,
                  "sessionid": sessionid,
                  "createdAt": Timestamp.now(),
                });
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
            }, child: Text("sign up"))
          ],
        ),
      ),
    );
  }
}
