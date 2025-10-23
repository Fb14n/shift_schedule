import express from "express";
import pkg from "pg";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import cors from "cors";
import fs from "fs";

const { Pool } = pkg;
const app = express();
app.use(express.json());
app.use(cors({ origin: "*" }));

// -------------------------
// Database Pool
// -------------------------
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  host: process.env.DATABASE_HOST || "postgres",
  port: 5432,
  user: process.env.DATABASE_USER || "myuser",
  password: process.env.DATABASE_PASSWORD || "mypassword",
  database: process.env.DATABASE_NAME || "mydatabase",
});

// DB-Connection Check
pool.connect()
  .then(client => {
    console.log("✅ DB connection ok");
    client.release();
  })
  .catch(err => console.error("❌ DB connection failed:", err.stack));

// -------------------------
// JWT Secret
// -------------------------
const JWT_SECRET = process.env.JWT_SECRET || "secret123";

// Seed-SQL-Datei lesen
const seedFile = '.assets/db/seed.sql';
fs.readFile(seedFile, 'utf8', async (err, data) => {
  if (err) {
    console.error('Fehler beim Lesen der seed.sql:', err);
    return;
  }
  try {
    await pool.query(data);
    console.log('✅ Seed erfolgreich ausgeführt');
  } catch (err) {
    console.error('❌ Fehler beim Ausführen der seed.sql:', err.stack);
  }
});

// ---- DB Init ----
async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      name TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    );
  `);
  await pool.query(`
    CREATE TABLE IF NOT EXISTS shifts (
      id SERIAL PRIMARY KEY,
      user_id INTEGER REFERENCES users(id),
      shift_date DATE NOT NULL,
      shift_type TEXT NOT NULL,
      name TEXT NOT NULL
    );
  `);
}
initDB().catch(console.error);

// ---- Middleware ----
function authenticateToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.sendStatus(401);

  jwt.verify(token, JWT_SECRET, (err, user) => {
      if (err) return res.sendStatus(403);
      req.user = user;
      next();
    });
  }

// --- HILFSFUNKTION ---
// Konvertiert eine Zahl in einen #RRGGBB Hex-String
function toHexColor(colorValue) {
    if (typeof colorValue === 'string' && colorValue.startsWith('#')) {
        return colorValue; // Ist bereits ein Hex-String
    }
    // Konvertiert Integer zu Hex und füllt mit Nullen auf 6 Stellen auf
    const hex = Number(colorValue).toString(16).padStart(6, '0');
    return `#${hex.toUpperCase()}`;
}

// ---- Routes ----

// KORREKTUR 1: /shifts-Route angepasst
app.get("/shifts", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const result = await pool.query(
        'SELECT s.id, s.shift_date, st.type_name, st.type_color FROM shifts s JOIN shift_types st ON s.shift_type_id = st.id WHERE s.user_id = $1',
        [userId]
    );

    // Stelle sicher, dass die Farbe immer ein Hex-String ist
    const shiftsWithHexColor = result.rows.map(shift => ({
        ...shift,
        type_color: toHexColor(shift.type_color)
    }));

    res.json(shiftsWithHexColor);

  } catch (err) {
    console.error("Shifts error:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

// KORREKTUR 2: /shift-types-Route angepasst
app.get("/shift-types", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT id, type_name, type_color FROM shift_types ORDER BY id');

    // Stelle sicher, dass die Farbe immer ein Hex-String ist
    const typesWithHexColor = result.rows.map(type => ({
        ...type,
        type_color: toHexColor(type.type_color)
    }));

    res.json(typesWithHexColor);
  } catch (err) {
    console.error("Error fetching shift types:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.put("/shift-types/:id/color", authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const { color } = req.body;

    if (!color) {
      return res.status(400).json({ error: "Color is required" });
    }

    if (!/^#[0-9A-F]{6}$/i.test(color)) {
      return res.status(400).json({ error: "Invalid color format. Use #RRGGBB." });
    }

    // HINWEIS: Wir speichern es jetzt als String. Zukünftige DB-Änderungen sollten
    // die Spalte 'type_color' als VARCHAR(7) oder TEXT definieren.
    const result = await pool.query(
      'UPDATE shift_types SET type_color = $1 WHERE id = $2 RETURNING *',
      [color, id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Shift type not found" });
    }

    // Stelle sicher, dass die zurückgegebene Farbe auch ein Hex-String ist
    const updatedType = {
        ...result.rows[0],
        type_color: toHexColor(result.rows[0].type_color)
    };

    res.json(updatedType);
  } catch (err) {
    console.error("Error updating shift type color:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});


app.post("/register", async (req, res) => {
  const { username, password } = req.body;
  try {
    const hashed = await bcrypt.hash(password, 10);
    await pool.query("INSERT INTO users (name, password) VALUES ($1, $2)", [
      username,
      hashed,
    ]);
    res.json({ msg: "User created" });
  } catch (err) {
    if (err.code === "23505") {
      return res.status(400).json({ error: "User already exists" });
    }
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/login", async (req, res) => {
  console.log("Login request body:", req.body);
  const { username, password } = req.body;
  try {
    const result = await pool.query(
      "SELECT id, first_name, last_name, employee_id, password FROM users WHERE first_name = $1",
      [username]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: "User not found" });
    }

    const user = result.rows[0];
    const match = await bcrypt.compare(password, user.password);

    if (!match) {
      return res.status(401).json({ error: "Invalid password" });
    }

    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: "2h" });
    res.json({ access_token: token, token_type: "bearer" });

  } catch (err) {
    console.error("Login error:", err.stack);
    res.status(500).json({ error: err.message});
  }
});

app.get("/user/details", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    const userResult = await pool.query(
      "SELECT first_name, last_name, employee_id FROM users WHERE id = $1",
      [userId]
    );

    const vacationResult = await pool.query(
      "SELECT COUNT(*) AS vacation_days FROM shifts WHERE user_id = $1 AND shift_type_id = '5'",
      [userId]
    );

    const sickResult = await pool.query(
      "SELECT COUNT(*) AS sick_days FROM shifts WHERE user_id = $1 AND shift_type_id = '4'",
      [userId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({
      first_name: userResult.rows[0].first_name,
      last_name: userResult.rows[0].last_name,
      employee_id: userResult.rows[0].employee_id,
      vacation_days: parseInt(vacationResult.rows[0].vacation_days),
      sick_days: parseInt(sickResult.rows[0].sick_days),
    });
  } catch (err) {
    console.error("Error fetching user details:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ---- Start Server ----
const host = process.env.HOST || '0.0.0.0';
app.listen(3000, host, () => {
  console.log(`🚀 Server running on :${host}:3000`);
});