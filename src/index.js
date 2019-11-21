const config = require('config');
const fetchStatuCakeData = require('./statuscake');
const server = require('./server');
const Storage = require('./statuscakedata');

this.interval = setInterval(() => fetchStatuCakeData(Storage), config.statuscake.interval);

server(Storage).listen(config.statuscake.listener);
