class StatutCakeData {
  constructor() {
    this.data = {};
  }

  setData(data) {
    this.data = data;
  }

  getData() {
    return this.data;
  }
}

module.exports = new StatutCakeData();
