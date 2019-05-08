#include <Encoder.h>

Encoder myEnc(2,3);

byte *b;

long pos = 0;
long prevPos = 0;

const int VISSTIM = 13;
const int OUTPIN = 11;

unsigned long previousMillis = 0;
const float sampling = 40;
const float interval = 1000.0 / sampling;
const long pulseDur = 1;
const int  samplingDur = 100;
const int bufferLen = (samplingDur / interval) + 1;
float bufferArr[bufferLen];
int pulseCount = 0;

float beforeVel = 0.0;
float afterVel = 0.0;
unsigned long tic0 = 0;
unsigned long toc0 = 0;
bool postStim = 0;

bool pulse = false;
bool pulseState = 0;

void setup()
{  
  pinMode(VISSTIM, INPUT);
  pinMode(OUTPIN, OUTPUT);
  
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
//    Serial.write(b, 4);
//    Serial.println(vel);
    bufferArr[pulseCount] = vel;
    pulseCount++;
    if (pulseCount > bufferLen) {
      pulseCount = 0;
      }
    prevPos = pos;
    pulse = !pulse;}

  if (pulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    pulse = !pulse;}

  float velSum = 0;
  for (int i=0; i < bufferLen; i++) {
    velSum = velSum + bufferArr[i];
    }
  float averageVel = velSum / bufferLen;
//  Serial.println(averageVel);

  bool VisStim = digitalRead(VISSTIM);
  if (!pulseState && VisStim) {
    // Rising
    pulseState = 1;
    beforeVel = averageVel;
//    Serial.println("rising");
    }
//  else if (!pulseState && !VisStim) {
//    // Low
//    Serial.println("low");
//    }
//  else if (pulseState && VisStim) {
//    // High
//    Serial.println("high");
//    }
  else if (pulseState && !VisStim) {
    // Falling
    pulseState = 0;
//    Serial.println("falling");
    tic0 = millis();
    postStim = 1;    
    }

  toc0 = millis();
  if (postStim && toc0 - tic0 > samplingDur) {
    afterVel = averageVel;
    postStim = 0;
//    Serial.println(afterVel - beforeVel);
    if (afterVel - beforeVel > 0.25
    ) {
      digitalWrite(OUTPIN, HIGH);
      delay(50);
      digitalWrite(OUTPIN, LOW);
      }
    
//    Serial.println(beforeVel);
//    Serial.println(afterVel);
    }
  
}
