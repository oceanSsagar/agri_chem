import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.only(bottom: 16.0),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12.0),
      // ),
      // elevation: 4,
      // child: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         module["title"]!,
      //         style: const TextStyle(
      //           fontSize: 18,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //       const SizedBox(height: 8),
      //       Text(
      //         module["description"]!,
      //         style: const TextStyle(fontSize: 14, color: Colors.grey),
      //       ),
      //       const SizedBox(height: 16),
      //       Align(
      //         alignment: Alignment.centerRight,
      //         child: ElevatedButton(
      //           onPressed: () {
      //             // Handle module action
      //             ScaffoldMessenger.of(context).showSnackBar(
      //               SnackBar(
      //                 content: Text("Opening ${module["title"]}..."),
      //               ),
      //             );
      //           },
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.green,
      //           ),
      //           child: const Text("Start"),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
