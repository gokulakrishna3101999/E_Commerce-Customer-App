import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: new AppBar
      (
        elevation: 0.0,
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text('About',style: TextStyle(color: Colors.white),),
      ),  
      body: new ListView
      (
        children: <Widget>
        [
          Padding(
                padding: const EdgeInsets.only(top:10.0,right: 20.0),
                child: CircleAvatar
                (
                  radius: 90.0,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('images/logo.png'),
                ),
              ),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Center(child: Text("Welcome to shoppy",style: new TextStyle(fontSize: 20.0,color: Colors.pink),),),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 8.0,top: 30.0),
            child: Text("Welcome to Shoppy, your number one source for all things product, such as shoes, Blazers, clothes. We're dedicated to giving you the very best of product, with a focus on dependability, customer service and uniqueness.",
            style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),
            ),          
          ),

          Padding(
            padding: const EdgeInsets.only(left:60.0,right: 18.0,top: 20.0),
            child: Row
            (
              children: <Widget>
              [
                 Text("Developers:",style: TextStyle(fontSize: 15.0,color: Colors.pink,fontWeight: FontWeight.bold),),
                 Text("Mohamed Hashim,Gokulakrishna",style: TextStyle(fontSize: 14.0,color: Colors.black,fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        
        Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Center(child: Text("Version 1.0",style: TextStyle(fontSize: 18.0,color: Colors.pink,fontWeight: FontWeight.bold)),),
        )
        ],
      ),
    );
  }
}