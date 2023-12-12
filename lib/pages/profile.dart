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

const List<String> list = <String>['Light', 'Dark'];

class _ProfilePage extends State<ProfilePage> {
  late TextEditingController _emailInputController;
  bool isMailChecked = false;
  bool isNotificationChecked = false;
  String dropdownValue = list.first;

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
  }

  Widget profilePicture(User? user) {
    List<String>? nameParts = user?.displayName!.split(' ');
    String initials = '';

    for (int i = 0; i < nameParts!.length && i < 2; i++) {
      initials += nameParts[i][0].toUpperCase();
    }

    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: Container(
        width: 64,
        height: 64,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: StyledText(text: initials),
      ),
    );
  }

  Widget userInformations(User? user) {
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
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: '${user?.email}',
            border: const OutlineInputBorder(),
          ),
        ),
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
        const SizedBox(
          height: 28,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StyledText(text: 'Enable notifications via mail'),
            Container(
              width: 32,
              height: 32,
              // constraints: const BoxConstraints.expand(),
              child: Checkbox(
                fillColor: MaterialStateProperty.resolveWith(getCheckBoxColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                value: isMailChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isMailChecked = value!;
                  });
                },
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const StyledText(text: 'Notified Email'),
        const SizedBox(
          height: 7,
        ),
        StyledInput(
          controller: _emailInputController,
          hint: '${user?.email}',
        ),
        const SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StyledText(text: 'Enable app notifications'),
            Checkbox(
              fillColor: MaterialStateProperty.resolveWith(getCheckBoxColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: isNotificationChecked,
              onChanged: (bool? value) {
                setState(() {
                  isNotificationChecked = value!;
                });
              },
            )
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StyledText(
              text: 'Theme',
            ),
            DropdownMenu<String>(
              initialSelection: list.first,
              onSelected: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              dropdownMenuEntries:
                  list.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ],
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              userInformations(user),
              const SizedBox(height: 32),
              preferences(user),

              // const SizedBox(
              //   height: 175,
              // ),
              // Expanded(
              //   child: Row(
              //     children: [
              //       StyledButton(handlePress: () => {}, text: 'Discard'),
              //       StyledButton(handlePress: () => {}, text: 'Save'),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
