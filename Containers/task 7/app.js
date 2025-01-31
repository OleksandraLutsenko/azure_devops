const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Log environment variables to verify injection
console.log("Loaded environment variables:");
console.log("APP_MESSAGE:", process.env.APP_MESSAGE);
console.log("APP_ENV:", process.env.APP_ENV);
console.log("API_KEY:", process.env.API_KEY); // Only for testing/debugging

app.get('/', (req, res) => {
  // Optionally, include the values in the response for verification (not recommended for production)
  res.send(`
    <h1>Hello from the containerized Node.js app!</h1>
    <p>APP_MESSAGE: ${process.env.APP_MESSAGE}</p>
    <p>APP_ENV: ${process.env.APP_ENV}</p>
    <p>API_KEY: ${process.env.API_KEY}</p>
  `);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
