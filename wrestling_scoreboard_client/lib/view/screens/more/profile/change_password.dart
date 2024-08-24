import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

// TODO: refactor to a user edit form
class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const route = 'change-password';

  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _password;
  String? _passwordAgain;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.auth_change_password)),
      body: ResponsiveScrollView(
        child: Card(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              PasswordInput(
                isMandatory: true,
                onSaved: (String? value) => _password = value,
                isNewPassword: true,
              ),
              PasswordInput(
                isMandatory: true,
                onSaved: (String? value) => _passwordAgain = value,
                isNewPassword: true,
                isRepetition: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      if (_password != _passwordAgain) {
                        throw Exception('Passwords must match!');
                      }
                      final user = await ref.read(userNotifierProvider);
                      if (user != null) {
                        await ref.read(userNotifierProvider.notifier).updateUser(
                                user: user.copyWith(
                              password: _password,
                            ));
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  child: Text(localizations.auth_password_save_phrase),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
