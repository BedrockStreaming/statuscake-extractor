<h1 align="center">Welcome to statuscake-extractor 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-blue.svg?cacheSeconds=2592000" />
</p>

> This project interrogate Statuscake to fetch pagespeeed data of some shows regularly. Thoses data are exported on Prometheus.
A library to take advantage of the API of [https://www.statuscake.com/](https://www.statuscake.com/)

Get access to this following information:
 - URL
 - Title
 - Loadtime_ms
 - Filesize_kb
 - Requests

## Configure

To configure the project, we use npm [`config`](https://www.npmjs.com/package/config) package, follow `config/default.json.dist` example to define yours with:
- interval (Speedtime is check every second by default)
- apikey (Imperative to get access to statuscake)
- username (Imperative to get access to statuscake)
- baseUrl (Imperative to get access to statuscake)
- route (Name your route)
- listener (3000 by default)

## Debug

Use debug to access to the data, or to check if you got some errors:
```sh
DEBUG=statuscake yarn start
```
```sh
DEBUG=error yarn start
```
If you need more information on this package: https://www.npmjs.com/package/debug

## Test

```sh
yarn test
```
If you need more information on this package: https://jestjs.io/docs/en/getting-started

## Eslint

```sh
yarn lint
```

## Install

```sh
yarn install
```

## Usage
Get access to node server with `yarn start`.

```sh
yarn start
```

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
