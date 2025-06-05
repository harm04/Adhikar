import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  final String appBarText;
  const WebViewPage({super.key, required this.url, required this.appBarText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarText)),
      body: NewsWebViewWidget(url: url),
    );
  }
}

class NewsWebViewWidget extends StatefulWidget {
  final String url;
  const NewsWebViewWidget({super.key, required this.url});

  @override
  State<NewsWebViewWidget> createState() => _NewsWebViewWidgetState();
}

class _NewsWebViewWidgetState extends State<NewsWebViewWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // <-- Enable JavaScript
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
