import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartlifeorganizer/Pages/CalenderandSchedule.dart';
import 'package:smartlifeorganizer/Pages/SignUp.dart';
import 'package:smartlifeorganizer/Pages/TaskManager.dart';
import 'package:smartlifeorganizer/Pages/ViewNotes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:weather/weather.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum MenuActions { logout, notes, addNote, viewNotes }

class _HomepageState extends State<Homepage> {
  final today = DateTime.now();
  final WeatherFactory wf = WeatherFactory("a95ac20b44385c921f020bdcf01d1094",
      language: Language.ENGLISH);

  Weather? _weather; // To store fetched weather

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  void fetchWeather() async {
    try {
      Weather w = await wf.currentWeatherByCityName("Lahore");
      setState(() {
        _weather = w;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<MenuActions>(
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldlogout = await showLogoutDialog(context);
                  if (shouldlogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  }
                case MenuActions.notes:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TaskManager()));
                case MenuActions.addNote:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Calenderandschedule()));
                case MenuActions.viewNotes:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ViewNotes()));
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActions>(
                  value: MenuActions.logout,
                  child: Text("Logout"),
                ),
                PopupMenuItem<MenuActions>(
                    value: MenuActions.notes, child: Text("Take Notes")),
                PopupMenuItem(
                    value: MenuActions.addNote, child: Text("AddNotes")),
                PopupMenuItem(
                    value: MenuActions.viewNotes, child: Text("View Notes"))
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Welcome To Skill Swap",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Good Day To You User",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                // Tasks Container
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tasks",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text("• Buy groceries"),
                      Text("• Complete Flutter project"),
                      Text("• Go for a walk"),
                    ],
                  ),
                ),
                const SizedBox(width: 300),
                // Calendar Container
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TableCalendar(
                    focusedDay: today,
                    firstDay: DateTime.utc(today.year, 1, 1),
                    lastDay: DateTime.utc(today.year, 12, 31),
                  ),
                ),
                const SizedBox(width: 220),
                // Weather Container
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _weather == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Weather",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text("City: ${_weather!.areaName}"),
                            Text(
                                "Temp: ${_weather!.temperature?.celsius?.toStringAsFixed(1)} °C"),
                            Text(
                                "Desc: ${_weather!.weatherDescription?.toUpperCase()}"),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
