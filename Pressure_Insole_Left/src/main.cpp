/*********
  Rui Santos
  Complete project details at https://RandomNerdTutorials.com/esp-now-many-to-one-esp32/
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files.
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
*********/

#include <esp_now.h>
#include <esp_wifi.h>
#include <WiFi.h>

// REPLACE WITH THE RECEIVER'S MAC Address
// uint8_t broadcastAddress[] = {0x0C, 0x8B, 0x95, 0x29, 0xBC, 0xA4};
uint8_t broadcastAddress[] = {0x3C, 0xE9, 0x0E, 0x8F, 0x66, 0xE4};
char ssid[] = "DESKTOP";
char password[] = "lhl160316";
int channel = 0;
bool mode_ap = false;

const int row = 7;
bool ledState = 0;
const int ledPin = 2;
const int pinout[] = {19, 18, 5};
// char sensor_read[] = "0000000000000000";
int input[row][3] = {{1, 0, 0}, {0, 0, 0}, {0, 1, 1}, {0, 1, 0}, {1, 0, 1}, {0, 0, 1}, {1, 1, 0}}; 
int arr[row][4];
int vo[row][4];
int i = 0;

// Structure example to send data
// Must match the receiver structure
typedef struct struct_message {
    int id; // must be unique for each sender board
    char text[25];
} struct_message;

// Create a struct_message called myData
struct_message myData;

// Create peer interface
esp_now_peer_info_t peerInfo;

// callback when data is sent
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  Serial.print("\r\nLast Packet Send Status:\t");
  Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}

void setup() {
  // Init Serial Monitor
  Serial.begin(115200);

  for(int j = 0; j < row; j++){
    pinMode(pinout[j], OUTPUT);
    digitalWrite(pinout[j], LOW);
  }

  // Set device as a Wi-Fi Station
  if(mode_ap){
    WiFi.mode(WIFI_AP);
    WiFi.softAP(ssid, password, channel);
    Serial.print("Soft-AP IP address: ");
    Serial.println(WiFi.softAPIP());
    // WiFi.begin(ssid, password);
    Serial.print("Mac address: ");
    Serial.println(WiFi.macAddress());
  }
  else{
    WiFi.mode(WIFI_STA);
    if(int32_t n = WiFi.scanNetworks()){
      for(uint8_t i = 0; i < n; i++){
        if(!strcmp(ssid, WiFi.SSID(i).c_str())){
          channel = WiFi.channel(i);
          break;
        }
      }
      WiFi.printDiag(Serial);
      esp_wifi_set_promiscuous(true);
      esp_wifi_set_channel(channel, WIFI_SECOND_CHAN_NONE);
      esp_wifi_set_promiscuous(false);
      WiFi.printDiag(Serial);
      Serial.printf("Find Channel %d!\n", channel);
    }
    else{
      Serial.printf("Find No WiFi!\n");
    }
  }
  
  // Init ESP-NOW
  if (esp_now_init() != ESP_OK) {
    Serial.println("Error initializing ESP-NOW");
    return;
  }
  // Once ESPNow is successfully Init, we will register for Send CB to
  // get the status of Trasnmitted packet
  esp_now_register_send_cb(OnDataSent);
  
  // Register peer
  memcpy(peerInfo.peer_addr, broadcastAddress, 6);
  peerInfo.channel = channel;  
  peerInfo.encrypt = false;
  
  // Add peer        
  if (esp_now_add_peer(&peerInfo) != ESP_OK){
    Serial.println("Failed to add peer");
    return;
  }
}

void loop() {
  int rate1 = 10;
  int rate2 = 1;
  int num = 0;
  myData.text[24] = '\0';
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
      myData.text[num++] = char(arr[i][k]+48);
    }
    // Serial.printf("%d %d %d %d\n", arr[i][0], arr[i][1], arr[i][2], arr[i][3]);
  }

  // Set values to send
  myData.id = 1;
  // Send message via ESP-NOW
  Serial.printf("%s\n", myData.text);
  esp_err_t result = esp_now_send(broadcastAddress, (uint8_t *) &myData, sizeof(myData));
  
  if (result == ESP_OK) {
    Serial.println("Sent with success");
  }
  else {
    Serial.println("Error sending the data");
  }
  delay(5);
}
