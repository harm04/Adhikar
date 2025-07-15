import 'dart:convert';

import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/search/widget/search_post.dart';
import 'package:adhikar/features/search/widget/search_user.dart';
import 'package:adhikar/theme/color_scheme.dart';
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
          backgroundColor: Colors.white,
          title: const Text('Judgment', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: WebViewWidget(
          controller: WebViewController()..loadRequest(Uri.parse(url)),
        ),
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
      return Center(
        child: Text(
          'No results found.',
          style: TextStyle(color: context.textSecondaryColor),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10.0),
      itemCount: _legalResults.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = _legalResults[index];
        return Card(
          color: context.cardColor,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: item['title'] != null
                ? RichText(
                    text: parseBoldHtml(
                      item['title'],
                      style: TextStyle(
                        fontSize: 18,
                        color: context.textPrimaryColor,
                      ),
                      boldStyle: TextStyle(
                        fontSize: 18,
                        color: context.textPrimaryColor,
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
                        style: TextStyle(
                          fontSize: 14,
                          color: context.textSecondaryColor,
                        ),
                        boldStyle: TextStyle(
                          fontSize: 14,
                          color: context.textSecondaryColor,
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
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textTertiaryColor,
                      ),
                    ),
                  ),
                if (item['docsource'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Source: ${item['docsource']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textTertiaryColor,
                      ),
                    ),
                  ),
                if (item['citation'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Citation: ${item['citation']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.textTertiaryColor,
                      ),
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
      backgroundColor: context.backgroundColor,
      // Prevent the scaffold from resizing when keyboard appears
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.iconPrimaryColor),
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                cursorColor: context.textPrimaryColor,
                style: TextStyle(
                  color: context.textPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/svg/search.svg',
                      color: context.iconSecondaryColor,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: context.secondaryColor),
                  ),
                  hintText: 'Search for people, posts, or legal documents...',
                  hintStyle: TextStyle(color: context.textHintColor),
                  hintMaxLines: 1,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: context.secondaryColor,
          labelColor: context.secondaryColor,
          unselectedLabelColor: context.textSecondaryColor,
          labelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Posts'),
            Tab(text: 'Legal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _query.isEmpty
              ? Center(
                  child: Text(
                    'Type to search users',
                    style: TextStyle(color: context.textSecondaryColor),
                  ),
                )
              : SearchUser(query: _query),
          _query.isEmpty
              ? Center(
                  child: Text(
                    'Type to search posts',
                    style: TextStyle(color: context.textSecondaryColor),
                  ),
                )
              : SearchPost(query: _query),
          _buildLegalResults(),
        ],
      ),
    );
  }
}
