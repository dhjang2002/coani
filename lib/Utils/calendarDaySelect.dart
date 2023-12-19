
// ignore_for_file: file_names, must_be_immutable
import 'package:coani/Utils/buttonSingle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDaySelect extends StatefulWidget {
  String? seletedDay;
  CalendarDaySelect({
    Key? key,
    this.seletedDay,
  }) : super(key: key);

  @override
  State<CalendarDaySelect> createState() => _CalendarDaySelectState();
}

class _CalendarDaySelectState extends State<CalendarDaySelect> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _today = DateTime.now();
  DateTime  _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _bDirty = false;
  bool _btnEnable = false;

  String _dateText = "";

  void _validate() {
    setState((){
      _btnEnable = (_bDirty && _dateText.isNotEmpty);
    });
  }

  @override
  void initState() {
    if(widget.seletedDay != null && widget.seletedDay!.isNotEmpty) {
      _selectedDay = DateFormat('yyyy-MM-dd').parse(widget.seletedDay!);
      _focusedDay = _selectedDay!;
    }
    setState((){
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("날짜 선택"),
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: true,
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 32,
                ),
                onPressed: () async {
                  _doClose();
                }),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [

          // content
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left:5, right: 5, top: 10),
                    child: TableCalendar(
                      locale: 'ko-KR',
                      rowHeight:80,
                      firstDay: DateTime.utc(_today.year-30, _today.month, _today.day),
                      lastDay:  DateTime.now(),
                      focusedDay: _focusedDay,
                      headerVisible: true,
                      calendarFormat: _calendarFormat,
                      pageJumpingEnabled:true,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: const TextStyle().copyWith(color: Colors.red),
                        holidayTextStyle: const TextStyle().copyWith(color: Colors.blue[800]),
                        selectedDecoration : const BoxDecoration(color: Color(0xFFF6C443), shape: BoxShape.circle),
                        todayDecoration : const BoxDecoration(color: Color(0xFF1A4C97), shape: BoxShape.circle,),
                      ),

                      headerStyle: const HeaderStyle(
                        //headerMargin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.arrow_left),
                        rightChevronIcon: Icon(Icons.arrow_right),
                        titleTextStyle: TextStyle(fontSize: 18.0),
                      ),

                      selectedDayPredicate: (day) { return isSameDay(_selectedDay, day);},
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _bDirty = true;
                          _selectedDay = selectedDay;
                          _focusedDay  = focusedDay;
                          _dateText = "${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}";
                        });
                        _validate();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ButtonSingle(
                    text: '확인',
                    enable: _btnEnable,
                    visible: true,
                    onClick: () {
                      Navigator.pop(context, _dateText);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _doClose() {
    Navigator.pop(context, "");
  }
}
