const fetchStatuCakeData = require('../statuscake');
const StatutCakeData = require('../statuscakedata');
const axios = require('axios');
const config = require('config');
const Storage = require('../statuscakedata');

jest.mock('axios');
jest.mock('config', () => ({ statuscake: {
  "apikey": "api-key",
  "username": "user",
  "baseUrl": "https://example.com/API/Pagespeed/",
}}))

jest.mock('../statuscakedata', () => ({
  setData: jest.fn()
}))

test('fetchStatuCakeData call axios', async () => {
  axios.get.mockResolvedValue({ data: { data: [{
    ID: 49216,
    Title: '6play.fr - Programme NCIS - Mobile',
    URL: 'http://www.6play.fr/n-c-i-s-p_843',
    Location: 'FR1.PAGESPEED.STATUSCAKE.NET',
    Location_ISO: 'FR',
    ContactGroups: [],
    LatestStats: { Loadtime_ms: 5374, Filesize_kb: 4080.815, Requests: 47 }
  },
  {
    ID: 49217,
    Title: '6play.fr - Programme Z NCIS - Mobile',
    URL: 'http://www.6play.fr/n-c-i-s-p_843',
    Location: 'FR1.PAGESPEED.STATUSCAKE.NET',
    Location_ISO: 'FR',
    ContactGroups: [],
    LatestStats: { Loadtime_ms: 4394, Filesize_kb: 3514.8, Requests: 26 }
  }] }})};

    await fetchStatuCakeData();
    expect(axios.get).toBeCalledWith("https://example.com/API/Pagespeed/?API=api-key&Username=user");
    expect(Storage.setData).toBeCalledTimes(2)
});


test('fetchStatuCakeData should have an error', async () => {
  axios.get.mockRejectedValue('C est la fin du monde');

  await fetchStatuCakeData();

  expect(axios.get).toBeCalledWith("https://example.com/API/Pagespeed/?API=api-key&Username=user");
  
});
