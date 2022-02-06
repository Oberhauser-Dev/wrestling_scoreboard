import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wrestling_scoreboard/data/wrestling_style.dart';
import 'package:wrestling_scoreboard/ui/components/edit.dart';
import 'package:wrestling_scoreboard/util/network/data_provider.dart';

class WeightClassEdit extends StatefulWidget {
  final WeightClass? weightClass;

  const WeightClassEdit({this.weightClass, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WeightClassEditState();
}

class WeightClassEditState extends State<WeightClassEdit> {
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
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final items = [
      ListTile(
        leading: const Icon(Icons.style),
        title: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<WrestlingStyle>(
            hint: Text(localizations.weight),
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
        title: TextFormField(
          initialValue: widget.weightClass?.weight.toString() ?? '',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              icon: const Icon(Icons.fitness_center),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
              labelText: AppLocalizations.of(context)!.weight),
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}'))],
          onSaved: (String? value) {
            _weight = value != null ? int.parse(value) : 0;
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.straighten),
        title:
        ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<WeightUnit>(
            hint: Text(localizations.weight),
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
        title: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: localizations.suffix,
            icon: const Icon(Icons.description),
          ),
          initialValue: widget.weightClass?.suffix ?? '',
          onSaved: (newValue) => _suffix = newValue,
        ),
      ),
    ];

    return Form(
        key: _formKey,
        child: EditWidget(
            title:
                '${widget.weightClass == null ? localizations.add : localizations.edit} ${localizations.weightClass}',
            onSubmit: () => handleSubmit(context),
            items: items));
  }

  void handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final weightClassId = await dataProvider.createOrUpdateSingle(WeightClass(
          id: widget.weightClass?.id, suffix: _suffix!, weight: _weight, style: _wrestlingStyle, unit: _unit));
      Navigator.of(context).pop();
    }
  }
}
