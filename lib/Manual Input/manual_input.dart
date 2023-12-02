import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:rms_app/Home/home_screen.dart';
import 'package:rms_app/Info/info_screen.dart';
import 'package:rms_app/Info/update_screen.dart';
import 'package:rms_app/Methods/methods.dart';

class ManualInput extends StatefulWidget {
  const ManualInput({Key? key}) : super(key: key);

  @override
  State<ManualInput> createState() => _ManualInputState();
}

class _ManualInputState extends State<ManualInput> {
  var List2 = <Icon>[Icon(Icons.search), Icon(Icons.file_copy)];
  Icon List3 = Icon(Icons.search);
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 220.h,
                width: 320.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1.w, ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: (){Get.to(HomeScreen());},
                          icon: Icon(Icons.arrow_back),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: lightblue)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 270.w,
                              height: 50.h,
                              child: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: 'Enter Code',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            storeUpdate("Update");
                          },
                          child: Container(
                            height: 40.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Inventory Checker",
                                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 40.w,),
                        InkWell(
                          onTap: () {
                            storePost("Info");
                          },
                          child: Container(
                            height: 40.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: lightblue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Information",
                                style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future <void> storePost(String type) async{
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('server/ip');
    var data;
    starCountRef.onValue.listen((DatabaseEvent event) async {
      data = event.snapshot.value;
      print(data);
      Uri url = Uri.parse("http://$data:5000/Secinfo");

      var response = await http.post(
          url,
          body : {'uid':FirebaseAuth.instance.currentUser?.uid.toString(), 'barcode':controller.text.toString()}
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if(response.statusCode == 200)
      {

        if(responseJson['User'].toString() == "Authenticated"){
          if(type == "Info"){
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

        print('please try later');

      }
    });
  }

  Future<void> storeUpdate(String type) async {
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
            'barcode': controller.text.toString()
          }
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if (response.statusCode == 200) {
        if (responseJson['User'].toString() == "Authenticated") {
          if (type == "Info") {
          } else {
            Get.off(UpdateScreen(
              code: controller.text.toString(),
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


}

