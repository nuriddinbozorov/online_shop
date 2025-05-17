import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String appVersion = '1.0.0';
  final String developerName = "Sotuvchisiz  do'kon";
  final String contactEmail = 'support@sotuvchisizdokon.uz';
  final String websiteUrl = 'https://sotuvchisizdokon.uz';
  final String privacyPolicyUrl = 'https:/sotuvchisizdokon.uz/privacy';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Ilova haqida',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            Text(
              "Sotuvchisiz do'kon",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Versiya: $appVersion',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Ilova haqida',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Bu ilova RFID texnologiyasi yordamida ishlaydigan '
                      'innovatsion online do\'kon loyihasi. '
                      'Mahsulotlarni tez va qulay tarzda sotib olish imkoniyatiga ega.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildInfoCard(
              icon: Icons.code,
              title: 'Ishlab chiqaruvchi',
              value: developerName,
            ),
            _buildInfoCard(
              icon: Icons.email,
              title: 'Aloqa uchun',
              value: contactEmail,
              isClickable: true,
              onTap: () {},
            ),
            _buildInfoCard(
              icon: Icons.language,
              title: 'Veb sayt',
              value: websiteUrl,
              isClickable: true,
              onTap: () {},
            ),
            _buildInfoCard(
              icon: Icons.privacy_tip,
              title: 'Maxfiylik siyosati',
              value: 'Ko\'rish',
              isClickable: true,
              onTap: () {},
            ),
            SizedBox(height: 32),
            Text(
              "© 2025 Sotuvchisiz do'kon. Barcha huquqlar himoyalangan.",
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      child: Card(
        margin: EdgeInsets.all(6),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue[800], size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color:
                            isClickable ? Colors.blue[800] : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              if (isClickable)
                Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
