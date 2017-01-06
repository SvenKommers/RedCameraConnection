server = require('./web.js')
Connection = require('./redCamera.js')
connections = []
settings = {'nrOfConnections' : 10}

i = 1
while i <= settings.nrOfConnections
  connections[i] = new Connection()
  connections[i].on('data',(data)->
    console.log("app.js #{connections.indexOf(this)} (data): #{data}"))
  connections[i].on('status',(data)->
    console.log("app.js #{connections.indexOf(this)} (status): #{data}"))
  connections[i].on('statusVB',(data)->
    console.log("app.js #{connections.indexOf(this)} (statusVB): #{data}"))
  i++


server.start(connections,settings)

process.stdin.setEncoding('utf8')
process.stdin.on('readable', () =>
  chunk = process.stdin.read()
  if chunk != null
    chunk = chunk.replace("\n","")
    camera2.sendCommand(chunk)
);
