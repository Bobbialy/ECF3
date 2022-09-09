import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../screens/selecteddaypage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class MyCal extends StatefulWidget {
  const MyCal({Key? key}) : super(key: key);

  @override
  State<MyCal> createState() => _MyCalState();
}

class _MyCalState extends State<MyCal> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String formattedDate = '';


  @override
  Widget build(BuildContext context) {
    return Center(
        child: TableCalendar(
        locale: 'fr_FR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,

        availableCalendarFormats: const {
          CalendarFormat.month: 'Mois',
          CalendarFormat.week: 'Semaine',
          CalendarFormat.twoWeeks: 'Deux Semaines'
        },

        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          // Need to store day info somewhere to get them back on the other side
          formatTheDate(_selectedDay, () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectedDayPage(selDay: formattedDate))
            )
          });

        },

        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },

        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },

      )
    );
  }

  formatTheDate(date, cb) {
    initializeDateFormatting('fr-FR', '').then((_) => setState(() => formattedDate = DateFormat.yMMMMEEEEd('fr-FR').format(DateTime.parse(date.toString()))));
    cb();
  }
}




/*class MyCal extends StatelessWidget {
  const MyCal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TableCalendar(
        locale: 'fr_FR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),

      ),
    );
  }
}*/
