const char index_html[] PROGMEM = R"rawliteral(
<!DOCTYPE HTML><html>
<head>
  <title>ESP Web Server</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" href="data:,">
  <style>
  html {
    font-family: Arial, Helvetica, sans-serif;
    text-align: center;
  }
  h1 {
    font-size: 1.8rem;
    color: white;
  }
  h2{
    font-size: 1.5rem;
    font-weight: bold;
    color: #143642;
  }
  .topnav {
    overflow: hidden;
    background-color: #143642;
  }
  body {
    margin: 0;
  }
  .content {
    padding: 30px;
    max-width: 600px;
    margin: 0 auto;
  }
  .card {
    background-color: #F8F7F9;;
    box-shadow: 2px 2px 12px 1px rgba(140,140,140,.5);
    padding-top:10px;
    padding-bottom:20px;
  }
  .button {
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
   .state {
     font-size: 1.5rem;
     color:#8c8c8c;
     font-weight: bold;
   }
  </style>
<title>ESP Web Server</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" href="data:,">
</head>
<body>
  <div class="topnav">
    <h1>ESP WebSocket Server</h1>
  </div>
  <div class="content">
    <div class="card">
      <h2>
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
      <p class="state">state: <span id="state">%STATE%</span></p>
      <p><button id="button" class="button">Toggle</button></p>
    </div>
  </div>
<script>
  var gateway = `ws://${window.location.hostname}/ws`;
  var websocket;
  window.addEventListener('load', onLoad);
  function initWebSocket() {
    console.log('Trying to open a WebSocket connection...');
    websocket = new WebSocket(gateway);
    websocket.onopen    = onOpen;
    websocket.onclose   = onClose;
    websocket.onmessage = onMessage; // <-- add this line
  }
  function onOpen(event) {
    console.log('Connection opened');
  }
  function onClose(event) {
    console.log('Connection closed');
    setTimeout(initWebSocket, 2000);
  }
  function onMessage(event) {
    var jsonResponse = event.data
    document.getElementById("r61").innerHTML = jsonResponse[20];
    document.getElementById("r62").innerHTML = jsonResponse[21];
    document.getElementById("r63").innerHTML = jsonResponse[22];
    document.getElementById("r64").innerHTML = jsonResponse[23];

    document.getElementById("r51").innerHTML = jsonResponse[16];
    document.getElementById("r52").innerHTML = jsonResponse[17];
    document.getElementById("r53").innerHTML = jsonResponse[18];
    document.getElementById("r54").innerHTML = jsonResponse[19];
    
    document.getElementById("r44").innerHTML = jsonResponse[15];

    document.getElementById("r32").innerHTML = jsonResponse[9];
    document.getElementById("r33").innerHTML = jsonResponse[10];
    document.getElementById("r34").innerHTML = jsonResponse[11];

    document.getElementById("r22").innerHTML = jsonResponse[5];
    document.getElementById("r23").innerHTML = jsonResponse[6];

    document.getElementById("r12").innerHTML = jsonResponse[1];
    document.getElementById("r13").innerHTML = jsonResponse[2];
  }
  function onLoad(event) {
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