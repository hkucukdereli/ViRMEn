#include <Encoder.h>

Encoder myEnc(2,3);

byte *b;

long pos = 0;
long prevPos = 0;

unsigned long previousMillis = 0;
const float sampling = 20;
const float interval = 1000.0 / sampling;
const long pulseDur = 1;

bool pulse = false;

void setup()
{  
  Serial.begin(115200);
  myEnc.write(0);
}
void loop() { 
  pos = myEnc.read();

  unsigned long currentMillis = millis();

  if (!pulse && currentMillis - previousMillis >= interval - pulseDur) {
    previousMillis = currentMillis;
    long vel = (pos - prevPos) / interval * 1000;
    b = (byte *) &vel;
    Serial.write(b, 4);
    prevPos = pos;
    pulse = !pulse;}

  if (pulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    pulse = !pulse;}
}
