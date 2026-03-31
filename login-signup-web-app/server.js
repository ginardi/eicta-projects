// Import required modules
const express = require("express");
const sqlite = require("sqlite3");
const path = require("path");

// Initialize Express application
const app = express();

// Open SQLite database (must be in the same folder)
const db = new sqlite.Database("users.db");

// Middleware: serve static files from "public" folder
app.use(express.static("public"));

// Middleware: automatically parse JSON request bodies
app.use(express.json());

// Base path for static files
const staticPath = path.join(__dirname, "public");

// Serve the main HTML page
app.get("/", (req, res) => {
  res.sendFile(path.join(staticPath, "index.html"));
});

/**
 * USER SIGN-UP
 * Route: POST /api/signup
 * The client sends: email, password, first_name, last_name, date_of_birth, address
 * The server adds a new user to the database
 */
app.post("/api/signup", (req, res) => {
  const {
    email,
    password,
    first_name,
    last_name,
    date_of_birth,
    address
  } = req.body;

  // Server-side validation
  if (!email || !password || !first_name || !last_name || !date_of_birth || !address) {
    return res.status(400).json({ message: "All fields are required." });
  }

  // SQL statement with parameter placeholders
  const sql = `
    INSERT INTO users (email, password, first_name, last_name, date_of_birth, address)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  // Execute INSERT query
  db.run(sql, [email, password, first_name, last_name, date_of_birth, address], function (err) {
    if (err) {
      // UNIQUE constraint → email already exists
      if (err.message.includes("UNIQUE constraint failed")) {
        return res.status(409).json({ message: "Email already registered." });
      }
      return res.status(500).json({ message: "Internal server error." });
    }

    // Success → user created
    return res.status(201).json({
      message: `Welcome, ${first_name}! Your account has been created.`
    });
  });
});

/**
 * USER LOGIN
 * POST /api/login
 * The client sends: email, password
 * The server checks credentials in the database
 */
app.post("/api/login", (req, res) => {
    const { email, password } = req.body;
  
    // Server-side validation
    if (!email || !password) {
      return res.status(400).json({ message: "Email and password are required." });
    }
  
    // Single query: email AND password must match
    const sql = `
      SELECT * FROM users
      WHERE email = ? AND password = ?
    `;
  
    db.get(sql, [email, password], (err, row) => {
      if (err) {
        console.error("DB error in login:", err.message);
        return res.status(500).json({ message: "Internal server error." });
      }
  
      // No user found → either email or password is wrong
      if (!row) {
        return res.status(401).json({ message: "Invalid email or password." });
      }
  
      // Login successful
      return res.json({
        message: `Welcome back, ${row.first_name} ${row.last_name}!`
      });
    });
  });

// Start the server
app.listen(3000, () => {
    console.log("Server running on http://localhost:3000");
  });