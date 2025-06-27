const express = require("express");
const app = express();
const port = 3000;

const message = process.env.APP_MESSAGE || 'Hello from Kubernetes!';
const secret = process.env.SECRET_KEY || 'No secret set';

app.get("/", (req, res) => {
  res.send(`<!DOCTYPE html>
<html>
<head>
  <title>K8s Node App</title>
  <style>
    body { background: yellow; font-family: sans-serif; }
    .container { margin: 50px auto; max-width: 600px; padding: 2em; border-radius: 8px; box-shadow: 0 2px 8px #ccc; background: #fffbe6; }
    h1 { color: #333; }
    p { color: #444; }
  </style>
</head>
<body>
  <div class="container">
    <h1>${message}</h1>
    <p><strong>Secret:</strong> ${secret}</p>
  </div>
</body>
</html>`);
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
