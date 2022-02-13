import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/ui/components/dropdown.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';
import 'package:wrestling_scoreboard/util/date_time.dart';

class TeamMatchEdit extends StatefulWidget {
  final TeamMatch? teamMatch;
  final Team? initialHomeTeam;
  final Team? initialGuestTeam;

  const TeamMatchEdit({this.teamMatch, this.initialHomeTeam, this.initialGuestTeam, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TeamMatchEditState();
}

class TeamMatchEditState extends State<TeamMatchEdit> {
  final _formKey = GlobalKey<FormState>();

  List<Team>? teams;

  String? _location;
  String? _no;
  Team? _homeTeam;
  Team? _guestTeam;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _homeTeam = widget.teamMatch?.home.team ?? widget.initialHomeTeam;
    _guestTeam = widget.teamMatch?.guest.team ?? widget.initialGuestTeam;
    _date = widget.teamMatch?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.matchNumber,
            icon: const Icon(Icons.tag),
          ),
          initialValue: widget.teamMatch?.no,
          onSaved: (newValue) => _no = newValue,
        ),
      ),
      ListTile(
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.place,
            icon: const Icon(Icons.place),
          ),
          initialValue: widget.teamMatch?.location,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
          },
          onSaved: (newValue) => _location = newValue,
        ),
      ),
      ListTile(
        title: TextFormField(
          key: ValueKey(_date),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
            icon: const Icon(Icons.date_range),
          ),
          onTap: () => showDatePicker(
            initialDatePickerMode: DatePickerMode.day,
            context: context,
            initialDate: _date,
            firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
            lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
          ).then((value) {
            if (value != null) {
              setState(() => _date = value);
            }
          }),
          initialValue: _date.toDateTimeString(context),
        ),
      ),
      ListTile(
        title: getDropdown<Team>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _homeTeam,
          label: '${localizations.team} ${localizations.red}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _homeTeam = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            teams ??= await dataProvider
                .readMany<Team>(); // TODO filter by teams of same league, but may add an option to search all teams
            return (filter == null ? teams! : teams!.where((element) => element.name.contains(filter))).toList();
          },
        ),
      ),
      ListTile(
        title: getDropdown<Team>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _guestTeam,
          label: '${localizations.team} ${localizations.blue}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _guestTeam = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            teams ??= await dataProvider
                .readMany<Team>(); // TODO filter by teams of same league, but may add an option to search all teams
            return (filter == null ? teams! : teams!.where((element) => element.name.contains(filter))).toList();
          },
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.match,
        id: widget.teamMatch?.id,
        onSubmit: () => handleSubmit(context),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var home = widget.teamMatch?.home;
      if (home == null) {
        final homeId = await dataProvider.createOrUpdateSingle(Lineup(team: _homeTeam!));
        home = Lineup(id: homeId, team: _homeTeam!); // TODO check if it works without refetching the objects
      } else if (home.team != _homeTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await dataProvider.createOrUpdateSingle(Lineup(id: home.id, team: _homeTeam!));
      }

      var guest = widget.teamMatch?.guest;
      if (guest == null) {
        final guestId = await dataProvider.createOrUpdateSingle(Lineup(team: _guestTeam!));
        guest = Lineup(id: guestId, team: _guestTeam!); // TODO check if it works without refetching the objects
      } else if (guest.team != _guestTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await dataProvider.createOrUpdateSingle(Lineup(id: guest.id, team: _guestTeam!));
      }

      await dataProvider.createOrUpdateSingle(
        TeamMatch(
          id: widget.teamMatch?.id,
          location: _location!,
          no: _no,
          home: home,
          guest: guest,
          date: _date,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
