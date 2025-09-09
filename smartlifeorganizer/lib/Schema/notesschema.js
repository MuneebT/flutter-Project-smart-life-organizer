const mongoose = require("mongoose");

const notesSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true
  },
  note: {
    type: String, // Assuming note is an array of strings
    required: true
  },
  time: {
    type: Date,
    required: true
  },
  reminder: {
    type: String,
    required: true
  }
});

const Notes = mongoose.model("Notes", notesSchema);
module.exports = Notes;
