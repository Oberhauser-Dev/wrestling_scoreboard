import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/home/more.dart';
import 'package:wrestling_scoreboard_client/view/screens/more/profile/sign_up.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
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
  String? _password;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
              PasswordInput(
                onSaved: (String? value) => _password = value,
                isNewPassword: false,
                // Do not make mandatory, as first login is with password 'admin', which does not fulfill the requirements.
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => catchAsync(context, () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await ref.read(userNotifierProvider.notifier).signIn(username: _username!, password: _password!);
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  }),
                  child: Text(localizations.auth_signIn),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: InkWell(
                  onTap: () => context.push('/${MoreScreen.route}/${SignUpScreen.route}'),
                  child: Text(localizations.auth_signUpPrompt_phrase),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
