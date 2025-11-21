import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_in.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/user_verification.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const route = 'sign-up';

  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _email;
  String? _password;
  String? _passwordAgain;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.auth_signUp)),
      body: ResponsiveScrollView(
        child: Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextInput.icon(
                  onSaved: (String? value) => _username = value,
                  label: localizations.username,
                  isMandatory: true,
                  validator:
                      (v) => (v != null && User.isValidUsername(v)) ? null : localizations.usernameRequirementsWarning,
                ),
                EmailInput(initialValue: _email, onSaved: (String? value) => _email = value, isMandatory: false),
                PasswordInput(onSaved: (String? value) => _password = value, isNewPassword: true, isMandatory: true),
                PasswordInput(
                  onSaved: (String? value) => _passwordAgain = value,
                  isNewPassword: true,
                  isRepetition: true,
                  isMandatory: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ElevatedButton(
                    onPressed:
                        () => catchAsync(context, () async {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            if (_password != _passwordAgain) {
                              throw Exception('Passwords must match!');
                            }
                            final navigator = Navigator.of(context);
                            await ref
                                .read(userProvider.notifier)
                                .signUp(
                                  User(
                                    email: _email,
                                    username: _username!,
                                    password: _password!,
                                    createdAt: DateTime.now(),
                                    // TODO: may add ability to connect person to account
                                  ),
                                );
                            if ((await ref.readAsync(remoteConfigProvider.future)).hasEmailVerification &&
                                context.mounted) {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserVerificationScreen(username: _username!)),
                              );
                            }
                            navigator.pop();
                          }
                        }),
                    child: Text(localizations.auth_signUp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () => context.pushReplacement('/${MoreScreen.route}/${SignInScreen.route}'),
                    child: Text(localizations.auth_signInPrompt_phrase),
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
