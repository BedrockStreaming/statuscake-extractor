const client = require('prom-client');
const config = require('config');
const fetchStatuCakeData = require('./statuscake');
const server = require('./server');
const storage = require('./statuscakedata');

const regex = /\s?([-])\s?/;

const getTagsFromTitle = Title => Title.split(regex);

const loadtimeGauge = new client.Gauge({
  name: 'frontend_pagespeed_loadtime_seconds',
  help: 'Loadtime of your page',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const filesizeGauge = new client.Gauge({
  name: 'frontend_pagespeed_filesize_bytes',
  help: 'Filesize of your page',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const requestGauge = new client.Gauge({
  name: 'frontend_pagespeed_request_count',
  help: 'Number of request',
  labelNames: ['customer', 'service', 'device', 'version'],
});

setInterval(() => {
  const date = (Date.now());
  const data = storage.getData();
  if (data.length > 0) {
    data.forEach((myItem) => {
      const parsedTitle = getTagsFromTitle(myItem.Title);
      const labels = {
        customer: parsedTitle[0], service: parsedTitle[2], device: parsedTitle[4], version: parsedTitle[6],
      };
      const setter = (gauge, value) => gauge.set(labels, value, date);
      setter(loadtimeGauge, myItem.LatestStats.loadTimeMS);
      setter(filesizeGauge, myItem.LatestStats.fileSizeKB);
      setter(requestGauge, myItem.LatestStats.Requests);
    });
  }
});

this.interval = setInterval(() => fetchStatuCakeData(storage), config.statuscake.interval);

server.listen(config.statuscake.listener);
