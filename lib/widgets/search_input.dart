import 'package:flutter/material.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: kFontLight.withAlpha(75)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: kFontLight.withAlpha(30),
                  filled: true,
                  contentPadding: EdgeInsets.all(18),
                  border: InputBorder.none,
                  hintText: "Search for history, classes,...",
                  hintStyle: TextStyle(fontSize: 16, color: kFontLight),
                ),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 25,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                colorFilter: ColorFilter.mode(kBackground, BlendMode.srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
