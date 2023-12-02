import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rms_app/Info/info_screen.dart';
import 'package:rms_app/Info/update_screen.dart';
import 'package:rms_app/Manual%20Input/manual_input.dart';
import 'package:rms_app/Methods/methods.dart';
class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  var qrstr = "let's Scan it";
  var height,width;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List pages = [UpdateScreen(), InfoScreen(), ManualInput()];

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF333333),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Color(0xFF333333),
                hoverColor: Color(0xFF333333),
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: lightblue,
                color: Colors.black,
                tabs: [
                  GButton(
                    iconColor: lightblue,
                    textColor: Colors.white,
                    icon: Icons.file_copy,
                    text: 'Inventory Checker',
                  ),
                  GButton(
                    iconColor: lightblue,
                    textColor: Colors.white,
                    icon: Icons.search,
                    text: 'Info',
                  ),
                  GButton(
                    iconColor: lightblue,
                    textColor: Colors.white,
                    icon: Icons.text_fields,
                    text: 'Manual Input',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future <void>scanQr()async{
    try{
      FlutterBarcodeScanner.scanBarcode('#2A99CF', 'cancel', true, ScanMode.QR).then((value){
        setState(() {
          qrstr=value;
        });
      });
    }catch(e){
      setState(() {
        qrstr='unable to read this';
      });
    }
  }
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Code: '),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter code'
          ),
          controller: controller,
        ),
      )
  );
  void submit(){
    Get.to(controller.text);
  }
}