import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';
import 'package:wrestling_scoreboard_client/localization/season.dart';
import 'package:wrestling_scoreboard_client/provider/data_provider.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/utils/provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_client/view/widgets/toggle_buttons.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class TeamMatchEdit extends ConsumerStatefulWidget {
  final TeamMatch? teamMatch;
  final Team? initialHomeTeam;
  final Team? initialGuestTeam;
  final League? initialLeague;
  final Organization? initialOrganization;

  const TeamMatchEdit({
    this.teamMatch,
    this.initialHomeTeam,
    this.initialGuestTeam,
    this.initialLeague,
    this.initialOrganization,
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
  int? _visitorsCount;
  String? _comment;

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
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      CustomTextInput(
        iconData: Icons.tag,
        label: localizations.matchNumber,
        initialValue: widget.teamMatch?.no,
        isMandatory: false,
        onSaved: (value) => _no = value,
      ),
      CustomTextInput(
        iconData: Icons.place,
        label: localizations.place,
        initialValue: widget.teamMatch?.location,
        isMandatory: false,
        onSaved: (value) => _location = value,
      ),
      ListTile(
        leading: const Icon(Icons.date_range),
        title: TextFormField(
          key: ValueKey(_date),
          readOnly: true,
          decoration: CustomInputDecoration(isMandatory: true, label: localizations.date, localizations: localizations),
          onTap:
              () => showDatePicker(
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
          onSaved:
              (Team? value) => setState(() {
                _homeTeam = value;
              }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async => await _getTeams(),
        ),
      ),
      ListTile(
        title: SearchableDropdown<Team>(
          icon: const Icon(Icons.group),
          selectedItem: _guestTeam,
          label: '${localizations.team} ${localizations.blue}',
          context: context,
          onSaved:
              (Team? value) => setState(() {
                _guestTeam = value;
              }),
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async => await _getTeams(),
        ),
      ),
      NumericalInput(
        iconData: Icons.confirmation_number,
        initialValue: widget.teamMatch?.visitorsCount,
        label: localizations.visitors,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 9223372036854775808),
        isMandatory: false,
        onSaved: (int? value) => _visitorsCount = value,
      ),
      CustomTextInput(
        iconData: Icons.comment,
        label: localizations.comment,
        initialValue: widget.teamMatch?.comment,
        isMandatory: false,
        onSaved: (value) => _comment = value,
      ),
      ListTile(
        title: SearchableDropdown<League>(
          icon: const Icon(Icons.emoji_events),
          selectedItem: _league,
          label: localizations.league,
          context: context,
          onSaved:
              (League? value) => setState(() {
                _league = value;
              }),
          onChanged: (value) {
            _league = value;
            setState(() {
              _availableTeams = null;
            });
          },
          // Reset team list, if league changes
          itemAsString: (u) => u.name,
          asyncItems: (String filter) async {
            _availableLeagues ??= await (await ref.read(
              dataManagerProvider,
            )).readMany<League, Organization>(filterObject: widget.initialOrganization);
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

  Future<List<Team>> _getTeams() async {
    if (_availableTeams == null && _league != null) {
      _availableTeams =
          (await ref.readAsync(
            manyDataStreamProvider(ManyProviderData<LeagueTeamParticipation, League>(filterObject: _league)).future,
          )).map((e) => e.team).toList();
    }
    return _availableTeams ?? [];
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var home = widget.teamMatch?.home;
      if (home == null) {
        final homeId = await (await ref.read(dataManagerProvider)).createOrUpdateSingle(TeamLineup(team: _homeTeam!));
        home = TeamLineup(id: homeId, team: _homeTeam!); // TODO check if it works without refetching the objects
      } else if (home.team != _homeTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await (await ref.read(dataManagerProvider)).createOrUpdateSingle(TeamLineup(id: home.id, team: _homeTeam!));
      }

      var guest = widget.teamMatch?.guest;
      if (guest == null) {
        final guestId = await (await ref.read(dataManagerProvider)).createOrUpdateSingle(TeamLineup(team: _guestTeam!));
        guest = TeamLineup(id: guestId, team: _guestTeam!); // TODO check if it works without refetching the objects
      } else if (guest.team != _guestTeam) {
        // Update Lineup team only, no need to replace whole lineup
        await (await ref.read(dataManagerProvider)).createOrUpdateSingle(TeamLineup(id: guest.id, team: _guestTeam!));
      }

      await (await ref.read(dataManagerProvider)).createOrUpdateSingle(
        TeamMatch(
          id: widget.teamMatch?.id,
          organization:
              widget.teamMatch?.organization ?? widget.initialLeague?.organization ?? widget.initialOrganization,
          orgSyncId: widget.teamMatch?.orgSyncId,
          location: _location!,
          no: _no,
          home: home,
          guest: guest,
          date: _date,
          league: _league,
          seasonPartition: _seasonPartition,
          comment: _comment,
          visitorsCount: _visitorsCount,
        ),
      );
      navigator.pop();
    }
  }
}
