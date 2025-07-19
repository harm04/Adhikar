import 'package:flutter/material.dart';
import 'package:adhikar/theme/color_scheme.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQsPageState extends State<FAQsPage> {
  List<FAQItem> faqs = [
    FAQItem(
      question: "What is Adhikar?",
      answer:
          "Adhikar is a comprehensive legal awareness and education platform designed to empower individuals with knowledge of their fundamental rights. Our app provides easy access to legal information, AI-powered assistance, and educational resources to help you understand your rights and navigate legal matters effectively.",
      category: "General",
    ),
    FAQItem(
      question: "Is Adhikar free to use?",
      answer:
          "Yes, Adhikar is completely free to download and use. We believe that legal awareness and knowledge of fundamental rights should be accessible to everyone, regardless of their economic background.",
      category: "General",
    ),
    FAQItem(
      question: "What kind of legal information can I find on Adhikar?",
      answer:
          "Adhikar provides comprehensive information on:\n• Fundamental Rights guaranteed by the Indian Constitution\n• Consumer Rights and Protection\n• Labor Laws and Workplace Rights\n• Women's Rights and Safety Laws\n• Child Rights and Protection\n• Property and Land Rights\n• Criminal Law basics\n• Civil Law procedures\n• Government schemes and benefits",
      category: "Content",
    ),
    FAQItem(
      question: "How does the AI chatbot work?",
      answer:
          "Our AI-powered chatbot uses advanced natural language processing to understand your legal queries and provide relevant information. Simply type your question in simple language, and the chatbot will provide you with accurate, easy-to-understand answers based on Indian laws and legal precedents.",
      category: "Features",
    ),
    FAQItem(
      question: "Can I get legal advice through this app?",
      answer:
          "Adhikar provides legal information and educational content, but we do not provide personalized legal advice. For specific legal matters or cases, we strongly recommend consulting with a qualified legal professional or advocate who can provide advice tailored to your specific situation.",
      category: "Legal Disclaimer",
    ),
    FAQItem(
      question: "Is the information on Adhikar reliable and up-to-date?",
      answer:
          "Yes, we strive to maintain accurate and current legal information. Our content is regularly reviewed and updated by legal experts. However, laws can change, and we recommend verifying critical information with current legal sources or consulting a legal professional for important matters.",
      category: "Content",
    ),
    FAQItem(
      question: "Can I use Adhikar offline?",
      answer:
          "Yes, many of the key features and essential legal information in Adhikar are available offline once downloaded. However, features like the AI chatbot, latest legal updates, and community discussions require an internet connection.",
      category: "Features",
    ),
    FAQItem(
      question:
          "How do I report incorrect information or suggest improvements?",
      answer:
          "We welcome your feedback! You can report incorrect information or suggest improvements by:\n• Using the 'Feedback & Support' option in the app settings\n• Contacting us through the contact form\n• Sending us an email with specific details about the issue or suggestion",
      category: "Support",
    ),
    FAQItem(
      question: "Is my personal data safe with Adhikar?",
      answer:
          "Absolutely. We take data privacy very seriously. We do not collect unnecessary personal information, and all data is stored securely. We never share your personal information with third parties without your consent. Please read our Privacy Policy for detailed information about data handling.",
      category: "Privacy",
    ),
    FAQItem(
      question: "What languages is Adhikar available in?",
      answer:
          "Currently, Adhikar is available in English and Hindi. We are working on adding more Indian regional languages to make legal information accessible to a wider audience across the country.",
      category: "Features",
    ),
    FAQItem(
      question: "Can I share articles or information from Adhikar?",
      answer:
          "Yes, you can share legal articles and information from Adhikar with others. Many articles have built-in sharing options. However, please ensure you credit Adhikar as the source when sharing our content.",
      category: "Features",
    ),
    FAQItem(
      question: "How often is the app updated?",
      answer:
          "We regularly update Adhikar with new content, features, and improvements. Major updates are released monthly, while security updates and bug fixes are deployed as needed. Enable automatic updates to ensure you have the latest version.",
      category: "Updates",
    ),
    FAQItem(
      question: "Can I suggest new topics or features?",
      answer:
          "We'd love to hear your suggestions! You can suggest new topics, features, or improvements through:\n• The feedback form in the app\n• Our support email\n• Community discussions within the app\n\nWe actively consider user suggestions for future updates.",
      category: "Support",
    ),
    FAQItem(
      question: "What should I do if I'm facing a legal emergency?",
      answer:
          "For legal emergencies, we recommend:\n• Contacting emergency services (100, 112) if immediate safety is at risk\n• Reaching out to local police or relevant authorities\n• Consulting with a lawyer immediately\n• Using helpline numbers for specific issues (women's helpline, child helpline, etc.)\n\nAdhikar is an educational tool and not meant for emergency legal assistance.",
      category: "Legal Disclaimer",
    ),
    FAQItem(
      question: "How can I prepare for competitive exams using Adhikar?",
      answer:
          "Adhikar offers several resources for exam preparation:\n• Comprehensive study materials on constitutional law\n• Practice questions and case studies\n• Legal current affairs and updates\n• Important judgments and precedents\n• Mock tests and quizzes\n\nRegularly engage with these materials and track your progress through the app.",
      category: "Education",
    ),
  ];

  List<String> categories = [
    "All",
    "General",
    "Features",
    "Content",
    "Privacy",
    "Support",
    "Legal Disclaimer",
    "Updates",
    "Education",
  ];
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        title: Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              style: TextStyle(color: context.textPrimaryColor),
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle: TextStyle(color: context.textSecondaryColor),
                prefixIcon: Icon(Icons.search, color: context.primaryColor),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? context.surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.primaryColor),
                ),
              ),
            ),
          ),

          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? context.textPrimaryColor
                            : context.textSecondaryColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: context.cardColor,
                    selectedColor: context.primaryColor,
                    checkmarkColor: context.textPrimaryColor,
                    side: BorderSide(
                      color: isSelected
                          ? context.primaryColor
                          : context.textSecondaryColor.withOpacity(0.3),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredFAQs.length,
              itemBuilder: (context, index) {
                final faq = filteredFAQs[index];
                return FAQCard(faq: faq);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FAQItem> get filteredFAQs {
    List<FAQItem> filtered = faqs;

    // Filter by category
    if (selectedCategory != "All") {
      filtered = filtered
          .where((faq) => faq.category == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (faq) =>
                faq.question.toLowerCase().contains(searchQuery) ||
                faq.answer.toLowerCase().contains(searchQuery),
          )
          .toList();
    }

    return filtered;
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
    this.isExpanded = false,
  });
}

class FAQCard extends StatefulWidget {
  final FAQItem faq;

  const FAQCard({super.key, required this.faq});

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.textSecondaryColor.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            widget.faq.isExpanded = expanded;
            if (expanded) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          });
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.help_outline,
            color: context.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          widget.faq.question,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.faq.category,
              style: TextStyle(
                color: context.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        iconColor: context.primaryColor,
        collapsedIconColor: context.textSecondaryColor,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faq.answer,
                style: TextStyle(
                  color: context.textSecondaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
