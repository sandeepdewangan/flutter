import 'package:flutter/material.dart';
import 'package:gallary_app/dialogs/generic_dialogs.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) =>
    showGenericDialog<bool>(
      context: context,
      title: 'Delete Account',
      content: 'Are you sure you want to delete account?',
      optionsBuilder: () => {
        'Cancel': false,
        'Delete Account': true,
      },
    ).then((value) => value ?? false);
