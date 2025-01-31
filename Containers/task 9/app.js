// const express = require('express');
// const app = express();
// const port = process.env.PORT || 3000;

// app.get('/', (req, res) => {
//   res.send(`
//     <html>
//       <head>
//         <title>Simple App v1</title>
//         <style>
//           body { background-color: lightblue; }
//         </style>
//       </head>
//       <body>
//         <h1>Welcome to Version 1</h1>
//       </body>
//     </html>
//   `);
// });

// app.listen(port, () => {
//   console.log(`App v1 listening on port ${port}`);
// });

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Simple App v2</title>
        <style>
          body { background-color: lightgreen; }
        </style>
      </head>
      <body>
        <h1>Welcome to Version 2</h1>
      </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`App v2 listening on port ${port}`);
});
