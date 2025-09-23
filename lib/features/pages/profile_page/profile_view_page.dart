import 'package:flutter/material.dart';
import '../../data/profile/user_profile.dart';

class ViewFullProfilePage extends StatelessWidget {
  final UserProfile? userProfile;
  final VoidCallback onBack;

  const ViewFullProfilePage({
    super.key,
    required this.userProfile,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
        ),
        body: const Center(
          child: Text("No profile data available"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info Table
            _buildSection(
              title: "👤 Basic Information",
              data: [
                {'label': 'Grade', 'value': userProfile!.grade?.toString() ?? 'N/A'},
                {'label': 'Province', 'value': userProfile!.province?.toString() ?? 'N/A'},
                {
                  'label': 'Financial Background',
                  'value': "${userProfile!.financialBackground?.toString() ?? 'Unknown'} Income"
                },
              ],
            ),

            const SizedBox(height: 16),

            // Subjects Chips
            _buildSection(
              title: "📚 My Subjects (${userProfile!.subjects.length})",
              children: userProfile!.subjects
                  .map((subject) => _buildChip(subject?.toString() ?? 'N/A', Colors.blue[100]!))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Interests Chips
            _buildSection(
              title: "❤️ My Interests (${userProfile!.interests.length})",
              children: userProfile!.interests
                  .map((interest) => _buildChip(interest?.toString() ?? 'N/A', Colors.green[100]!))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Profile Strength
            _buildSection(
              title: "⭐ Profile Strength",
              children: [
                _buildInfoRow("Profile Completion", "100%"),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 1,
                  backgroundColor: Colors.purple[100],
                  color: Colors.purple[600],
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Great! Your profile is complete and ready for personalized career recommendations.",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Section widget that can handle both table data and children widgets
  Widget _buildSection({
    required String title,
    List<Map<String, String>>? data,
    List<Widget>? children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Table for key-value data
            if (data != null && data.isNotEmpty)
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: data.map((item) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(item['label'] ?? '',
                            style: const TextStyle(color: Colors.black54)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          item['value'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

            // Additional widgets like Chips or ProgressIndicators
            if (children != null && children.isNotEmpty) ...[
              const SizedBox(height: 10),
              ...children,
            ],
          ],
        ),
      ),
    );
  }

  // Row for showing a label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Chip widget for subjects and interests
  Widget _buildChip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
