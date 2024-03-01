// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:native_screenshot_widget/native_screenshot_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NativeScreenshot Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NativeScreenshot Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final webViewScreenshotController = NativeScreenshotController();
  final flutterWidgetScreenshotController = NativeScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            child: PopupMenuButton<VoidCallback>(
              child: const Text('Menus'),
              onSelected: (call) {
                Future.delayed(const Duration(milliseconds: 300), call);
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: () =>
                        _takeScreenshot('WebView', webViewScreenshotController),
                    child: const Text('WebView Screenshot'),
                  ),
                  PopupMenuItem(
                    value: () => _takeScreenshot(
                        'Flutter Widget', flutterWidgetScreenshotController),
                    child: const Text('Flutter Widget Screenshot'),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("WebView:"),
          Expanded(
            child: NativeScreenshot(
              controller: webViewScreenshotController,
              child: WebViewWidget(
                controller: WebViewController()
                  ..loadRequest(Uri.parse('https://flutter.dev')),
              ),
            ),
          ),
          const Text("Flutter Widget:"),
          Expanded(
            child: NativeScreenshot(
              controller: flutterWidgetScreenshotController,
              child: Container(
                color: Colors.grey.shade300,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      NativeScreenshot(
                        controller: flutterWidgetScreenshotController,
                        child: Text(
                          "Flutter Widget",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _takeScreenshot(
      String type, NativeScreenshotController screenshotController) async {
    final bytes = await screenshotController.takeScreenshot();
    if (bytes?.isNotEmpty ?? false) {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Screenshot-$type'),
          content: Image.memory(
            bytes!,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }
}
