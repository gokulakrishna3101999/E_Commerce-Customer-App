import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/about.dart';
import 'package:shop/account_added..dart';
import 'package:shop/firebase_curd.dart';
import 'package:shop/myOrders.dart';
import 'package:shop/products.dart';
import 'bank.dart';


FireBaseService fireBaseService = new FireBaseService();


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username='',useremail='';

  void retreiveUserDetails() async
  {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String uid;
    try
    {
       if(firebaseAuth.currentUser()!=null)
       {
         final FirebaseUser user = await firebaseAuth.currentUser();
         uid = user.uid.toString();
         Firestore.instance.collection("users").document(uid).get().then((datasnapshot)
         {
           setState(() {
              username = (datasnapshot.data['username']);
              useremail = (datasnapshot.data['email']);
           });
            
         });
       }
    }
    catch(e)
    {
      Fluttertoast.showToast(msg:e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    retreiveUserDetails();
  }


  @override
  Widget build(BuildContext context) {

    //banner carousel widget starts

    Widget imageCarousel = new Container
    (
      height: 270.0,
      child: new Carousel
      (
        boxFit: BoxFit.cover,
        images: 
        [
          AssetImage('images/Banner/clothes.jpg'),
          AssetImage('images/products/skt2.jpg'),
          AssetImage('images/products/pants2.jpg'),
          AssetImage('images/Banner/c4.jpg'),
          AssetImage('images/Banner/c5.jpg'),
          AssetImage('images/Banner/c2.jpg'),
          AssetImage('images/Banner/s3.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 500),
        dotBgColor: Colors.transparent,
      ),
    );

//banner carousel widget ends 


    return Scaffold
    (
     //header starts 
     appBar: new AppBar
     (
       elevation: 0.0,
       centerTitle: true,
       title: new Text("Shop", style: new TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
     ), 
     //header ends
     //drawer starts
     drawer: new Drawer
     (
       child: new ListView
       (
         children: <Widget>
         [
           new UserAccountsDrawerHeader
           (
             currentAccountPicture: GestureDetector
             (
               child: new CircleAvatar
               (
                 child: Icon(Icons.person, color:Colors.white),
                 backgroundColor: Colors.grey,
               ),
             ),
             accountName: Text(username),
             accountEmail: Text(useremail),
          ),
         InkWell
         (
           onTap: ()
           {
              Navigator.push(
               context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
           },
           child: ListTile
                  (
                   leading: Icon(Icons.home,color: Colors.pink,),
                   title: new Text("Home", style: new TextStyle(color: Colors.grey,fontSize: 17.0)),
                  ),
         ),
         InkWell
         (
           onTap: () async
           {
              FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              final FirebaseUser user = await firebaseAuth.currentUser();
              String uid = user.uid.toString();
              DocumentSnapshot documentSnapshot = await Firestore.instance.collection("users").document(uid).get();
              bool result = documentSnapshot.data['bank account'];
              if(result==false)
              Navigator.push(
               context, MaterialPageRoute(builder: (BuildContext context) => Bank()));
               else 
               Navigator.push(
               context, MaterialPageRoute(builder: (BuildContext context) => Account()));
           },
           child: ListTile
                  (
                   leading: Icon(Icons.account_balance_wallet,color: Colors.pink,),
                   title: new Text("Add Your Bank Account", style: new TextStyle(color: Colors.grey,fontSize: 17.0)),
                  ),
         ),
         InkWell
         (
           onTap: ()
           {
              Navigator.push(
               context, MaterialPageRoute(builder: (BuildContext context) => MyOrders()));
           },
           child: ListTile
                  (
                   leading: Icon(Icons.shopping_basket,color: Colors.pink,),
                   title: new Text("My Orders", style: new TextStyle(color: Colors.grey,fontSize: 17.0)),
                  ),
         ),
         InkWell
         (
           onTap: ()
           {
             fireBaseService.signOut(context);
           },
           child: ListTile
                  (
                   leading: Icon(Icons.exit_to_app,color: Colors.pink,),
                   title: new Text("Sign Out", style: new TextStyle(color: Colors.grey,fontSize: 17.0)),
                  ),
         ),
         InkWell
         (
           onTap: ()
           {
             Navigator.push(
               context, MaterialPageRoute(builder: (BuildContext context) => About()));
           },
           child: ListTile
                  (
                   leading: Icon(Icons.help,color: Colors.pink,),
                   title: new Text("About", style: new TextStyle(color: Colors.grey,fontSize: 17.0)),
                  ),
         ),
         ],
       ),
     ),
//drawer ends

     body: new ListView
     (
       children: <Widget>
       [
         //banner starts
         imageCarousel,
         //banner ends
          //Latest arrival starts
          Padding(
           padding: const EdgeInsets.all(8.0),
           child: new Center
           (
             child: new Text("Latest Arrival" , style: new TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold),),
           )
         ),

         new Container
         (
           height: 420.0,
           child: Products(),
         ),
         //latest arrival ends
       ],
     ), 
    );
  }
}
