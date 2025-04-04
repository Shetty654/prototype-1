import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample/Home.dart';

class SignUp extends StatefulWidget {
  final String uid;
  const SignUp({super.key, required this.uid});

  @override
  State<SignUp> createState() => _SignUpState();
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
            ElevatedButton(onPressed: (){
                FirebaseFirestore.instance.collection("users").doc(widget.uid).set({
                  "username": usernameController.text,
                  "password": passwordController.text,
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
