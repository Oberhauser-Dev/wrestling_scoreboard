import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/loading_builder.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class UserEdit extends ConsumerStatefulWidget {
  final SecuredUser? user;
  final Future<void> Function(SecuredUser user)? onCreated;

  const UserEdit({this.user, this.onCreated, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserEditState();
}

class UserEditState extends ConsumerState<UserEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _username;
  String? _email;
  late UserPrivilege _userPrivilege;
  Person? _person;
  String? _password;

  @override
  void initState() {
    _username = widget.user?.username;
    _email = widget.user?.email;
    _person = widget.user?.person;
    _userPrivilege = widget.user?.privilege ?? UserPrivilege.none;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput.icon(
        onSaved: (String? value) => _username = value,
        label: localizations.username,
        isMandatory: true,
        iconData: Icons.short_text,
        initialValue: _username,
        validator: (v) => (v != null && User.isValidUsername(v)) ? null : localizations.usernameRequirementsWarning,
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
      if (widget.user?.id == null)
        PasswordInput(isMandatory: true, onSaved: (String? value) => _password = value, isNewPassword: true),
      ListTile(
        leading: const Icon(Icons.key),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<UserPrivilege>(
            isNullable: false,
            label: localizations.privilege,
            isExpanded: true,
            options: UserPrivilege.values.map((value) => MapEntry(value, Text(value.name))),
            selected: _userPrivilege,
            onSaved: (newValue) => _userPrivilege = newValue!,
          ),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.user,
        id: widget.user?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SecuredUser securedUser;
      if (widget.user?.id == null) {
        // Create a new user, incl. password
        final user = User(
          username: _username!,
          createdAt: widget.user?.createdAt ?? DateTime.now(),
          email: _email,
          privilege: _userPrivilege,
          person: _person,
          password: _password,
        );
        securedUser = user.toSecuredUser().copyWithId(
          await (await ref.read(dataManagerProvider)).createOrUpdateSingle(user),
        );
      } else {
        securedUser = widget.user!.copyWith(
          username: _username!,
          email: _email,
          privilege: _userPrivilege,
          person: _person,
          // Disallow changing the password of already existing users (for now). One should delete and recreate an account in such edge cases.
        );
        securedUser = widget.user!.copyWithId(
          await (await ref.read(dataManagerProvider)).createOrUpdateSingle(securedUser),
        );
      }

      if (widget.onCreated != null) {
        await widget.onCreated!(securedUser);
      }
      navigator.pop();
    }
  }
}
