import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skripsi_dispenser_iot/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static String id = "MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int nilaiTinggiGelombang = 600;
  double? targetHarian;

  double? BB;
  double? TB;
  String? aktifitas;
  String? jenisK;
  double? jumlahMinum;
  String? link;
  String? nama;
  double? usia;

  int? persen;

  double? BMR;
  double? EER;

  final dbRef = FirebaseDatabase.instance.ref().child("pengguna");
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      dbRef.child(uid).onValue.listen((event) {
        var snapshot = event.snapshot;
        if (snapshot.value != null) {
          Map<String, dynamic> values = Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
          setState(() {
            BB = values['BB'] != null ? values['BB'].toDouble() : null;
            TB = values['TB'] != null ? values['TB'].toDouble() : null;
            aktifitas = values['aktifitas'];
            jenisK = values['jenisK'];
            jumlahMinum = values['jumlahMinum'] != null ? values['jumlahMinum'].toDouble() : null;
            link = values['link'];
            nama = values['nama'];
            usia = values['usia'] != null ? values['usia'].toDouble() : null;
            targetHarian = perhitunganTargetHarianAirMinum()!;
            persen = (100 * (jumlahMinum??1) / (targetHarian??1)).round();
            perhitunganTinggi();
          });
        } else {
          //TODO: UID tidak ada di database, lakukan sesuatu
          print('UID tidak ada di database');
        }
      });
    }
    //scheduleAlarm();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //----------Inisiasi Logika-Logika----------
  Widget indikatorStatus(){

    if(persen != null){
      if(persen! <= 30){
        return Text("Sangat Kurang", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18 ));
      } else if(persen! > 30 && persen! <= 70){
        return Text("Masih Kurang", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent, fontSize: 18));
      } else if(persen! > 70 && persen! <= 100){
        return Text("Kurang Dikit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18));
      } else if(persen! > 100){
        return Text("Wah Selamat!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 18));
      } else {
        return Text("-", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18));
      }
    } else {
      return Text("Data tidak tersedia", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18));
    }
  }

  double? perhitunganTargetHarianAirMinum(){

    if(jenisK == "laki-laki"){
      BMR = (88.4 + 13.4 * BB!) + (4.8 * TB!) - (5.68 * usia!);
    }else if(jenisK == "perempuan"){
      BMR = (447.6 + 9.25 * BB!) + (3.1 * TB!) - (4.33 * usia!);
    }

    if(aktifitas == "tidak aktif" && jenisK == "perempuan"){
      EER = 1.4 * BMR!;
    }else if(aktifitas == "tidak aktif" && jenisK == "laki-laki"){
      EER = 1.4 * BMR!;
    }else if(aktifitas == "sedang tidak aktif" && jenisK == "perempuan"){
      EER = 1.5 * BMR!;
    }else if(aktifitas == "sedang tidak aktif" && jenisK == "laki-laki"){
      EER = 1.5 * BMR!;
    }else if(aktifitas == "sedang aktif" && jenisK == "perempuan"){
      EER = 1.78 * BMR!;
    }else if(aktifitas == "sedang aktif" && jenisK == "laki-laki"){
      EER = 1.64 * BMR!;
    }else if(aktifitas == "aktif" && jenisK == "perempuan"){
      EER = 2.1 * BMR!;
    }else if(aktifitas == "aktif" && jenisK == "laki-laki"){
      EER = 1.82 * BMR!;
    }
    return EER;
  }

  void perhitunganTinggi(){
    int range0 = 100 - 0;
    int range1 = 200 - 600;

    nilaiTinggiGelombang = (((persen! - 0) * range1) / range0).round() + 600;
  }

  void kirimData(double tambahan) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      jumlahMinum = (jumlahMinum ?? 0) + tambahan;
      dbRef.child(uid).update({
        'jumlahMinum': jumlahMinum,
      });
    }
  }

  /* ---------- Keterbatasan Fitur : Reset Kebutuhan Air Memerlukan Cloud Functions ----------

  void resetJumlahMinum(int id) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      final dbRef = FirebaseDatabase.instance.ref().child("pengguna");
      dbRef.child(uid).update({
        'jumlahMinum': 0,
      });
    }
  }

  void scheduleAlarm() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final int alarmID = 0;
    AndroidAlarmManager.oneShotAt(nextMidnight, alarmID, resetJumlahMinum);
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Konfirmasi'),
              content: Text('Apakah Anda ingin keluar? 🥺'),
              actions: <Widget>[
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: TextButton(
                    child: Text('Tidak', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    child: Text('Ya', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(_controller.value, nilaiTinggiGelombang),
                    child: SizedBox.expand(child: child),
                  );
                },
                child: Container(),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Builder(
                          builder: (context) {
                            return IconButton(
                              iconSize: 30,
                              padding: const EdgeInsets.all(30),
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          }
                      ),
                      IconButton(
                        iconSize: 30,
                        padding: const EdgeInsets.all(30),
                        icon: Icon(Icons.notifications, color: Colors.orange),
                        onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black),
                                  dialogBackgroundColor: Colors.green,
                                ),
                                child: child!,
                              );
                            },
                          );

                          /* ---------- Keterbatasan Fitur : Push-Up Notification Memerlukan Firebase Messaging ---------- */

                          if (picked != null) {
                            final minutes = picked.minute;
                            final roundedMinutes = (minutes ~/ 30) * 30;
                            final roundedTime = TimeOfDay(hour: picked.hour, minute: roundedMinutes);

                            if (roundedTime.hour <= 12) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Waktu notifikasi dipilih ${roundedTime.format(context)}')),
                              );
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setInt('notificationHour', roundedTime.hour);
                              await prefs.setInt('notificationMinute', roundedTime.minute);

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mohon pilih waktu dalam rentang 12 jam.')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  kSpasi4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text("Target", style: TextStyle(fontSize: 18)),
                          Text("${(targetHarian)?.round()} mL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Status", style: TextStyle(fontSize: 20)),
                          indikatorStatus()
                        ],
                      ),
                    ],
                  ),
                  kSpasi4,
                  kSpasi4,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("${(persen)?.round()}", style: TextStyle(fontSize: 100, fontWeight: FontWeight.w900)),
                          Text("%", style: TextStyle(fontSize: 30)),
                        ],
                      ),
                      Text("Telah Minum ${(jumlahMinum)?.round()} mL", style: TextStyle(color: Color.fromRGBO(105,99, 99, 1), fontWeight: FontWeight.w400, fontSize: 18, letterSpacing: 1)),
                      Text("dari ${(targetHarian)?.round()} mL", style: TextStyle(color: Color.fromRGBO(105,99, 99, 1), fontWeight: FontWeight.w600, fontSize: 28, letterSpacing: 5)),
                    ],
                  ),
                  kSpasi4,
                  kSpasi4,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(4)),
                    onPressed: () {
                      final TextEditingController controller = TextEditingController();

                      showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                        'Ingin Minum Berapa Banyak?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22)),
                                    SizedBox(height: 20),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: TextField(
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                  borderSide: BorderSide()),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: kBGBiru),
                                                  borderRadius: BorderRadius.circular(30.0)),
                                              labelText: 'Masukkan angka')),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shadowColor: Colors.grey,
                                            elevation: 5),
                                        onPressed: () {
                                          String inputText = controller.text;
                                          int? number = int.tryParse(inputText);
                                          if (number != null && number % 100 == 0 && number >= 100 && number <= 1000) {
                                            kirimData(number.toDouble());
                                            print('Data yang dikirim ke Firebase: $number');
                                            Navigator.pop(context);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Perhatian'),
                                                  content: Text('Harap masukkan angka antara 100 - 1000 & kelipatan 100.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Siap', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Text('Minum', style: TextStyle(color: Colors.white))),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.local_drink,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage('$link'),
                          radius: 50.0,),
                        kSpasi1,
                        Text('Selamat Datang, Baginda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    decoration: BoxDecoration(color: Colors.blue)),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),),
                        Expanded(
                          flex: 2,
                          child: Text(': ${nama}'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('Usia', style: TextStyle(fontWeight: FontWeight.bold)),),
                        Expanded(
                          flex: 2,
                          child: Text(': ${(usia?.round())} Tahun'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(': ${jenisK}'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text('BB', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: 2,
                          child: Text(': ${BB} Kg'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('TB', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(': ${(TB?.round())} cm'),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Atur padding sesuai kebutuhan
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text('Aktifitas', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          flex: 2,
                          child: Text(': ${aktifitas}'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveProgress;
  final int tinggiGelombang;

  WavePainter(this.waveProgress, this.tinggiGelombang);

  @override
  void paint(Canvas canvas, Size size) {
    const Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.blue, Colors.white],
      stops: [0.3, 1.0],
    );
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    final path = Path();

    for (double x = 0; x <= size.width; x++) {
      final y = sin((x / size.width * 2 * pi) + (waveProgress * 2 * pi)) * 20 + tinggiGelombang;
      if (x == 0) {
        path.moveTo(x, y);
      }
      else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => oldDelegate.waveProgress != waveProgress;
}