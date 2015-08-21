# imgur2rss

A application you can run on Heroku to make RSS feeds of Imgur things.

It currently only supports Imgur albums.

## Usage: Command Line

[Register an Imgur application](https://api.imgur.com/oauth2/addclient) and copy the Client ID. Then:

```
$ npm install -g imgur2rss
$ imgur2rss -c YOUR_CLIENT_ID album tleVt
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
...
```

## Usage: Module

```coffeescript
i2r = require "imgur2rss"
i2r.album2rss clientId, albumId, (err, xml) ->
  if err
    console.error "Error: #{ err }"
    process.exit 1
  else
    console.log xml
```

## Usage: Heroku



