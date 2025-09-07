import express from "express";
import pkg from "pg";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

const { Pool } = pkg;

const app = express();
app.use(express.json());

// -------------------------
// Database Pool
// -------------------------
const pool = new Pool({
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

// ---- DB Init ----
async function initDB() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL
    );
  `);
  await pool.query(`
    CREATE TABLE IF NOT EXISTS items (
      id SERIAL PRIMARY KEY,
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

  jwt.verify(token, process.env.JWT_SECRET || "secret", (err, user) => {
      if (err) return res.sendStatus(403);
      req.user = user;
      next();
    });
  }

// ---- Routes ----
app.get("/shifts", async (req, res) => {
  const authHeader = req.headers["authorization"];
  if (!authHeader) return res.status(401).json({ error: "Missing token" });

  const token = authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Missing token" });

  try {
    const payload = jwt.verify(token, JWT_SECRET);
    const userId = payload.userId;

    const result = await pool.query(
      "SELECT shift_date, shift_type FROM shifts WHERE user_id = $1",
      [userId]
    );

    res.json(result.rows);

  } catch (err) {
    console.error("Shifts error:", err.stack);
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
  const { username, password } = req.body;

  try {
    const result = await pool.query(
      "SELECT id, name, password FROM users WHERE name = $1",
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
    res.status(500).json({ error: "Internal server error" });
  }
});

app.get("/items", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM items");
    res.json({ user: req.user.username, items: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.post("/items", authenticateToken, async (req, res) => {
  const { name } = req.body;
  try {
    await pool.query("INSERT INTO items (name) VALUES ($1)", [name]);
    res.json({ msg: "Item added", user: req.user.username });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

// ---- Start Server ----
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});