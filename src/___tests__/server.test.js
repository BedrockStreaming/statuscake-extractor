const request = require("supertest");
const Storage = require('../statuscakedata');
const app = require('../server');

jest.mock('config', () => ({ statuscake: {
  "route": "/",
  "listener": 3000,
}}))

jest.mock('../statuscakedata', () => ({
  getData: jest.fn().mockReturnValue('fake-data')
}))

test('server should return ', async () => {
    const response = await request(app).get('/').expect(200)
    expect(response.text).toEqual('fake-data')
    expect(Storage.getData).toBeCalledTimes(1)
});
