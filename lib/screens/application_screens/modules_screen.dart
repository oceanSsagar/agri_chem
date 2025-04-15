import 'package:flutter/material.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchBar(
              hintText: "Search For Modules...",
              onSubmitted: (value) {
                print(value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Module ${index + 1}"),
                    subtitle: Text("Description of Module ${index + 1}"),
                    leading: Icon(Icons.book),
                    trailing: Icon(Icons.arrow_forward),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
