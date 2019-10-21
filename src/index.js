const config = require('../config');
const fetchStatuCakeData = require('./statuscake')

this.interval = setInterval(fetchStatuCakeData, config.statuscake.interval);
