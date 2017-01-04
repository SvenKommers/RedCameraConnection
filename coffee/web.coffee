express = require('express')
app = express()

module.exports = start: (cameras) ->
  app.get('/connect1', (req, res) ->
    cameras[1].connect('127.0.0.1',true,0,8888)
    res.end("connecting1\n")
  )
  app.get('/connect2', (req, res) ->
    cameras[2].connect('127.0.0.1',true,0,8889)
    res.end("connecting2\n")
  )
  app.get('/disconnect1', (req, res) ->
    cameras[1].disconnect()
    res.end("disconnecting1\n")
  )
  app.get('/disconnect2', (req, res) ->
    cameras[2].disconnect()
    res.end("disconnecting2\n")
  )

  app.listen(3000, () ->
    console.log('Example app listening on port 3000!')
  )
