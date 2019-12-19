const axios = require('axios');
const config = require('config');
const fetchStatuCakeData = require('../statuscake');
const storage = require('../statuscakedata');

jest.mock('axios');
jest.mock('config', () => ({
  statuscake: {
    apikey: 'api-key',
    username: 'user',
    baseUrl: 'https://example.com/API/Pagespeed/',
  },
}));

jest.mock('../statuscakedata', () => ({
  setData: jest.fn(),
}));

beforeEach(() => {
  jest.clearAllMocks();
});

const block = {
  data: {
    data: [{
      ID: 49216,
      Title: 'NCIS',
      URL: 'http://www.6play.fr/n-c-i-s-p_843',
      Location: 'FR1.PAGESPEED.STATUSCAKE.NET',
      Location_ISO: 'FR',
      ContactGroups: [],
      LatestStats: { Loadtime_ms: 5374, Filesize_kb: 4080.815, Requests: 47 },
    },
    {
      ID: 49217,
      Title: 'Marseillais',
      URL: 'http://www.6play.fr/n-c-i-s-p_843',
      Location: 'FR1.PAGESPEED.STATUSCAKE.NET',
      Location_ISO: 'FR',
      ContactGroups: [],
      LatestStats: { Loadtime_ms: 4394, Filesize_kb: 3514.8, Requests: 26 },
    }],
  },
};

test('fetchStatuCakeData call axios', async () => {
  axios.get.mockResolvedValue(
    block,
  );

  await fetchStatuCakeData(storage);
  expect(axios.get).toBeCalledWith('https://example.com/API/Pagespeed/?API=api-key&Username=user');
  expect(storage.setData).toBeCalledTimes(1);
});

test('it should filter metrics base on config', async () => {
  axios.get.mockResolvedValue(
    block,
  );
  config.statuscake.testTitleFilter = 'NCIS';

  await fetchStatuCakeData(storage);

  expect(storage.setData).toBeCalledTimes(1);
  expect(storage.setData).toBeCalledWith([{
    LatestStats: {
      fileSizeKB: 4080.815,
      Requests: 47,
      loadTimeMS: 5374,

    },
    Title: 'NCIS',
    URL: 'http://www.6play.fr/n-c-i-s-p_843',
  }]);
});


test('fetchStatuCakeData should have an error', async () => {
  axios.get.mockRejectedValue('C est la fin du monde');

  await fetchStatuCakeData();

  expect(axios.get).toBeCalledWith('https://example.com/API/Pagespeed/?API=api-key&Username=user');
});
