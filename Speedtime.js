const config = require('./config');
const axios = require('axios');

const username = { username: config.Speedtime.username }
const apikey = { apikey: config.Speedtime.apikey }

this.interval = setInterval(() => { //Add an interval to get information 
axios.get(`https://app.statuscake.com/API/Pagespeed/?API=${apikey.apikey}&Username=${username.username}`) //Acces to the URL
  .then(({data : {data: urls} }) => { //Rename data to urls
      urls.map(item => { //Acces to the information that I need on urls
          const {
              URL,
              Title,
              LatestStats: {
                Loadtime_ms,
                Filesize_kb,
                Requests
              }
          } = item

          console.log(URL,Title, Loadtime_ms, Filesize_kb, Requests);

      }) 
  });
}, config.Speedtime.interval );

//Using GET Based Auth :
//GET[API] = 4CjJF0sJvXaX8NtWOhXC
//GET[Username] = M6Web

