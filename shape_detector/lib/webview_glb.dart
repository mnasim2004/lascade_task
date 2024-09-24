// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// class WebViewGLB extends StatefulWidget {
//   final String glbFilePath;

//   const WebViewGLB({Key? key, required this.glbFilePath}) : super(key: key);

//   @override
//   _WebViewGLBState createState() => _WebViewGLBState();
// }

// class _WebViewGLBState extends State<WebViewGLB> {
//   late WebViewController _webViewController;

//   @override
//   void initState() {
//     super.initState();
//     // Enable virtual display for Android WebView
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("GLB Model Viewer")),
//       body: WebView(
//         initialUrl: '',
//         onWebViewCreated: (controller) async {
//           _webViewController = controller;
//           await _loadLocalHtml();
//         },
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }

//   Future<void> _loadLocalHtml() async {
//     String htmlString = await _loadHtmlStringWithModel(widget.glbFilePath);
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/index.html');
//     await file.writeAsString(htmlString);
//     _webViewController.loadUrl(Uri.file(file.path).toString());
//   }

//   Future<String> _loadHtmlStringWithModel(String modelPath) async {
//     // Load the HTML content and replace the placeholder with the actual GLB file path
//     String htmlContent = await DefaultAssetBundle.of(context).loadString('assets/index.html');
//     return htmlContent.replaceFirst('MODEL_URL_PLACEHOLDER', 'file://$modelPath');
//   }
// }
