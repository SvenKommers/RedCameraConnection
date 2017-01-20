ipConnection = require('./ip.js')
eventEmitter = require('events').EventEmitter
util = require('util');

redFunctions = require('./redFunctions.js')

class RedCameraConnection
  constructor: ()->
    @connection= new ipConnection()
    @status= {}
    @id=null            #id number of the connection used for emit
    @ip=null
    @port=1111           #default port for RED camera's is 1111
    @timeout=1000        #a emit is made every 300ms
    @autoReconnect= yes  #in case of timeout
    @verbose= yes        #for log msg
    #create a 200 char buffer filled with 0's
    @buffer= Buffer.alloc(200,0,'base64')

    @connection.on('status',(data)=>
    #send it out
      @.emit('status',data)
      switch data
        when 2
          @.status.connected = true
          getInitialInfo(@)
        else
          #if not connected return the value's to empty
          @status.lists = {}
          @status.current = {}
          @status.notify = {}
          @status.connected = false
      if data != 2 then @.status.connected = false
    )

      #on a verbose status
    @connection.on('statusVb',(data)=>
      @.emit('statusVB',data)
      consoleOutput(data))

      #on data
    @connection.on('data',(data)=>
      @.emit('data',data)
      #add data to buffer
      @.buffer += data
      @.buffer = handelData(@buffer,@)
      )

  #Connect Function                  #port is temp
  connect: (ip,autoReconnect,timeout,port) =>
    consoleOutput("connection triggerd to #{ip} \t
    autoReconnect:#{autoReconnect} \t timeout: #{timeout}")
    @ip = ip
    if port
      @port = port
    #check if autoReconnect = boolean
    if typeof(autoReconnect) == "boolean"
      @autoReconnect = autoReconnect
    else
      consoleOutput("none or none valid autoReconnect value using te default setting #{autoReconnect}")

    #check if timeout is interger
    if (typeof timeout=='number' && (timeout%1)==0) && timeout >= 0
      @timeout = timeout
    else
      consoleOutput("timeout not a valid integer")
      @.emit('statusVb', "timeout not a valid integer")
      @.emit('status',6)
    #open the connection        #####
    if (!@connection.connect(@ip,@port,@timeout))
      consoleOutput("connection failed (ip.js)")
      @.emit('statusVb', "connection failed")
      @.emit('status',6)

  getStatus: =>
    return @status

  disconnect: =>
    @connection.disconnect()
    @status.connected = false

  sendCommand:(type,value) =>
    if @status.connected
      msg = "$EXT:#{type}:#{value}:"
      msgres = parseDataForTransmit(msg)
      if msgres == false
        consoleOutput("msg Not Valid: #{msg}")
        @.emit('statusVB',"msg Not Valid: #{msg}")
      else
        @connection.write(msgres)
    else
        console.log(@.status)
        consoleOutput("not connected to #{@.ip} so can't send a msg")
        @.emit('statusVB',"not connected to #{@.ip} so can't send a msg")


  handelData = (buffer,thisRef) =>
    #look for a newline char
    splitPosition = buffer.indexOf('\n')
    #Repeat until buffer had no full line of information
    while splitPosition != -1
      #create the substring to parse
      stringToParse = buffer.substring(0,splitPosition)
      #take the substring from the buffer
      buffer = buffer.substring(splitPosition+1)
      #parse string via regEx
      parsedString = redFunctions.parseLine(stringToParse)
      #if the return value is valid
      if parsedString
        handelParsedString(parsedString,thisRef)
      #get the next index for the while loop
      splitPosition = buffer.indexOf('\n')
    #return the buffer
    return buffer

  handelParsedString = (parsedString,thisRef) =>
    target = null
    if parsedString[3] != "NOTIFY"
      if parsedString[2] == "D"
        target = "lists"
      if parsedString[2] == "C"
        target = "current"
      #need to send out msg
      if target
        thisRef.emit("cameraStatusUpdate",parsedString[2],parsedString[3],parsedString[4])
        thisRef.status[target][parsedString[3]] = parsedString[4]
      if parsedString[3] == "XXX"
        console.log('bla')
      #console.log(parsedString)
    else
      console.log("handel notify msg")
      console.log(parsedString)

  parseDataForTransmit = (data) ->
    if !redFunctions.checkIfValid(data)
      return false
    checksum = redFunctions.calcChecksum(data)
    data = "##{data}"
    data += "*" + checksum
    data += "\n"
    return data

getInitialInfo = (thisRef)=>
  for value in redFunctions.gValues
      thisRef.sendCommand("G",value);
    for value in redFunctions.hValues
      thisRef.sendCommand("H",value);


consoleOutput = (data) ->
  if RedCameraConnection.verbose
    console.log(data)




util.inherits(RedCameraConnection, eventEmitter)

module.exports = RedCameraConnection;
