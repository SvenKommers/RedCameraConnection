server = require('./web.js')
Connection = require('./redCamera.js')
connections = []
nrOfConnections = 2

i = 1
while i <= nrOfConnections
  connections[i] = new Connection()
  connections[i].on('data',(data)->
    console.log("app.js #{connections.indexOf(this)} (data): #{data}"))
  connections[i].on('status',(data)->
    console.log("app.js #{connections.indexOf(this)} (status): #{data}"))
  connections[i].on('statusVB',(data)->
    console.log("app.js #{connections.indexOf(this)} (statusVB): #{data}"))
  i++


server.start(connections)
###
setInterval(()->
  console.log(connections[1].status)
,1000)
###
process.stdin.setEncoding('utf8')

process.stdin.on('readable', () =>
  chunk = process.stdin.read()
  if chunk != null
    chunk = chunk.replace("\n","")
    camera2.sendCommand(chunk)
);
###
ip = require('./ip.js')
connection = new ip
connection.autoReconnect = yes
connection.on('data',(data)->
  console.log(data)
)
connection.on('statusVb',(data)->
  console.log("VB status: #{data}")
)

connection.on('status',(data)->
  switch data
    when 0 then console.log('not connected')
    when 1 then console.log('connecting')
    when 2 then console.log('connected')
    when 3 then console.log('disconncting')
    when 4 then console.log('timeout')
    when 5 then console.log('reconnect')
    when 6 then console.log('error')
    else console.log.log("unhandeld status code: #{data}")
)

connection.connect("127.0.0.1",8888)
#0 not connected
#1 connecting
#2 connected
#3 disconncting
#4 timeout
#5 reconnect
#6 error
###
