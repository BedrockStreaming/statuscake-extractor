const client = require('prom-client');
const express = require('express');

const server = express();
const { register } = client;

server.get('/metrics', (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(register.metrics());
});

module.exports = server;
