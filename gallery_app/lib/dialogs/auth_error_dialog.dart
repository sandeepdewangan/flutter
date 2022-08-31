import 'package:flutter/material.dart';
import 'package:gallary_app/auth/auth_error.dart';
import 'package:gallary_app/dialogs/generic_dialogs.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) =>
    showGenericDialog<void>(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {
        'Ok': true,
      },
    );
