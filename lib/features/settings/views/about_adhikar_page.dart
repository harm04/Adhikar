import 'package:adhikar/theme/image_theme.dart';
import 'package:flutter/material.dart';
import 'package:adhikar/theme/color_scheme.dart';

class AboutAdhikarPage extends StatelessWidget {
  const AboutAdhikarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Adhikar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          context.primaryColor,
                          context.primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Image.asset(ImageTheme.defaultAdhikarLogo),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Adhikar',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                  Text(
                    'Know Your Rights, Empower Your Voice',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Mission Section
            _buildSectionCard(
              title: 'Our Mission',
              content:
                  'Adhikar is dedicated to empowering every individual with knowledge of their fundamental rights and legal awareness. We believe that understanding your rights is the first step toward building a just and equitable society.',
              icon: Icons.flag,
              context: context,
            ),

            const SizedBox(height: 20),

            // What We Offer Section
            _buildSectionCard(
              title: 'What We Offer',
              content: '',
              icon: Icons.star,
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    '📚 Legal Education',
                    'Comprehensive guides on fundamental rights, laws, and legal processes',
                  ),
                  _buildFeatureItem(
                    context,
                    '🤖 AI-Powered Assistance',
                    'Get instant answers to your legal queries with our intelligent chatbot',
                  ),
                  _buildFeatureItem(
                    context,
                    '📝 Case Discussions',
                    'Real-world case studies and legal precedents explained in simple terms',
                  ),
                  _buildFeatureItem(
                    context,
                    '🎓 Exam Preparation',
                    'Resources for competitive exams related to law and governance',
                  ),
                  _buildFeatureItem(
                    context,
                    '🔍 Legal Resources',
                    'Quick access to important legal documents and government schemes',
                  ),
                  _buildFeatureItem(
                    context,
                    '💬 Community Support',
                    'Connect with others to discuss legal matters and share experiences',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Key Features Section
            _buildSectionCard(
              title: 'Key Features',
              content: '',
              icon: Icons.lightbulb,
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    '🎯 User-Friendly Interface',
                    'Easy navigation with intuitive design',
                  ),
                  _buildFeatureItem(
                    context,
                    '🌐 Multi-Language Support',
                    'Available in multiple Indian languages',
                  ),
                  _buildFeatureItem(
                    context,
                    '📱 Offline Access',
                    'Access key information even without internet',
                  ),
                  _buildFeatureItem(
                    context,
                    '🔔 Legal Updates',
                    'Stay updated with latest legal news and changes',
                  ),
                  _buildFeatureItem(
                    context,
                    '🎨 Dark/Light Themes',
                    'Comfortable reading experience',
                  ),
                  _buildFeatureItem(
                    context,
                    '🔒 Privacy Focused',
                    'Your data security is our priority',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Vision Section
            _buildSectionCard(
              title: 'Our Vision',
              content:
                  'To create a society where every citizen is aware of their rights and empowered to exercise them effectively. We envision a future where legal literacy is not a privilege but a fundamental aspect of education for all.',
              icon: Icons.visibility,
              context: context,
            ),

            const SizedBox(height: 20),

            // Target Audience Section
            _buildSectionCard(
              title: 'Who Can Benefit',
              content: '',
              icon: Icons.people,
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    '👨‍🎓 Students',
                    'Preparing for competitive exams or studying law',
                  ),
                  _buildFeatureItem(
                    context,
                    '👨‍💼 Working Professionals',
                    'Understanding workplace rights and labor laws',
                  ),
                  _buildFeatureItem(
                    context,
                    '👨‍👩‍👧‍👦 General Citizens',
                    'Learning about fundamental rights and civic duties',
                  ),
                  _buildFeatureItem(
                    context,
                    '🏢 Small Business Owners',
                    'Understanding business regulations and compliance',
                  ),
                  _buildFeatureItem(
                    context,
                    '👩‍⚖️ Legal Practitioners',
                    'Quick reference and case study materials',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // App Info Section
            _buildSectionCard(
              title: 'App Information',
              content: '',
              icon: Icons.info,
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(context, 'Version:', '1.0.0'),
                  _buildInfoRow(context, 'Last Updated:', 'July 2025'),
                  _buildInfoRow(context, 'Platform:', 'Android & iOS'),
                  _buildInfoRow(context, 'Size:', '~50MB'),
                  _buildInfoRow(context, 'Category:', 'Education & Legal'),
                  _buildInfoRow(context, 'Developer:', 'Adhikar Team'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Made with ❤️ in India',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2025 Adhikar. All rights reserved.',
                    style: TextStyle(
                      color: context.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
    required BuildContext context,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: context.primaryColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: context.textSecondaryColor,
                height: 1.5,
              ),
            ),
          ],
          if (child != null) ...[const SizedBox(height: 12), child],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondaryColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: context.textPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
