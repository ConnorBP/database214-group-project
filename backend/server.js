const express = require("express");
const cors = require("cors");

const app = express();
const port = 3001;

app.use(cors()); // To allow cross origin requests from frontend

// Route to check if the server is running
app.get("/api/check-db", (req, res) => {
 console.log("Server is up and running");

 res.send("Server is running");
});
x;

// Start the server
app.listen(port, () => {
 console.log(`Server running at http://localhost:${port}`);
});
