import 'package:flutter/material.dart';
import 'package:skripsi_dispenser_iot/component/constant.dart';

class ReusableInput extends StatelessWidget {

  //Property
  final String label;
  final Function(String) onChanged;
  final bool rahasia;
  final String jenisKeyboard;

  //Constructor
  ReusableInput({required this.label, required this.onChanged, required this.rahasia, required this.jenisKeyboard});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      keyboardType: (jenisKeyboard == "email")? TextInputType.emailAddress: TextInputType.text,
      style: TextStyle(color: kBGHitam),
      obscureText: rahasia,
      decoration: InputDecoration(
          disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          isDense: true,
          contentPadding: EdgeInsets.all(15),
          filled: true,
          fillColor: kBGAbu2,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kBGBiru) // Mengubah warna garis border menjadi biru saat difokuskan
        ),
      ),
      onChanged: onChanged,
    );
  }
}

