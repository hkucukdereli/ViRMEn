#include <Encoder.h>
#include <TimeLib.h>

#define LED 13
#define STIM 12
#define PUNISH 11
#define LICK 10

Encoder myEnc(2,3);

byte *b;

long pos = 0;
long prevPos = 0;

//unsigned long previousMillis = 0;
const float sampling = 20;
const float interval = 1000.0 / sampling;
const long pulseDur = 1;

bool onPulse = false;
unsigned long rewardStart = 0;
unsigned long punishStart = 0;
unsigned long punishStop = 0;
bool onPunish = false;
int punishCount = 0;

// Initialize the LED as low
int ledState = LOW;
int stimState = HIGH;

unsigned long previousMillis = 0;
unsigned long previousTime = 0;

// Pulse length in ms 
const long pulse = 10;

// Frequency in Hz
const long freq = 20;

// on/off stimulation times in ms
const long onTime = 1000;
const long offTime = 3000;

// experiment durations in sec
const long preStim = 60 * 60;
const long onStim = 60 * 60;
const long  postStimm = 60 * 60;

bool onStimPulse = false;
unsigned long previousMillisP = 0;
unsigned long previousTimeP = 0;

void setup()
{  
  Serial.begin(115200);
  myEnc.write(0);
  pinMode(LED, OUTPUT);
  pinMode(STIM, OUTPUT);
  pinMode(PUNISH, OUTPUT);
}
void loop() {
  // read messages  
  char msg = Serial.read();
  switch (msg) {
    case 'O':
      // terminate stimulation
//      digitalWrite(STIM, LOW);
//      digitalWrite(LED, LOW);
      onStimPulse = false;
      break;
      
    case 'S':
      // initate stimulation
      rewardStart = millis();
//      digitalWrite(STIM, HIGH);
//      digitalWrite(LED, HIGH);
      onStimPulse = true;
      break;

    case 'P':
      // initate punishment timer
      punishStart = millis();
      digitalWrite(PUNISH, HIGH);
//      digitalWrite(LED, HIGH);
      onPunish = true;
      punishCount++;
      break;
    default:
      break;}
      
  pos = myEnc.read();

  //
  unsigned long currentMillis = millis();

  if (onStimPulse) {
    unsigned long currentMillisP = millis();
    unsigned long currentTimeP = now();
    
    if (currentTimeP - previousTimeP > onStim) {
      previousTimeP = now();
      if (stimState == HIGH) {
        stimState = LOW;}}
  
    if (stimState == HIGH) {
      if (ledState == LOW && currentMillisP - previousMillisP > offTime) {
        previousMillisP = millis();
        ledState = HIGH;}
      else if (ledState == HIGH && currentMillisP - previousMillisP > onTime) {
        previousMillisP = millis();
        ledState = LOW;}
        }
  
      if (stimState == HIGH && ledState == HIGH) {
//        digitalWrite(LED, HIGH);}
          // Pulse the LED
          digitalWrite(STIM, HIGH);
          digitalWrite(LED, HIGH);
          delay(pulse);
          digitalWrite(STIM, LOW);
          digitalWrite(LED, LOW);
          long int offPeriod = (1. / freq * 1000) - pulse;
          delay(offPeriod);}
      else if (stimState == HIGH && ledState == LOW) {
          digitalWrite(STIM, LOW);
          digitalWrite(LED, LOW);}
  }
    //

  if (!onPulse && currentMillis - previousMillis >= interval - pulseDur) {
    previousMillis = currentMillis;
    long vel = (pos - prevPos) / interval * 1000;
    b = (byte *) &vel;
    Serial.write(b, 4);
    prevPos = pos;
    onPulse = !onPulse;
    }

  if (onPulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    onPulse = !onPulse;
    }

  if (onPunish && punishCount == 1 && punishStart - millis() > 50) {
    digitalWrite(PUNISH, LOW);
    punishStop = millis();
    onPunish = false;
    punishCount++;}
  else if (!onPunish && punishCount == 2 && punishStop - millis() > 100) {
    digitalWrite(PUNISH, HIGH);
    punishStart = millis();
    onPunish = true;}
  else if (onPunish && punishCount == 2 && punishStart - millis()) {
    digitalWrite(PUNISH, HIGH);
    onPunish = false;
    punishCount = 0;}
      
}
