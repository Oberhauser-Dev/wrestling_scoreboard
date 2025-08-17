import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/l10n/app_localizations.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';

class CustomTextInput extends StatelessWidget {
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final IconData? iconData;
  final String label;
  final String? initialValue;
  final bool isMultiline;
  final bool isMandatory;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;
  final String? errorText;

  const CustomTextInput({
    this.onSaved,
    this.onChanged,
    required this.label,
    this.iconData,
    this.initialValue,
    this.isMultiline = false,
    this.isMandatory = false,
    super.key,
    this.validator,
    this.autofillHints,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return ListTile(
      leading: iconData != null ? Icon(iconData) : const SizedBox(),
      title: TextFormField(
        autofillHints: autofillHints,
        readOnly: onSaved == null && onChanged == null,
        maxLines: isMultiline ? null : 1,
        keyboardType: isMultiline ? TextInputType.multiline : null,
        // Convert empty value to null
        onSaved: onSaved == null ? null : (value) => onSaved!((value?.isEmpty ?? true) ? null : value),
        onChanged: onChanged == null ? null : (value) => onChanged!(value),
        validator:
            validator ??
            (value) {
              if (isMandatory && (value == null || value.isEmpty)) {
                return localizations.mandatoryField;
              }
              return null;
            },
        initialValue: initialValue,
        decoration: CustomInputDecoration(
          isMandatory: isMandatory,
          label: label,
          localizations: localizations,
          errorText: errorText,
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
        decoration: CustomInputDecoration(isMandatory: isMandatory, label: label, localizations: localizations),
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
    final label = localizations.email;
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
        decoration: CustomInputDecoration(isMandatory: isMandatory, label: label, localizations: localizations),
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
  final bool requiresMinLength;
  final String? errorText;

  const PasswordInput({
    this.initialValue,
    required this.onSaved,
    this.isNewPassword = false,
    super.key,
    this.isRepetition = false,
    this.isMandatory = false,
    this.requiresMinLength = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final label = isRepetition ? 'Repeat ${localizations.auth_Password}' : localizations.auth_Password;
    return ListTile(
      leading: const Icon(Icons.password),
      title: TextFormField(
        initialValue: initialValue,
        // Convert empty value to null
        onSaved: (value) => onSaved((value?.isEmpty ?? true) ? null : value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (isMandatory) {
              return localizations.mandatoryField;
            }
          } else {
            if (!RegExp(r'^(?!.*\s).+$').hasMatch(value)) {
              return 'Password must not contain any whitespace!';
            }
            if (requiresMinLength && value.length < 8) {
              return 'Password must have at least 8 characters!';
            }
          }
          return null;
        },
        obscureText: true,
        decoration: CustomInputDecoration(
          isMandatory: isMandatory,
          label: label,
          localizations: localizations,
          errorText: errorText,
        ),
        autofillHints: [isNewPassword ? AutofillHints.newPassword : AutofillHints.password],
      ),
    );
  }
}

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({
    required bool isMandatory,
    String? label,
    required AppLocalizations localizations,
    super.errorText,
    super.icon,
  }) : super(
         border: const UnderlineInputBorder(),
         labelText:
             label == null
                 ? null
                 : isMandatory
                 ? '$label*'
                 : label,
         hintText: isMandatory ? null : localizations.optional,
       );
}
