
const int SERIAL_COMM_SPEED = 9600; //Bits per second to send serial data.
const int SERIAL_COMM_POST_DELAY = 500; //Milliseconds to delay after sending SERIAL_COMM_MSG_BTN_PRESSED before continuing execution.

const String SERIAL_COMM_MSG_PING = "btnping"; //Sent by the computer to detect this device.
const String SERIAL_COMM_MSG_PONG = "btnpong"; //Send by the arduino to the computer to acknoledge the ping.
const String SERIAL_COMM_MSG_BTN_PRESSED = "btnpressed"; //Serial data to send when the button is pressed.
const String SERIAL_COMM_MSG_STOP = "STOP"; //Sent at the end of every command to indicate that the command is complete

const int PIN_LED = 13;

void setup() {
    Serial.begin(SERIAL_COMM_SPEED);
    while(!Serial) {
      //Wait
    }
    pinMode(PIN_LED, OUTPUT); 
    
    digitalWrite(PIN_LED, LOW);
}

void loop() {
  //Check for serial input
  readSerialData();
  
  onBtnPress();
}


void onBtnPress() {
//  sendSerialData(SERIAL_COMM_MSG_BTN_PRESSED);
}

void readSerialData() {
  while (Serial.available() > 0) {
    digitalWrite(PIN_LED, HIGH);
    
    // read the incoming byte:
    int incomingByte = Serial.read() - 48; //Convert to ASCII
    sendSerialData(incomingByte);
  }
}

void sendSerialData(String data) {
  Serial.print(data);
  Serial.print(SERIAL_COMM_MSG_STOP);
  delay(SERIAL_COMM_POST_DELAY);
}
