import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How do I verify my health certification?',
      'answer':
          'To verify your health certification, go to your profile and tap on "Health Certification". Follow the instructions to upload your documents.',
    },
    {
      'question': 'How do I change my location?',
      'answer':
          'You can change your location in Settings > Location. Make sure you have granted location permissions to the app.',
    },
    {
      'question': 'How do I reset my password?',
      'answer':
          'Tap on "Forgot Password" on the login screen and follow the instructions sent to your email.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildContactSupport(),
          SizedBox(height: 24),
          Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...faqItems.map((item) => _buildFAQItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildContactSupport() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildContactOption(
                    icon: Icons.email,
                    title: 'Email Us',
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildContactOption(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> item) {
    return ExpansionTile(
      title: Text(
        item['question'],
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            item['answer'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
