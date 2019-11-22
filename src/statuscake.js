const axios = require('axios');
const debug = require('debug')('statuscake');
const logError = require('debug')('error');
const config = require('config');

const { username, apikey, baseUrl } = config.statuscake;
const STATUS_CAKE_BASE_URL = `${baseUrl}?API=${apikey}&Username=${username}`;

const fetchStatuCakeData = Storage => axios.get(STATUS_CAKE_BASE_URL)
  .then(({ data: { data: urls } }) => {
    const urlsFormated = urls.map((item) => {
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
   
    console.log(urlsFormated);
    Storage.setData(urlsFormated);
  }).catch((error) => {
    logError('axios can not access to the URL', error);
  });

module.exports = fetchStatuCakeData;
