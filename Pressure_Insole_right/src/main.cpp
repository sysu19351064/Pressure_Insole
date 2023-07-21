/*********
  Rui Santos
  Complete project details at https://RandomNerdTutorials.com/esp-now-many-to-one-esp32/
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files.
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
*********/

/*
0 -> row2 -> out3 -> [0 0 0]
1 -> row6 -> out2 -> [0 0 1]
2- > row4 -> out1 -> [0 1 0]
3 -> row3 -> out4 -> [0 1 1]
4 -> row1 -> out5 -> [1 0 0]
5 -> row5 -> out6 -> [1 0 1]
7 -> out7 -> [1 1 0]
*/

#include <esp_now.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

// Replace with your network credentials
const char* ssid     = "INSOLE_DEVICE1";
const char* password = "insoledevice1";
String message = "000000000000000000000000";
const int row = 7;
bool ledState = 0;
const int ledPin = 2;
const int pinout[] = {19, 18, 5};

int arr[row][4];
int vo[row][4];
// int input[row][3] = {{1, 0, 0}, {0, 0, 0}, {0, 1, 1}, {0, 1, 0}, {1, 0, 1}, {0, 0, 1}, {1, 1, 0}};
int input[row][3] = {{1, 0, 0}, {0, 0, 0}, {0, 1, 1}, {0, 1, 0}, {1, 0, 1}, {0, 0, 1}, {1, 1, 0}}; 
int i = 0;
bool mode_ap = true;
int channel = 0;
String message_recv;
// Create AsyncWebServer object on port 80
AsyncWebServer server(80);
AsyncWebSocket ws("/ws");

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
    var jsonResponse = event.data;
    document.getElementById("r61").innerHTML = jsonResponse[20]-48;
    document.getElementById("r62").innerHTML = jsonResponse[21]-48;
    document.getElementById("r63").innerHTML = jsonResponse[22]-48;
    document.getElementById("r64").innerHTML = jsonResponse[23]-48;

    document.getElementById("r51").innerHTML = jsonResponse[16]-48;
    document.getElementById("r52").innerHTML = jsonResponse[17]-48;
    document.getElementById("r53").innerHTML = jsonResponse[18]-48;
    document.getElementById("r54").innerHTML = jsonResponse[19]-48;
    
    document.getElementById("r44").innerHTML = jsonResponse[15]-48;

    document.getElementById("r32").innerHTML = jsonResponse[9]-48;
    document.getElementById("r33").innerHTML = jsonResponse[10]-48;
    document.getElementById("r34").innerHTML = jsonResponse[11]-48;

    document.getElementById("r22").innerHTML = jsonResponse[5]-48;
    document.getElementById("r23").innerHTML = jsonResponse[6]-48;

    document.getElementById("r12").innerHTML = jsonResponse[1]-48;
    document.getElementById("r13").innerHTML = jsonResponse[2]-48;
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


// Structure example to send data
// Must match the receiver structure
typedef struct struct_message {
    int id; // must be unique for each sender board
    char text[25];
} struct_message;

// Create a struct_message called myData
struct_message myData;

// Create a structure to hold the readings from each board
struct_message board1;
// struct_message board2;
// struct_message board3;

// Create an array with all the structures
// struct_message boardsStruct[3] = {board1, board2, board3};


void notifyClients() {
  // String results_json = "{ \"r61\": " + String(arr[5][0]) +
  //                        "," + "\"r62\": " + String(arr[5][1]) +
  //                        "," + "\"r63\": " + String(arr[5][2]) +
  //                        "," + "\"r64\": " + String(arr[5][3]) +
  //                        "," + "\"r51\": " + String(arr[4][0]) +
  //                        "," + "\"r52\": " + String(arr[4][1]) +
  //                        "," + "\"r53\": " + String(arr[4][2]) +
  //                        "," + "\"r54\": " + String(arr[4][3]) +
  //                        "," + "\"r44\": " + String(arr[3][3]) +
  //                        "," + "\"r32\": " + String(arr[2][1]) +
  //                        "," + "\"r33\": " + String(arr[2][2]) +
  //                        "," + "\"r34\": " + String(arr[2][3]) +
  //                        "," + "\"r22\": " + String(arr[1][1]) +
  //                        "," + "\"r23\": " + String(arr[1][2]) +
  //                        "," + "\"r12\": " + String(arr[0][1]) +
  //                        "," + "\"r13\": " + String(arr[0][2]) + "}";
  // ws.textAll(results_json);
  ws.textAll(message_recv);
  // Serial.println(results_json);
}

void handleWebSocketMessage(void *arg, uint8_t *data, size_t len) {
  AwsFrameInfo *info = (AwsFrameInfo*)arg;
  if (info->final && info->index == 0 && info->len == len && info->opcode == WS_TEXT) {
    data[len] = 0;
    Serial.printf("text: %s\n", (char*)data);
    if (strcmp((char*)data, "toggle") == 0) {
      ledState = !ledState;
      Serial.println("FXXK!");
      digitalWrite(ledPin, ledState);
      // notifyClients();
    }
  }
}

void onEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type,
             void *arg, uint8_t *data, size_t len) {
  switch (type) {
    case WS_EVT_CONNECT:
      Serial.printf("WebSocket client #%u connected from %s\n", client->id(), client->remoteIP().toString().c_str());
      break;
    case WS_EVT_DISCONNECT:
      Serial.printf("WebSocket client #%u disconnected\n", client->id());
      break;
    case WS_EVT_DATA:
      handleWebSocketMessage(arg, data, len);
      break;
    case WS_EVT_PONG:
    case WS_EVT_ERROR:
      break;
  }
}

void initWebSocket() {
  ws.onEvent(onEvent);
  server.addHandler(&ws);
}

String processor(const String& var){
  Serial.println(var);
  if(var == "STATE"){
    if (ledState){
      return "ON";
    }
    else{
      return "OFF";
    }
  }
  return String();
}

// callback function that will be executed when data is received
void OnDataRecv(const uint8_t * mac_addr, const uint8_t *incomingData, int len) {
  char macStr[18];
  Serial.print("Packet received from: ");
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  Serial.println(macStr);
  memcpy(&myData, incomingData, sizeof(myData));
  Serial.printf("Board ID %u: %u bytes\n", myData.id, len);
  // Update the structures with the new incoming data
  
  Serial.printf("text: %s\n", myData.text);
  Serial.println();
  notifyClients();
}

void setup() {
  //Initialize Serial Monitor
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  //Set device as a Wi-Fi Station
  if(mode_ap){
    WiFi.mode(WIFI_AP_STA);
    WiFi.softAP(ssid, password, channel);
    Serial.print("Soft-AP IP address: ");
    Serial.println(WiFi.softAPIP());
    // WiFi.begin(ssid, password);
    Serial.print("Mac address: ");
    Serial.println(WiFi.macAddress());
  }
  else{
    WiFi.mode(WIFI_STA);
    // Connect to Wi-Fi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(1000);
      Serial.println("Connecting to WiFi..");
    }
    // Print ESP Local IP Address
    Serial.print("Station IP Address: ");
    Serial.println(WiFi.localIP());
    Serial.print("Wi-Fi Channel: ");
    Serial.println(WiFi.channel());
    Serial.print("Mac address: ");
    Serial.println(WiFi.macAddress());
  }

  for(int j = 0; j < 3; j++){
    pinMode(pinout[j], OUTPUT);
    digitalWrite(pinout[j], LOW);
  }

  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", index_html, processor);
  });

  initWebSocket();
  // Start server
  server.begin();

  //Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  // Once ESPNow is successfully Init, we will register for recv CB to
  // get recv packer info
  esp_now_register_recv_cb(OnDataRecv);
}

void loop() {
  // Acess the variables for each board
  int rate1 = 10;
  int rate2 = 1;
  int num = 0;
  ws.cleanupClients();
  digitalWrite(ledPin, ledState);
  for(i = 0; i < row; i++){
    for(int k = 0; k < 3; k++){
      // Serial.printf("%d ", input[i][k]);
      if(input[i][k] == 1){
        digitalWrite(pinout[k], HIGH);
      }
      else{
        digitalWrite(pinout[k], LOW);
      }
      delay(5);
    }
    // Serial.printf("\n");
    delay(5);
    vo[i][0] = analogRead(34);
    vo[i][1] = analogRead(35);
    vo[i][2] = analogRead(32);
    vo[i][3] = analogRead(33);
  }
  for(i = 0; i < row-1; i++){
    for(int k = 0; k < 4; k++){
      arr[i][k] = ((4097-vo[i][k])*rate1)/((4097-vo[row-1][k])*rate2);
      if(arr[i][k] > 20){
        arr[i][k] = 20;
      }
      message[num++] = char(arr[i][k]+48);
    }
    // Serial.printf("%s\n", message);
    // Serial.println(message);
  }
  message_recv = message + String(myData.text);
  // Serial.printf("len: %d\n", message_recv.length());
  // delay(10);
  notifyClients();
}

