import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final String leftText;
  final String rightText;

  const CategoryTitle(this.leftText, this.rightText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: kFont,
            ),
          ),
          Text(rightText, style: TextStyle(fontSize: 16, color: kFontLight)),
        ],
      ),
    );
  }
}
