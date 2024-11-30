const express = require("express");
const oracledb = require("oracledb"); // Oracle DB module
const cors = require("cors"); // CORS module to enable cross-origin requests

const app = express(); // Initialize app before using it
app.use(cors()); // Enable CORS middleware

const PORT = 3001;

app.use(express.json()); // Middleware to parse incoming JSON requests

// Function for Oracle DB connection and query execution
async function aaa() {
 let conn;
 try {
  // Establish connection with the Oracle DB
  //const connectionString = "jdbc:oracle:thin:@199.212.26.208:1521:SQLD";
  //"oracle1.centennialcollege.ca:1521/SQLD" inside centennial connect
  conn = await oracledb.getConnection({
   user: "COMP214_F24_zo_60", // Replace with your DB username
   password: "password", // Replace with your DB password
   connectionString: "199.212.26.208:1521/SQLD", // Replace with your Oracle DB connection string
  });
  console.log("Connection successful");

  // Query to execute (Replace with your query)
  let comm = `INSERT INTO customer (email, password_hash, full_name, phone_number, birthday, billing_address)
            VALUES ('asdf@asdf', 'hash_asdf', 'ASDF ASDF', '911-911', SYSDATE, 'asdf ROAD')`;
  let result = await conn.execute(comm);
  console.log(result.rowsAffected);
  await conn.commit(); // Commit the transaction
 } catch (err) {
  console.log("Error:", err);
 } finally {
  if (conn) {
   try {
    await conn.close(); // Close the DB connection
   } catch (err) {
    console.log("Error closing connection:", err);
   }
  }
 }
}

// Test the button to server
app.post("/api/hello", (req, res) => {
 console.log("Hello World from the server!");
 res.send({ message: "Hello World!" });
});

// Endpoint to handle adding to cart (for example purposes)
app.post("/api/cart", async (req, res) => {
 const { productId, quantity, cartId } = req.body;

 // Check if required fields are present
 if (!productId || !quantity || !cartId) {
  return res.status(400).send("Missing required fields");
 }

 // Query to insert product into CartProduct table
 const query = `INSERT INTO CartProduct (product_id, quantity, cart_id)
        VALUES (:productId, :quantity, :cartId)`;

 try {
  // Execute the query to insert the product into the cart
  const result = await aaa(); // call  aaa function here for DB operation
  res.status(201).send({ message: "Product added to cart", result });
 } catch (err) {
  console.error("Error during adding to cart:", err);
  res.status(500).send("Error adding to cart");
 }
});

// Start the server and listen on the specified port
app.listen(PORT, () => {
 console.log(`Server running on http://localhost:${PORT}`);
});
