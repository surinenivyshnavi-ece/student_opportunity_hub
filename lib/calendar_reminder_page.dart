import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/notification_service.dart';

class CalendarReminderPage extends StatefulWidget {
  const CalendarReminderPage({super.key});

  @override
  State<CalendarReminderPage> createState() => _CalendarReminderPageState();
}

class _CalendarReminderPageState extends State<CalendarReminderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _reminders = {};
  TimeOfDay _selectedTime = TimeOfDay.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadReminders();
  }

  Future<void> _addReminder() async {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Reminder"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter reminder",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {

                debugPrint("Save button pressed");

                if (controller.text.isEmpty) return;

                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );

                if (pickedTime == null) return;

                debugPrint("Time selected: ${pickedTime.format(context)}");

                _selectedTime = pickedTime;

                final date = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );

                setState(() {
                  _reminders.putIfAbsent(date, () => []);
                  _reminders[date]!.add(
                    "${controller.text} (${pickedTime.format(context)})",
                  );
                });
                await _firestore
                    .collection("users")
                    .doc(uid)
                    .collection("reminders")
                    .add({
                  "title": controller.text,
                  "date": date.toIso8601String(),
                  "time": pickedTime.format(context),
                  "createdAt": FieldValue.serverTimestamp(),
                });
                debugPrint("Calling scheduleReminder()");

                await NotificationService().scheduleReminder(
                  title: controller.text,
                  body: "Your reminder is due now",
                  dateTime: DateTime(
                    date.year,
                    date.month,
                    date.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );
                await NotificationService().scheduleReminder(
                  title: controller.text,
                  body: "Your reminder is due now",
                  dateTime: DateTime(
                    date.year,
                    date.month,
                    date.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  Future<void> _loadReminders() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("reminders")
        .get();

    Map<DateTime, List<String>> loadedReminders = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();

      DateTime date = DateTime.parse(data["date"]);

      DateTime onlyDate = DateTime(
        date.year,
        date.month,
        date.day,
      );

      loadedReminders.putIfAbsent(onlyDate, () => []);

      loadedReminders[onlyDate]!.add(
        "${data["title"]} (${data["time"]})",
      );
    }

    setState(() {
      _reminders.clear();
      _reminders.addAll(loadedReminders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Reminder"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2035, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Builder(
              builder: (context) {
                final date = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );

                final reminders = _reminders[date] ?? [];

                if (reminders.isEmpty) {
                  return const Center(
                    child: Text(
                      "No reminders",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(reminders[index]),
                    );
                  },
                );
              },
            ),
          )

        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}