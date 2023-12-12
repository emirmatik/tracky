import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:tracky/components/styled_text.dart';

class Item {
  final String uid;
  final String html;
  final String title;
  final String url;
  final String xpath;
  final bool isUpdated;

  const Item(
      {required this.uid,
      required this.html,
      required this.title,
      required this.url,
      required this.xpath,
      required this.isUpdated});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      uid: json['uid'] as String,
      html: json['html'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      xpath: json['xpath'] as String,
      isUpdated: json['isUpdated'] as bool,
    );
  }
}

class TrackedItemsPage extends StatefulWidget {
  const TrackedItemsPage({super.key});

  @override
  State<TrackedItemsPage> createState() => _TrackedItemsPageState();
}

class _TrackedItemsPageState extends State<TrackedItemsPage> {
  final Map<String, String> user = {
    "email": "matik@gmail.com",
    "uid": "fJARoNcmiDUFXULNhBHC39kTR552"
  };

  // final String serverUrl = 'http://localhost:8080';
  final String serverUrl = 'https://tracky-wwr6.onrender.com';

  late Future<List<Item>> items;

  Future<List<Item>> _fetchItems() async {
    final res = await http.get(Uri.parse('$serverUrl/items/${user['uid']}'));

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body)['data'];
      final Iterable<Item> items =
          data.map((itemJson) => Item.fromJson(itemJson));
      return items.toList();
    } else {
      throw Exception('Failed to fetch tracked items');
    }
  }

  @override
  void initState() {
    super.initState();
    items = _fetchItems();
    // TODO :: call fn to mark items as seen
  }

  Widget _webView(String url, String xpath) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.black),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          gestureRecognizers: Set()
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          onLoadStop: (controller, url) async {
            controller.addJavaScriptHandler(
                handlerName: 'getXpath',
                callback: (args) {
                  return xpath;
                });

            await controller.evaluateJavascript(source: '''
              (function() {
                function getElementByXpath(path) {
                  return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
                };

                window.flutter_inappwebview.callHandler('getXpath').then((xpath) => {
                  const element = getElementByXpath(xpath);

                  if (element) {
                    element.scrollIntoView({ behavior: 'smooth', block: 'center' });
                  }
                });
              })();
            ''');
          },
        ),
      ),
    );
  }

  Widget _renderTrackedItems(List<Item>? items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(items!.length, (index) {
        final item = items[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(text: '${item.title} - ${Uri.parse(item.url).host}'),
            const SizedBox(height: 16),
            _webView(item.url, item.xpath),
            (index != items.length - 1
                ? const SizedBox(height: 32)
                : const SizedBox())
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'Tracked Items',
          type: 'h1',
        ),
        const SizedBox(height: 32),
        FutureBuilder<List<Item>>(
          future: items,
          builder: (context, snapshot) {
            Widget centeredElement;

            if (snapshot.hasError) {
              centeredElement = StyledText(text: snapshot.error.toString());
            } else if (snapshot.hasData) {
              return _renderTrackedItems(snapshot.data);
            } else {
              centeredElement = const CircularProgressIndicator();
            }

            return SizedBox(
              height: 300,
              child: Center(child: centeredElement),
            );
          },
        )
      ],
    );
  }
}
