import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/otpverify.dart';

class MobileAuth extends StatefulWidget {
  const MobileAuth({super.key});

  @override
  State<MobileAuth> createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mobile Auth"), centerTitle: true),
      body: Column(
        children: [
          TextField(
            controller: mobileController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter Phone Number"),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException ex) {},
                codeSent: (String verificationid, int? resendtoken) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPVerify(verificationid: '',)));
                },
                codeAutoRetrievalTimeout: (String verificationid) {},
                phoneNumber: mobileController.text.toString(),
              );
            },
            child: Text("Verify Phone Number"),
          ),
        ],
      ),
    );
  }
}
