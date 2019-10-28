const express = require('express');
const Storage = require('./statuscakedata');
const app = express();
const config = require('config');

const { route } = config.statuscake;

app.get(route, (request, response) => {
    response.send(Storage.getData());
})

module.exports = app;
