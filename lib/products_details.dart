import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomePage.dart';
import 'about.dart';
import 'account_added..dart';
import 'bank.dart';
import 'myOrders.dart';

String randomID;

Future getData() async
  {
    var firestore = Firestore.instance;
    QuerySnapshot data = await firestore.collection("products").getDocuments();
    return data.documents;
  }

class ProductsDetails extends StatefulWidget {

  final productDetailName;
  final productDetailOldPrice;
  final productDetailPrice;
  final productDetailPicture;
  final productID;

  ProductsDetails
  ({
    this.productDetailName,
    this.productDetailOldPrice,
    this.productDetailPicture,
    this.productDetailPrice,
    this.productID
  });


  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
    return Scaffold
    (
       appBar: new AppBar
       (
       title: new InkWell
       (
         onTap: ()
         {
             Navigator.pop(context);
             Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()),);
         },
        child: new Center
        (
          child:new Text("Shop", style: new TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
        )
       ),
       ),

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
            //this is for image,products name,price ,old price
            new Container
            (
              height: 450.0,
              child: GridTile
              (
                child: new Container
                (
                  child: Image.network(widget.productDetailPicture,fit: BoxFit.cover,),
                ),
                footer: new Container
                (
                  color: Colors.white70,
                  child: ListTile
                  (
                    leading: Padding(
                      padding: const EdgeInsets.only(top:5.0),
                      child: Text(widget.productDetailName,style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                    title: new Row
                    (
                      children: <Widget>
                      [
                        Expanded
                        (
                          child: Padding(
                            padding: const EdgeInsets.only(left:30.0),
                            child: new Text("\$${widget.productDetailOldPrice}",
                            style: new TextStyle(color: Colors.black45,decoration: TextDecoration.lineThrough,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Expanded
                        (
                            child: new Text("\$${widget.productDetailPrice}",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),   
                  ),
                ),
              ),
            ),
            //buy now starts
             Row
            (
                 children: <Widget>
                 [
                   Expanded
                   (
                     child: Padding(
                       padding: const EdgeInsets.only(left:13.0,right: 13.0),
                       child: MaterialButton
                       (
                         elevation: 0.2,
                         onPressed: () async
                         {
                             FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                             final FirebaseUser user = await firebaseAuth.currentUser();
                             String uid = user.uid.toString();
                             DocumentSnapshot documentSnapshot = await Firestore.instance.collection("users").document(uid).get();
                             bool result = documentSnapshot.data['bank account'];
                             if(result==true)
                             {
                             String username; 
                             final FirebaseUser user = await firebaseAuth.currentUser();
                             String uid = user.uid.toString();
                             DocumentSnapshot snapshot = await Firestore.instance.collection("users").document(uid).get();  
                             username = snapshot.data['username'].toString();
                             if(snapshot.data['account balance']>=(int.parse(widget.productDetailPrice.toString())))
                             {
                               fireBaseService.buyProducts(widget.productDetailName, widget.productDetailOldPrice.toString(), widget.productDetailPrice.toString(),widget.productID,username,widget.productDetailPicture);
                             } 
                             else
                                 Fluttertoast.showToast(msg: "Insufficient Balance");     
                             }
                             else
                             {
                               Fluttertoast.showToast(msg: "Add Your Bank Account First");
                                Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (BuildContext context) => Bank()));
                             }   
                         },
                         textColor: Colors.white,
                         color: Colors.pink,
                         child: new Text("Buy Now",style: new TextStyle(fontWeight: FontWeight.bold),),
                       ),
                     ),
                   ),
                   //buy now ends
                   //cancel order starts
                   /* Expanded
                   (
                     child: Padding(
                       padding: const EdgeInsets.only(left:13.0,right: 13.0),
                       child: MaterialButton
                       (
                         elevation: 0.2,
                         onPressed: ()
                         {
                           FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                           
                           firebaseAuth.currentUser().then((firebaseUser)
                           {
                             Firestore.instance.collection(firebaseUser.uid).document(widget.productDetailName).get().then((value) 
                             {
                               setState(() {
                                  randomID = value.data['random id'].toString();
                               });
                               fireBaseService.cancelOrder(widget.productDetailName,randomID);
                             });
                           });
                         },
                         textColor: Colors.white,
                         color: Colors.pink,
                         child: new Text("Cancel Order",style: new TextStyle(fontWeight: FontWeight.bold),),
                       ),
                     ),
                   ),*/
                   //cancel order ends
                 ],
            ),
            Divider(color: Colors.grey,),
            //Product Details and Description Starts
            new ListTile
            (
              title: new Text("Products details",style:new TextStyle(color: Colors.black45,fontWeight:FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: new Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vulputate dignissim suspendisse in est ante in. Sit amet nulla facilisi morbi tempus iaculis urna id volutpat. Luctus venenatis lectus magna fringilla urna porttitor. Dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim. Metus dictum at tempor commodo ullamcorper a. Purus gravida quis blandit turpis cursus in hac. Bibendum ut tristique et egestas quis. Nunc non blandit massa enim nec dui. "),
              ),
            ),
            //Product Details and Description ends
            //Suggested for you Starts
            Padding(
              padding: const EdgeInsets.only(left:16.0,top: 20.0),
              child: new Text("Suggested For You",style: new TextStyle(color: Colors.black,fontWeight:FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: new Container
              (
                height: 370.0,
                child: SuggestedForYou(),
              ),
            ),
            //suggetsed for you ends
          ],         
       ),  
    );
  }
}

//suggested for you main class starts here
class SuggestedForYou extends StatefulWidget {
  @override
  _SuggestedForYouState createState() => _SuggestedForYouState();
}

class _SuggestedForYouState extends State<SuggestedForYou> {

  @override
  Widget build(BuildContext context) {
        return Container(
      child: FutureBuilder
      (
        future: getData(),
        builder: (context,AsyncSnapshot snapshot)
      {
         if(snapshot.connectionState == ConnectionState.waiting)
         return Center
         (
           child: Text("Loading Products...",style: new TextStyle(color:Colors.pink),),
         );
         else
         {
           return GridView.builder
    (
      itemCount: snapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
      itemBuilder: (BuildContext context,int index)
      {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: SuggestSingleProducts
          (
            productsName: snapshot.data[index].data['name'],
            productsOldPrice: snapshot.data[index].data['oldPrice'],
            productsPrice: snapshot.data[index].data['price'],
            productsPicture: snapshot.data[index].data['picture'],
            productID:snapshot.data[index].data['random id'],
          ),
        );
      },
    );
         }
      }),
    );
  }
}

class SuggestSingleProducts extends StatelessWidget {
  final productsName;
  final productsPicture;
  final productsOldPrice;
  final productsPrice;
  final productID;

  SuggestSingleProducts({this.productsName,this.productsPicture,this.productsOldPrice,this.productsPrice,this.productID});
  @override
  Widget build(BuildContext context) {
    return Card
    (
      child: Hero
      (
        tag: new Text("hero"),
        child: Material
        (
         child: InkWell
         (
           onTap: ()
           {
              Navigator.push(context,MaterialPageRoute(builder: (context) => ProductsDetails
              (
                productDetailName: productsName,
                productDetailPicture: productsPicture,
                productDetailPrice: productsPrice,
                productDetailOldPrice: productsOldPrice,
                productID: productID,
              )),);
           },
           child: GridTile
           (
             footer: Container
             (
               height: 30.0,
               color: Colors.white,
               child: new Row
               (
                 children: <Widget>
                 [
                   Expanded
                   (
                     child: Text(productsName,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                   ),
                   new Text("\$$productsPrice",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,))
                 ],
               )
             ),
             child: Image.network(productsPicture,fit: BoxFit.cover,),
           ),
         ),
        ),
      ),
    );
  }
}

//suggested for you main class ends here