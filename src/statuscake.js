const axios = require('axios');
const debug = require('debug')('statuscake');
const logError = require('debug')('error');
const config = require('config');

const { username, apikey, baseUrl } = config.statuscake;
const STATUS_CAKE_BASE_URL = `${baseUrl}?API=${apikey}&Username=${username}`;

const fetchStatuCakeData = storage => axios.get(STATUS_CAKE_BASE_URL)
  .then(({ data: { data: urls } }) => {
    const urlsFormated = urls.filter(item => String(item.Title).startsWith(config.statuscake.testTitleFilter)).map((item) => {
      const {
        URL,
        Title,
        LatestStats: {
          Loadtime_ms: loadTimeMS,
          Filesize_kb: fileSizeKB,
          Requests,
        },
      } = item;
      debug(URL, Title, loadTimeMS, fileSizeKB, Requests);
      const myNewItem = {
        URL,
        Title,
        LatestStats: {
          loadTimeMS,
          fileSizeKB,
          Requests,
        },
      };

      return myNewItem;
    });

    storage.setData(urlsFormated);
  }).catch((error) => {
    logError('axios can not access to the URL', error);
  });

module.exports = fetchStatuCakeData;
