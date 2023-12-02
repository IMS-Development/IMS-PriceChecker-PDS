import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rms_app/Home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:firebase_database/firebase_database.dart';
import 'package:rms_app/Methods/methods.dart';

var Code;
var Description;
var Price;
var Quantity;
var Warehousequantity;
var Priceaftersale;
var Salestartdate;
var Saleenddate;

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {


  final player = AudioPlayer();
  Future<void> playAudio(String url)async{
    await player.play(AssetSource("assets/beep-6-96243.mp3"));
  }

  void showSnackbar() {
    // playSound();
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
    storePost();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Information',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22.sp),),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){Get.to(HomeScreen());},
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text('Product Information',
                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),),
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
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),)
                    ],
                  ),
                  SizedBox(height: 15.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Price: ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                      SizedBox(width: 30.w,),
                      Text('$Price',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),)
                    ],
                  ),
                  SizedBox(height: 15.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Quantity: ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                      SizedBox(width: 30.w,),
                      Text('$Quantity',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),)
                    ],
                  ),
                  SizedBox(height: 15.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Warehouse quantity: ',
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                      SizedBox(width: 30.w,),
                      Text('$Warehousequantity',
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),)
                    ],
                  ),
                  SizedBox(height: 15.h,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Price after sale: ',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                          SizedBox(width: 30.w,),
                          Text('$Priceaftersale',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp),)
                        ],
                      ),
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Sale start date: ',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                          SizedBox(width: 30.w,),
                          Text('$Salestartdate',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp),)
                        ],
                      ),
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Sale end date: ',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp, fontWeight: FontWeight.bold),),
                          SizedBox(width: 30.w,),
                          Text('$Saleenddate',
                            style: TextStyle(color: Colors.green, fontSize: 16.sp),)
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
            SizedBox(height: 120.h,),
            InkWell(
              onTap: () {
                Get.off(HomeScreen());
                AudioPlayer();
                showSnackbar();
              },
              child: Container(
                height: 40.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: lightblue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future <void> storePost() async{
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('server/ip');
    var data;
    starCountRef.onValue.listen((DatabaseEvent event) async {
      data = event.snapshot.value;
      print(data);
      Uri url = Uri.parse("http://$data:5000/Secinfo");

      var response = await http.post(
          url,
          body : {'uid':FirebaseAuth.instance.currentUser?.uid.toString(), 'barcode':"S201382"}
      );

      var responseJson = convert.jsonDecode(response.body);

      // 200 ok

      if(response.statusCode == 200)
      {

        if(responseJson['User'].toString() == "Authenticated"){
          setState(() {
            Code = "S201382";
          });
          Description = responseJson['Description'].toString();
          Price = responseJson['Price'].toString();
          Quantity = responseJson['Quantity'].toString();
          Saleenddate = responseJson['SaleEndDate'].toString();
          Salestartdate = responseJson['SaleStartDate'].toString();
          Priceaftersale = responseJson['SalePrice'].toString();
          Warehousequantity = responseJson['Warehouse Quantity'].toString();
        }

        print(responseJson['User'].toString());

      }else{

        print('please try later');

      }
    });


  }
}

