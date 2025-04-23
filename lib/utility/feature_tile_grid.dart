import 'package:flutter/material.dart';

class FeatureTileGrid extends StatelessWidget {
  final void Function(String featureKey) onFeatureSelected;

  const FeatureTileGrid({super.key, required this.onFeatureSelected});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem('Courses', Icons.school, 'courses'),
      _FeatureItem('Chatbot', Icons.chat_bubble_outline, 'chatbot'),
      _FeatureItem('QR Scanner', Icons.qr_code_scanner, 'scanner'),
      _FeatureItem('Chemicals', Icons.science_outlined, 'chemicals'),
      _FeatureItem(
        'Notifications',
        Icons.notifications_outlined,
        'notifications',
      ),
      _FeatureItem('Profile', Icons.person_outline, 'profile'),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final feature = features[index];
        return GestureDetector(
          onTap: () => onFeatureSelected(feature.key),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(feature.icon, size: 36, color: Colors.teal),
                const SizedBox(height: 10),
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FeatureItem {
  final String title;
  final IconData icon;
  final String key;

  _FeatureItem(this.title, this.icon, this.key);
}
