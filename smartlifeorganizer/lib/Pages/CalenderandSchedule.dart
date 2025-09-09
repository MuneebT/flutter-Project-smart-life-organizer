import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Calenderandschedule extends StatefulWidget {
  const Calenderandschedule({super.key});

  @override
  State<Calenderandschedule> createState() => _CalenderandscheduleState();
}

class _CalenderandscheduleState extends State<Calenderandschedule> {
  String priority = "low";
  late final TextEditingController text;
  DateTime? selecteddatetime;

  @override
  void initState() {
    text = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> senddatatobackend(String data, DateTime datetime) async {
    const url = "http://localhost:3000/addNotes";

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ No logged-in user");
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": user.email,
          "task": data,
          "datetime": datetime.toIso8601String(),
          "reminder": priority, // ⚠️ Make sure `priority` is defined!
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Data sent: ${response.body}");
      } else {
        print("❌ Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
    }
  }

  Future<void> datetimeselector() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(const Duration(days: 3652)),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(Tween(begin: 0.0, end: 1.0)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) => dateTime != DateTime(2023, 2, 25),
    );

    if (dateTime != null) {
      setState(() {
        selecteddatetime = dateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar & Schedule"),
        backgroundColor: const Color.fromARGB(255, 5, 173, 38),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                controller: text,
                decoration: const InputDecoration(
                  hintText: "Enter Task Or Event",
                  fillColor: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await datetimeselector();
              },
              child: const Text("Pick Date & Time"),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () async {
                if (selecteddatetime != null && text.text.isNotEmpty) {
                  await senddatatobackend(text.text, selecteddatetime!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please enter task and select date")),
                  );
                }
              },
              child: const Text("Add"),
            ),
            Row(
              children: [
                const Text("Reminder:"),
                Radio(
                    value: "daily",
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value!;
                      });
                    }),
                const Text("Daily"),
                const SizedBox(
                  width: 10,
                ),
                Radio(
                    value: "weekly",
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value!;
                      });
                    }),
                const Text("Weekly"),
                Radio(
                    value: "monthly",
                    groupValue: priority,
                    onChanged: (value) {
                      setState(() {
                        priority = value!;
                      });
                    }),
                const Text("Monthly"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
