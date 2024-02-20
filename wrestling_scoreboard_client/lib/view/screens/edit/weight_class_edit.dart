import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrestling_scoreboard_client/localization/wrestling_style.dart';
import 'package:wrestling_scoreboard_client/provider/network_provider.dart';
import 'package:wrestling_scoreboard_client/view/widgets/edit.dart';
import 'package:wrestling_scoreboard_client/view/screens/edit/common.dart';
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
    final localizations = AppLocalizations.of(context)!;
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
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))],
          onSaved: (String? value) {
            _weight = int.tryParse(value ?? '') ?? 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.style),
        title: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<WrestlingStyle>(
            hint: Text(localizations.wrestlingStyle),
            isExpanded: true,
            items: WrestlingStyle.values.map((WrestlingStyle value) {
              return DropdownMenuItem<WrestlingStyle>(
                value: value,
                child: Text('${styleToString(value, context)} (${styleToAbbr(value, context)})'),
              );
            }).toList(),
            value: _wrestlingStyle,
            onChanged: (newValue) => setState(() {
              _wrestlingStyle = newValue!;
            }),
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.straighten),
        title: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<WeightUnit>(
            hint: Text(localizations.weightUnit),
            isExpanded: true,
            items: WeightUnit.values.map((WeightUnit value) {
              return DropdownMenuItem<WeightUnit>(
                value: value,
                child: Text(value.toAbbr()),
              );
            }).toList(),
            value: _unit,
            onChanged: (newValue) => setState(() {
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
      weightClass = weightClass.copyWithId(await (await ref.read(dataManagerNotifierProvider)).createOrUpdateSingle(weightClass));
      await handleNested(weightClass);
      navigator.pop();
    }
  }
}
