import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'HomePage.dart';
import 'SignIn.dart';
import 'package:uuid/uuid.dart';

class FireBaseService
{

  void register(BuildContext context,String email,String password,String username) async
  {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    ProgressDialog progressDialog;

    //progress dialog start
        progressDialog = new ProgressDialog(context);

         progressDialog.style(
            message: 'Signing Up......',
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
            );

        //progress dialog ends
        
    progressDialog.show();
          FirebaseUser firebaseUser = await firebaseAuth.currentUser();
          if(firebaseUser == null)
          {
            try
            {
                FirebaseUser createUser = (await firebaseAuth.createUserWithEmailAndPassword
                (
                  email: email, 
                  password:password)
                ).user;
            //adding user to the table or relation
             Firestore.instance.collection("users").document(createUser.uid).setData
            (
             {
            "id":createUser.uid,
            "username":username,
            "email":email,
            "bank account":false,
            "account number":0,
            "account balance":0,
            "pin":0
             }
            );
          
                progressDialog.hide();
                Fluttertoast.showToast(msg: "Account Created Successfully");
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
            }
            catch(e)
            {
              progressDialog.hide();
               Fluttertoast.showToast(msg: e.toString(),toastLength: Toast.LENGTH_LONG);
            }
          }
  }
   
  //backend google sign in code starts
  Future handleSignIn(BuildContext context) async
  {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    ProgressDialog progressDialog;

    //progress dialog start
        progressDialog = new ProgressDialog(context);

         progressDialog.style(
            message: 'Signing In......',
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
            );

        //progress dialog ends

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken,);
    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    if(firebaseUser != null)
    {
      progressDialog.show();
      final QuerySnapshot result = await Firestore.instance.collection("users").where("id",isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if(documents.length == 0)
     {
       //adding user to the table or relation
       Firestore.instance.collection("users").document(firebaseUser.uid).setData
       (
         {
            "id":firebaseUser.uid,
            "username":firebaseUser.displayName,
            "profilePicture":firebaseUser.photoUrl,
            "email":firebaseUser.email,
            "bank account":false,
            "account number":0,
            "account balance":0,
            "pin":0
         }
      );
     }
     progressDialog.hide();
     Fluttertoast.showToast(msg: "Welcome");
     Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    else
    {
      Fluttertoast.showToast(msg: "Login Failed");
    }
  }


 // signin method starts here
   void login(BuildContext context,String email,String password) async
   {
    final FirebaseAuth auth = FirebaseAuth.instance;
    ProgressDialog progressDialog;

    //progress dialog start
        progressDialog = new ProgressDialog(context);

         progressDialog.style(
            message: 'Signing In......',
            borderRadius: 10.0,
            backgroundColor: Colors.white,
            progressWidget: CircularProgressIndicator(),
            elevation: 10.0,
            insetAnimCurve: Curves.easeInOut,
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
            );

        //progress dialog ends
        progressDialog.show();
       try
       {
        FirebaseUser user = (await auth.signInWithEmailAndPassword
                                 (
                                    email: email, 
                                    password: password)
                            ).user;
       progressDialog.hide();
       print("${user.uid}");
       Fluttertoast.showToast(msg:"welcome");
      Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
      catch(e)
      {
         progressDialog.hide();
        Fluttertoast.showToast(msg: e.toString());
      }
   }


  //check for google sign in
  void checkUserIsSignnedIn(BuildContext context) async 
  {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    bool isLoggedIn = await googleSignIn.isSignedIn();

    if(isLoggedIn)
    {
      Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  //return the current user 
  Future<FirebaseUser> getUser() async
  { 
    FirebaseAuth auth = FirebaseAuth.instance;
    return await auth.currentUser();
  }

  //signout method
  void signOut(BuildContext context)
  {
    GoogleSignIn googleSignIn = new GoogleSignIn();
    googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => SignIn()));
  }
  //buy products starts

  void buyProducts(String name,String oldPrice,String newPrice,String productID,String username,String picture)
  {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Fluttertoast.showToast(msg: "Your Order is Placed successfully $username");
                           firebaseAuth.currentUser().then((firebaseUser)
                           {
                              var id = Uuid();
                              String uuid = id.v1().toString();
                              Firestore.instance.collection(firebaseUser.uid).document(uuid).setData
                               (
                                 {
                                   "random id":uuid.toString(),
                                   "product id":productID,
                                   "id":firebaseUser.uid,
                                   "product name":name,
                                   "product picture":picture,
                                   "product old price":oldPrice,
                                   "product price":newPrice
                                 }
                                );
                                Firestore.instance.collection("orders").document(uuid.toString()).setData
                               (
                                 {
                                   "name":username,
                                   "picture":picture,
                                   "price":newPrice,
                                   "random id":uuid.toString(),
                                   "product id":productID,
                                   "id":firebaseUser.uid,
                                   "product name":name,
                                   "product old price":oldPrice,
                                   "product price":newPrice
                                 }
                                );
                              
                           });
  }

  //cancel prodcuts 

  void cancelOrder(String name,String orderID)async
  {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Fluttertoast.showToast(msg: "your Order has been cancelled");
                           firebaseAuth.currentUser().then((firebaseUser)
                           {
                             Firestore.instance.collection(firebaseUser.uid).document(orderID).delete();
                             Firestore.instance.collection("orders").document(orderID).delete();
                           });
  }

}