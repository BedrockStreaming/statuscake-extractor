class StatutCakeData {
    constructor() {
       this.data = {} 
    }

    setData(data) {
        this.data = data;
    }

    getData(data) {
        return this.data;
    }
}

module.exports = new StatutCakeData();
