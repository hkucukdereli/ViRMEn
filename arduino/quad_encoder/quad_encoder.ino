
// This is now the DUE version 

#include <Encoder.h>

Encoder myEnc(2,3); // pick your pins, reverse for sign flip

void setup() {
  Serial.begin(115200);
  //SerialUSB.begin(115200); // for real-time feedback
  myEnc.write(0);
}

void loop() {
  long pos;
  byte *b,m;

  b = (byte *) &pos;  
  pos = myEnc.read();

  if (Serial.available()) {
    m = Serial.read();
    if(m>0) {
      myEnc.write(0);    // zero the position
      pos = 0;
    } 
    else {
      Serial.write((byte *) &pos,4);
    }
  }

  //if(SerialUSB.available()) {
  //  SerialUSB.read();
  //  SerialUSB.write((byte *) & pos,4);
  //}
  
}
