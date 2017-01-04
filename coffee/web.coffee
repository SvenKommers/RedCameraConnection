express = require('express')
app = express()

start = (cameras)->
  console.log('trugger')
  app.get('/connect1', (req, res) ->
    cameras[1].connect('127.0.0.1')
    res.end("connecting1")
  )
  app.get('/connect2', (req, res) ->
    cameras[2].connect()
    res.end("connecting2")
  )
  app.get('/disconnect1', (req, res) ->
    cameras[1].disconnect()
    res.end("disconnecting1")
  )
  app.get('/disconnect2', (req, res) ->
    cameras[2].disconnect()
    res.end("disconnecting2")
  )

  app.listen(3000, () ->
    console.log('Example app listening on port 3000!')
  )

module.exports = start()
