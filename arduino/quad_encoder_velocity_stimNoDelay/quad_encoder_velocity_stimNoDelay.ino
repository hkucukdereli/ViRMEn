#include <Encoder.h>
#include <TimeLib.h>

#define LED 13
#define STIM 12
#define LICK 10

Encoder myEnc(2,3);

byte *b;

long pos = 0;
long prevPos = 0;

//unsigned long previousMillis = 0;
const float sampling = 20;
const float interval = 1000.0 / sampling;
const long pulseDur = 1; // how long is the duration of pulsing

bool onPulse = false;
unsigned long rewardStart = 0;
unsigned long shockStart = 0;
unsigned int shockState = 0;

// Initialize the LED as low
int ledState = LOW;
int stimState = HIGH;
int pulseState = LOW;

unsigned long previousMillis = 0;
unsigned long previousTime = 0;
unsigned long pulsePrevTime = 0;

// Frequency in Hz
const long freq = 20;

// Pulse length in ms 
const long pulse = 10; // duration of an individual pulse in ms
long int offPeriod = (1. / freq * 1000) - pulse; // inter pulse interval

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
          unsigned long pulseTime = millis();
          if (!pulseState && pulseTime - pulsePrevTime > pulse) {
            digitalWrite(STIM, LOW);
            digitalWrite(LED, LOW);
            pulseState = HIGH;
            pulsePrevTime = millis();
            }
          if (pulseState && pulseTime - pulsePrevTime > offPeriod) {
            digitalWrite(STIM, HIGH);
            digitalWrite(LED, HIGH);
            pulseState = LOW;
            pulsePrevTime = millis();
            }
          }
          
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
      
}
