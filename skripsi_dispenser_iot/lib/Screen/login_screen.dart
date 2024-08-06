import 'package:flutter/material.dart';
import 'package:skripsi_dispenser_iot/Screen/main_screen.dart';
import 'package:skripsi_dispenser_iot/component/constant.dart';
import 'package:skripsi_dispenser_iot/component/reusable_button.dart';
import 'package:skripsi_dispenser_iot/component/reusable_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {

  static String id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _RegisterState();
}

class _RegisterState extends State<LoginScreen> with SingleTickerProviderStateMixin{

  late String email;
  late String password;
  bool loading = false;

  final akun = FirebaseAuth.instance;
  late final user;

  late AnimationController controller;
  late Animation animasi;
  late num animasiValue;
  int animasiValueInt = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
        upperBound: 1);
    controller.forward(from: 0);
    animasi = CurvedAnimation(parent: controller, curve: Curves.easeInOutExpo);
    controller.addListener((){
      setState((){
        animasiValue = animasi.value*500;
        animasiValueInt = animasiValue.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: loading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: animasiValueInt*1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: kBGBiru,
                          borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 140))),
                      child: Center(
                        child: Image.asset("images/SplashScreen.png", width: 250, height: 350,),
                      )),),
                Expanded(
                  flex: 1000,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          kSpasi1,
                          Text("Selamat Datang", style: kStyleText1),
                          Text("Silahkan Masuk Untuk Melanjutkan", style: kStyleText5),
                          kSpasi2,
                          ReusableInput(label: "Email", rahasia: false, onChanged: (value){
                            email = value;
                          }, jenisKeyboard: "email"),
                          kSpasi2,
                          ReusableInput(label: "Password", rahasia: true, onChanged: (value){
                            password = value;
                          }, jenisKeyboard: "biasa"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Belum Punya Akun ? "),
                              TextButton(onPressed: (){
                                Alert(
                                  context: context,
                                  desc: "Maaf, Fitur Belum Tersedia",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      color: kBGBiru,
                                      radius: BorderRadius.circular(10.0),
                                      child: const Text(
                                        "Baik",
                                        style: kStyleText3,
                                      ),
                                    ),
                                  ],
                                ).show();
                              }, child: const Text("Daftar", style: TextStyle(color: kBGBiru, fontSize: 15),))
                            ],
                          ),
                          ReusableButton(text: "Masuk", ontap: () async{
                            setState((){
                              loading = true;
                            });
                            try{
                              user = await akun.signInWithEmailAndPassword(email: email, password: password);
                              if(user != null){
                                Navigator.pushNamed(context, MainScreen.id);
                              }
                            }
                            catch(e){
                              print(e);
                              setState((){
                                loading = false;
                              });
                              Alert(
                                context: context,
                                title: "Login Gagal",
                                desc: "Password atau Email yang kamu masukkan salah",
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context),
                                    color: kBGBiru,
                                    radius: BorderRadius.circular(10.0),
                                    child: const Text(
                                      "Baik",
                                      style: kStyleText3,
                                    ),
                                  ),
                                ],
                              ).show();
                            }
                          }),
                        ],
                      )),
                ),
                kSpasi3
              ],
            ),
          ),
        ),
      ),
    );
  }
}