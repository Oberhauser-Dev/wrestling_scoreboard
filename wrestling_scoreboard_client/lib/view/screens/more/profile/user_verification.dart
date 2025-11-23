import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/account_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/card.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dialogs.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
import 'package:wrestling_scoreboard_client/view/widgets/responsive_container.dart';

class UserVerificationScreen extends ConsumerStatefulWidget {
  static const route = 'verification';
  final String username;
  final String? verificationCode;

  const UserVerificationScreen({super.key, required this.username, this.verificationCode});

  @override
  ConsumerState<UserVerificationScreen> createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends ConsumerState<UserVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _verificationCode;

  @override
  void initState() {
    _verificationCode = widget.verificationCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.auth_verfication)),
      body: ResponsiveScrollView(
        child: PaddedCard(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                ContentItem.icon(iconData: Icons.person, title: widget.username, subtitle: localizations.username),
                CustomTextInput.icon(
                  label: localizations.auth_verificationCode,
                  initialValue: _verificationCode,
                  onSaved: (String? value) => _verificationCode = value,
                  isMandatory: true,
                  inputFormatters: [UpperCaseTextFormatter()],
                  textCapitalization: TextCapitalization.characters,
                ),
                ElevatedButton(
                  onPressed:
                      () => catchAsync(context, () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          await ref
                              .read(userProvider.notifier)
                              .signInVerificationCode(username: widget.username, verificationCode: _verificationCode!);
                          if (!context.mounted) return;
                          await showOkDialog(
                            context: context,
                            child: Text(localizations.auth_verification_confirmation),
                          );
                          if (context.mounted) {
                            context.pop();
                          }
                        }
                      }),
                  child: Text(localizations.auth_verfication),
                ),
                InkWell(
                  onTap:
                      () => catchAsync(context, () async {
                        final user = await ref.read(userProvider);
                        if (user != null) {
                          await (await ref.read(dataManagerProvider)).requestVerificationCode(username: user.username);
                          if (!context.mounted) return;
                          await showOkDialog(
                            context: context,
                            child: Text(localizations.auth_verificationCodeSend_confirmation),
                          );
                        }
                      }),
                  child: Text(localizations.auth_verificationCodeSend),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
