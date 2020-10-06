import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:shop/firebase_curd.dart';
import 'HomePage.dart';
import 'SignUp.dart';




TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
FireBaseService fireBaseService = new FireBaseService();



class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final formKey = GlobalKey<FormState>();

  @override
  void initState() 
  {
    super.initState();
    fireBaseService.getUser().then((user)
    {
      if(user!=null)
      Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      else
      fireBaseService.checkUserIsSignnedIn(context);
    });
  }

    
      @override
      Widget build(BuildContext context) {
        return Scaffold
        (
          appBar: new AppBar
          (
            centerTitle: true,
            elevation: 0.0,
            title: new Text("Login",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
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

              ListTile
              (
                title: TextFormField
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
             /* FlatButton
                 (
                   onPressed: (){}, 
                   child: new Text("Forgot Password",style: new TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)
                 ),*/
              Padding(
                padding: const EdgeInsets.only(left:80.0,right: 80.0,top:30.0),
                child: RaisedButton
                      (
                        onPressed: () async
                        {
                             FormState formState = formKey.currentState;
                             if(formState.validate())
                             {
                               fireBaseService.login(context, emailController.text, passwordController.text);
                               formState.reset();
                             } 
                        },
                        color: Colors.pink,
                        child: new Text("Login",textAlign: TextAlign.center,style:new TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
              ),
               FlatButton
                (
                  onPressed: ()
                  {
                    Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (BuildContext context) => SignUp()));
                  },
                  child: new Text("New User ? Register ",style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),),
                ),
            Center
                  (
                    child: new Text("Or",style: new TextStyle(color: Colors.pink))
                  ),
             //For future google sign in button
              Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: new Container
                (
                 alignment: Alignment.bottomCenter,
                 child: GoogleSignInButton
                    (
                      onPressed: ()
                      {
                        fireBaseService.handleSignIn(context);
                      },
                      borderRadius: 10.0,
                    ),
                ),
              ),
            ],
          ),
          ),
        );
      }
    
}