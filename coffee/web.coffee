express = require('express')
app = express()

module.exports = start: (cameras,settings) ->
#  i=1
#  while i <= cameras.length#
#    console.log(cameras[i])
    #cameras[i].Connection.on("cameraStatusUpdate",(a,b,c)->
      #console.log("statusUpdate #{a},#{b},#{c}")
      #)
#    i++

#  app.get('/', (req, res) ->
#    res.sendFile(__dirname+'/public/index.html')
#  )

  app.use(express.static(__dirname + '/public'))

  app.get('/connect', (req, res) ->
    id = req.query.id
    ip = req.query.ip

    if ip == null then ip = '127.0.0.1'
    if id && id <= cameras.length
      cameras[id].connect(ip,true,1000,1111)
      res.end("connecting #{id} to #{ip}\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/disconnect', (req, res) ->
    id = req.query.id
    if id && id <= cameras.length
      cameras[id].disconnect()
      res.end("disconnecting #{id}\n")
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/status', (req, res) ->
    id = req.query.id
    if id && 0 < id <= cameras.length
      res.status(200).json(cameras[id].status)
    else if id == "0"
      statusRes = []
      iii = 1
      while iii <= cameras.length
        tempStatus = cameras[iii]
        if tempStatus
          console.log(tempStatus.status)
          tempStatus = tempStatus.status
          statusRes[iii]= tempStatus
        iii++
      res.status(200).json(statusRes)
    else
      res.status(404).json('no camera found, use ?id=')
  )
  app.get('/settings', (req, res) ->
    res.status(200).json(settings)
  )

  app.listen(3000, () ->
    console.log('Red app listening on port 3000!')
  )
