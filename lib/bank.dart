import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/account_added..dart';



String email="",username="";
TextEditingController accountnumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Bank extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  final formKey = GlobalKey<FormState>();

     Future<FirebaseUser> getUser() async
     {
       FirebaseAuth auth = FirebaseAuth.instance;
       return await auth.currentUser();
     }
  
    
      @override
      Widget build(BuildContext context) {
        return Scaffold
        (
          appBar: new AppBar
          (
            centerTitle: true,
            elevation: 0.0,
            title: new Text("Link Your Account",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
          ),
          body: new Form
          (
            key: formKey,
            child: ListView
           (
            children: <Widget>
            [
              Padding(
                padding: const EdgeInsets.only(top:60.0,right: 20.0),
                child: CircleAvatar
                (
                  radius: 80.0,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('images/bank.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right:20.0,top:30.0),
                child: TextFormField
                (
                  decoration: InputDecoration
                  (
                    icon:Icon(Icons.account_balance_wallet),
                    hintText: "Enter your Account number",
                  ),
                  controller: accountnumberController,
                  validator: (value)
                  {
                    return value.isEmpty ? 'Account number is required' : null;
                  },
                ),
              ),

              ListTile
              (
                title: TextFormField
                (
                  obscureText: true,
                  decoration: InputDecoration
                  (
                    icon:Icon(Icons.lock_outline),
                    hintText: "Enter your pin",
                  ),
                  controller: passwordController,
                  validator: (value)
                  {
                    if(value.isEmpty)
                    return 'pin is required';
                    else if(value.length!=4)
                    return 'pin must be four digits';
                    else
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:80.0,right: 80.0,top:30.0),
                child: RaisedButton
                      (
                        onPressed: () async
                        {

                          FormState formState = formKey.currentState;
                          if(formState.validate()) 
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
                             "bank account":true,
                             "account number":int.parse(accountnumberController.text),
                             "account balance":1000,
                             "pin":int.parse(passwordController.text)
                          });
                          formState.reset();
                          }      
                          Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (BuildContext context) => Account()));
                        },
                        color: Colors.pink,
                        child: new Text("ADD ACCOUNT",textAlign: TextAlign.center,style:new TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
              ),
            ],
          ),
          ),
        );
}
}
