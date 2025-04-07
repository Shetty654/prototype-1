import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/mobile_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .snapshots()
        .listen((snapshot) async{
          if(snapshot.exists){
            String remotesessionid = snapshot.data()?['sessionid'];
            final pref = await SharedPreferences.getInstance();
            String? localsessionid = pref.getString('sessionid');
            if(remotesessionid!=localsessionid){
              await FirebaseAuth.instance.signOut();
              Fluttertoast.showToast(
                msg: "Session expired!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER, // center it
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MobileAuth())
              );
            }
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
