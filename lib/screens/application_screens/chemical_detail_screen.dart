import 'package:flutter/material.dart';

class ChemicalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> chemical;

  const ChemicalDetailScreen({super.key, required this.chemical});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          chemical['name'] ?? 'Chemical Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoCard(
              title: "Usage Guidelines",
              icon: Icons.info_outline,
              content: chemical['usageGuidelines'],
            ),
            _buildInfoCard(
              title: "Safety Rating",
              icon: Icons.warning_amber_rounded,
              content: chemical['safetyRating'],
            ),
            _buildInfoCard(
              title: "Soil Impact",
              icon: Icons.landscape_outlined,
              content: chemical['soilImpact'],
            ),
            _buildInfoCard(
              title: "Status",
              icon: Icons.verified_outlined,
              content: chemical['status'],
              statusColor: _getStatusColor(chemical['status']),
            ),
            _buildInfoCard(
              title: "Compatible Crops",
              icon: Icons.agriculture,
              content:
                  (chemical['compatibleCrops'] as List?)?.join(', ') ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String? content,
    Color? statusColor,
  }) {
    return content == null
        ? SizedBox()
        : Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: statusColor ?? Colors.green.shade800),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(content, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }

  Color? _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'allowed':
        return Colors.green;
      case 'restricted':
        return Colors.orange;
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
