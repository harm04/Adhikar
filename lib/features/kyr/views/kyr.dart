import 'dart:convert';
import 'package:adhikar/models/kyr_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

Future<List<KYRModel>> loadKYRs() async {
  final String response = await rootBundle.loadString(
    'lib/kyr_fundamental_rights.json',
  );
  final List<dynamic> data = json.decode(response);
  // Filter out entries without a title or required fields
  final filtered = data
      .where((e) => e is Map && (e['title'] ?? '').toString().trim().isNotEmpty)
      .toList();
  return filtered.map((e) => KYRModel.fromJson(e)).toList();
}

class KYRDetailView extends StatelessWidget {
  final KYRModel kyr;
  const KYRDetailView({required this.kyr, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kyr.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              kyr.category,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(kyr.description),
            const SizedBox(height: 16),
            Text(
              'Legal Basis: ${kyr.legalBasis}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Action Points:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...kyr.actionPoints.map(
              (e) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(e),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
