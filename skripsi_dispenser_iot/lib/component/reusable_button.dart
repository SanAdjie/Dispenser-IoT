import 'package:flutter/material.dart';
import 'package:skripsi_dispenser_iot/component/constant.dart';

class ReusableButton extends StatelessWidget {

  final text;
  Function()? ontap;

  ReusableButton({@required this.text, @required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ontap,
        child: Container(
            width: 153,
            height: 50,
            decoration: BoxDecoration(
                color: kBGBiru,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 12,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]
            ),
            child: Center(
                child: Text(text,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))))
    );
  }
}


