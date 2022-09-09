import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class SelectedDayPage extends StatefulWidget {
  final String selDay;
  const SelectedDayPage({Key? key, required this.selDay}) : super(key: key);


  @override
  State<SelectedDayPage> createState() => _SelectedDayPageState();
}

class _SelectedDayPageState extends State<SelectedDayPage> {


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selDay),
      ),
    );
  }


}