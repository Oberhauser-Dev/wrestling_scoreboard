import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/toggle_buttons.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchEdit extends ConsumerStatefulWidget {
  final TeamMatch? teamMatch;
  final Team? initialHomeTeam;
  final Team? initialGuestTeam;
  final League? initialLeague;

  const TeamMatchEdit({
    this.teamMatch,
    this.initialHomeTeam,
    this.initialGuestTeam,
    this.initialLeague,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeamMatchEditState();
}

class TeamMatchEditState extends ConsumerState<TeamMatchEdit> {
  final _formKey = GlobalKey<FormState>();

  List<League>? _availableLeagues;
  List<Team>? _availableTeams;

  String? _location;
  String? _no;
  Team? _homeTeam;
  Team? _guestTeam;
  League? _league;
  int? _seasonPartition;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _homeTeam = widget.teamMatch?.home.team ?? widget.initialHomeTeam;
    _guestTeam = widget.teamMatch?.guest.team ?? widget.initialGuestTeam;
    _date = widget.teamMatch?.date ?? DateTime.now();
    _league = widget.teamMatch?.league ?? widget.initialLeague;
    // Set initial season partition to 0, if match has a league.
    _seasonPartition = widget.teamMatch?.seasonPartition ?? (_league != null ? 0 : null);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    final items = [
      ListTile(
        leading: const Icon(Icons.tag),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.matchNumber,
          ),
          initialValue: widget.teamMatch?.no,
          onSaved: (newValue) => _no = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.place),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.place,
          ),
          initialValue: widget.teamMatch?.location,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return localizations.mandatoryField;
            }
            return null;
          },
          onSaved: (newValue) => _location = newValue,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_date),
          readOnly: true,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.date,
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
          icon: const Icon(Icons.group),
          selectedItem: _homeTeam,
          label: '${localizations.team} ${localizations.red}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _homeTeam = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            // TODO: filter by teams of same league, but may add an option to search all teams
            _availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return (filter == null
                    ? _availableTeams!
                    : _availableTeams!.where((element) => element.name.contains(filter)))
                .toList();
          },
        ),
      ),
      ListTile(
        title: getDropdown<Team>(
          icon: const Icon(Icons.group),
          selectedItem: _guestTeam,
          label: '${localizations.team} ${localizations.blue}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _guestTeam = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            // TODO: filter by teams of same league, but may add an option to search all teams
            _availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return (filter == null
                    ? _availableTeams!
                    : _availableTeams!.where((element) => element.name.contains(filter)))
                .toList();
          },
        ),
      ),
      ListTile(
        title: getDropdown<League>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _league,
          label: localizations.league,
          context: context,
          onSaved: (League? value) => setState(() {
            _league = value;
          }),
          itemAsString: (u) => u.name,
          onFind: (String? filter) async {
            _availableLeagues ??= await (await ref.read(dataManagerNotifierProvider)).readMany<League, Null>();
            return (filter == null
                    ? _availableLeagues!
                    : _availableLeagues!.where((element) => element.name.contains(filter)))
                .toList();
          },
        ),
      ),
      if (_league != null && _league!.seasonPartitions > 1)
        ListTile(
          leading: const Icon(Icons.sunny_snowing),
          title: IndexedToggleButtons(
            label: localizations.seasonPartition,
            onPressed: (e) => setState(() => _seasonPartition = e),
            selected: _seasonPartition,
            numOptions: _league!.seasonPartitions,
            getTitle: (e) => e.asSeasonPartition(context, _league!.seasonPartitions),
          ),
        ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.match,
        id: widget.teamMatch?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var home = widget.teamMatch?.home;
      if (home == null) {
        final homeId =
            await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Lineup(team: _homeTeam!));
        home = Lineup(id: homeId, team: _homeTeam!); // TODO check if it works without refetching the objects
      } else if (home.team != _homeTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Lineup(id: home.id, team: _homeTeam!));
      }

      var guest = widget.teamMatch?.guest;
      if (guest == null) {
        final guestId =
            await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(Lineup(team: _guestTeam!));
        guest = Lineup(id: guestId, team: _guestTeam!); // TODO check if it works without refetching the objects
      } else if (guest.team != _guestTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await (await ref.read(dataManagerNotifierProvider))
            .createOrUpdateSingle(Lineup(id: guest.id, team: _guestTeam!));
      }

      await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(
        TeamMatch(
          id: widget.teamMatch?.id,
          location: _location!,
          no: _no,
          home: home,
          guest: guest,
          date: _date,
          league: _league,
          seasonPartition: _seasonPartition,
        ),
      );
      navigator.pop();
    }
  }
}
