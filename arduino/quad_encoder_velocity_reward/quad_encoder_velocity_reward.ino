#include <Encoder.h>

#define LED 13
#define LICK 12
#define SHOCK 11
#define REWARD 10

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
  pinMode(REWARD, OUTPUT);
  pinMode(SHOCK, OUTPUT);
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
      break;
    case 'R':
      // initate reward sequence
      rewardStart = millis();
      digitalWrite(REWARD, HIGH);
      digitalWrite(LED, HIGH);
      break;
    case 'S':
      // initate shock sequence
      shockStart = millis();
      digitalWrite(SHOCK, HIGH);
      digitalWrite(LED, HIGH);
      shockState = 1;
      break;
    default:
      break;
      }

    // that's enough reward
    if (millis() - rewardStart > 500) {
      digitalWrite(REWARD, LOW);
      digitalWrite(LED, LOW);
      }

    if (shockState == 1 & millis() - shockStart > 500) {
      shockStart = millis();
      digitalWrite(SHOCK, LOW);
      digitalWrite(LED, LOW);
      shockState = 2;
      }

    if (shockState == 2 & millis() - shockStart > 1000) {
      shockStart = millis();
      digitalWrite(SHOCK, HIGH);
      digitalWrite(LED, HIGH);
      shockState = 3;
      }

    if (shockState == 3 & millis() - shockStart > 500) {
      digitalWrite(SHOCK, LOW);
      digitalWrite(LED, LOW);
      shockState = 0;
      }
      
}
