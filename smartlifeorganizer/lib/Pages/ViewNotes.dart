import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewNotes extends StatefulWidget {
  const ViewNotes({super.key});

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  List<dynamic> notes = [];

  Future<void> readNotesfromdb() async {
    final String url = "http://localhost:3000/viewnotes";

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": user.email}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          notes = responseData['notes'];
        });
      } else {
        print("Failed to load notes. Status code: ${response.statusCode}");
      }
    } catch (err) {
      print("Error fetching notes: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    readNotesfromdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Notes"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: notes.isEmpty
            ? const Center(child: Text("No notes found"))
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(note['note'] ?? 'No content'),
                      subtitle: Text("Reminder: ${note['reminder'] ?? 'None'}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.green),
                            onPressed: () {
                              // TODO: Implement edit functionality here
                              print("Edit note ${note['_id']}");
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // TODO: Implement delete functionality here
                              print("Delete note ${note['_id']}");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
