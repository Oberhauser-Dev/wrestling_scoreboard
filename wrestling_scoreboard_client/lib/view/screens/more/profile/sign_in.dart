import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_in_password.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_up.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/user_verification.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const route = 'sign-in';

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _username;

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
                CustomTextInput(
                  onSaved: (String? value) => _username = value,
                  isMandatory: true,
                  label: localizations.username,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed:
                        () => catchAsync(context, () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPasswordScreen(username: _username!)),
                            );
                            if (context.mounted) context.pop();
                          }
                        }),
                    child: Text(localizations.auth_signIn),
                  ),
                ),
                LoadingBuilder(
                  future: ref.watch(remoteConfigProvider.future),
                  builder: (context, remoteConfig) {
                    if (!remoteConfig.hasEmailVerification) return SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap:
                            () => catchAsync(context, () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await (await ref.read(
                                  dataManagerProvider,
                                )).requestVerificationCode(username: _username!);
                                if (!context.mounted) return;
                                await showOkDialog(
                                  context: context,
                                  child: Text(localizations.auth_verificationCodeSend_confirmation),
                                );
                                if (context.mounted) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserVerificationScreen(username: _username!),
                                    ),
                                  );
                                  if (context.mounted) context.pop();
                                }
                              }
                            }),
                        child: Text(localizations.auth_forgotPassword),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: InkWell(
                    onTap: () => context.pushReplacement('/${MoreScreen.route}/${SignUpScreen.route}'),
                    child: Text(localizations.auth_signUpPrompt_phrase),
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
