import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/grouped_list.dart';
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
  List<Person>? _availablePersons;

  String? _location;
  String? _no;
  Team? _homeTeam;
  Team? _guestTeam;
  League? _league;
  int? _seasonPartition;
  late DateTime _date;
  String? _comment;

  // Persons
  Person? _referee;
  Person? _matChairman;
  Person? _judge;
  Person? _timeKeeper;
  Person? _transcriptWriter;

  @override
  void initState() {
    super.initState();
    _homeTeam = widget.teamMatch?.home.team ?? widget.initialHomeTeam;
    _guestTeam = widget.teamMatch?.guest.team ?? widget.initialGuestTeam;
    _date = widget.teamMatch?.date ?? DateTime.now();
    _comment = widget.teamMatch?.comment;
    _league = widget.teamMatch?.league ?? widget.initialLeague;
    // Set initial season partition to 0, if match has a league.
    _seasonPartition = widget.teamMatch?.seasonPartition ?? (_league != null ? 0 : null);

    // Persons
    _referee = widget.teamMatch?.referee;
    _matChairman = widget.teamMatch?.matChairman;
    _judge = widget.teamMatch?.judge;
    _timeKeeper = widget.teamMatch?.timeKeeper;
    _transcriptWriter = widget.teamMatch?.transcriptWriter;
    // TODO: steward from list
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
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
        title: SearchableDropdown<Team>(
          icon: const Icon(Icons.group),
          selectedItem: _homeTeam,
          label: '${localizations.team} ${localizations.red}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _homeTeam = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            // TODO: filter by teams of same league, but may add an option to search all teams, needs disableFilter option
            _availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return _availableTeams!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Team>(
          icon: const Icon(Icons.group),
          selectedItem: _guestTeam,
          label: '${localizations.team} ${localizations.blue}',
          context: context,
          onSaved: (Team? value) => setState(() {
            _guestTeam = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            // TODO: filter by teams of same league, but may add an option to search all teams
            _availableTeams ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Team, Null>();
            return _availableTeams!.toList();
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.comment),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.comment,
          ),
          initialValue: widget.teamMatch?.comment,
          onSaved: (newValue) => _comment = newValue,
        ),
      ),
      ListTile(
        title: SearchableDropdown<League>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _league,
          label: localizations.league,
          context: context,
          onSaved: (League? value) => setState(() {
            _league = value;
          }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableLeagues ??= await (await ref.read(dataManagerNotifierProvider)).readMany<League, Null>();
            return _availableLeagues!.toList();
          },
        ),
      ),
      if (_league != null && _league!.division.seasonPartitions > 1)
        ListTile(
          leading: const Icon(Icons.sunny_snowing),
          title: IndexedToggleButtons(
            label: localizations.seasonPartition,
            onPressed: (e) => setState(() => _seasonPartition = e),
            selected: _seasonPartition,
            numOptions: _league!.division.seasonPartitions,
            getTitle: (e) => e.asSeasonPartition(context, _league!.division.seasonPartitions),
          ),
        ),
      HeadingItem(title: localizations.persons),
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.sports),
          selectedItem: _referee,
          label: localizations.referee,
          context: context,
          onSaved: (Person? value) => setState(() {
            _referee = value;
          }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Null>();
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.manage_accounts),
          selectedItem: _matChairman,
          label: localizations.matChairman,
          context: context,
          onSaved: (Person? value) => setState(() {
            _matChairman = value;
          }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Null>();
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.manage_accounts),
          selectedItem: _judge,
          label: localizations.judge,
          context: context,
          onSaved: (Person? value) => setState(() {
            _judge = value;
          }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Null>();
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.pending_actions),
          selectedItem: _timeKeeper,
          label: localizations.timeKeeper,
          context: context,
          onSaved: (Person? value) => setState(() {
            _timeKeeper = value;
          }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Null>();
            return _availablePersons!.toList();
          },
        ),
      ),
      ListTile(
        title: SearchableDropdown<Person>(
          icon: const Icon(Icons.history_edu),
          selectedItem: _transcriptWriter,
          label: localizations.transcriptionWriter,
          context: context,
          onSaved: (Person? value) => setState(() {
            _transcriptWriter = value;
          }),
          itemAsString: (u) => u.fullName,
          asyncItems: (String filter) async {
            _availablePersons ??= await (await ref.read(dataManagerNotifierProvider)).readMany<Person, Null>();
            return _availablePersons!.toList();
          },
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
          organization: widget.teamMatch?.organization ?? widget.initialLeague?.organization,
          orgSyncId: widget.teamMatch?.orgSyncId,
          location: _location!,
          no: _no,
          home: home,
          guest: guest,
          date: _date,
          league: _league,
          seasonPartition: _seasonPartition,
          referee: _referee,
          matChairman: _matChairman,
          judge: _judge,
          timeKeeper: _timeKeeper,
          transcriptWriter: _transcriptWriter,
          comment: _comment,
        ),
      );
      navigator.pop();
    }
  }
}
