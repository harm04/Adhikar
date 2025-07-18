import 'dart:convert';

import 'package:adhikar/common/widgets/error.dart';
import 'package:adhikar/common/widgets/loader.dart';
import 'package:adhikar/constants/appwrite_constants.dart';
import 'package:adhikar/features/news/views/news.dart';
import 'package:adhikar/features/news/widget/news_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class NewsList extends ConsumerStatefulWidget {
  NewsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsState();
}

class _NewsState extends ConsumerState<NewsList> {
  List<dynamic> _newsResults = [];
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.webz.io/newsApiLite?token=${AppwriteConstants.newsAuthToken}&q=legal&language=english&country=IN',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _newsResults = data['posts'] ?? [];
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loader()
        : _error != null
        ? ErrorPage(error: _error!)
        : Scaffold(
            appBar: AppBar(
              title: Text('News'),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            body: _newsResults.isEmpty
                ? Center(child: Text('No news found'))
                : ListView.builder(
                    padding: EdgeInsets.all(18.0),
                    itemCount: _newsResults.length,
                    itemBuilder: (context, index) {
                      final item = _newsResults[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // Pass the full news list as allNews, and the selected item as item
                              return News(item: item, allNews: _newsResults);
                            },
                          ),
                        ),
                        child: NewsListCard(item: item),
                      );
                    },
                  ),
          );
  }
}
