import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final bool includeTime;
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateTimeChanged;
  final String title;

  const DateTimePickerWidget({
    super.key,
    this.includeTime = false,
    this.initialDate,
    required this.onDateTimeChanged,
    this.title = "",
  });

  @override
  DateTimePickerWidgetState createState() => DateTimePickerWidgetState();
}

class DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.includeTime && widget.initialDate != null) {
      _selectedTime = TimeOfDay.fromDateTime(widget.initialDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null ) {
      setState(() {
        _selectedDate = picked;
        widget.onDateTimeChanged(_selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        final DateTime newDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          picked.hour,
          picked.minute,
        );
        widget.onDateTimeChanged(newDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        datePicker(context),
        if (widget.includeTime)
          SizedBox(width: 20,),
          timePicker(context),
      ],
    );
  }

  Expanded datePicker(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: '${widget.title} Date',
              border: OutlineInputBorder(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_selectedDate!.toLocal()}".split(' ')[0],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      );
  }

  Expanded timePicker(BuildContext context) {
    return Expanded(
          child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
          decoration: InputDecoration(
            labelText: '${widget.title} Time',
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedTime?.format(context) ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Icon(Icons.access_time),
            ],
          ),
                      ),
                    ),
        );
  }
}
