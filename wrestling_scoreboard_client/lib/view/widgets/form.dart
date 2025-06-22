import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';

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
    final localizations = context.l10n;
    return ListTile(
      leading: iconData != null ? Icon(iconData) : const SizedBox(),
      title: TextFormField(
        readOnly: onSaved == null,
        maxLines: isMultiline ? null : 1,
        keyboardType: isMultiline ? TextInputType.multiline : null,
        // Convert empty value to null
        onSaved: onSaved == null ? null : (value) => onSaved!((value?.isEmpty ?? true) ? null : value),
        validator:
            validator ??
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
          hintText: isMandatory ? null : localizations.optional,
        ),
      ),
    );
  }
}

class NumericalInput<T extends num> extends StatelessWidget {
  final FormFieldSetter<T>? onSaved;
  final IconData? iconData;
  final String label;
  final T? initialValue;
  final bool isMandatory;
  final FormFieldValidator<String>? validator;
  final TextInputFormatter inputFormatter;

  const NumericalInput({
    super.key,
    this.onSaved,
    this.iconData,
    required this.label,
    this.initialValue,
    this.isMandatory = false,
    this.validator,
    this.inputFormatter = const NumericalRangeFormatter(min: 0, max: 1000),
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return ListTile(
      leading: iconData != null ? Icon(iconData) : const SizedBox(),
      title: TextFormField(
        initialValue: initialValue?.toString() ?? '',
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: label,
          hintText: isMandatory ? null : localizations.optional,
        ),
        inputFormatters: <TextInputFormatter>[inputFormatter],
        onSaved:
            onSaved == null
                ? null
                : (String? value) {
                  if (T == int) {
                    onSaved!(int.tryParse(value ?? '') as T?);
                  } else if (T == double) {
                    onSaved!(double.tryParse(value ?? '') as T?);
                  } else {
                    onSaved!(num.tryParse(value ?? '') as T?);
                  }
                },
        validator:
            validator ??
            (value) {
              if (isMandatory && (value == null || value.isEmpty)) {
                return localizations.mandatoryField;
              }
              return null;
            },
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final String? initialValue;
  final FormFieldSetter<String> onSave;
  final bool isMandatory;

  const EmailInput({this.initialValue, required this.onSave, this.isMandatory = false, super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
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
          hintText: isMandatory ? null : localizations.optional,
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
    final localizations = context.l10n;
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
          hintText: isMandatory ? null : localizations.optional,
        ),
        autofillHints: [isNewPassword ? AutofillHints.newPassword : AutofillHints.password],
      ),
    );
  }
}
