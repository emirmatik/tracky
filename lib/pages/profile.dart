import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/app_themes.dart';
import 'package:tracky/core/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:tracky/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _emailFormKey = GlobalKey<FormState>();
  late TextEditingController _emailInputController;

  User? user;

  bool isLoading = true;
  bool areEqual = true;
  bool isUpdating = false;

  Map<String, dynamic> preferences = {};
  Map<String, dynamic> initialPreferences = {};

  final String serverUrl = 'https://tracky-wwr6.onrender.com';

  void _fetchPreferences() async {
    final res =
        await http.get(Uri.parse('$serverUrl/preferences/${user?.uid}'));

    if (!mounted) {
      return;
    }

    var userPreferences = preferences;

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      userPreferences = body['data'];
      _emailInputController.text = userPreferences['notifiedEmail'];
    }

    setState(() {
      isLoading = false;
      preferences = {...userPreferences};
      initialPreferences = {...userPreferences};
    });
  }

  void _updatePreferences() async {
    setState(() {
      isUpdating = true;
    });

    await http.put(
      Uri.parse('$serverUrl/preferences/${user?.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(preferences),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      initialPreferences = {...preferences};
      areEqual = true;
      isUpdating = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    user = Provider.of<UserProvider>(context, listen: false).user;
    _fetchPreferences();
  }

  String? _emailValidator(value) {
    if (value == null ||
        !RegExp(r'^(([^<>()[]\.,;:\s@"]+(.[^<>()[]\.,;:\s@"]+)*)|(".+"))@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}])|(([a-zA-Z-0-9]+.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
      return 'Please type a valid email';
    }

    return null;
  }

  void _onChangeEmail(String value) {
    preferences['notifiedEmail'] = value;
    bool currentEquality = _arePreferencesEqual();

    if (areEqual != currentEquality) {
      setState(() {
        areEqual = currentEquality;
      });
    }
  }

  bool _arePreferencesEqual() {
    return mapEquals(preferences, initialPreferences);
  }

  void _onChangeCheckbox(bool? value, String key) {
    preferences[key] = value;
    bool currentEquality = _arePreferencesEqual();

    setState(() {
      areEqual = currentEquality;
    });
  }

  void _discardPreferences() {
    setState(() {
      preferences = {...initialPreferences};
      areEqual = true;
    });
  }

  Widget profilePicture() {
    List<String>? nameParts = user?.displayName!.split(' ');
    String initials = '';
    String theme = Main.theme;

    for (int i = 0; i < nameParts!.length && i < 2; i++) {
      initials += nameParts[i][0].toUpperCase();
    }

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: theme == 'light' ? Colors.white : darkBackground,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: theme == 'light' ? Colors.black : darkTextPrimary,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: StyledText(
          text: initials,
          type: 'h2',
        ),
      ),
    );
  }

  Widget readOnlyTextField() {
    String theme = Main.theme;

    return TextFormField(
      readOnly: true,
      enabled: false,
      initialValue: user!.email,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: theme == 'light' ? Colors.black45 : darkTextSmoke,
          ),
    );
  }

  Widget profile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'Profile',
          type: 'h1',
        ),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profilePicture(),
            const SizedBox(
              width: 16,
            ),
            StyledText(text: '${user?.displayName}'),
          ],
        ),
        const SizedBox(height: 16),
        readOnlyTextField(),
      ],
    );
  }

  Widget checkbox(String key) {
    return Transform.scale(
      scale: 1.7,
      child: Checkbox(
        side: const BorderSide(width: 0.5),
        fillColor: MaterialStateProperty.resolveWith(getCheckBoxColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        value: preferences[key],
        onChanged: (bool? value) {
          _onChangeCheckbox(value, key);
        },
      ),
    );
  }

  Color getCheckBoxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return bluePrimary;
    }
    return Colors.white;
  }

  Widget dropdownMenu() {
    String theme = Main.theme;

    return Container(
      height: 40,
      width: 171,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme == 'light' ? Colors.black : darkTextPrimary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_down,
                  color: theme == 'light' ? Colors.black : darkTextPrimary),
              const SizedBox(width: 8),
            ],
          ),
          SizedBox(
            height: 40,
            width: 171,
            child: DropdownButton<String>(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              isDense: true,
              value: theme,
              onChanged: Main.updateAppTheme,
              items: const [
                DropdownMenuItem(
                  value: 'light',
                  child: StyledText(
                    text: 'Light',
                  ),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: StyledText(
                    text: 'Dark',
                  ),
                ),
              ],
              icon: const SizedBox.shrink(),
              underline: Container(
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StyledText(
          text: 'Preferences',
          type: 'h2',
        ),
        const SizedBox(height: 16),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const StyledText(text: 'Enable notifications via mail'),
                      checkbox('enableEmailNotifications'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const StyledText(text: 'Notified Email'),
                  const SizedBox(height: 7),
                  Form(
                    key: _emailFormKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: StyledInput(
                      controller: _emailInputController,
                      hint: '${user?.email}',
                      validatorFn: _emailValidator,
                      handleChange: _onChangeEmail,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const StyledText(text: 'Enable app notifications'),
                      checkbox('enableAppNotifications'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const StyledText(
                        text: 'Theme',
                      ),
                      dropdownMenu(),
                    ],
                  ),
                ],
              ),
      ],
    );
  }

  Widget buttons() {
    return Row(
      children: [
        Expanded(
          child: StyledButton(
            handlePress: isUpdating ? null : () => _discardPreferences(),
            text: 'Discard',
            type: 'discard',
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: StyledButton(
            handlePress: isUpdating ? null : () => _updatePreferences(),
            text: 'Save',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profile(),
        const SizedBox(height: 32),
        renderPreferences(),
        const SizedBox(height: 32),
        isUpdating
            ? const Column(
                children: [
                  SizedBox(height: 16),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 16),
                ],
              )
            : Container(),
        !areEqual
            ? buttons()
            : StyledButton(
                handlePress: () => FirebaseAuth.instance.signOut(),
                text: 'Sign out',
                type: 'secondary',
              ),
      ],
    );
  }
}
