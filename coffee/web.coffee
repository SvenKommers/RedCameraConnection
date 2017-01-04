express = require('express')
app = express()

module.exports = start: (cameras) ->
  app.get('/connect', (req, res) ->
    id = req.query.id
    if id
      cameras[id].connect('127.0.0.1',true,0,8888)
      res.end("connecting #{id}\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/disconnect', (req, res) ->
    id = req.query.id
    if id
      cameras[id].disconnect()
      res.end("disconnecting1\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/status', (req, res) ->
    id = req.query.id
    if id
      res.status(200).json(cameras[id].status)
    else
      res.status(404).json('no camera found, use ?id=')
  )



  app.listen(3000, () ->
    console.log('Example app listening on port 3000!')
  )
