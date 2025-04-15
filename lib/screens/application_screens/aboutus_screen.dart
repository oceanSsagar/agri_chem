import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🌱 About Us – AgriChem",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "AgriChem is a smart mobile application designed to empower farmers and students with knowledge about agrochemicals, sustainable farming techniques, and agricultural innovations. Our mission is to bridge the gap between complex agricultural science and practical, easy-to-understand learning for everyday users.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _sectionTitle("📘 What is AgriChem?"),
            const Text(
              "AgriChem is an educational and advisory platform built for mobile devices. It offers:\n\n"
              "• Daily agricultural feeds on agrochemical use, techniques, and technologies.\n"
              "• Interactive learning modules covering key topics such as:\n"
              "   - Soil pH and nutrient absorption\n"
              "   - Pesticide handling and first aid\n"
              "   - Organic vs. inorganic fertilizers\n"
              "• A knowledge base to explore information on various agricultural chemicals and their impacts.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _sectionTitle("🌾 How AgriChem Helps You"),
            const Text(
              "AgriChem stands out by combining traditional education with smart features like:\n\n"
              "• Interactive learning modules focused on real-life applications.\n"
              "• An AI-powered advisory chatbot to answer queries with quick, mocked solutions.\n"
              "• Feeds and newsletters to keep you updated on the latest trends and tips in agriculture.\n"
              "• Push notifications to alert users about new content, reminders, and critical advisories.\n\n"
              "Whether you're a student studying agriculture or a farmer on the field, AgriChem helps you learn better, make informed decisions, and stay updated.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _sectionTitle("⚙️ Core Features"),
            const Text(
              "✅ User Authentication & Profiles\n"
              "📚 Chemical Knowledge Base\n"
              "🧠 Interactive Learning Modules\n"
              "🤖 AI-Powered Advisory Bot\n"
              "📷 Scan & Learn (QR/Barcode)\n"
              "🔔 Push Notifications & Reminders\n"
              "🔐 Secure and Reliable Infrastructure",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _sectionTitle("🛠️ Our Tech Stack & Dev Tools"),
            const Text(
              "• Flutter & Dart (Mobile App Development)\n"
              "• Firebase Auth, Firestore, Storage\n"
              "• GitHub for version control\n"
              "• GitHub Actions for CI/CD\n"
              "• Jenkins for pipeline automation\n"
              "• Third-party APIs for enriched features",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _sectionTitle("🔗 Find Us on GitHub"),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse(
                  "https://github.com/oceanSsagar/agri_chem",
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Could not launch URL")),
                  );
                }
              },
              child: const Text(
                "👉 GitHub Repository",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
