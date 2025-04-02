import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/main.dart';

class OTPVerify extends StatefulWidget {
  String verificationid;
  OTPVerify({super.key, required this.verificationid});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verify"),
        centerTitle: true,
      ),
      body: Column(children: [
        TextField(
          controller: otpController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter the otp"
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(onPressed: () async {
          try{
            PhoneAuthCredential credential = await PhoneAuthProvider.credential(verificationId: widget.verificationid, smsCode: otpController.text.toString());
            FirebaseAuth.instance.signInWithCredential(credential).then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "home page")));
            });
          }catch(ex){
            log(ex.toString() as num);
          }
        }, child: Text("OTP"))
      ],),
    );
  }
}
