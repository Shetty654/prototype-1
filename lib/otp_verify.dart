import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/Home.dart';
import 'package:sample/sign_up.dart';
import 'dart:developer';

class OTPVerify extends StatefulWidget {
  final String verificationId;
  OTPVerify({super.key, required this.verificationId});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  TextEditingController otpController = TextEditingController();

  Future<void> handlePostLogin(User user, BuildContext context) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!snapshot.exists) {
      print("User does NOT exist, going to SignUp()");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUp(uid: user.uid)),
      );
    } else {
      print("User exists, going to Home()");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verify"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter the OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otpController.text.trim(),
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await handlePostLogin(user, context);
                  }
                } catch (ex) {
                  log("Error: ${ex.toString()}");
                }
              },
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
