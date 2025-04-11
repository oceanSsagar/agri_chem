import 'package:agri_chem/themes/my_colors.dart';
import 'package:agri_chem/widgets/category_title.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActiveCourse extends StatelessWidget {
  const ActiveCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CategoryTitle("Currently active", "view all"),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: kFontLight.withAlpha(25),
              border: Border.all(color: kFontLight.withAlpha(100)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/courses/course1/course1.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Symmetry theory",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kFont,
                      ),
                    ),
                    Text(
                      "2 lessons left",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: kFontLight,
                      ),
                    ),
                  ],
                ),
                Spacer(), // Pushes the CircularPercentIndicator to the far right
                CircularPercentIndicator(
                  radius: 30.0,
                  lineWidth: 5.0,
                  percent: 0.61,
                  center: Text(
                    '61%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  progressColor: kAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
