const config = require('config');
const fetchStatuCakeData = require('./statuscake')
const server = require('./server');

this.interval = setInterval(fetchStatuCakeData, config.statuscake.interval);

server.listen(config.statuscake.listener);
