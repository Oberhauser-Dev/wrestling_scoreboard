import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomTextInput extends StatelessWidget {
  final FormFieldSetter<String>? onSaved;
  final IconData? iconData;
  final String label;
  final String? initialValue;
  final bool isMultiline;
  final bool isMandatory;
  final FormFieldValidator<String>? validator;

  const CustomTextInput({
    this.onSaved,
    required this.label,
    this.iconData,
    this.initialValue,
    this.isMultiline = false,
    this.isMandatory = false,
    super.key,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      leading: iconData != null ? Icon(iconData) : const SizedBox(),
      title: TextFormField(
        readOnly: onSaved == null,
        maxLines: isMultiline ? null : 1,
        keyboardType: isMultiline ? TextInputType.multiline : null,
        onSaved: onSaved,
        validator: validator ??
            (value) {
              if (isMandatory && (value == null || value.isEmpty)) {
                return localizations.mandatoryField;
              }
              return null;
            },
        initialValue: initialValue,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final String? initialValue;
  final FormFieldSetter<String> onSave;
  final bool isMandatory;

  const EmailInput({
    this.initialValue,
    required this.onSave,
    this.isMandatory = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.email),
      title: TextFormField(
        initialValue: initialValue,
        onSaved: onSave,
        validator: (value) {
          if (isMandatory && (value == null || value.length < 3)) {
            return 'Please enter a valid email address!';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: localizations.email,
        ),
        autofillHints: const [AutofillHints.email],
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  final String? initialValue;
  final FormFieldSetter<String> onSaved;
  final bool isNewPassword;
  final bool isRepetition;
  final bool isMandatory;

  const PasswordInput({
    this.initialValue,
    required this.onSaved,
    this.isNewPassword = false,
    super.key,
    this.isRepetition = false,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.password),
      title: TextFormField(
        initialValue: initialValue,
        onSaved: onSaved,
        validator: (value) {
          if (isMandatory) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            if (!RegExp(r'^(?!.*\s).+$').hasMatch(value)) {
              return 'Password must not contain any whitespace!';
            }
            if (value.length < 8) {
              return 'Password must have at least 8 characters!';
            }
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: isRepetition ? 'Repeat ${localizations.auth_Password}' : localizations.auth_Password,
        ),
        autofillHints: [isNewPassword ? AutofillHints.newPassword : AutofillHints.password],
      ),
    );
  }
}
