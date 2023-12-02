import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rms_app/Info/info_screen.dart';
import 'package:rms_app/Info/update_screen.dart';
import 'package:rms_app/Manual%20Input/manual_input.dart';
import 'package:rms_app/Methods/methods.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

var Code;
var Description;
var Price;
var Quantity;
var Warehousequantity;
var Priceaftersale;
var Salestartdate;
var Saleenddate;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
String result = '';

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/home.png'),),
                SizedBox(height: 80.h,),
                InkWell(
                  onTap:() async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SimpleBarcodeScannerPage(),
                          ));
                      setState(() {
                        if (res is String) {
                          result = res;
                          storeUpdate("Update");
                        }
                      });
                  },
                  child: Container(
                    height: 50.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: lightblue,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                            color: lightblue
                        ),
                      ]
                    ),
                    child: Center(
                      child: Text(
                        "Inventory Checker",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h,),
                InkWell(
                  onTap:() async {
                    var res = await
                    Get.to(SimpleBarcodeScannerPage());
                    setState(() {
                      if (res is String) {
                        result = res;
                        storePost("Info");
                      }
                    });
                  },
                  child: Container(
                    height: 50.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: lightblue,
                      borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                            color: lightblue
                          ),
                        ]
                    ),
                    child: Center(
                      child: Text(
                        "Info",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h,),
                InkWell(
                  onTap: () {
                    Get.to(ManualInput());
                  },
                  child: Container(
                    height: 50.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: lightblue,
                      borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: lightblue
                          ),
                        ]
                    ),
                    child: Center(
                      child: Text(
                        "Manual Input",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> storeUpdate(String type) async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('server/ip');
    var data;
    starCountRef.onValue.listen((DatabaseEvent event) async {
      data = event.snapshot.value;
      print(data);
      Uri url = Uri.parse("http://$data:5000/Secupdate");

      var response = await http.post(
          url,
          body: {
            'uid': FirebaseAuth.instance.currentUser?.uid.toString(),
            'barcode': result
          }
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if (response.statusCode == 200) {
        if (responseJson['User'].toString() == "Authenticated") {
          if (type == "Info") {
          } else {
            Get.off(UpdateScreen(
              code: result,
              description: responseJson['Description'].toString(),
              old : responseJson['Quantity'].toString()
            ));
          }
          // setState(() {
          //   Code = "S201382";
          // });

          print(responseJson['Description'].toString());
        }

        print(responseJson['User'].toString());
      } else {
        print('please try later');
      }
    });
  }

  Future <void> storePost(String type) async{
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('server/ip');
    var data;
    starCountRef.onValue.listen((DatabaseEvent event) async {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      data = event.snapshot.value;
      print(data);
      Uri url = Uri.parse("http://$data:5000/Secinfo");

      var response = await http.post(
          url,
          body : {'uid':FirebaseAuth.instance.currentUser?.uid.toString(), 'barcode':result}
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if(response.statusCode == 200)
      {

        if(responseJson['User'].toString() == "Authenticated"){
          if(type == "Info"){
            Navigator.of(context).pop();
            Get.off(InfoScreen());
          }else{
            Get.off(UpdateScreen());
          }
          // setState(() {
          //   Code = "S201382";
          // });

          print(responseJson['Description'].toString());
        }

        print(responseJson['User'].toString());

      }else{
        Navigator.of(context).pop();
        print('please try later');

      }
    });


  }
}
