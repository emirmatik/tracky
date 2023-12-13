import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracky/components/styled_button.dart';
import 'package:tracky/components/styled_input.dart';
import 'package:tracky/components/styled_text.dart';
import 'package:tracky/core/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late TextEditingController _emailInputController;
  bool isMailChecked = false;
  bool isNotificationChecked = false;
  String dropdownValue = 'Light';

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    isMailChecked = false;
    isNotificationChecked = false;
  }

  Widget profilePicture(User? user) {
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

  Widget readOnlyTextField(User? user) {
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
          color: Colors.black,
        ),
        disabledBorder: Theme.of(context).inputDecorationTheme.border,
      ),
    );
  }

  Widget profile(User? user) {
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
            profilePicture(user),
            const SizedBox(
              width: 16,
            ),
            StyledText(text: '${user?.displayName}'),
          ],
        ),
        const SizedBox(height: 16),
        readOnlyTextField(user),
      ],
    );
  }

  Widget checkbox(bool check, Function(bool) onChanged) {
    return Transform.scale(
      scale: 1.7,
      child: Checkbox(
        side: const BorderSide(width: 0.5),
        fillColor: MaterialStateProperty.resolveWith(getCheckBoxColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        value: check,
        onChanged: (bool? value) {
          onChanged(value ?? false);
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
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          SizedBox(
            height: 40,
            width: 171,
            child: DropdownButton<String>(
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

  Widget buttons() {
    return Row(
      children: [
        Expanded(
          child: StyledButton(
            handlePress: () => {},
            text: 'Discard',
            // type: 'discard',
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          child: StyledButton(
            handlePress: () => {},
            text: 'Save',
          ),
        )
      ],
    );
  }

  Widget preferences(User? user) {
    return Column(
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
            checkbox(isMailChecked, (value) {
              setState(() {
                isMailChecked = value;
              });
            }),
          ],
        ),
        const SizedBox(height: 20),
        const StyledText(text: 'Notified Email'),
        const SizedBox(height: 7),
        StyledInput(
          controller: _emailInputController,
          hint: '${user?.email}',
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StyledText(text: 'Enable app notifications'),
            checkbox(isNotificationChecked, (value) {
              setState(() {
                isNotificationChecked = value;
              });
            }),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profile(user),
        const SizedBox(height: 32),
        preferences(user),
        const SizedBox(height: 96),
        buttons(),
        const SizedBox(height: 64),
        StyledButton(
          handlePress: () => FirebaseAuth.instance.signOut(),
          text: 'Sign out',
        )
      ],
    );
  }
}
