import 'package:flutter/material.dart';
import 'package:wrestling_scoreboard_client/localization/date_time.dart';

class DateFormField extends FormField<DateTime> {
  final DateTime? minValue;
  final DateTime? maxValue;
  final void Function(DateTime?)? onChange;
  final InputDecoration? decoration;
  final bool readOnly;
  final DatePickerMode? initialDatePickerMode;

  DateFormField({
    super.key,
    super.initialValue,
    this.minValue,
    this.maxValue,
    this.onChange,
    super.onSaved,
    this.decoration,
    this.readOnly = false,
    this.initialDatePickerMode,
  }) : super(
         builder: (FormFieldState<DateTime?> state) {
           return DatePicker(
             initialValue: initialValue,
             minValue: minValue,
             maxValue: maxValue,
             onChange: (DateTime? dateTime) {
               state.didChange(dateTime);
               if (onChange != null) {
                 onChange(dateTime);
               }
             },
             decoration: decoration,
             initialDatePickerMode: initialDatePickerMode,
           );
         },
       );
}

class DateTimeFormField extends FormField<DateTime> {
  final DateTime? minValue;
  final DateTime? maxValue;
  final void Function(DateTime?)? onChange;
  final InputDecoration? decoration;
  final bool readOnly;
  final DatePickerMode? initialDatePickerMode;

  DateTimeFormField({
    super.key,
    super.initialValue,
    this.minValue,
    this.maxValue,
    this.onChange,
    super.onSaved,
    this.decoration,
    this.readOnly = false,
    this.initialDatePickerMode,
  }) : super(
         builder: (FormFieldState<DateTime?> state) {
           return Row(
             children: [
               Expanded(
                 child: DatePicker(
                   initialValue: initialValue,
                   minValue: minValue,
                   maxValue: maxValue,
                   onChange: (DateTime? dateTime) {
                     dateTime = dateTime?.copyWith(
                       hour: state.value?.hour,
                       minute: state.value?.minute,
                       second: state.value?.second,
                       millisecond: state.value?.millisecond,
                     );
                     state.didChange(dateTime);
                     if (onChange != null) {
                       onChange(dateTime);
                     }
                   },
                   decoration: decoration,
                   initialDatePickerMode: initialDatePickerMode,
                 ),
               ),
               Expanded(
                 child: TimePicker(
                   initialValue: initialValue == null ? null : TimeOfDay.fromDateTime(initialValue),
                   onChange: (TimeOfDay? timeOfDay) {
                     final dateTime = state.value?.copyWith(hour: timeOfDay?.hour, minute: timeOfDay?.minute);
                     state.didChange(dateTime);
                     if (onChange != null) {
                       onChange(dateTime);
                     }
                   },
                   decoration: decoration,
                 ),
               ),
             ],
           );
         },
       );
}

class DatePicker extends StatefulWidget {
  final DateTime? initialValue;
  final DateTime? minValue;
  final DateTime? maxValue;
  final void Function(DateTime?)? onChange;
  final InputDecoration? decoration;
  final DatePickerMode? initialDatePickerMode;

  const DatePicker({
    super.key,
    required this.initialValue,
    this.minValue,
    this.maxValue,
    required this.onChange,
    this.decoration,
    this.initialDatePickerMode,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime? _date;

  @override
  void initState() {
    _date = widget.initialValue;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _textEditingController.text = _date?.toDateString(context) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      readOnly: true,
      decoration: (widget.decoration ?? InputDecoration()).copyWith(
        suffixIcon:
            widget.onChange == null
                ? null
                : IconButton(
                  onPressed: () {
                    _date = null;
                    widget.onChange!(null);
                    _textEditingController.text = '';
                  },
                  icon: const Icon(Icons.close),
                ),
      ),
      onTap: () async {
        final value = await showDatePicker(
          initialDatePickerMode: widget.initialDatePickerMode ?? DatePickerMode.day,
          context: context,
          initialDate: _date,
          firstDate: widget.minValue ?? DateTime.now().subtract(const Duration(days: 365 * 100)),
          lastDate: widget.maxValue ?? DateTime.now().add(const Duration(days: 365 * 3)),
        );
        if (widget.onChange != null && value != null) {
          _date = value;
          widget.onChange!(value);
          if (context.mounted) {
            _textEditingController.text = _date?.toDateString(context) ?? '';
          }
        }
      },
    );
  }
}

class TimePicker extends StatefulWidget {
  final TimeOfDay? initialValue;
  final void Function(TimeOfDay?)? onChange;
  final InputDecoration? decoration;

  const TimePicker({super.key, required this.initialValue, required this.onChange, this.decoration});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  final TextEditingController _textEditingController = TextEditingController();
  TimeOfDay? _time;

  @override
  void initState() {
    _time = widget.initialValue;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _textEditingController.text = _toDateTime(_time)?.toTimeString(context) ?? '';
    });
  }

  DateTime? _toDateTime(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return null;
    return DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      readOnly: true,
      decoration: (widget.decoration ?? InputDecoration()).copyWith(
        suffixIcon:
            widget.onChange == null
                ? null
                : IconButton(
                  onPressed: () {
                    _time = null;
                    widget.onChange!(null);
                    _textEditingController.text = '';
                  },
                  icon: Icon(Icons.close),
                ),
      ),
      onTap: () async {
        final value = await showTimePicker(context: context, initialTime: _time ?? TimeOfDay.now());
        if (widget.onChange != null && value != null) {
          _time = value;
          widget.onChange!(value);
          if (context.mounted) {
            _textEditingController.text = _toDateTime(_time)?.toTimeString(context) ?? '';
          }
        }
      },
    );
  }
}
