import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rms_app/Home/home_screen.dart';
import 'package:rms_app/Info/info_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:rms_app/Methods/methods.dart';

var Code;
var Description;
var Quantity = "0";
String? oldquan ;

class UpdateScreen extends StatefulWidget {
  UpdateScreen({String? code, String? description, String? old}){
    Code = code;
    Description = description;
    oldquan = old;
  }

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  TextEditingController controller1 = TextEditingController();
  var List = <String>['Sheet 1', 'Sheet 2'];
  String List1 = "Sheet 1";

  final player = AudioPlayer();
  Future<void> playAudio(String url)async{
    await player.play(AssetSource("assets/beep-6-96243.mp3"));
  }

  void showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Done"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){Get.to(HomeScreen());},
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Text('Product Information',
              style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Code: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                    SizedBox(width: 30.w,),
                    Text('$Code',
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),)
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Description: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                    SizedBox(width: 20.w,),
                    Text('$Description',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),)
                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Quantity: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                    SizedBox(width: 30.w,),
                    Container(
                      height: 40.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.w, ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 95.w,
                            height: 40.h,
                            child: TextFormField(
                              controller: controller1,
                              decoration: InputDecoration(
                                hintText: '$Quantity',
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  onPressed: controller1.clear,
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Sheet: ',
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                    SizedBox(width: 30.w,),
                    Container(
                      height: 40.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.w, ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: DropdownButton<String>(items: List.map<DropdownMenuItem<String>>(
                                (String value)
                            {
                              return DropdownMenuItem<String>(

                                value: value,
                                child: Text(value, style: TextStyle(color: Color(0xff5573CD)),),
                              );
                            }

                        ).toList(),
                            icon: Icon(Icons.arrow_drop_down),

                            value: List1,
                            onChanged:(alinanVeri)
                            {
                              setState(() {
                                List1 = alinanVeri!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 70.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.off(HomeScreen());
                },
                child: Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 30.w,),
              InkWell(
                onTap: () {
                  storechecker();
                },
                child: Container(
                  height: 30.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: lightblue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> storechecker() async {
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('server/ip');
    var data;
    starCountRef.onValue.listen((DatabaseEvent event) async {
      data = event.snapshot.value;
      print(data);
      Uri url = Uri.parse("http://$data:5000/storechecker");

      var response = await http.post(
          url,
          body: {
            'uid': FirebaseAuth.instance.currentUser?.uid.toString(),
            'barcode': result,
            'newquan': controller1.text.toString(),
            'oldquan': oldquan,
            'sheet':List1,
            'desc': Description
          }
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if (response.statusCode == 200) {
        Get.off(HomeScreen());
        AudioPlayer();
        showSnackbar();
      } else {
        print('please try later');
      }
    },
    );
  }


}
