// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// class Search extends StatefulWidget {
//   const Search({super.key});

//   @override
//   State<Search> createState() => _SearchState();
// }

// class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final TextEditingController _searchController = TextEditingController();
//   String _query = '';
//   bool _isLoading = false;
//   List<dynamic> _legalResults = [];
//   List<dynamic> _categories = [];
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _searchController.addListener(() {
//       setState(() {
//         _query = _searchController.text;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _searchLegal() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//       _legalResults = [];
//       _categories = [];
//     });
//     try {
//       final response = await http.post(
//         Uri.parse(
//           'https://api.indiankanoon.org/search/?formInput=$_query&pagenum=0',
//         ),
//         headers: {
//           'Authorization': 'Token 130502b76136f79e9aeafd2f20283bc0cba32c68',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           // Use 'docs' key as per the actual API response
//           _legalResults = data['docs'] ?? [];
//           _categories = data['categories'] ?? [];
//         });
//       } else {
//         setState(() {
//           _error = 'Failed to fetch results (${response.statusCode})';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error: $e';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildCategories() {
//     if (_categories.isEmpty) return const SizedBox.shrink();
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: _categories.map<Widget>((cat) {
//           final String title = cat[0] ?? '';
//           final List<dynamic> items = cat[1] ?? [];
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               Wrap(
//                 spacing: 8,
//                 children: items.map<Widget>((item) {
//                   return Chip(label: Text(item['value'] ?? ''));
//                 }).toList(),
//               ),
//               const SizedBox(height: 8),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildLegalResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_error != null) {
//       return Center(
//         child: Text(_error!, style: const TextStyle(color: Colors.red)),
//       );
//     }
//     if (_legalResults.isEmpty) {
//       return const Center(child: Text('No results found.'));
//     }
//     // Use ListView with a header for categories
//     return ListView.separated(
//       itemCount: _legalResults.length + 1,
//       separatorBuilder: (_, __) => const Divider(),
//       itemBuilder: (context, index) {
//         if (index == 0) {
//           // Categories header
//           return _buildCategories();
//         }
//         final item = _legalResults[index - 1];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             title: Text(
//               item['title'] ?? 'No Title',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (item['headline'] != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       item['headline'],
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 if (item['publishdate'] != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4.0),
//                     child: Text(
//                       'Date: ${item['publishdate']}',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                 if (item['docsource'] != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2.0),
//                     child: Text(
//                       'Source: ${item['docsource']}',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//                 if (item['citation'] != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 2.0),
//                     child: Text(
//                       'Citation: ${item['citation']}',
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ),
//               ],
//             ),
//             onTap: () {
//               // Optionally handle tap
//             },
//             trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Legal Search'),
//             Tab(text: 'Other Search'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search legal cases...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       _searchLegal();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 // First tab: Legal Search
//                 _buildLegalResults(),
//                 // Second tab: Placeholder for other search
//                 Center(child: Text('Other search results here')),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
