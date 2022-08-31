import 'package:flutter/material.dart';
import 'package:gallary_app/dialogs/generic_dialogs.dart';

Future<bool> showLogoutDialog(BuildContext context) => showGenericDialog<bool>(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      optionsBuilder: () => {
        'Cancel': false,
        'Logout': true,
      },
    ).then((value) => value ?? false);
 