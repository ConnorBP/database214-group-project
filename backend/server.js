const express = require("express");
const oracledb = require("oracledb");
const cors = require("cors");

const app = express(); 
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Test Oracle DB Connection
async function testConnection() {
  let conn;
  try {
    conn = await oracledb.getConnection({
      user: "COMP214_F24_zo_62", 
      password: "password",     
      connectionString: "199.212.26.208:1521/SQLD",
    });
    console.log("Connection successful");
    const result = await conn.execute(`SELECT * FROM CartProduct`);
    console.log("CartProduct data:", result.rows);
  } catch (err) {
    console.error("Error:", err);
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (err) {
        console.error("Error closing connection:", err);
      }
    }
  }
}

// API Endpoints
app.post("/api/hello", (req, res) => {
  console.log("Hello World from the server!");
  res.send({ message: "Hello World!" });
});

app.post("/api/cart", async (req, res) => {
  console.log("Received payload:", req.body); // Debug received payload

  const { productId, quantity, cartId } = req.body;

  if (!productId || !quantity || !cartId) {
    console.error("Missing required fields:", req.body); // Log missing fields
    return res.status(400).send("Missing required fields: productId, quantity, or cartId");
  }

  const query = `INSERT INTO CartProduct (product_id, quantity, cart_id)
                 VALUES (:productId, :quantity, :cartId)`;

  let conn;
  try {
    conn = await oracledb.getConnection({
      user: "COMP214_F24_zo_62",
      password: "password",
      connectionString: "199.212.26.208:1521/SQLD",
    });

    const result = await conn.execute(
      query,
      { productId, quantity, cartId },
      { autoCommit: true }
    );

    console.log("Insert result:", result);
    res.status(201).send({ message: "Product added to cart", result });
  } catch (err) {
    console.error("Error during adding to cart:", err);
    res.status(500).send("Error adding to cart");
  } finally {
    if (conn) {
      try {
        await conn.close();
      } catch (err) {
        console.error("Error closing connection:", err);
      }
    }
  }
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
