import 'package:agri_chem/screens/application_screens/schedule_reminder_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(2),
                leading: Icon(Icons.notification_add),
                title: Text("Schedule Reminder"),
                subtitle: Text("Set a reminder for your schedule"),
                tileColor: Colors.amber[300],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScheduleReminderScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
