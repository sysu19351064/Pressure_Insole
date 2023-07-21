const char MAIN_page[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html>
<style>
.card{
    max-width: 400px;
     min-height: 250px;
     background: #02b875;
     padding: 30px;
     box-sizing: border-box;
     color: #FFF;
     margin:20px;
     box-shadow: 0px 2px 18px -4px rgba(0,0,0,0.75);
}
.button{
    padding: 15px 50px;
    font-size: 24px;
    text-align: center;
    outline: none;
    color: #fff;
    background-color: #0f8b8d;
    border: none;
    border-radius: 5px;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    -webkit-tap-highlight-color: rgba(0,0,0,0);
}
/*.button:hover {background-color: #0f8b8d}*/
.button:active {
    background-color: #0f8b8d;
    box-shadow: 2 2px #CDCDCD;
    transform: translateY(2px);
}
</style>
<body>

<div class="card">
  <h4>The ESP32 Update web page without refresh</h4><br>
  <h2>Row Index:<span id="row">0</span>
  <table border="1">
  <tr>
    <td> R6_1 <span id="r61">0.0</span></td>
    <td> R6_2 <span id="r62">0.0</span></td>
    <td> R6_3 <span id="r63">0.0</span></td>
    <td> R6_4 <span id="r64">0.0</span></td>
  </tr>
  <tr>
    <td> R5_1 <span id="r51">0.0</span></td>
    <td> R5_2 <span id="r52">0.0</span></td>
    <td> R5_3 <span id="r53">0.0</span></td>
    <td> R5_4 <span id="r54">0.0</span></td>
  </tr>
  <tr>
    <td> R4_1 <span id="r41">None</span></td>
    <td> R4_2 <span id="r42">None</span></td>
    <td> R4_3 <span id="r43">None</span></td>
    <td> R4_4 <span id="r44">0.0</span></td>
  </tr>
  <tr>
    <td> R3_1 <span id="r31">None</span></td>
    <td> R3_2 <span id="r32">0.0</span></td>
    <td> R3_3 <span id="r33">0.0</span></td>
    <td> R3_4 <span id="r34">0.0</span></td>
  </tr>
  <tr>
    <td> R2_1 <span id="r21">None</span></td>
    <td> R2_2 <span id="r22">0.0</span></td>
    <td> R2_3 <span id="r23">0.0</span></td>
    <td> R2_4 <span id="r24">None</span></td>
  </tr>
  <tr>
    <td> R1_1 <span id="r11">None</span></td>
    <td> R1_2 <span id="r12">0.0</span></td>
    <td> R1_3 <span id="r13">0.0</span></td>
    <td> R1_4 <span id="r14">None</span></td>
  </table>
  </h2>
</div>

<script>
  var gateway = 'ws://${window.location.hostname}/ws';
  var wevsocket
  window.addEventListener('load', onLoad);
  function initWebSocket() {
    console.log('Trying to open a WebSocket connection...');
    websocket = new WebSocket(gateway);
    websocket.onopen    = onOpen;
    websocket.onclose   = onClose;
    websocket.onmessage = onMessage; // <-- add this line
  }

  function onOpen(event){
    console.log('Connection opened');
    websocket.send('hi');
  }

  function onClose(event){
    console.log('Connection closed');
    setTimeout(initWebSocket, 2000);
  }

  function onMessage(event){
    var jsonResponse = JSON.parse(event.data);
    document.getElementById("r61").innerHTML = jsonResponse.r61;
    document.getElementById("r62").innerHTML = jsonResponse.r62;
    document.getElementById("r63").innerHTML = jsonResponse.r63;
    document.getElementById("r64").innerHTML = jsonResponse.r64;

    document.getElementById("r51").innerHTML = jsonResponse.r51;
    document.getElementById("r52").innerHTML = jsonResponse.r52;
    document.getElementById("r53").innerHTML = jsonResponse.r53;
    document.getElementById("r54").innerHTML = jsonResponse.r54;
    
    document.getElementById("r44").innerHTML = jsonResponse.r44;

    document.getElementById("r32").innerHTML = jsonResponse.r32;
    document.getElementById("r33").innerHTML = jsonResponse.r33;
    document.getElementById("r34").innerHTML = jsonResponse.r34;

    document.getElementById("r22").innerHTML = jsonResponse.r22;
    document.getElementById("r23").innerHTML = jsonResponse.r23;

    document.getElementById("r12").innerHTML = jsonResponse.r12;
    document.getElementById("r13").innerHTML = jsonResponse.r13;
  }

  function onLoad(event){
    initWebSocket();
    initButton();
  }

  function initButton() {
    document.getElementById('button').addEventListener('click', toggle);
  }

  function toggle(){
    websocket.send('toggle');
  }

</script>
</body>
</html>
)rawliteral";

