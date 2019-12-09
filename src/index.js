const client = require('prom-client');
const config = require('config');
const fetchStatuCakeData = require('./statuscake');
const server = require('./server');
const storage = require('./statuscakedata');

const regexp = config.statuscake.regex;

const getTagsFromTitle = title => title.match(new RegExp(regexp));
const tags = [
  (config.statuscake.customer),
  (config.statuscake.service),
  (config.statuscake.device),
  (config.statuscake.version)];

const loadtimeGauge = new client.Gauge({
  name: (config.statuscake.nameofloadtimegauge),
  help: 'Loadtime of your page',
  labelNames: (tags),
});
const filesizeGauge = new client.Gauge({
  name: (config.statuscake.nameoffilesizegauge),
  help: 'Filesize of your page',
  labelNames: (tags),
});
const requestGauge = new client.Gauge({
  name: (config.statuscake.nameofrequestgauge),
  help: 'Number of request',
  labelNames: (tags),
});

setInterval(() => {
  const date = (Date.now());
  const data = storage.getData();
  if (data.length > 0) {
    data.forEach((myItem) => {
      const parsedTitle = getTagsFromTitle(myItem.Title);
      const setter = (gauge, value) => gauge.set(parsedTitle.groups, value, date);
      setter(loadtimeGauge, myItem.LatestStats.loadTimeMS);
      setter(filesizeGauge, myItem.LatestStats.fileSizeKB);
      setter(requestGauge, myItem.LatestStats.Requests);
    });
  }
});

this.interval = setInterval(() => fetchStatuCakeData(storage), config.statuscake.interval);

server.listen(config.statuscake.listener);
