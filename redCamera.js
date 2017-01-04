// Generated by CoffeeScript 1.12.2
(function() {
  var RedCameraConnection, consoleOutput, eventEmitter, getInitialInfo, ipConnection, redFunctions, util,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ipConnection = require('./ip.js');

  eventEmitter = require('events').EventEmitter;

  util = require('util');

  redFunctions = require('./redFunctions.js');

  RedCameraConnection = (function() {
    var handelData, handelParsedString, parseDataForTransmit;

    function RedCameraConnection() {
      this.sendCommand = bind(this.sendCommand, this);
      this.disconnect = bind(this.disconnect, this);
      this.connect = bind(this.connect, this);
      this.connection = new ipConnection();
      this.status = {
        lists: [],
        current: []
      };
      this.id = null;
      this.ip = null;
      this.port = 8888;
      this.timeout = 1000;
      this.autoReconnect = true;
      this.verbose = true;
    }

    console.log("" + RedCameraConnection.timeout);

    RedCameraConnection.prototype.buffer = Buffer.alloc(200, 0, 'base64');


    /*
    @connection.on('status',(data)=>
    #send it out
      @.emit('status',data)
      switch data
        when 2
          getInitialInfo()
          @.status.connected = true
        else
          #if not connected return the value's to empty
          @status.lists = []
          @status.current = []
          @status.notify = []
    
      if data != 2 then @.status.connected = false
      )
    
    #on a verbose status
    @.connection.on('statusVb',(data)=>
      @.emit('statusVB',data)
      consoleOutput(data))
    
    #on data
    @.connection.on('data',(data)=>
      @.emit('data',data)
      #add data to buffer
      @.buffer += data
      @.buffer = handelData(@.buffer,@)
    )
     */

    RedCameraConnection.prototype.connect = function(ip, autoReconnect, timeout, port) {
      console.log('connect');
      consoleOutput("connection triggerd to " + ip + " \t autoReconnect:" + autoReconnect + " \t timeout: " + timeout);
      if (port) {
        this.port = port;
      }
      if (typeof autoReconnect === "boolean") {
        this.autoReconnect = autoReconnect;
      } else {
        consoleOutput("none or none valid autoReconnect value using te default setting " + autoReconnect);
      }
      if ((typeof timeout === 'number' && (timeout % 1) === 0) && timeout >= 0) {
        this.timeout = timeout;
      } else {
        consoleOutput("timeout not a valid integer");
        this.emit('statusVb', "timeout not a valid integer");
        this.emit('status', 6);
      }
      if (!this.connection.connect(this.ip, this.port, this.timeout)) {
        consoleOutput("connection failed (ip.js)");
        this.emit('statusVb', "connection failed");
        return this.emit('status', 6);
      }
    };

    RedCameraConnection.prototype.disconnect = function() {
      return this.connection.disconnect();
    };

    RedCameraConnection.prototype.sendCommand = function(data) {
      var msg;
      if (this.status.connected) {
        msg = parseDataForTransmit(data);
        if (msg === false) {
          consoleOutput("msg Not Valid: " + data);
          return this.emit('statusVB', "msg Not Valid: " + data);
        } else {
          return this.connection.write(msg);
        }
      } else {
        consoleOutput("not connected to " + this.ip + " so can't send a msg");
        return this.emit('statusVB', "not connected to " + this.ip + " so can't send a msg");
      }
    };

    handelData = function(buffer, thisRef) {
      var parsedString, splitPosition, stringToParse;
      splitPosition = buffer.indexOf('\n');
      while (splitPosition !== -1) {
        stringToParse = buffer.substring(0, splitPosition);
        buffer = buffer.substring(splitPosition + 1);
        parsedString = redFunctions.parseLine(stringToParse);
        if (parsedString) {
          handelParsedString(parsedString, thisRef);
        }
        splitPosition = buffer.indexOf('\n');
      }
      return buffer;
    };

    handelParsedString = function(parsedString, thisRef) {
      var target;
      target = null;
      if (parsedString[2] === "D") {
        target = "lists";
      }
      if (parsedString[2] === "C") {
        target = "current";
      }
      if (target) {
        thisRef.emit(parsedString[2], parsedString[3], parsedString[4]);
        thisRef.status[target][parsedString[3]] = parsedString[4];
      }
      console.log(thisRef.status);
      if (parsedString[3] === "XXX") {
        return console.log('bla');
      }
    };

    parseDataForTransmit = function(data) {
      var checksum;
      if (!redFunctions.checkIfValid(data)) {
        return false;
      }
      checksum = redFunctions.calcChecksum(data);
      data += "*" + checksum;
      return data;
    };

    return RedCameraConnection;

  })();

  getInitialInfo = function() {
    return consoleOutput("sending get info");
  };

  consoleOutput = function(data) {
    if (RedCameraConnection.verbose) {
      return console.log(data);
    }
  };

  util.inherits(RedCameraConnection, eventEmitter);

  module.exports = RedCameraConnection;

}).call(this);
