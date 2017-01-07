status = null
$(document).ready ->
  init()

init = () ->
  $.get("/settings", (data, status)->
    status = data
    loadWindows(status.nrOfConnections)
  )


loadWindows = (nrOfConnections) ->
  #Clear out the current windows
  $("#cameraControllers").text("")
  i = 1
  while i <= nrOfConnections
    console.log(i)
    #create a new Iframe for every camera availible
    $("#cameraControllers").append("
    <div class='panel panel-info cameraController'>
      <div class='panel-heading'>
        <b>Camera #{i}</b>
      </div>
      <div class='panel-body'>
        <form class=''>
          <div class='form-group'>
            <div class='input-group'>
              <div class='input-group-addon'>@</div>
              <input type='url' class='form-control input-sm' id='ip' placeholder='127.0.0.1'>
            </div>
            <div class='connectButtonDiv text-center'>
              <p><button type='button' class='btn btn-default btn-xs btn-block'>connect</button></p>
            </div>

            <div id='hiddenGroup#{i}'>
                <div class='text-center text-shadow'>
                  <p><small><kbd id='TC#{i}'>00:00:00:--</kbd></small></p>
                </div>
                <div class='row'>
                    <div class='col-xs-2 col-xs-offset-1'><p><span class='label label-default'>TC</span></p></div>
                    <div class='col-xs-3'><p><span class='label label-default'>GEN</span></p></div>
                    <div class='col-xs-3'><p><span class='label label-default'>SYNC</span></p></div>
                </div>
                <div class='row'>
                  <div class='col-xs-12 text-center'>
                    <p><button type='button' class='btn btn-default btn-xs'>pre-</button> <button type='button' class='btn btn-default btn-xs'>Record</button></p>
                  </div>
                </div>
                <small>
                <p>
                <div class='row'>
                    <div class='col-xs-3'><i class='glyphicon glyphicon-floppy-disk'></i></div>
                    <div class='col-xs-3'>100%</div>
                    <div class='col-xs-6 text-right'>xxx min</div>
                </div>
                <div class='row'>
                    <div class='col-xs-3'><i class='glyphicon glyphicon-flash'></i></div>
                    <div class='col-xs-3'>15,5V</div>
                    <div class='col-xs-6 text-right'>DC</div>
                </div>
                </p>
                <p>
                <div class='row'>
                    <div class='col-xs-3'>iso:</div>
                    <div class='col-xs-9'>15,5V</div>
                </div>
                <div class='row'>
                    <div class='col-xs-3'>iris:</div>
                    <div class='col-xs-9'>15,5V</div>
                </div>
                <div class='row'>
                    <div class='col-xs-3'>kelvin:</div>
                    <div class='col-xs-9'>3600</div>
                </div>
                <div class='row'>
                    <div class='col-xs-3'>tint:</div>
                    <div class='col-xs-9'>0</div>
                </div>
                </p>
                <p>
                <div class='row'>
                    <div class='col-xs-3'>FPS:</div>
                    <div class='col-xs-9'>23.987 FPS</div>
                </div>
                <div class='row'>
                    <div class='col-xs-3'>Shutter</div>
                    <div class='col-xs-9'>1/60</div>
                </div>
                </p>
                <div class='row'>
                    <div class='col-xs-12 text-center'>
                    <small>black level:</small>
                     <input type='range' id='shadow' min='-2000' max='2000' width='10px' class='slider' data-default-Value='0'><br>
                     <canvas id='histogramSmall' width='127' height='32' style='border:1px solid #FFFFFF;'></canvas><br>
                     <canvas id='vu' width='127' height='32'></canvas><br>
                    </div>
                  </div>
                <p>
                <div class='row'>
                    <div class='col-xs-12 text-center'><button type='button' class='btn btn-default btn-xs btn-warning'>EJECT</button>
                    <button type='button' class='btn btn-default btn-xs btn-warning'>FORMAT</button></div>
                </div>
                </p>
            </div>
          </div>
          </small>
        </form>
      </div>
    </div>
    ")
    i++
