import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  final User user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _username;
  String? _email;

  @override
  void initState() {
    _username = widget.user.username;
    _email = widget.user.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text('${localizations.edit} (${localizations.profile})')),
      body: ResponsiveScrollView(
        child: Card(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextInput.icon(
                  onSaved: (String? value) {
                    if (value != null) _username = value;
                  },
                  label: localizations.username,
                  isMandatory: true,
                  iconData: Icons.short_text,
                  initialValue: _username,
                  validator:
                      (v) => (v != null && User.isValidUsername(v)) ? null : localizations.usernameRequirementsWarning,
                ),
                LoadingBuilder(
                  future: ref.watch(remoteConfigProvider.future),
                  builder: (context, remoteConfig) {
                    return EmailInput(
                      initialValue: _email,
                      onSaved: (String? value) => _email = value,
                      isMandatory: remoteConfig.hasEmailVerification,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ElevatedButton(
                    onPressed:
                        () => catchAsync(context, () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await ref
                                .read(userProvider.notifier)
                                .updateUser(user: widget.user.copyWith(username: _username, email: _email));

                            if (context.mounted) Navigator.of(context).pop();
                          }
                        }),
                    child: Text(localizations.save),
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
