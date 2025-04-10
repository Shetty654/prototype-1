import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/Home.dart';
import 'package:sample/otp_verify.dart';
import 'package:sample/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileAuth extends StatefulWidget {
  const MobileAuth({super.key});

  @override
  State<MobileAuth> createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {
  TextEditingController mobileController = TextEditingController();

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


  Future<void> handlePostLogin(User user, BuildContext context) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!snapshot.exists) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUp(uid: user.uid)),
      );
    } else {
      String sessionId = await getDeviceId();
      final pref = await SharedPreferences.getInstance();
      await pref.setString('sessionid', sessionId);
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "sessionid": sessionId,
      }, SetOptions(merge: true));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
      return const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Mobile Auth"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: "+91" + mobileController.text.trim(),
                  verificationCompleted: (PhoneAuthCredential credential) async {
                    await FirebaseAuth.instance.signInWithCredential(credential);
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await handlePostLogin(user, context);
                    }
                  },
                  verificationFailed: (FirebaseAuthException ex) {
                    print("Verification Failed: ${ex.message}");
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OTPVerify(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text('VERIFY PHONE NUMBER')),
            ),
          ],
        ),
      ),
    );
  }
}
