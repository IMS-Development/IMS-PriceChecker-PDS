import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rms_app/Database/firebase_options.dart';
import 'package:rms_app/Home/home_screen.dart';
import 'package:rms_app/Methods/methods.dart';


class SigninScreen extends StatefulWidget
{
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool shouldUseFirebaseEmulator = false;

  late final FirebaseApp app;
  late final FirebaseAuth auth;

  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  bool passToggle = true;
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            labelText: 'User name',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                            hintText: 'User name',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5573CD),)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5573CD),)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5573CD),width: 2.w)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5573CD),)),
                              border: OutlineInputBorder(),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5573CD), width: 2.w)),
                              suffix: InkWell(
                                onTap: (){
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
                                child: Icon(passToggle ? Icons.visibility_off : Icons.visibility, color: Colors.grey,),
                              )
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Center(
                          child: Container(
                            width: 275.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                                color: lightblue,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    offset: Offset(0, 5),
                                  )
                                ]
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                try {
                                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: emailcontroller.text+"@pds.rms",
                                      password: passwordcontroller.text
                                  );
                                  Get.off(HomeScreen());
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    print('No user found for that email.');
                                    return;
                                  } else if (e.code == 'wrong-password') {
                                    print('Wrong password provided for that user.');
                                    return;
                                  }
                                }

                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h,),
            Image(
              image: AssetImage("assets/signin.png"),
              height: 270.h,
              width: 270.w,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // We store the app and auth to make testing with a named instance easier.
    app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    auth = FirebaseAuth.instanceFor(app: app);

    if (shouldUseFirebaseEmulator) {
      await auth.useAuthEmulator('localhost', 9099);
    }

    runApp( SigninScreen());
  }

}
