#!/usr/bin/env coffee

escape = require 'escape-html'
moment = require 'moment'
request = require 'request'

API_ENDPOINT = 'https://api.imgur.com/3/'

class Feed

  constructor: (@title, @link) ->
    @items = []

  toString: ->
    str = """
      <?xml version="1.0" encoding="utf-8"?>
      <rss version="2.0">
      <channel>
      <title>#{ escape @title }</title>
      <description>#{ escape @title }</description>
      <link>#{ escape @link }</link>
      <generator>imgur2rss</generator>
    """
    for {title, link, contents, timestamp} in @items
      str += """
        <item>
          <title>#{ escape title }</title>
          <link>#{ escape link }</link>
          <guid isPermaLink="true">#{ escape link }</guid>
          <description><![CDATA[ #{ contents } ]]></description>
          <pubDate>#{ rfc822 timestamp }</pubDate>
        </item>
      """
    str += """
      </channel>
      </rss>
    """
    return str


rfc822 = (date) ->
  return moment(date).format('ddd, DD MMM YYYY HH:mm:ss ZZ')

get = (clientId, path, query, cb) ->
  request {
    url: API_ENDPOINT + path
    method: 'get'
    qs: query
    json: true
    headers:
      Authorization: "Client-ID #{ clientId }"
  }, cb

exports.album2rss = (clientId, albumId, cb) ->
  return cb "Must specify a client ID" unless clientId
  return cb "Must specify an album ID" unless albumId
  get clientId, "album/#{ albumId }", null, (err, res, body) ->
    return cb err if err
    return cb String(body?.data?.error) unless body?.success
    feed = new Feed(body.data.title, body.data.link)
    for image in body.data.images.slice 0, 10
      feed.items.push
        title: image.title ? image.id
        link: "http://imgur.com/#{ image.id }"
        timestamp: image.datetime * 1000
        contents: """<img src="#{ image.link }" alt="#{ image.title ? image.id }"/>"""
    cb null, feed.toString()
