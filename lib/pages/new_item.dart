import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key});

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  final _websiteFormKey = GlobalKey<FormState>();
  final _saveFormKey = GlobalKey<FormState>();

  late TextEditingController _websiteInputController;
  late TextEditingController _titleInputController;

  InAppWebViewController? _initialController;

  Map<String, dynamic>? selectedItem;

  bool isWebviewVisible = false;
  bool isSelecting = true;

  @override
  void initState() {
    super.initState();
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

  void _onEnterWebsite() {
    bool isURLValid = _websiteFormKey.currentState!.validate();

    if (isURLValid) {
      // text is valid, open up the webview
      setState(() {
        isWebviewVisible = isURLValid;
      });
    }
  }

  void _onTrack() {
    bool isTitleValid = _saveFormKey.currentState!.validate();
    if (!isTitleValid) return;

    String title = _titleInputController.text;

    print(selectedItem); // xpath, innerHTML
    print(title);

    // TODO :: API call
    // TODO :: show notification based on the result
    // TODO :: clear the inputs and set the variables to default
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
      color: Colors.black45,
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
          StyledButton(handlePress: _onEnterWebsite, text: 'Visit')
        ],
      ),
    );
  }

  Widget _webView() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Colors.black),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse(_websiteInputController.text)),
          onLoadStop: (controller, url) async {
            _initialController = controller;

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
                });
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
          child: StyledButton(handlePress: _onGoUp, text: 'Go up'),
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
        border: Border.all(color: Colors.black),
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
              controller: _titleInputController,
              hint: 'Give it a name',
              validatorFn: _titleValidator,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: StyledButton(handlePress: _onTrack, text: 'Track'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
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
          ),
        ),
      ),
    );
  }
}
