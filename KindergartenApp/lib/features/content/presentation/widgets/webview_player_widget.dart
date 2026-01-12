import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPlayerWidget extends StatefulWidget {
  final String url;
  const WebviewPlayerWidget({super.key, required this.url});

  @override
  State<WebviewPlayerWidget> createState() => _WebviewPlayerWidgetState();
}

class _WebviewPlayerWidgetState extends State<WebviewPlayerWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    final WebViewController controller = WebViewController();
    
    if (!kIsWeb) {
      controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      controller.setBackgroundColor(const Color(0x00000000));
    }
    
    controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
      
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
