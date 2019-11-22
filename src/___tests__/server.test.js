const request = require('supertest');
const app = require('../server');

jest.mock('prom-client', () => ({
  register: {
    contentType: 'fakeContentType',
    metrics: jest.fn(() => 'test-value'),
  },
}));

describe('Server', () => {
  test('should respond prom-client metrics values', async () => {
    const response = await request(app).get('/metrics').expect(200);
    expect(response.text).toEqual('test-value');
  });

  test('should respond with Header Content-type based on prom-client', async () => {
    const response = await request(app).get('/metrics').expect(200);
    expect(response.headers['content-type']).toEqual('fakeContentType');
  });
});
