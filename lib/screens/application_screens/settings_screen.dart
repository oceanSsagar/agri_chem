import 'package:agri_chem/utility/upload_data_dev.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              child: Text("Upload Chemicals"),
              onPressed: () async {
                await uploadChemicalsToFirestore();
              },
            ),
          ],
        ),
      ),
    );
  }
}
