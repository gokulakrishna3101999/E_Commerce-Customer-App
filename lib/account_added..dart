import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/bank.dart';

String username='',email='';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
     appBar: new AppBar
     (
       title: new Text("Account Status",style:new TextStyle(color: Colors.white,fontWeight:FontWeight.bold)),
     ),  
     body: new ListView
     (
       children: <Widget>
       [
         Padding(
                padding: const EdgeInsets.only(top:60.0,right: 20.0),
                child: CircleAvatar
                (
                  radius: 80.0,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('images/added.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: Center
                (
                  child: new Text("Your Account is Added Successfully",style:new TextStyle(fontSize:18,color: Colors.green,fontWeight:FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:80.0,right: 80.0,top:50.0),
                child: RaisedButton
                (
                  onPressed: () async
                  {
                      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                          final FirebaseUser user = await firebaseAuth.currentUser();
                          String uid = user.uid.toString();
                          DocumentSnapshot documentSnapshot = await Firestore.instance.collection("users").document(uid).get();
                           username = documentSnapshot.data['username'].toString();
                           email = documentSnapshot.data['email'].toString();
                           Firestore.instance.collection("users").document(uid).updateData({
                             "id":uid,
                             "username":username,
                             "email":email,
                             "bank account":false,
                             "account number":0,
                             "account balance":0,
                             "pin":0
                          });
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (BuildContext context) => Bank()));
                  },
                  color: Colors.pink,
                  child: new Text("REMOVE ACCOUNT",textAlign: TextAlign.center,style:new TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                ),
              )
       ],
     ),
    );
  }
}