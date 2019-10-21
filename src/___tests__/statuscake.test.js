const fetchStatuCakeData = require('../statuscake');
const axios = require('axios');
const config = require('../../config')

jest.mock('axios');
jest.mock('../../config', () => ({ statuscake: {
  "apikey": "api-key",
  "username": "user",
  "baseUrl": "https://example.com/API/Pagespeed/"
}}))

test('fetchStatuCakeData call axios', async () => {
    axios.get.mockResolvedValue({ data: { data: {}}})

    await fetchStatuCakeData();

    expect(axios.get).toBeCalledWith("https://example.com/API/Pagespeed/?API=api-key&Username=user");
});


test('fetchStatuCakeData should have an error', async () => {
  axios.get.mockRejectedValue('C est la fin du monde');

  await fetchStatuCakeData();

  expect(axios.get).toBeCalledWith("https://example.com/API/Pagespeed/?API=api-key&Username=user");
});
