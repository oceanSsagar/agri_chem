import 'package:agri_chem/utility/upload_data_dev.dart';
import 'package:flutter/material.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                uploadChemicalsToFirestore();
              },
              child: Text("Insert the chemical.json file"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await uploadCourseModulesFromJsonToFirestore();
              },
              child: Text('Upload Modules to Firestore'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await uploadProductsJsonToFirestore();
              },
              child: Text('Upload Products to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
