import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/services/print/pdf/competition_certificate.dart';
import 'package:wrestling_scoreboard_client/view/screens/overview/competition/competition_overview.dart';
import 'package:wrestling_scoreboard_client/view/widgets/document_editor.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/form.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

class CompetitionEdit extends ConsumerStatefulWidget {
  final Competition? competition;
  final Organization? initialOrganization;

  const CompetitionEdit({this.competition, this.initialOrganization, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => CompetitionEditState();
}

class CompetitionEditState extends ConsumerState<CompetitionEdit> {
  final _formKey = GlobalKey<FormState>();

  String? _location;
  String? _no;
  late DateTime _startDate;
  DateTime? _endDate;
  String? _comment;
  String? _name;
  int? _visitorsCount;
  int? _matCount;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _startDate = widget.competition?.date ?? DateTime.now();
    _endDate = widget.competition?.endDate;
    _comment = widget.competition?.comment;
    _location = widget.competition?.location;
    _name = widget.competition?.name;
    _no = widget.competition?.no;
    _matCount = widget.competition?.matCount;
    _visitorsCount = widget.competition?.visitorsCount;
    _comment = widget.competition?.comment;

    final certificateJson = widget.competition?.certificateTemplate;
    _quillController = QuillController.basic();
    if (certificateJson != null) {
      _quillController.document = Document.fromJson(jsonDecode(certificateJson));
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final quillText = _quillController.document.toPlainText().trim();
    final items = [
      CustomTextInput.icon(
        onSaved: (String? value) => _name = value,
        label: localizations.name,
        isMandatory: true,
        iconData: Icons.short_text,
        initialValue: _name,
      ),
      CustomTextInput.icon(
        iconData: Icons.tag,
        label: localizations.competitionNumber,
        initialValue: _no,
        isMandatory: false,
        onSaved: (value) => _no = value,
      ),
      CustomTextInput.icon(
        onSaved: (String? value) => _location = value,
        label: localizations.place,
        isMandatory: true,
        iconData: Icons.place,
        initialValue: _location,
      ),
      DateTimeInput(
        iconData: Icons.event,
        label: localizations.startDate,
        initialValue: _startDate,
        isMandatory: true,
        minValue: DateTime.now().subtract(const Duration(days: 365 * 5)),
        maxValue: DateTime.now().add(const Duration(days: 365 * 3)),
        onSaved: (newValue) {
          if (newValue != null) {
            _startDate = newValue;
          }
        },
      ),
      DateTimeInput(
        iconData: Icons.event,
        label: localizations.endDate,
        initialValue: _endDate,
        isMandatory: false,
        minValue: DateTime.now().subtract(const Duration(days: 365 * 5)),
        maxValue: DateTime.now().add(const Duration(days: 365 * 3)),
        onSaved: (newValue) => _endDate = newValue,
      ),
      NumericalInput(
        iconData: Icons.adjust,
        // Replace with square_dot
        initialValue: _matCount,
        label: localizations.mats,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 1000),
        isMandatory: true,
        onSaved: (int? value) => _matCount = value,
      ),
      NumericalInput(
        iconData: Icons.confirmation_number,
        initialValue: _visitorsCount,
        label: localizations.visitors,
        inputFormatter: NumericalRangeFormatter(min: 1, max: 9223372036854775808),
        isMandatory: false,
        onSaved: (int? value) => _visitorsCount = value,
      ),
      CustomTextInput.icon(
        iconData: Icons.comment,
        label: localizations.comment,
        initialValue: _comment,
        isMandatory: false,
        onSaved: (value) => _comment = value,
      ),
      ExpansionTile(
        // TODO: replace with Icons.contract
        leading: Icon(Icons.description),
        trailing: IconButton(
          onPressed: () async {
            final competition = _buildCompetition();
            final competitionCertificate = CompetitionCertificate(
              buildContext: context,
              competition: competition,
              deltaAsJson: jsonEncode(_quillController.document.toDelta().toJson()),
            );
            final bytes = await competitionCertificate.buildPdf();
            await Printing.sharePdf(bytes: bytes, filename: '${competition.fileBaseName}-Certificate-Template.pdf');
          },
          icon: Icon(Icons.print),
        ),
        title: Text(quillText.substring(0, math.min(100, quillText.length)).split('\n').first),
        subtitle: Text(localizations.certificate),
        children: [DocumentEditor(quillController: _quillController)],
      ),
    ];

    return Form(
      key: _formKey,
      child: EditWidget(
        typeLocalization: localizations.competition,
        id: widget.competition?.id,
        onSubmit: () => handleSubmit(navigator),
        items: items,
      ),
    );
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BoutConfig? boutConfig = widget.competition?.boutConfig;
      if (boutConfig == null) {
        boutConfig = Competition.defaultBoutConfig;
        boutConfig = boutConfig.copyWithId(
          await (await ref.read(dataManagerProvider)).createOrUpdateSingle(boutConfig),
        );
      }
      final String certificateJson = jsonEncode(_quillController.document.toDelta().toJson());
      await (await ref.read(
        dataManagerProvider,
      )).createOrUpdateSingle(_buildCompetition(boutConfig: boutConfig, certificateJson: certificateJson));
      navigator.pop();
    }
  }

  Competition _buildCompetition({BoutConfig? boutConfig, String? certificateJson}) {
    return Competition(
      id: widget.competition?.id,
      organization: widget.competition?.organization ?? widget.initialOrganization,
      orgSyncId: widget.competition?.orgSyncId,
      location: _location!,
      no: _no,
      date: _startDate,
      endDate: _endDate,
      comment: _comment,
      name: _name!,
      boutConfig: boutConfig ?? Competition.defaultBoutConfig,
      visitorsCount: _visitorsCount,
      matCount: _matCount!,
      certificateTemplate: certificateJson,
    );
  }
}
