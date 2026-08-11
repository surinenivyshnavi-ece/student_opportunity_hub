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

  final Map<DateTime, List<Map<String, dynamic>>> _reminders = {};

  TimeOfDay _selectedTime = TimeOfDay.now();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    _loadReminders();
  }

  // ============================================================
  // ADD REMINDER
  // ============================================================

  Future<void> _addReminder() async {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                debugPrint("Save button pressed");

                if (controller.text.trim().isEmpty) {
                  return;
                }

                final TimeOfDay? pickedTime =
                await showTimePicker(
                  context: dialogContext,
                  initialTime: _selectedTime,
                );

                if (pickedTime == null) {
                  return;
                }

                _selectedTime = pickedTime;

                final date = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );

                final reminderDateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                debugPrint(
                  "Reminder DateTime: $reminderDateTime",
                );

                // ==================================================
                // SAVE TO FIRESTORE
                // ==================================================

                final reminderDoc = await _firestore
                    .collection("users")
                    .doc(uid)
                    .collection("reminders")
                    .add({
                  "title": controller.text,
                  "date": date.toIso8601String(),
                  "time": pickedTime.format(context),
                  "createdAt": FieldValue.serverTimestamp(),
                });

                final String reminderId = reminderDoc.id;



                debugPrint(
                  "✅ Reminder saved with ID: $reminderId",
                );

                // ==================================================
                // UPDATE UI
                // ==================================================

                setState(() {
                  _reminders.putIfAbsent(date, () => []);

                  _reminders[date]!.add({
                    "id": reminderId,
                    "title": controller.text.trim(),
                    "time": pickedTime.format(dialogContext),
                  });
                });

                // ==================================================
                // SCHEDULE NOTIFICATION
                // ==================================================

                debugPrint(
                  "Calling scheduleReminder()",
                );

                await NotificationService().scheduleReminder(
                  reminderId: reminderId,
                  title: controller.text.trim(),
                  body: "Your reminder is due now",
                  dateTime: reminderDateTime,
                );

                // IMPORTANT:
                // Only schedule ONCE.
                //
                // Your previous code called scheduleReminder()
                // twice, which could create duplicate notifications.

                debugPrint(
                  "✅ Reminder and notification created",
                );

                if (mounted) {
                  Navigator.pop(dialogContext);
                }
              },

              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // LOAD REMINDERS
  // ============================================================

  Future<void> _loadReminders() async {
    final snapshot = await _firestore
        .collection("users")
        .doc(uid)
        .collection("reminders")
        .get();

    final Map<DateTime, List<Map<String, dynamic>>>
    loadedReminders = {};

    for (final doc in snapshot.docs) {
      final data = doc.data();

      final DateTime date =
      DateTime.parse(data["date"]);

      final DateTime onlyDate = DateTime(
        date.year,
        date.month,
        date.day,
      );

      loadedReminders.putIfAbsent(
        onlyDate,
            () => [],
      );

      loadedReminders[onlyDate]!.add({
        "id": doc.id,
        "title": data["title"] ?? "",
        "time": data["time"] ?? "",
      });
    }

    if (!mounted) return;

    setState(() {
      _reminders.clear();
      _reminders.addAll(loadedReminders);
    });
  }

  // ============================================================
  // OPEN PARTICULAR REMINDER
  // ============================================================

  void _openReminder(
      Map<String, dynamic> reminder,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            reminder["title"] ?? "Reminder",
          ),

          content: Text(
            "Time: ${reminder["time"] ?? ""}",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar Reminder"),
      ),

      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(
              2020,
              1,
              1,
            ),

            lastDay: DateTime.utc(
              2035,
              12,
              31,
            ),

            focusedDay: _focusedDay,

            selectedDayPredicate: (day) {
              return isSameDay(
                _selectedDay,
                day,
              );
            },

            onDaySelected: (
                selectedDay,
                focusedDay,
                ) {
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

                final reminders =
                    _reminders[date] ?? [];

                if (reminders.isEmpty) {
                  return const Center(
                    child: Text(
                      "No reminders",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: reminders.length,

                  itemBuilder: (
                      context,
                      index,
                      ) {
                    final reminder =
                    reminders[index];

                    return ListTile(
                      leading: const Icon(
                        Icons.notifications,
                      ),

                      title: Text(
                        reminder["title"] ?? "",
                      ),

                      subtitle: Text(
                        reminder["time"] ?? "",
                      ),

                      onTap: () {
                        _openReminder(
                          reminder,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,

        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}