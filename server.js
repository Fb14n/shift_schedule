// language: javascript
// Datei: `server.js` (angepasst)
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

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  host: process.env.DATABASE_HOST || "postgres",
  port: 5432,
  user: process.env.DATABASE_USER || "myuser",
  password: process.env.DATABASE_PASSWORD || "mypassword",
  database: process.env.DATABASE_NAME || "mydatabase",
});

pool.connect()
  .then(client => { console.log("✅ DB connection ok"); client.release(); })
  .catch(err => console.error("❌ DB connection failed:", err.stack));

const JWT_SECRET = process.env.JWT_SECRET || "secret123";

async function runSeed() {
  const seedFile = './assets/db/seed.sql';
  try {
    const data = await fs.promises.readFile(seedFile, 'utf8');
    const statements = data.split(';').filter(statement => statement.trim() !== '');
    const client = await pool.connect();
    try {
      console.log('🚀 Starting background seed...');
      await client.query('BEGIN');
      for (const statement of statements) {
        if (statement.trim()) {
          await client.query(statement);
        }
      }
      await client.query('COMMIT');
      console.log('✅ Background seed successful.');
    } catch (dbErr) {
      await client.query('ROLLBACK');
      console.error('❌ Error during background seed:', dbErr.stack);
    } finally {
      client.release();
    }
  } catch (fileErr) {
    console.error('❌ Error reading seed.sql for background process:', fileErr);
  }
}

// Init DB: an Seed angepasst
async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      first_name TEXT,
      last_name TEXT,
      password TEXT NOT NULL,
      employee_id INTEGER UNIQUE,
      company_id INTEGER,
      vacation_days INTEGER DEFAULT 0,
      is_admin BOOLEAN DEFAULT false
    );
  `);
  await pool.query(`
    CREATE TABLE IF NOT EXISTS companies (
      id SERIAL PRIMARY KEY,
      name TEXT UNIQUE NOT NULL,
      address TEXT
    );
  `);
  await pool.query(`
    CREATE TABLE IF NOT EXISTS shift_types (
      id SERIAL PRIMARY KEY,
      type_name TEXT NOT NULL,
      type_color INTEGER,
      type_time_start TEXT,
      type_time_end TEXT
    );
  `);
  // shifts in Seed: (id, shift_date, shift_type_id, user_id)
  await pool.query(`
    CREATE TABLE IF NOT EXISTS shifts (
      id SERIAL PRIMARY KEY,
      shift_date DATE NOT NULL,
      shift_type_id INTEGER REFERENCES shift_types(id),
      user_id INTEGER REFERENCES users(id)
    );
  `);
}
initDB().catch(console.error);

function authenticateToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Token missing" });

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    if (!decoded || typeof decoded !== "object" || !('userId' in decoded)) {
      console.error("Invalid token payload:", decoded);
      return res.status(401).json({ error: "Invalid token payload" });
    }
    req.user = decoded;
    next();
  } catch (err) {
    console.error("JWT verify error:", err);
    return res.status(403).json({ error: "Invalid token" });
  }
}

function toHexColor(colorValue) {
  if (typeof colorValue === 'string' && colorValue.startsWith('#')) return colorValue;
  if (colorValue === null || colorValue === undefined) return '#000000';
  const n = Number(colorValue);
  if (!Number.isFinite(n) || isNaN(n)) {
    try {
      const asInt = parseInt(String(colorValue), 10);
      if (Number.isFinite(asInt) && !isNaN(asInt)) {
        const hex = asInt.toString(16).padStart(6, '0');
        return `#${hex.toUpperCase()}`;
      }
    } catch (_) {}
    return '#000000';
  }
  const hex = Math.trunc(n).toString(16).padStart(6, '0');
  return `#${hex.toUpperCase()}`;
}

// Shift-types
app.get("/shift-types", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT id, type_name, type_color, type_time_start, type_time_end FROM shift_types ORDER BY id');
    const typesWithHexColor = result.rows.map(type => ({ ...type, type_color: toHexColor(type.type_color) }));
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
    if (!color) return res.status(400).json({ error: "Color is required" });
    if (!/^#[0-9A-F]{6}$/i.test(color)) return res.status(400).json({ error: "Invalid color format. Use #RRGGBB." });
    const colorAsInteger = parseInt(color.substring(1), 16);
    const result = await pool.query('UPDATE shift_types SET type_color = $1 WHERE id = $2 RETURNING *', [colorAsInteger, id]);
    if (result.rowCount === 0) return res.status(404).json({ error: "Shift type not found" });
    const updatedType = { ...result.rows[0], type_color: toHexColor(result.rows[0].type_color) };
    res.json(updatedType);
  } catch (err) {
    console.error("Error updating shift type color:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Shifts (user-specific)
app.get("/shifts", authenticateToken, async (req, res) => {
  try {
    const userId = req.user && req.user.userId;
    if (!userId) {
      console.warn("GET /shifts called without userId in token payload", { tokenPayload: req.user });
      return res.status(401).json({ error: "userId missing in token" });
    }

    const result = await pool.query(
      `SELECT s.id, s.shift_date, st.type_name, st.type_color, st.type_time_start, st.type_time_end, s.user_id
       FROM shifts s
       LEFT JOIN shift_types st ON s.shift_type_id = st.id
       WHERE s.user_id = $1
       ORDER BY s.shift_date`,
      [userId]
    );

    const shiftsWithHexColor = result.rows.map(shift => ({ ...shift, type_color: toHexColor(shift.type_color) }));
    res.json(shiftsWithHexColor);
  } catch (err) {
    console.error("Shifts error:", err.stack || err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Alle Schichten (Übersicht)
app.get("/shifts/all", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT s.id, s.shift_date, s.user_id, u.first_name, u.last_name,
              st.type_name, st.type_color, st.type_time_start, st.type_time_end
       FROM shifts s
       LEFT JOIN users u ON s.user_id = u.id
       LEFT JOIN shift_types st ON s.shift_type_id = st.id
       ORDER BY s.shift_date`
    );
    const rows = result.rows.map(r => ({ ...r, type_color: toHexColor(r.type_color) }));
    res.json(rows);
  } catch (err) {
    console.error("Error fetching all shifts:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/shifts", authenticateToken, async (req, res) => {
  const { user_id, shift_date, shift_type_id } = req.body;
  if (!user_id || !shift_date || !shift_type_id) {
    return res.status(400).json({ error: "user_id, shift_date and shift_type_id are required" });
  }
  try {
    const result = await pool.query(
      'INSERT INTO shifts (user_id, shift_date, shift_type_id) VALUES ($1, $2, $3) RETURNING *',
      [user_id, shift_date, shift_type_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error("Error creating shift:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.put("/shifts/:id", authenticateToken, async (req, res) => {
  const { id } = req.params;
  const updates = req.body;
  const fields = [];
  const values = [];
  let idx = 1;

  for (const key of ['user_id', 'shift_date', 'shift_type_id']) {
    if (updates[key] !== undefined) {
      fields.push(`${key} = $${idx}`);
      values.push(updates[key]);
      idx++;
    }
  }

  if (fields.length === 0) return res.status(400).json({ error: "No valid fields to update" });

  try {
    const result = await pool.query(
      `UPDATE shifts SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      [...values, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: "Shift not found" });
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error updating shift:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Users / Auth
app.post("/register", async (req, res) => {
  const { username, password } = req.body;
  try {
    const hashed = await bcrypt.hash(password, 10);
    await pool.query("INSERT INTO users (first_name, password) VALUES ($1, $2)", [username, hashed]);
    res.json({ msg: "User created" });
  } catch (err) {
    if (err.code === "23505") return res.status(400).json({ error: "User already exists" });
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/login", async (req, res) => {
  console.log("Login request body:", req.body);
  const { username, password } = req.body;
  try {
    const result = await pool.query("SELECT id, first_name, last_name, employee_id, password FROM users WHERE first_name = $1", [username]);
    if (result.rows.length === 0) return res.status(401).json({ error: "User not found" });
    const user = result.rows[0];
    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ error: "Invalid password" });
    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: "2h" });
    res.json({ access_token: token, token_type: "bearer" });
  } catch (err) {
    console.error("Login error:", err.stack);
    res.status(500).json({ error: err.message });
  }
});

app.post("/reset-password", async (req, res) => {
  const { username, employeeId, newPassword } = req.body;
  if (!username || !employeeId || !newPassword) {
    return res.status(400).json({ error: "Username, employee ID, and new password are required." });
  }
  try {
    const userResult = await pool.query("SELECT id FROM users WHERE first_name = $1 AND employee_id = $2", [username, employeeId]);
    if (userResult.rows.length === 0) return res.status(404).json({ error: "User not found or employee ID is incorrect." });
    const userId = userResult.rows[0].id;
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    await pool.query("UPDATE users SET password = $1 WHERE id = $2", [hashedNewPassword, userId]);
    res.json({ msg: "Password has been reset successfully." });
  } catch (err) {
    console.error("Password reset error:", err.stack);
    res.status(500).json({ error: "Internal server error while resetting password." });
  }
});

app.get("/user/details", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const userResult = await pool.query("SELECT first_name, last_name, employee_id, holidays, is_admin FROM users WHERE id = $1", [userId]);
    const vacationResult = await pool.query("SELECT COUNT(*) AS holidays FROM shifts WHERE user_id = $1 AND shift_type_id = 5", [userId]);
    const sickResult = await pool.query("SELECT COUNT(*) AS sick_days FROM shifts WHERE user_id = $1 AND shift_type_id = 4", [userId]);
    if (userResult.rows.length === 0) return res.status(404).json({ error: "User not found" });
    res.json({
      first_name: userResult.rows[0].first_name,
      last_name: userResult.rows[0].last_name,
      employee_id: userResult.rows[0].employee_id,
      vacation_days: parseInt(vacationResult.rows[0].vacation_days),
      sick_days: parseInt(sickResult.rows[0].sick_days),
      vacation_balance: userResult.rows[0].vacation_days,
      is_admin: userResult.rows[0].is_admin
    });
  } catch (err) {
    console.error("Error fetching user details:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.get("/users", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT id, first_name, last_name, employee_id, company_id, holidays, is_admin FROM users ORDER BY id');
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching users:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/users", authenticateToken, async (req, res) => {
  const { first_name, last_name, employee_id, password, company_id, vacation_days, is_admin } = req.body;
  if (!first_name || !last_name || employee_id === undefined || !password) {
    return res.status(400).json({ error: "first_name, last_name, employee_id and password are required" });
  }
  try {
    const hashed = await bcrypt.hash(password, 10);
    const result = await pool.query(
      'INSERT INTO users (first_name, last_name, password, employee_id, company_id, holidays, is_admin) VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING id, first_name, last_name, employee_id, company_id, vacation_days, is_admin',
      [first_name, last_name, hashed, employee_id, company_id || null, vacation_days || 0, is_admin || false]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") return res.status(400).json({ error: "User with this employee_id already exists" });
    console.error("Error creating user:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.put("/users/:id", authenticateToken, async (req, res) => {
  const { id } = req.params;
  const updates = req.body;
  const fields = [];
  const values = [];
  let idx = 1;

  if (updates.password) {
    updates.password = await bcrypt.hash(updates.password, 10);
  }

  for (const key of ['first_name', 'last_name', 'employee_id', 'company_id', 'password', 'vacation_days', 'is_admin']) {
    if (updates[key] !== undefined) {
      fields.push(`${key} = $${idx}`);
      values.push(updates[key]);
      idx++;
    }
  }

  if (fields.length === 0) return res.status(400).json({ error: "No valid fields to update" });

  try {
    const result = await pool.query(
      `UPDATE users SET ${fields.join(', ')} WHERE id = $${idx} RETURNING id, first_name, last_name, employee_id, company_id, holidays, is_admin`,
      [...values, id]
    );
    if (result.rowCount === 0) return res.status(404).json({ error: "User not found" });
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error updating user:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Companies unchanged
app.get("/companies", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query('SELECT id, name, address FROM companies ORDER BY id');
    res.json(result.rows);
  } catch (err) {
    console.error("Error fetching companies:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/companies", authenticateToken, async (req, res) => {
  const { name, address } = req.body;
  if (!name) return res.status(400).json({ error: "name is required" });
  try {
    const result = await pool.query('INSERT INTO companies (name, address) VALUES ($1,$2) RETURNING *', [name, address || null]);
    res.status(201).json(result.rows[0]);
  } catch (err) {
    if (err.code === "23505") return res.status(400).json({ error: "Company already exists" });
    console.error("Error creating company:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.put("/companies/:id", authenticateToken, async (req, res) => {
  const { id } = req.params;
  const updates = req.body;
  const fields = [];
  const values = [];
  let idx = 1;
  for (const key of ['name', 'address']) {
    if (updates[key] !== undefined) {
      fields.push(`${key} = $${idx}`);
      values.push(updates[key]);
      idx++;
    }
  }
  if (fields.length === 0) return res.status(400).json({ error: "No valid fields to update" });
  try {
    const result = await pool.query(`UPDATE companies SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`, [...values, id]);
    if (result.rowCount === 0) return res.status(404).json({ error: "Company not found" });
    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error updating company:", err.stack);
    res.status(500).json({ error: "Internal server error" });
  }
});

const host = process.env.HOST || '0.0.0.0';
app.listen(3000, host, () => {
  console.log(`🚀 Server running on :${host}`);
  runSeed();
});