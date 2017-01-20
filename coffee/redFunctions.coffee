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
  pattr = /^(#\$EXT:)[G|H|S|T|U|V|C|D]{1}:([A-Z0-9_]{1,8}(:[A-Za-z0-9\|\\]+)?)*:\*[\w]{2}$/
  pattr.exec(msg)

exports.checkIfValid = (msg) ->
  pattr = /^(\$EXT:)[G|H|S|T|U|V|C|D]{1}:([A-Z0-9_]{1,8}(:[A-Za-z0-9\|\\]+)?)+:$/
  pattr.exec(msg)

exports.parseLine = (msg) ->
#  pattr = /#(?:\@[\w]+)?\$(\w{1,8}):([G|H|S|T|U|V|C|D]):(\w+):([a-zA-Z0-9|=|+|/|\-|\\\:|\||,|&|:|\(|\))]+)?:(\*[A-Z0-9]{2})?/
  pattr = /#(?:\@[\w]+)?\$(\w{1,8}):([G|H|S|T|U|V|C|D]):([\w|_]+):(.+)?:?(\*[A-Z0-9]{2})?/
  res = pattr.exec(msg)
  if !res
    console.log("NOT matched msg with regEx: #{msg}")
  return res


exports.gValues = ["CAMFWVER","CAMID","CAMINFO","CAMNAME","CAMSER","RCPVER","RCPPSVER","TARGETID","GROUPID","HDRFACT","HDRMODE","MMSHCOLR","MMSHTIME","MMSHANGL","SHANGLE","SHANGLET","SHDISP","SHMODE","SHTIME","SHTIMET","COLTMP","COLTMPP","CSPACE","GSPACE","ISO","RAWMODE","RCURVE","GCURVE","BCURVE","LCURVE","REDG","BLUEG","GREENG","HDRXMONX","SATURAT","CONTRST","BRIGHT","EXPCOMP","FLUT","SHADOW","TINT","ACES","BGAIN","BGAMMA","BLIFT","GGAIN","GGAMMA","GLIFT","RGAIN","RGAMMA","RLIFT","APERCTRL","APRTR","LDISPM","FLENGTH","FOCSCTRL","FOCUS","FOCUSF","FOCUSN","LENSFDMD","SHRCKDST","MMMODE","MMMISOND","MMNDV","MMNDMODE","ZEBRA1","ZEBRA1LO","ZEBRA1HI","ZEBRA2","ZEBRA2LO","ZEBRA2HI","F0MODE","F0SCL","F0OFFSX","F0OFFSY","F0LNST","F0COLOR","F0OPAC","F0NUM","F0ABSXOF","F0ABSYOF","F0ABSW","F0ABSH","F1MODE","F1SCL","F1OFFSX","F1OFFSY","F1LNST","F1COLOR","F1OPAC","F1NUM","F1ABSXOF","F1ABSYOF","F1ABSW","F1ABSH","F1RELF0","F2MODE","F2SCL","F2OFFSX","F2OFFSY","F2LNST","F2COLOR","F2OPAC","F2NUM","F2ABSXOF","F2ABSYOF","F2ABSW","F2ABSH","F2RELF0","CGGUIDE","CGCOLOR","CGOPAC","GGGUIDE","GGCOLOR","GGOPAC","SHGUIDE","SHCOLOR","SHOPAC","TCDMODE","FALSEC","HORIZON","CAMERAOP","CAMLOC","CAMMEID","CAMPOS","CAMSCENE","CAMTAKE","CAMUNIT","DIRECTOR","DOPNAME","PRODUCTN","PROJINFO","FORMAT2","GENLOC","MAXRC","MAXSHA","MAXSHT","MINRC","MINSHA","MINSHT","FRPRMODE","FRPRNUM","PROJFPS","RCTARGET","REDCODE","RECMODE","PRERECDR","PRERECON","RECLIMEN","RECLIMFR","RECTLRF","RECTLINT","RECPRE","RECPOST","SENSFPS","MINFPS","MAXFPS","SUNC","SHSYNC","GENSRC","VRISPDMD","PLAYBACK","RECORD","CLIPNAME","CLIPNMST","MEDACLI","MEDACLPC","MEDAGCII","MEDIAPCT","MEDIAMIN","MEDIAMOD","MLABEL","PLABEL","BATTMODE","BATTRTM","PWRBATL","PWRSRC","PSLEVEL1","PSLEVEL2","PSLEVEL3","TCJAM","TCSOURCE","RIGSTATE","NWSTAT","FSMODE","RECFS","PREVFS","FPRDELAY","NOTIFY","FANTRGTT","FANPCTT","FANPCTF","TWARN1","TWARN2","TWARN3","TPATTERN","TPATTONE","CALSTAT","EVFTALLY","GEIPADDR","GENETMSK","GEGWADDR","GEDHCP","GEC2C","GEEXT","SERPROTO","GPIN","GPOUT","FMTREELN","FMTCAMID","FMTCAMPO","TARGET","DATETIME","TIMEZONE","BEEPEN","BEEPREC","BEEPSTOP","BEEPTAGS","HISTTYPE","RCLIP","GCLIP","BCLIP","CH12SRC","CH34SRC","CH12ILNK","CH34ILNK","CH12OLNK","CH34OLNK","CH12ST","CH34ST","VUSRC","CH1MODE","CH2MODE","CH3MODE","CH4MODE","CH1NAME","CH2NAME","CH3NAME","CH4NAME","CH1GAIN","CH2GAIN","CH3GAIN","CH4GAIN","CH1VOL","CH2VOL","CH3VOL","CH4VOL","CH1LIMIT","CH2LIMIT","CH3LIMIT","CH4LIMIT","CH1LIMPR","CH2LIMPR","CH3LIMPR","CH4LIMPR","CH1_48V","CH2_48V","CH3_48V","CH4_48V","CH1_48VP","CH2_48VP","CH3_48VP","CH4_48VP","MAGNIFY","BHDSDIEN","PHDS1EN","PHDS2EN","LCDM","HDMIM","HDSDIM","PLCDM","PHDSDI1M","PHDSDI2M","EVFM","REVFM","BLCDOV","BHDMIOV","BHDSDIOV","PHDS1OV","PHDS2OV","PLCDOV","BEVFOV","REVFOV","HDMIR","HDSDIR","PHDSDI1R","PHDSDI2R","LCDF","HDMIF","PHDSDI1F","PHDSDI2F","HDSDIF","EVFF","PLCDF","REVFF","BLCDTL","BHDMITL","BHDSDITL","PLCDTL","PSDI1TL","PSDI2TL","BECFTL","REVFTL","BLCDFMSP","RLCDFMSP","BLCDFM","BLCDFM2","BHDMIFM","BHDSDIFM","PLCDFM","RLCDFM2","PSDI1FM","PSDI2FM","BEVFFM","REVFFM","BLCDVF","BHDMIVF","BHDSDIVF","PLCDVF","PSDI1VF","PSDI2VF","BEVFVF","REVFVF","BLCDFO","BHDMIFO","BHDSDIFO","PLCDFO","PSDI1FO","PDSI2FO","BEVFFO","REVFFO","BLCDDM","BHDMIDM","BHDSDIDM","PLCDDM","PSDI1DM","PSDI2DM","BEVFDM","REVFDM","BLCDBR","BEVFBR","PLCDBR","REVFBR","FUIBR","IMGSPCRV","LCDCV","HDMICV","HDSDICV","PLCDCV","PHDSD1CV","PHDSD2CV","EVFCV","REVFCV","AFMODE","AFZONE","AFSIZE","AFENHNCD","AFENHMON","AFENCONS","HCFOCUS","HCIRIS","HCZOOM","AEMODE","AEEVSHFT","AEMETERM","AESPEED","AESELECT","AELOCKAP","AELOCKEX","AWBMODE"];
exports.hValues = ["HDRFACT","HDRMODE","SHANGLE","SHDISP","SHMODE","SHTIME","COLTMP","CSPACE","GSPACE","ISO","REDG","BLUEG","GREENG","HDRXMONX","SATURAT","CONTRST","BRIGHT","EXPCOMP","FLUT","SHADOW","TINT","BGAIN","BGAMMA","BLIFT","GGAIN","GGAMMA","GLIFT","RGAIN","RGAMMA","RLIFT","APRTR","LDISPM","FLENGTH","FOCUS","LENSFDMD","SHRCKDST","MMMODE","MMMISOND","MMNDV","MMNDMODE","ZEBRA1LO","ZEBRA1HI","ZEBRA2LO","ZEBRA2HI","F0MODE","F0SCL","F0OFFSX","F0OFFSY","F0LNST","F0COLOR","F0OPAC","F1MODE","F1SCL","F1OFFSX","F1OFFSY","F1LNST","F1COLOR","F1OPAC","F2MODE","F2SCL","F2OFFSX","F2OFFSY","F2LNST","F2COLOR","F2OPAC","CGGUIDE","CGCOLOR","CGOPAC","GGGUIDE","GGCOLOR","GGOPAC","SHGUIDE","SHCOLOR","SHOPAC","TCDMODE","FALSEC","CAMMEID","CAMPOS","FORMAT2","FRPRMODE","FRPRNUM","PROJFPS","REDCODE","PRERECDR","RECMODE","SENSFPS","SHSYNC","GENSRC","MEDIAMOD","BATTMODE","PWRSRC","PSLEVEL1","PSLEVEL2","PSLEVEL3","TCSOURCE","FSMODE","RECFS","PREVFS","FPRDELAY","FANTRGTT","SERPROTO","GPIN","GPOUT","FMTCAMID","FMTCAMPO","TARGET","TIMEZONE","BEEPREC","BEEPSTOP","BEEPTAGS","HISTTYPE","CH12SRC","CH34SRC","VUSRC","CH1MODE","CH2MODE","CH3MODE","CH4MODE","CH1GAIN","CH2GAIN","CH3GAIN","CH4GAIN","CH1VOL","CH2VOL","CH3VOL","CH4VOL","MAGNIFY","MONPRTY","LCDM","HDMIM","HDSDIM","PLCDM","PHDSDI1M","PHDSDI2M","EVFM","REVFM","BLCDOV","BHDMIOV","BHDSDIOV","PHDS1OV","PHDS2OV","PLCDOV","BEVFOV","REVFOV","HDMIR","HDSDIR","PHDSDI1R","PHDSDI2R","LCDF","HDMIF","PHDSDI1F","PHDSDI2F","HDSDIF","EVFF","PLCDF","REVFF","BLCDBR","BEVFBR","PLCDBR","REVFBR","FUIBR","LCDCV","HDMICV","HDSDICV","PLCDCV","PHDSD1CV","PHDSD2CV","EVFCV","REVFCV","AFMODE","AFZONE","AFSIZE","AFENHMON","AFENCONS","AEMODE","AEEVSHFT","AEMETERM","AESPEED","AESELECT"];



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
