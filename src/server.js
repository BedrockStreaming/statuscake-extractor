const express = require('express');
const config = require('config');
const Storage = require('./statuscakedata');

const app = express();

const { route } = config.statuscake;

app.get(route, (request, response) => {
  response.send(Storage.getData());
});

module.exports = app;
