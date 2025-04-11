import 'package:agri_chem/models/course.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  final Course course;
  const CourseItem({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(course.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape:
                                  BoxShape
                                      .circle, // Makes the container circular
                              image: DecorationImage(
                                image: AssetImage(course.authorImg),
                                fit:
                                    BoxFit
                                        .cover, // Ensures the image covers the circular area
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            course.author,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kFont,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                              color: kFontLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              '2h 22min',
                              style: TextStyle(fontSize: 14, color: kFontLight),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: Text("Start", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
