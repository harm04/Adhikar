import 'package:adhikar/features/kyr/views/kyr.dart';
import 'package:adhikar/models/kyr_model.dart';
import 'package:flutter/material.dart';

class KYRListView extends StatelessWidget {
  const KYRListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KYRModel>>(
      future: loadKYRs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load rights.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No rights found.'));
        }
        final kyrs = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Know Your Rights'),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: kyrs.length,
            itemBuilder: (context, index) {
              final kyr = kyrs[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    kyr.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(kyr.category),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KYRDetailView(kyr: kyr),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
