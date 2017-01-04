exports.calcChecksum = (inputcmd) ->
  inputcmd = inputcmd.toString()
  if !(inputcmd.slice(-1) == ":")
    inputcmd += ":"
  checksum = 0
  i = 0
  for j in inputcmd
    checksum = checksum ^ inputcmd.charCodeAt(i)
    i++
  checksum = Number(checksum).toString(16).toUpperCase()
  if checksum.length < 2
    checksum = ("00#{checksum}").slice(-2)
  return checksum

exports.checkIfValidIncChecksum = (msg) ->
  pattr = /^(#\$EXT:)[G|H|S|T|U|V|C|D]{1}:([A-Z]{1,8}(:[A-Za-z0-9\|\\]+)?)*:\*[\w]{2}$/
  pattr.exec(msg)

exports.checkIfValid = (msg) ->
  pattr = /^(#\$EXT:)[G|H|S|T|U|V|C|D]{1}:([A-Z]{1,8}(:[A-Za-z0-9\|\\]+)?)+:$/
  pattr.exec(msg)

exports.parseLine = (msg) ->
  pattr = /#(?:\@[\w]+)?\$(\w{1,8}):([G|H|S|T|U|V|C|D]):(\w+):([a-zA-Z0-9|\\\:|\||,|&|:]+)?:\*[A-Z0-9]{2}/
  res = pattr.exec(msg)
  #if !res
    #console.log("NOT matched msg with regEx: #{msg}")
  return res




#abc = "#$EPIC:S:TIMECODE:10\\:11\\:12:ISO:1200:*C2"
#console.log(abc)
#test(abc)
#checkIfValidB('#$EXT:G:ISO')

###
function buildCommand(target,value){
	    target = target.toUpperCase();				//Make Uppercase
		   var command = '$EXT:'+ target + ':'+ value;			    //Build Syntax

		    var inputcmd = command.toString() + ":";                        //Add last :
		    var checksum = 0;                                               //Calculate XOR 8bit checksum
		      for(var i = 0; i < inputcmd.length; i++) {
		     checksum = checksum ^ inputcmd.charCodeAt(i);
			}
		     var hexsum = Number(checksum).toString(16).toUpperCase();
		    if (hexsum.length < 2) {
		     hexsum = ("00" + hexsum).slice(-2);
		     }
		    command = '#' + inputcmd + '*' + hexsum + '\n';
                return command;
        }


        function praseLine(line) {
            var tokens = line.split(':');                       //Split on split sign
            var positionValue = tokens[0] + tokens[2] + 'AAAA'; //Get the lengt until the start of the msg
	    var value = line.substring(positionValue.length, line.length-2);          //Get the messege
	    if (tokens.length >= 4) {
		return {
		    idname: tokens[0],
		    name: tokens[2],
		    value: value
		}
	    } else {
		return null;
	    }
        }
###
