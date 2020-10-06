import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
String userID,pName,orderID;

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {

  void retreiveUserID() async
  {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String uid;
    try
    {
       if(firebaseAuth.currentUser()!=null)
       {
         final FirebaseUser user = await firebaseAuth.currentUser();
         uid = user.uid.toString();
         setState(() {
           userID = uid.toString();
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
    retreiveUserID();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
     appBar: AppBar
     (
       title: Text("My orders"),
       actions: <Widget>
       [
         IconButton(icon: Icon(Icons.refresh), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyOrders()));})
       ],
     ), 
      body: Data(),
    );
  }
}


class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
 
 //alert dialog box starts

 createDeleteDialog(BuildContext context,String orderid)
 {
   return showDialog
   (
     context:context,
     builder:(context)
     {
       return AlertDialog
       (
         title: Text("Do You Want Cancel Order",style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
         actions: <Widget>
         [
           FlatButton(onPressed: ()
           {
              Firestore.instance.collection(userID).document(orderid).delete();
              Firestore.instance.collection("orders").document(orderid).delete();
              Fluttertoast.showToast(msg: "your Order has been cancelled");   
              Navigator.of(context).pop();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyOrders()));    
           }, child: Text("Yes",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,),
           FlatButton(onPressed: ()
           {
              Navigator.of(context).pop();
           }, child: Text("No",style:TextStyle(color: Colors.pink,fontWeight:FontWeight.bold,fontSize:18.0)),color: Colors.white,)
         ],
       );
     }
   );
 }

 //alert dialog box ends

//get all the ordered prducts of the user starts
  Future getProducts () async
  {
    var firestore = Firestore.instance;
    QuerySnapshot data =await firestore.collection("$userID").getDocuments();
    return data.documents;
  }

//get all the ordered prducts of the user ends

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:0.0),
      child: Container(
        child:FutureBuilder
        (
          future: getProducts(),
          builder: (context,snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child:Text("Loading .......",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),));
            else
            {
               return GridView.builder
               (
                 itemCount: snapshot.data.length,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2) ,
                 itemBuilder: (context,index)
                 {
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
                          setState(() {
                            orderID = snapshot.data[index].data['random id'].toString();
                          });
                          createDeleteDialog(context,orderID);
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
                                 child: Text("${snapshot.data[index].data['product name']}",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                                 ),
                               new Text("${snapshot.data[index].data['product price']}",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,))
                              ],
                            )
                          ),
                           child: Image.network("${snapshot.data[index].data['product picture']}",fit: BoxFit.cover,),
                        ),
                        ),
                      ),
                      ),
                    );
                   }
                );
            }
          },
        )
      ),
    );
  }
}