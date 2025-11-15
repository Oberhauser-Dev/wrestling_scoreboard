import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class SignInPasswordScreen extends ConsumerStatefulWidget {
  final String username;

  const SignInPasswordScreen({required this.username, super.key});

  @override
  ConsumerState<SignInPasswordScreen> createState() => _SignInPasswordScreenState();
}

class _SignInPasswordScreenState extends ConsumerState<SignInPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _password;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.auth_signIn)),
      body: ResponsiveScrollView(
        child: Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                PasswordInput(
                  onSaved: (String? value) => _password = value,
                  isMandatory: true,
                  // Allow passwords smaller than minLength, as 'admin' is the standard password, which does not have to fulfill the requirement.
                  requiresMinLength: false,
                  isNewPassword: false,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed:
                        () => catchAsync(context, () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await ref
                                .read(userProvider.notifier)
                                .signInPassword(username: widget.username, password: _password!);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        }),
                    child: Text(localizations.auth_signIn),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
