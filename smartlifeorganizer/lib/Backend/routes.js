const express = require('express');
const cors = require('cors');
const app = express();

const { addNote, readNotes } = require("../Backend/MongoDbfuncs");
const port = 3000;

app.use(express.json());
app.use(cors());

// ✅ Add Note Route
app.post("/addNotes", async (req, res) => {
  const { email, task, datetime, reminder } = req.body;

  console.log("Task:", task);
  console.log("Datetime:", datetime);
  console.log("Reminder Time:", reminder);

  if (email && task && datetime && reminder) {
    try {
      await addNote(email, task, datetime, reminder);
      res.status(200).json({ message: "Data received and saved successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error saving data", error: error.message });
    }
  } else {
    res.status(400).json({ message: "Missing required fields" });
  }
});

// ✅ View Notes Route
app.post("/viewnotes", async (req, res) => {
  const { email } = req.body;

  if (email) {
    try {
      const notes = await readNotes(email);
      res.status(200).json({ notes });
    } catch (error) {
      res.status(500).json({ message: "Error reading notes", error: error.message });
    }
  } else {
    res.status(400).json({ message: "Email is required" });
  }
});

app.listen(port, () => {
  console.log(`🚀 Server running on http://localhost:${port}`);
});
