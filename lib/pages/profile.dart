import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/user_provider.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _emailFormKey = GlobalKey<FormState>();
  late TextEditingController _emailInputController;
  String dropdownValue = 'Light';

  User? user;

  bool isLoading = true;
  bool areEqual = true;
  bool isUpdating = false;

  Map<String, dynamic> preferences = {
    'enableAppNotifications': null,
    'enableEmailNotifications': null,
    'notifiedEmail': null,
  };
  Map<String, dynamic> initialPreferences = {
    'enableAppNotifications': null,
    'enableEmailNotifications': null,
    'notifiedEmail': null,
  };

  final String serverUrl = 'https://tracky-wwr6.onrender.com';

  void _fetchPreferences() async {
    final res =
        await http.get(Uri.parse('$serverUrl/preferences/${user?.uid}'));

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

    final res = await http.put(
      Uri.parse('$serverUrl/preferences/${user?.uid}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(preferences),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to update album.');
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
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
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
    return TextField(
      readOnly: true,
      enabled: false,
      decoration: InputDecoration(
        labelText: '${user?.email}',
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
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
      return const Color.fromRGBO(117, 157, 234, 1);
    }
    return Colors.white;
  }

  Widget dropdownMenu() {
    return Container(
      height: 40,
      width: 171,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_down),
              SizedBox(width: 8),
            ],
          ),
          SizedBox(
            height: 40,
            width: 171,
            child: DropdownButton<String>(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              isDense: true,
              value: dropdownValue,
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Light',
                  child: StyledText(
                    text: 'Light',
                  ),
                ),
                DropdownMenuItem(
                  value: 'Dark',
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
    return isLoading
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StyledText(
                text: 'Preferences',
                type: 'h2',
              ),
              const SizedBox(height: 28),
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
              isUpdating
                  ? const Column(
                      children: [
                        SizedBox(height: 16),
                        Center(child: CircularProgressIndicator()),
                        SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox(height: 32),
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
        SizedBox(height: !areEqual ? 48 : 0),
        !areEqual ? buttons() : Container(),
        const SizedBox(height: 64),
        StyledButton(
          handlePress: () => FirebaseAuth.instance.signOut(),
          text: 'Sign out',
          type: 'secondary',
        )
      ],
    );
  }
}
