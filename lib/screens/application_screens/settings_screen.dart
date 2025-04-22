import 'package:agri_chem/notifications/notification_service.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  int _selectedDelayMinutes = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _scheduleReminder() {
    if (_formKey.currentState!.validate()) {
      NotificationService.scheduleNotification(
        title: _titleController.text,
        body: _bodyController.text,
        delay: Duration(minutes: _selectedDelayMinutes),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reminder scheduled!")));

      _titleController.clear();
      _bodyController.clear();
      setState(() {
        _selectedDelayMinutes = 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Reminder Title"),
                validator:
                    (value) => value!.isEmpty ? "Please enter a title" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: "Reminder Description",
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? "Please enter a description" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedDelayMinutes,
                decoration: const InputDecoration(labelText: "Delay (minutes)"),
                items:
                    [5, 10, 15, 30, 60]
                        .map(
                          (min) => DropdownMenuItem(
                            value: min,
                            child: Text('$min minutes'),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDelayMinutes = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _scheduleReminder,
                child: const Text("Schedule Reminder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
