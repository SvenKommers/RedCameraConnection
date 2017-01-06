express = require('express')
app = express()

module.exports = start: (cameras,settings) ->
  i=1
  while i <= cameras.length
    #console.log(cameras[i])
    #cameras[i].Connection.on("cameraStatusUpdate",(a,b,c)->
      #console.log("statusUpdate #{a},#{b},#{c}")
      #)
    i++

#  app.get('/', (req, res) ->
#    res.sendFile(__dirname+'/public/index.html')
#  )

  app.use(express.static(__dirname + '/public'))

  app.get('/connect', (req, res) ->
    id = req.query.id
    if id & id <= cameras.length
      cameras[id].connect('127.0.0.1',true,0,8888)
      res.end("connecting #{id}\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/disconnect', (req, res) ->
    id = req.query.id
    if id & id <= cameras.length
      cameras[id].disconnect()
      res.end("disconnecting1\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/status', (req, res) ->
    id = req.query.id
    if id & id <= cameras.length
      res.status(200).json(cameras[id].status)
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/settings', (req, res) ->
    res.status(200).json(settings)
  )

  app.listen(3000, () ->
    console.log('Red app listening on port 3000!')
  )
