#include <Encoder.h>

#define LED 13
#define LICK 12
#define STIM 11

Encoder myEnc(2,3);

byte *b;

long pos = 0;
long prevPos = 0;

unsigned long previousMillis = 0;
const float sampling = 20;
const float interval = 1000.0 / sampling;
const long pulseDur = 1;

bool pulse = false;
unsigned long rewardStart = 0;
unsigned long shockStart = 0;
unsigned int shockState = 0;

void setup()
{  
  Serial.begin(115200);
  myEnc.write(0);
  pinMode(LED, OUTPUT);
  pinMode(STIM, OUTPUT);
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
    pulse = !pulse;
    }

  if (pulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    pulse = !pulse;
    }

  char msg = Serial.read();
  switch (msg) {
    case 'O':
      // terminate stimulation
      digitalWrite(STIM, LOW);
      digitalWrite(LED, LOW);
      break;
      
    case 'S':
      // initate stimulation
      rewardStart = millis();
      digitalWrite(STIM, HIGH);
      digitalWrite(LED, HIGH);
      break;
      
    default:
      break;
      }
      
}
