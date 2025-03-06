import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wrestling_scoreboard_client/localization/build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
import 'package:wrestling_scoreboard_client/view/widgets/dropdown.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/widgets/formatter.dart';
import 'package:wrestling_scoreboard_common/common.dart';

abstract class WeightClassEdit extends ConsumerStatefulWidget {
  final WeightClass? weightClass;

  const WeightClassEdit({this.weightClass, super.key});
}

abstract class WeightClassEditState<T extends WeightClassEdit> extends ConsumerState<T>
    implements AbstractEditState<WeightClass> {
  final _formKey = GlobalKey<FormState>();

  String? _suffix;
  var _weight = 0;
  late WrestlingStyle _wrestlingStyle;
  late WeightUnit _unit;

  @override
  void initState() {
    super.initState();
    _wrestlingStyle = widget.weightClass?.style ?? WrestlingStyle.free;
    _unit = widget.weightClass?.unit ?? WeightUnit.kilogram;
  }

  @override
  Widget buildEdit(
    BuildContext context, {
    required String classLocale,
    required int? id,
    required List<Widget> fields,
  }) {
    final localizations = context.l10n;
    final navigator = Navigator.of(context);

    final items = [
      ...fields,
      ListTile(
        leading: const Icon(Icons.fitness_center),
        title: TextFormField(
          initialValue: widget.weightClass?.weight.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            labelText: localizations.weight,
          ),
          inputFormatters: <TextInputFormatter>[NumericalRangeFormatter(min: 1, max: 1000)],
          onSaved: (String? value) {
            _weight = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.style),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WrestlingStyle>(
            hint: localizations.wrestlingStyle,
            isExpanded: true,
            options: WrestlingStyle.values.map((WrestlingStyle style) {
              return MapEntry(
                style,
                Text('${style.localize(context)} (${style.abbreviation(context)})'),
              );
            }),
            selected: _wrestlingStyle,
            onChange: (newValue) => setState(() {
              _wrestlingStyle = newValue!;
            }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.straighten),
        title: ButtonTheme(
          alignedDropdown: true,
          child: SimpleDropdown<WeightUnit>(
            hint: localizations.weightUnit,
            isExpanded: true,
            options: WeightUnit.values.map((WeightUnit value) {
              return MapEntry(value, Text(value.toAbbr()));
            }),
            selected: _unit,
            onChange: (newValue) => setState(() {
              _unit = newValue!;
            }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.description),
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.suffix,
            hintText: localizations.optional,
          ),
          initialValue: widget.weightClass?.suffix ?? '',
          onSaved: (newValue) => _suffix = newValue,
        ),
      ),
    ];

    return Form(
        key: _formKey,
        child: EditWidget(
            typeLocalization: classLocale,
            id: widget.weightClass?.id,
            onSubmit: () => handleSubmit(navigator),
            items: items));
  }

  Future<void> handleSubmit(NavigatorState navigator) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var weightClass = WeightClass(
          id: widget.weightClass?.id, suffix: _suffix!, weight: _weight, style: _wrestlingStyle, unit: _unit);
      weightClass =
          weightClass.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(weightClass));
      await handleNested(weightClass);
      navigator.pop();
    }
  }
}
