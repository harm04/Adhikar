import 'package:adhikar/features/pods/widgets/pods_card.dart';
import 'package:flutter/material.dart';

class PodsListView extends StatefulWidget {
  const PodsListView({super.key});

  @override
  State<PodsListView> createState() => _PodsListViewState();
}

class _PodsListViewState extends State<PodsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pods'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 20),
          child: Column(
            children: [
              PodsCard(
                podName: 'Freelance & Legal Services',
                podImage: 'assets/icons/ic_freelance_services.png',
                podDescription:
                    'Find contract-based legal work and collaboration opportunities.',
                podBanner: 'assets/images/freelance_legal_service.jpg',
              ),
              PodsCard(
                podName: 'Criminal & Civil Law',
                podImage: 'assets/icons/ic_criminal_law.png',
                podDescription:
                    'A space for discussions on litigation, trial strategies, and justice.',
                podBanner: 'assets/images/civil_and_criminal.jpeg',
              ),
              PodsCard(
                podName: 'Corporate & Business Law',
                podImage: 'assets/icons/ic_businees_law.png',
                podDescription:
                    'Contracts, compliance, and startup legal help.',
                podBanner: 'assets/images/coperate_and_businees.jpg',
              ),
              PodsCard(
                podName: 'Moot Court & Bar Exam Prep',
                podImage: 'assets/icons/ic_exam_prep.png',
                podDescription:
                    'Law students share resources and preparation strategies.',
                podBanner: 'assets/images/bar_exam.jpg',
              ),
              PodsCard(
                podName: 'Internships & Job Opportunities',
                podImage: 'assets/icons/ic_internship_and_job.png',
                podDescription:
                    'A hub for legal job postings and career growth.',
                podBanner: 'assets/images/internship.jpg',
              ),
              PodsCard(
                podName: 'Legal Tech & AI',
                podImage: 'assets/icons/ic_legal_tech_and_ai.png',
                podDescription:
                    'Discuss AI-driven legal research, case predictions, and automation.',
                podBanner: 'assets/images/law_and_ai.jpg',
              ),
              PodsCard(
                podName: 'Case Discussions',
                podImage: 'assets/icons/ic_case_discussion.png',
                podDescription:
                    'Lawyers and students analyze and debate important legal cases.',
                podBanner: 'assets/images/case_discussion.jpg',
              ),
              PodsCard(
                podName: 'Legal News & Updates',
                podImage: 'assets/icons/ic_legal_news_and_updates.png',
                podDescription:
                    'Stay updated on major rulings, amendments, and industry trends.',
                podBanner: 'assets/images/legal_news.jpg',
              ),
              PodsCard(
                podName: 'General',
                podImage: 'assets/icons/ic_general.png',
                podDescription:
                    'For general discussion that don\'t fit in any other pod',
                podBanner: 'assets/images/general.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
