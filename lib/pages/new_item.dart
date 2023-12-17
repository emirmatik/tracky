import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/core/user_provider.dart';
import 'package:tracky/main.dart';
import 'package:http/http.dart' as http;

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final _websiteFormKey = GlobalKey<FormState>();
  final _saveFormKey = GlobalKey<FormState>();

  final String serverUrl = 'https://tracky-wwr6.onrender.com';

  late TextEditingController _websiteInputController;
  late TextEditingController _titleInputController;

  InAppWebViewController? _initialController;

  Map<String, dynamic>? selectedItem;

  User? user;

  bool initialLoadComplete = false;
  bool isWebviewVisible = false;
  bool isSelecting = true;
  bool isPosting = false;

  bool isDarkTheme = Main.theme == 'dark';

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).user;

    _websiteInputController = TextEditingController();
    _titleInputController = TextEditingController();
  }

  @override
  void dispose() {
    _websiteInputController.dispose();
    _titleInputController.dispose();
    super.dispose();
  }

  String? _websiteValidator(value) {
    if (value == null || !Uri.parse(value).isAbsolute) {
      return 'Please type a valid URL';
    }

    return null;
  }

  String? _titleValidator(value) {
    if (value == null || value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }

    return null;
  }

  void _onEnterWebsite() async {
    bool isURLValid = _websiteFormKey.currentState!.validate();

    if (isURLValid) {
      // text is valid, open up the webview
      if (_initialController != null) {
        await _initialController?.evaluateJavascript(source: '''
          window.flutter_inappwebview.callHandler('getUrl').then((url) => {
            window.location.href = url;
          });
        ''');
      }

      setState(() {
        isWebviewVisible = isURLValid;
        isSelecting = true;
        selectedItem = null;
      });
    }
  }

  void _postItem() async {
    String title = _titleInputController.text;

    final Map<String, dynamic> body = {
      "xpath": selectedItem?['xpath'],
      "html": selectedItem?['html'],
      "title": title,
      "url": _websiteInputController.text
    };

    setState(() {
      isPosting = true;
    });

    final res = await http.post(
      Uri.parse('$serverUrl/items/${user?.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (!mounted) {
      return;
    }

    if (res.statusCode == 200) {
      _websiteInputController.clear();
      _titleInputController.clear();

      setState(() {
        _initialController = null;
        isWebviewVisible = false;
        selectedItem = null;
        isSelecting = true;
        isPosting = false;
      });
    } else {
      setState(() {
        isPosting = false;
      });
    }
  }

  void _onTrack() {
    bool isTitleValid = _saveFormKey.currentState!.validate();

    if (isTitleValid) {
      _postItem();
    }
  }

  void _onGoUp() async {
    await _initialController!.injectJavascriptFileFromAsset(
      assetFilePath: 'assets/js/webview_go_up.js',
    );
  }

  void _onDone() async {
    await _initialController!.evaluateJavascript(source: '''
      document.querySelector('.selectedByTracky').classList.add('doneByTracky');
      allElementsOnPage.forEach(node => node.style.pointerEvents = 'none');
      disableScroll();
    ''');
    setState(() {
      isSelecting = false;
    });
  }

  Widget _textPlaceholder(String text) {
    return StyledText(
      text: text,
      type: 'small',
      color: isDarkTheme ? darkTextSmoke : Colors.black45,
    );
  }

  Widget _websiteForm() {
    return Form(
      key: _websiteFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StyledText(text: 'Website'),
          const SizedBox(height: 8),
          StyledInput(
            controller: _websiteInputController,
            hint: 'https://amazon.com.tr/specific-item-url',
            validatorFn: _websiteValidator,
          ),
          const SizedBox(height: 16),
          StyledButton(
            handlePress: isPosting ? null : _onEnterWebsite,
            text: 'Visit',
          )
        ],
      ),
    );
  }

  Widget _webView() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: isDarkTheme ? darkTextPrimary : Colors.black),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldOverrideUrlLoading: true,
              useShouldInterceptFetchRequest: true,
            ),
          ),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url.toString();

            String userUrl = _websiteInputController.text;

            if (userUrl[userUrl.length - 1] != '/') {
              userUrl += '/';
            }

            if (initialLoadComplete && url != userUrl) {
              return NavigationActionPolicy.CANCEL;
            }

            return NavigationActionPolicy.ALLOW;
          },
          shouldInterceptFetchRequest: (controller, fetchRequest) async {
            return FetchRequest(action: FetchRequestAction.ABORT);
          },
          initialUrlRequest:
              URLRequest(url: Uri.parse(_websiteInputController.text)),
          gestureRecognizers: Set()
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          onLoadStop: (controller, url) async {
            _initialController = controller;
            initialLoadComplete = true;

            controller.addJavaScriptHandler(
              handlerName: 'getUrl',
              callback: (args) {
                return _websiteInputController.text;
              },
            );

            await controller.injectJavascriptFileFromAsset(
              assetFilePath: 'assets/js/webview_disable_scroll.js',
            );

            await controller.injectJavascriptFileFromAsset(
              assetFilePath: 'assets/js/webview_initial_script.js',
            );

            await controller.injectCSSCode(source: '''
              .selectedByTracky {
                border: 3px solid #759DEA;
              }
            ''');

            controller.addJavaScriptHandler(
              handlerName: 'selectItem',
              callback: (args) {
                setState(() {
                  selectedItem = args[0];
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _webViewNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: StyledButton(
            handlePress: _onGoUp,
            type: 'secondary',
            text: 'Go up',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: StyledButton(handlePress: _onDone, text: 'Done'),
        ),
      ],
    );
  }

  Widget _webViewPlaceholder() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: isDarkTheme ? darkTextSmoke : Colors.black),
      ),
      child: Center(
        child: _textPlaceholder('Visit a website to track an item'),
      ),
    );
  }

  Widget _save() {
    return Form(
      key: _saveFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: StyledInput(
              validatorFn: _titleValidator,
              controller: _titleInputController,
              isDisabled: isPosting,
              hint: 'Give it a name',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: StyledButton(
              handlePress: isPosting ? null : _onTrack,
              text: 'Track',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _websiteForm(),
        const SizedBox(height: 32),
        isWebviewVisible
            ? Column(
                children: [
                  _webView(),
                  const SizedBox(height: 32),
                  (isSelecting && selectedItem != null)
                      ? _webViewNavigator()
                      : !isSelecting
                          ? _save()
                          : _textPlaceholder('Select an item to track'),
                ],
              )
            : _webViewPlaceholder(),
      ],
    );
  }
}
