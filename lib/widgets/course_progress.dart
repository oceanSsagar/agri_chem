import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CourseProgress extends StatelessWidget {
  const CourseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                errorBuilder:
                    (context, error, stackTrace) => Icon(Icons.broken_image),
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
    );
  }
}
