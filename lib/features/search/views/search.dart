import 'dart:convert';

import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/search/widget/search_post.dart';
import 'package:adhikar/features/search/widget/search_user.dart';
import 'package:adhikar/theme/pallete_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isLoading = false;
  List<dynamic> _legalResults = [];
  List<dynamic> _categories = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
      _searchLegal();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLegal() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _legalResults = [];
        _categories = [];
        _error = null;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
      _legalResults = [];
      _categories = [];
    });
    try {
      final response = await http.post(
        Uri.parse(
          'https://api.indiankanoon.org/search/?formInput=${_searchController.text.trim()}&pagenum=0',
        ),
        headers: {
          'Authorization': AppwriteConstants.indiakanoonAuthToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _legalResults = data['docs'] ?? [];
          _categories = data['categories'] ?? [];
        });
      } else {
        setState(() {
          _error = 'Failed to fetch results (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showWebView(String url) {
    showDialog(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Judgment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()..loadRequest(Uri.parse(url)),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    if (_categories.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _categories.map<Widget>((cat) {
          final String title = cat[0] ?? '';
          final List<dynamic> items = cat[1] ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              Wrap(
                runSpacing: 10,
                spacing: 12,
                children: items.map<Widget>((item) {
                  return Chip(
                    label: Text(item['value'] ?? ''),
                    backgroundColor: Pallete.cardColor,
                    labelStyle: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Utility function to parse <b>...</b> and make bold
  TextSpan parseBoldHtml(
    String text, {
    TextStyle? style,
    TextStyle? boldStyle,
  }) {
    final RegExp exp = RegExp(r'<b>(.*?)<\/b>', caseSensitive: false);
    final List<InlineSpan> children = [];
    int currentIndex = 0;

    for (final match in exp.allMatches(text)) {
      if (match.start > currentIndex) {
        children.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: style,
          ),
        );
      }
      children.add(
        TextSpan(
          text: match.group(1),
          style:
              boldStyle ??
              style?.copyWith(fontWeight: FontWeight.bold) ??
              const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      currentIndex = match.end;
    }
    if (currentIndex < text.length) {
      children.add(TextSpan(text: text.substring(currentIndex), style: style));
    }
    return TextSpan(children: children);
  }

  Widget _buildLegalResults() {
    if (_isLoading) {
      return const Loader();
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (_legalResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.separated(
      itemCount: _legalResults.length + 1,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCategories();
        }
        final item = _legalResults[index - 1];
        return Card(
          color: Pallete.cardColor,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: item['title'] != null
                ? RichText(
                    text: parseBoldHtml(
                      item['title'],
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      boldStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const Text('No Title', style: TextStyle(fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['headline'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: RichText(
                      text: parseBoldHtml(
                        item['headline'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Pallete.whiteColor,
                        ),
                        boldStyle: const TextStyle(
                          fontSize: 14,
                          color: Pallete.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (item['publishdate'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'Date : ${item['publishdate']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                if (item['docsource'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Source: ${item['docsource']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                if (item['citation'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Citation: ${item['citation']}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            onTap: () {
              final tid = item['tid']?.toString() ?? '';
              if (tid.isNotEmpty) {
                final fullUrl = 'https://indiankanoon.org/doc/$tid/';
                _showWebView(fullUrl);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          cursorColor: Colors.white,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                color: Colors.white,
                width: 20,
                height: 20,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white),
            ),
            hintText: 'Search for people, posts, or legal documents...',
            hintStyle: const TextStyle(color: Pallete.whiteColor),
            hintMaxLines: 1,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Pallete.secondaryColor,
          labelColor: Pallete.secondaryColor,
          labelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Legal'),
            Tab(text: 'Posts'),
            Tab(text: 'Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLegalResults(),
          _query.isEmpty
              ? const Center(child: Text('Type to search posts'))
              : SearchPost(query: _query),
          _query.isEmpty
              ? const Center(child: Text('Type to search users'))
              : SearchUser(query: _query),
        ],
      ),
    );
  }
}
