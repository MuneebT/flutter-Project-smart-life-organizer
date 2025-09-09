const mongoose = require("mongoose");
const noteschema = require("../Schema/notesschema");

const url = "mongodb://localhost:27017/ToDoList";

const connect = async () => {
  await mongoose.connect(url, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
};

const disconnect = async () => {
  await mongoose.disconnect();
};

const addNote = async (email, note, time, reminder) => {
  try {
    await connect();
    await noteschema.create({ email, note, time, reminder }); // fixed typo: was 'notes' instead of 'note'
  } catch (err) {
    console.log("Error adding note:", err.message);
  } finally {
    await disconnect();
  }
};

const readNotes = async (email) => {
  try {
    await connect();
    const notes = await noteschema.find({ email: email });
    return notes; // ✅ return result
  } catch (err) {
    console.log("Error reading notes:", err.message);
    return []; // ✅ always return a value
  } finally {
    await disconnect();
  }
};

module.exports = {
  addNote,
  readNotes,
};
