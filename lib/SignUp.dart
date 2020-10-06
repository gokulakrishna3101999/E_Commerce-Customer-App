import 'package:flutter/material.dart';
import 'SignIn.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController userNameController = TextEditingController();



class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


      final formKey = GlobalKey<FormState>();


       @override
      Widget build(BuildContext context) {

        return Scaffold
        (
          appBar: new AppBar
          (
            centerTitle: true,
            elevation: 0.0,
            title: new Text("Register",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
          ),
          body: new Form
          (
            key: formKey,
            child: ListView
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
                padding: const EdgeInsets.only(left: 20.0, right:20.0),
                child: TextFormField
                (                
                  decoration: InputDecoration
                  (
                    icon:Icon(Icons.account_circle),
                    hintText: "Enter your username",
                  ),
                  controller: userNameController,
                  validator: (value)
                  {
                    return value.isEmpty ? 'Username is required' : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right:20.0),
                child: TextFormField
                (
                  decoration: InputDecoration
                  (
                    icon:Icon(Icons.alternate_email),
                    hintText: "Enter your email address",
                  ),
                  controller: emailController,
                  validator: (value)
                  {
                    return value.isEmpty ? 'email is required' : null;
                  },
                ),
              ),

              ListTile(
                title:TextFormField
                (
                  obscureText: true,
                  decoration: InputDecoration
                  (
                    icon:Icon(Icons.lock_outline),
                    hintText: "Enter your password",
                  ),
                  controller: passwordController,
                  validator: (value)
                  {
                    return value.isEmpty ? 'password is required' : null;
                  },
                ),
                //add show passowrd after wards
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
                             fireBaseService.register(context, emailController.text, passwordController.text, userNameController.text);
                          } 
                        },
                        color: Colors.pink,
                        child: new Text("Register",textAlign: TextAlign.center,style:new TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
              ),
               FlatButton
                (
                  onPressed: ()
                  {
                    Navigator.pushReplacement(
                         context, MaterialPageRoute(builder: (BuildContext context) => SignIn()));
                  },
                  child: new Text("Already Have An Account ? Login ",style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),),
                ),
            /*Center
                  (
                    child: new Text("Or",style: new TextStyle(color: Colors.pink))
                  ),
             For future google sign in button
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: new Container
                (
                 alignment: Alignment.bottomCenter,
                 child: GoogleSignInButton
                    (
                      onPressed: handleSignIn,
                      borderRadius: 10.0,
                    ),
                ),
              ),*/
            ],
          ),
          ),
        );
      }
}
