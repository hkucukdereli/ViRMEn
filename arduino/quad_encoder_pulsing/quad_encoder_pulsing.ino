
// This is now the DUE version 

#include <Encoder.h>

Encoder myEnc(2,3); // pick your pins, reverse for sign flip

bool pulsing = false;
unsigned long int pulsetime = 0;
unsigned long int now;

void setup() {
  Serial.begin(9600);
  //SerialUSB.begin(115200); // for real-time feedback
  myEnc.write(0);
  
  pinMode(12, OUTPUT);
  digitalWrite(12, LOW);
}

void loop() {
  long pos;
  byte *b,m;
  
  now = millis();
  if (pulsing && now - pulsetime > 50) {
    pulsing = false;
    digitalWrite(12, LOW);
  }

  // b = (byte *) &pos;  
  pos = myEnc.read();

  if (Serial.available()) {
    m = Serial.read();
    if(m>0) {
      myEnc.write(0);    // zero the position
      pos = 0;
    } 
    else {
      Serial.write((byte *) &pos, 4);
      pulsing = true;
      digitalWrite(12, HIGH);
      pulsetime = now;
    }
  }

  //if(SerialUSB.available()) {
  //  SerialUSB.read();
  //  SerialUSB.write((byte *) & pos,4);
  //}
  
}



