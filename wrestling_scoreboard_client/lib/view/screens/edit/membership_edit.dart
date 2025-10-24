import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/person_edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class MembershipEdit extends ConsumerStatefulWidget {
  final Membership? membership;
  final Club? initialClub;
  final Organization initialOrganization;
  final Person? initialPerson;

  const MembershipEdit({
    this.membership,
    this.initialClub,
    this.initialPerson,
    required this.initialOrganization,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MembershipEditState();
}

class MembershipEditState extends ConsumerState<MembershipEdit> {
  final _formKey = GlobalKey<FormState>();

  Iterable<Club>? _availableClubs;
  Iterable<Person>? _availablePersons;
  Club? _club;
  Person? _person;

  @override
  void initState() {
    super.initState();
    _club = widget.membership?.club ?? widget.initialClub;
    _person = widget.membership?.person ?? widget.initialPerson;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.person),
          selectedItem: _person,
          label: localizations.person,
          context: context,
          allowEmpty: false,
          onSaved:
              (Person? value) => setState(() {
                _person = value;
              }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(
              dataManagerProvider,
            )).readMany<Person, Organization>(filterObject: widget.initialOrganization);
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Club>(
          icon: const Icon(Icons.foundation),
          selectedItem: _club,
          label: localizations.club,
          context: context,
          allowEmpty: false,
          onSaved:
              (Club? value) => setState(() {
                _club = value;
              }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableClubs ??= await (await ref.read(
              dataManagerProvider,
            )).readMany<Club, Organization>(filterObject: widget.initialOrganization);
            return _availableClubs!.toList();
          },
        ),
      ),
    ];
    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: '${localizations.membership} (${localizations.club})',
        id: widget.membership?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await (await ref.read(
        dataManagerProvider,
      )).createOrUpdateSingle(Membership(id: widget.membership?.id, person: _person!, club: _club!));
      navigator.pop();
    }
  }
}

class MembershipPersonEdit extends AbstractPersonEdit {
  final Membership? membership;
  final Club? initialClub;
  final Person? initialPerson;

  MembershipPersonEdit({this.membership, this.initialClub, this.initialPerson, super.onCreated, super.key})
    : super(person: membership?.person ?? initialPerson, initialOrganization: initialClub?.organization);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MembershipPersonEditState();
}

class MembershipPersonEditState extends AbstractPersonEditState<MembershipPersonEdit> {
  Iterable<Club>? _availableClubs;
  String? _no;
  Club? _club;

  @override
  void initState() {
    super.initState();
    _club = widget.membership?.club ?? widget.initialClub;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    return buildEdit(
      context,
      id: widget.membership?.id,
      classLocale: localizations.membership,
      fields: [
        CustomTextInput(
          iconData: Icons.tag,
          label: localizations.membershipNumber,
          initialValue: widget.membership?.no,
          isMandatory: false,
          onSaved: (value) => _no = value,
        ),
        ListTile(
          title: SearchableDropdown<Club>(
            icon: const Icon(Icons.foundation),
            selectedItem: _club,
            label: localizations.club,
            context: context,
            onSaved:
                (Club? value) => setState(() {
                  _club = value;
                }),
            itemAsString: (u) => u.name,
            asyncItems: (String filter) async {
              _availableClubs ??= await (await ref.read(dataManagerProvider)).readMany<Club, Null>();
              return _availableClubs!.toList();
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<void> handleNested(person) async {
    var membership = Membership(id: widget.membership?.id, person: person, club: _club!, no: _no);
    membership = membership.copyWithId(await (await ref.read(dataManagerProvider)).createOrUpdateSingle(membership));
  }
}
