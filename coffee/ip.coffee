###
Status List
0 not connected
1 connecting
2 connected
3 disconncting
4 timeout
5 reconnect
6 error
###

net = require('net')
eventEmitter = require('events').EventEmitter
util = require('util');


class Connection
  ip: '127.0.0.1'
  port: 23
  timeout: 0
  autoReconnect: yes
  autoReconnectTime: 5000
  client: null
  noDelay: true
  connect:(ip,port,timeout)=> #public connect function
    console.log("ip.coffee connect:#{ip}")
    #check if the IP is valid, if not, return false
    if net.isIP(ip)
      @.ip = ip
    else
      @.emit('statusVb',"#{ip} is not a valid ip adress")
      @.emit('status',6)
      return false

    #check if Portnumber is valid, if not return false
    if (typeof port=='number' && (port%1)==0) &&  0 < port < 65535
      @.port = port
    else
      @.emit('statusVb',"#{port} is nog a valid port number, it must be a interger between 0 and 65535")
      @.emit('status',6)
      return false

    #set timeout
    if (typeof timeout=='number' && (timeout%1)==0)
      @.timeout = timeout
    else
      @.emit('statusVb',"timeout has no or a non interger value using default value of #{timeout}")
    #start te connection
    @.client = new net.connect(@.port,@.ip,()=>
      #no delay on for color timeing
      @.client.setNoDelay(@.noDelay)
      @.emit("statusVb","connecting to #{@.ip} #{@.port}")
      @.emit('status',1)  #connecting
      @.client.setTimeout(@.timeout,()=>
        @.emit('statusVb',"timeout triggerd. timeout was set to #{@.timeout/1000} second(s)")
        @.emit('status',4) #timeout
        @.emit('status',0) #not connected
        @.client.end()
        @.client.destroy()
        if @.autoReconnect
          @.reconnect()
        )
      @.emit('statusVb','connected')
      @.emit('status',2)
      )
    @.client.on('data',(resData)=>
      @.emit('data',resData)
      )
    @.client.on('timeout',()=>
      @.emit('status',4)
      @.emit('statusVb',"timeout on connection to #{@.ip} #{@.port}")
      )
    @.client.on('end',()=>
      @.emit('statusVb',"end")
      @.emit('status',0)
      if @autoReconnect && !@manualDisconnect
        @.reconnect()
      else
        @.manualDisconnect = no
      )
    @.client.on('error',(data)=>
      @.emit('statusVb',"error #{data}")
      @.emit('status',6)
      if @.autoReconnect
        @.reconnect()
      )
  reconnect: ()=>
    @.emit('status',5)
    @.emit('statusVb',"reconnecting to #{@.ip} #{@.port} in #{@.autoReconnectTime/1000} second(s)")
    setTimeout(()=>
      @.connect()
    ,@.autoReconnectTime)
  disconnect: ()=>
    @.manualDisconnect = yes
    @client.end()
  write: (data)=>
    @.client.write(data)

util.inherits(Connection,eventEmitter)
module.exports = Connection;
