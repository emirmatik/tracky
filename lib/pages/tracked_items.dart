import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:tracky/components/styled_text.dart';
import 'package:provider/provider.dart';
import 'package:tracky/core/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/main.dart';

class Item {
  final String uid;
  final String html;
  final String title;
  final String url;
  final String xpath;
  final bool isUpdated;

  const Item({
    required this.uid,
    required this.html,
    required this.title,
    required this.url,
    required this.xpath,
    required this.isUpdated,
  });

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
  User? user;

  bool initialLoadComplete = false;

  final String serverUrl = 'https://tracky-wwr6.onrender.com';
  String theme = Main.theme;

  late Future<List<Item>> items;

  Future<List<Item>> _fetchItems() async {
    final res = await http.get(Uri.parse('$serverUrl/items/${user?.uid}'));

    if (!mounted) {
      return [];
    }

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body)['data'];
      final Iterable<Item> items =
          data.map((itemJson) => Item.fromJson(itemJson));

      return items.toList();
    } else {
      throw Exception('Failed to fetch tracked items');
    }
  }

  void _markItemsAsSeen(List<String> ids) async {
    try {
      await http.post(
        Uri.parse('$serverUrl/items/seen/${user?.uid}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ids),
      );
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
    items = _fetchItems();
    items.then((List<Item> result) {
      List<Item> updatedItems = result.where((item) => item.isUpdated).toList();
      if (updatedItems.isNotEmpty) {
        final List<String> ids = updatedItems.map((item) => item.uid).toList();
        _markItemsAsSeen(ids);
      }
    });
  }

  Widget _textPlaceholder(String text) {
    return StyledText(
      text: text,
      type: 'small',
      color: theme == 'dark' ? darkTextSmoke : Colors.black45,
    );
  }

  Widget _webView(String url, String xpath) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border:
            Border.all(color: theme == 'dark' ? darkTextPrimary : Colors.black),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useShouldInterceptFetchRequest: true,
            ),
          ),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            if (initialLoadComplete) {
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          shouldInterceptFetchRequest: (controller, fetchRequest) async {
            return FetchRequest(action: FetchRequestAction.ABORT);
          },
          gestureRecognizers: Set()
            ..add(
              Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()),
            ),
          onLoadStop: (controller, url) async {
            setState(() {
              initialLoadComplete = true;
            });

            controller.addJavaScriptHandler(
              handlerName: 'getXpath',
              callback: (args) {
                return xpath;
              },
            );

            await controller.evaluateJavascript(source: '''
              (function() {
                function getElementByXpath(path) {
                  return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
                };

                window.flutter_inappwebview.callHandler('getXpath').then((xpath) => {
                  const element = getElementByXpath(xpath);
                  alert(element?.innerHTML);

                  if (element) {
                    element.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    element.style.border = '2px dashed #759DEA';
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
    return items!.isEmpty
        ? SizedBox(
            height: 400,
            child: Center(
              child: _textPlaceholder('Start tracking your favorite sites'),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(items.length, (index) {
              final item = items[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: const Alignment(-1.5, 0),
                        children: [
                          StyledText(text: item.title),
                          item.isUpdated
                              ? const Icon(
                                  Icons.circle,
                                  size: 11,
                                  color: bluePrimary,
                                )
                              : Container(),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(Uri.parse(item.url))) {
                            await launchUrl(
                              Uri.parse(item.url),
                            );
                          }
                        },
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StyledText(
                              text: 'See website',
                              type: 'small',
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.launch_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  StyledText(
                    text: Uri.parse(item.url).host,
                    type: 'small',
                  ),
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
