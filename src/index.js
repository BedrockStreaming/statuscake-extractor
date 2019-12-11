const client = require('prom-client');
const config = require('config');
const fetchStatuCakeData = require('./statuscake');
const server = require('./server');
const storage = require('./statuscakedata');

const { tagsFromTestTitleRegexp } = config.statuscake;

const matchTagsFromTitle = title => title.match(new RegExp(tagsFromTestTitleRegexp));
const tags = [
  config.statuscake.firstTag,
  config.statuscake.secondTag,
  config.statuscake.thirdTag,
  config.statuscake.fourthTag];

const loadtimeGauge = new client.Gauge({
  name: config.statuscake.nameOfLoadTimeGauge,
  help: 'Loadtime of your page',
  labelNames: tags,
});
const filesizeGauge = new client.Gauge({
  name: config.statuscake.nameOfFileSizeGauge,
  help: 'Filesize of your page',
  labelNames: tags,
});
const requestGauge = new client.Gauge({
  name: config.statuscake.nameOfRequestGauge,
  help: 'Number of request',
  labelNames: tags,
});

setInterval(() => {
  const date = (Date.now());
  const data = storage.getData();
  if (data.length > 0) {
    data.forEach((myItem) => {
      const parsedTitle = matchTagsFromTitle(myItem.Title);
      const setter = (gauge, value) => gauge.set(parsedTitle.groups, value, date);
      setter(loadtimeGauge, myItem.LatestStats.loadTimeMS);
      setter(filesizeGauge, myItem.LatestStats.fileSizeKB);
      setter(requestGauge, myItem.LatestStats.Requests);
    });
  }
});

this.interval = setInterval(() => fetchStatuCakeData(storage), config.statuscake.interval);

server.listen(config.statuscake.listener);
