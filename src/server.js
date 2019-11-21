const client = require('prom-client');

const express = require('express');

const regex = /\s?([-])\s?/;

const server = express();
const { register } = client;
const getTagsFromTitle = Title => Title.split(regex);

let Storage = null;

const g = new client.Gauge({
  name: 'metric_loadtime',
  help: 'metric_help',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const h = new client.Gauge({
  name: 'metric_filesize',
  help: 'metric_help',
  labelNames: ['customer', 'service', 'device', 'version'],
});
const i = new client.Gauge({
  name: 'metric_request',
  help: 'metric_help',
  labelNames: ['customer', 'service', 'device', 'version'],
});

setInterval(() => {
  const date = (100, Date.now());
  const data = Storage.getData();
  if (data.length > 0) {
    data.forEach((myItem) => {
      const parsedTitle = getTagsFromTitle(myItem.Title);
      g.set({
        customer: parsedTitle[0], service: parsedTitle[2], device: parsedTitle[4], version: parsedTitle[6],
      }, myItem.LatestStats.loadTimeMS, date);
      h.set({
        customer: parsedTitle[0], service: parsedTitle[2], device: parsedTitle[4], version: parsedTitle[6],
      }, myItem.LatestStats.fileSizeKB, date);
      i.set({
        customer: parsedTitle[0], service: parsedTitle[2], device: parsedTitle[4], version: parsedTitle[6],
      }, myItem.LatestStats.Requests, date);
    });
  }
}, 100);

server.get('/metrics', (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(register.metrics());
});

const init = (commonStorage) => {
  Storage = commonStorage;

  return server;
};

module.exports = init;
