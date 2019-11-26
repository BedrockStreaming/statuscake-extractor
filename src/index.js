const client = require('prom-client');
const config = require('config');
const fetchStatuCakeData = require('./statuscake');
const server = require('./server');
const Storage = require('./statuscakedata');

const regex = /\s?([-])\s?/;

const getTagsFromTitle = Title => Title.split(regex);

const g = new client.Gauge({
  name: 'frontend_pagespeed_loadtime_seconds',
  help: 'Loadtime of your page',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const h = new client.Gauge({
  name: 'frontend_pagespeed_filesize_bytes',
  help: 'Filesize of your page',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const i = new client.Gauge({
  name: 'frontend_pagespeed_request_count',
  help: 'Number of request',
  labelNames: ['customer', 'service', 'device', 'version'],
});

setInterval(() => {
  const date = (100, Date.now());
  const data = Storage.getData();
  if (data.length > 0) {
    const startsWithPrometheus = data.filter(d => String(d.Title).startsWith('[prometheus]'));
    startsWithPrometheus.forEach((myItem) => {
      const parsedTitle = getTagsFromTitle(myItem.Title);
      const labels = {
        customer: parsedTitle[0], service: parsedTitle[2], device: parsedTitle[4], version: parsedTitle[6],
      };
      const setterLoadTime = gauge => gauge.set(labels, myItem.LatestStats.loadTimeMS, date);
      setterLoadTime(g);
      const setterSize = gauge => gauge.set(labels, myItem.LatestStats.fileSizeKB, date);
      setterSize(h);
      const setterRequest = gauge => gauge.set(labels, myItem.LatestStats.Requests, date);
      setterRequest(i);
    });
  }
}, 100);

this.interval = setInterval(() => fetchStatuCakeData(Storage), config.statuscake.interval);

server.listen(config.statuscake.listener);
