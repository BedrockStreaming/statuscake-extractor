const client = require('prom-client');
require('../index');

jest.mock('prom-client');

jest.mock('config', () => ({
  statuscake: {
    nameOfLoadTimeGauge: 'name of your loadtime gauge',
    nameOfFileSizeGauge: 'name of your filesize gauge',
    nameOfRequestGauge: 'name of your request gauge',
    tags: ['foo', 'bar'],
  },
}));

jest.mock('../server', () => ({
  listen: jest.fn(),
}));

describe('index.js', () => {
  it('should set config label to Gauge tags', () => {
    expect(client.Gauge).toHaveBeenNthCalledWith(3, { help: expect.any(String), labelNames: ['foo', 'bar'], name: expect.any(String) });
  });
});
