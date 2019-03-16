#include <Encoder.h>

Encoder myEnc(2,3);

const int PIN_VSTIM = 7;
unsigned int lastVStimState = 0;
unsigned int VStimCounter = 0;

byte *b;

long pos = 0;
long prevPos = 0;
long vel = 0;

unsigned long previousMillis = 0;
const float sampling = 20; //Hz
const float interval = 1000.0 / sampling;
const long pulseDur = 1;

bool pulse = false;

long velArr[10];
long baseVel = 0.0;
int counter = 0;
int baseline = 0;

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
    vel = (pos - prevPos) / interval * 1000;
    b = (byte *) &vel;
    Serial.write(b, 4);
    prevPos = pos;
    pulse = !pulse;
    }

  if (pulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    pulse = !pulse;
    }

  unsigned int VStimState = digitalRead(PIN_VSTIM);
  if (VStimState == HIGH && lastVStimState == LOW) {
    baseline = 1;
    }
  else if (VStimState == LOW && lastVStimState == HIGH) {
    for (i=0; i < 10; i++) {
      baseVel += velArr[i];
      }
    baseVel = baseVel / 10;
    
    baseline = 2;
    }
  lastVStimState = VStimState;

  if (baseline == 1) {
    velArr[counter%10] = vel;
    counter++;
    }

  if (baseline == 2) {
    }

}
