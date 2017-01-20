server = require('./web.js')
Connection = require('./redCamera.js')
connections = []
settings = {'nrOfConnections' : 10}

datetime = () ->
          currentdate = new Date()
          date = currentdate.getDate()
          month = (currentdate.getMonth()+1)
          year = currentdate.getFullYear()
          hour = '00' + currentdate.getHours()
          hour = hour.slice(-2)
          min = '00' + currentdate.getMinutes()
          min = min.slice(-2)
          sec = '00' + currentdate.getSeconds()
          sec = sec.slice(-2)
          return "#{date}/#{month}/#{year} @ #{hour}:#{min}:#{sec}"

i = 1
while i <= settings.nrOfConnections
  connections[i] = new Connection()
#  connections[i].on('data',(data)->
#    console.log("app.js\t#{connections.indexOf(this)}\t(data): #{data}"))
#  connections[i].on('status',(data)->
#    console.log("app.js\t#{connections.indexOf(this)}\t(status): #{data}"))
  connections[i].on('statusVB',(data)->
    console.log("app.js\t#{connections.indexOf(this)}\t#{datetime()}\t(statusVB): #{data}"))
  i++



server.start(connections,settings)

process.stdin.setEncoding('utf8')
process.stdin.on('readable', () =>
  chunk = process.stdin.read()
  pattr = /^([\w]+)\s?([0-9]+)?\s?([^\s]+)?\s?([^\s]+)?\s?([^\s]+)?\n/
  res = pattr.exec(chunk)

  if chunk != null
    switch res[1]
      when "status"
        try
          console.log(JSON.stringify(connections[res[2]].status,null,'\t'))
        catch error
          console.log("error while status\n#{error}")
      when "disconnect"
        try
          connections[res[2]].disconnect()
        catch error
          console.log("error while trying disconnect\n #{error}")
      when "connect"
        try
          connections[res[2]].connect(res[3],true,0,1111)
        catch error
          console.log("error while trying connect\n #{error}")
      when "setstatus"
        try
          if res[3] == "C"
            connections[res[2]].status.current[res[4]] = res[5]
          else if res[3] == "D"
            connections[res[2]].status.list[res[4]] = res[5]
        catch error
          console.log("error while trying setstatus\n #{error}")
      else
        console.log('not a option')
);
