// ignore_for_file: file_names, prefer_const_constructors, avoid_print, unnecessary_null_comparison, dead_code, sized_box_for_whitespace, avoid_unnecessary_containers, use_key_in_widget_constructors
import 'package:beautysalon/helper/pref/sharedpref.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

import '/pages/home.dart';
import '/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


import '../uidata.dart';
import 'loading_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool otpVisibility = false;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "Phone Auth",
        //   ),
        // ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
               

                ),
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text('+91'),
                    ),
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
              ),
              Visibility(
                child:  Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0,top: 20.00),
                  child: TextField(
                    controller: otpController,
                    decoration: InputDecoration(
                      hintText: 'OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),


                      ),
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(''),
                      ),
                    ),
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                  ),
                ),
                visible: otpVisibility,
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(

                color: Colors.purple[500],
                onPressed: () {
                  if (otpVisibility) {
                    verifyOTP();
                  } else {
                    loginWithPhone();
                  }
                },
                child: Text(
                  otpVisibility ? "Verify" : "Send OTP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: "+91" + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).whenComplete(
          () {
            SharedPref().saveLocalData("phone", phoneController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }
}
// class Login extends StatefulWidget {
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final FirebaseAuth auth = FirebaseAuth.instance;
//    FirebaseFirestore db = FirebaseFirestore.instance;
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   String ? phoneNo, verificationId, smsCode;
//   bool codeSent = false;
//   bool loading = false;
//
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   loginWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//       setState(() {
//         loading = true;
//       });
//
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser!.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       var signCre =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       await db.collection("users").doc(signCre.user!.uid).set({
//         "userName": googleUser.displayName,
//         "email": googleUser.email,
//         "image": googleUser.photoUrl
//       });
//
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => HomePage()),
//           (route) => false);
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               content: Text(e.toString()),
//             );
//           });
//
//       print(e.toString());
//     }
//   }
//
//   loginWithEmailPassword() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }
//     setState(() {
//       loading = true;
//     });
//
//     try {
//       FirebaseAuth auth = FirebaseAuth.instance;
//
//       final String email = emailController.text;
//       final String password = passwordController.text;
//       final UserCredential user = await auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => HomePage()),
//           (route) => false);
//     } catch (e) {
//       setState(() {
//         loading = false;
//       });
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               content: Text(e.toString()),
//             );
//           });
//       print(e);
//     }
//   }
//
//   goToSignUpScreen() {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
//   }
//
//   goToHome() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => HomePage()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? LoadingScreen()
//         : MaterialApp(
//             debugShowCheckedModeBanner: false,
//             home: Scaffold(
//               appBar: AppBar(
//                 title: Center(child: Text("Login")),
//                 backgroundColor: Colors.purple[500],
//                 leading: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                   onPressed: goToHome,
//                 ),
//               ),
//               body: SafeArea(
//                   child: SingleChildScrollView(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                         child: Container(
//                           height: 150,
//                           width: 200,
//                           child: Icon(
//                             Icons.shopping_cart_outlined,
//                             color: Colors.purple[500],
//                             size: 150,
//                           ),
//                         ),
//                       ),
//                     Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Padding(
//                                 padding: EdgeInsets.only(left: 25.0, right: 25.0),
//                                 child: TextFormField(
//                                   keyboardType: TextInputType.phone,
//                                   decoration: InputDecoration(hintText: 'Enter phone number'),
//                                   onChanged: (val) {
//                                     setState(() {
//                                       this.phoneNo = val;
//                                     });
//                                   },
//                                 )),
//                             codeSent ? Padding(
//                                 padding: EdgeInsets.only(left: 25.0, right: 25.0),
//                                 child: TextFormField(
//                                   keyboardType: TextInputType.phone,
//                                   decoration: InputDecoration(hintText: 'Enter OTP'),
//                                   onChanged: (val) {
//                                     setState(() {
//                                       this.smsCode = val;
//                                     });
//                                   },
//                                 )) : Container(),
//                             Padding(
//                                 padding: EdgeInsets.only(left: 25.0, right: 25.0),
//                                 child: RaisedButton(
//                                     child: Center(child: codeSent ? Text('Login'):Text('Verify')),
//                                     onPressed: () {
//                                       codeSent ? FirebaseAuth.instance
//                                           .signInWithCredential(
//                                           PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: smsCode!)):verifyPhone(phoneNo);
//                                     }))
//                           ],
//                         )),
//
//                     ]),
//               )),
//             ),
//           );
//   }
//
//   /// TODO _verifyPhone() method
//   verifyPhone(phoneNo) async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '+91${phoneNo}',
//         verificationCompleted: (PhoneAuthCredential authCredential) async {
//           await FirebaseAuth.instance
//               .signInWithCredential(authCredential)
//               .then((value) async {
//
//             if (value.user != null) {
//
//               // Navigator.pushAndRemoveUntil(
//               //     context,
//               //     MaterialPageRoute(builder: (context) => HomePage()),
//               //         (route) => false);
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print(e.message);
//         },
//         codeSent: (String ? verID, int? forceCodeResend) {
//           setState(() {
//             verificationId = verID;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verID) {
//           setState(() {
//             verificationId = verID;
//           });
//         },
//         timeout: Duration(seconds: 10));
//   }
// }

