#include <TimeLib.h> // get it from https://github.com/PaulStoffregen/Time
#include <Encoder.h> // get it from https://github.com/PaulStoffregen/Encoder
#include <digitalWriteFast.h> // get it from: https://github.com/NicksonYap/digitalWriteFast

#define LED_PIN 13    // visual stim input from ML
#define STIM_PIN 9   // laser trigger pin
#define STIM_OUT 8   // copy of the laser pulses
#define PUNISH_PIN 10  // shock trigger pin
#define CAM_PIN 12    // camera trigger pin
#define CAM_OUT 11    // copy of the camera pulses
#define LICK_PIN 6    // lick input pin
#define REWARD_PIN 7  // reward trigger pin

Encoder myEnc(2,3);   // encoder is connected to interrupts 1&2

byte *b;

// sampling variables
const int sampling = 20;
const long interval = 1000L / sampling;
const int pulseDur = 10; // ms

// position variables
long pos = 0L;
long prevPos = 0L;

// speed variables
long vel = 0L;

// stimulation variables
const int stimFreq = 20; // Hz
const long stimInterval = 1000L / stimFreq;
const int stimDur = 1; // sec
const int stimPer = 3; // sec
const int pulseWidth = 10; // ms

// timing variables
unsigned long previousMillis = 0;
unsigned long previousTime = 0;
unsigned long triggerMillis = 0;
unsigned long rewardMillis = 0;
unsigned long punishMillis = 0;
unsigned int counter = 0;

// state variables
bool onPulse = false;
bool onStim = false;
bool onStimPulse = false;
bool onTrigger = false;
bool onPunish = false;
bool onPunishPulse = true;
bool onReward = false;
bool onRewardPulse = false;
bool onCam = false;

// punish variables
unsigned int punishPulse = 50; // ms. Shock trigger pulse.
unsigned int punishITI = 100; // ms. Shock iti.
unsigned int punishCount = 0;

// reward variables
unsigned int rewardPulse = 600; // ms. Single reward trigger pulse.
unsigned int rewardITI = 100; // ms. Reward iti.
unsigned int rewardCount = 0;

// debug or test mode
bool debug = false;
bool vrtest = false;

void setup()
{
  pinModeFast(LED_PIN, OUTPUT);
  pinModeFast(STIM_PIN, OUTPUT);
  pinModeFast(STIM_OUT, OUTPUT);
  pinModeFast(PUNISH_PIN, OUTPUT);
  pinModeFast(REWARD_PIN, OUTPUT);
  pinModeFast(CAM_PIN, OUTPUT);
  pinModeFast(CAM_OUT, OUTPUT);
  pinModeFast(LICK_PIN, INPUT);

  Serial.begin(115200);

  // Wait for serial port to connect
  while (!Serial) {
    ; // do nothing as you wait
    }
  if (debug) {Serial.println("Serial begins...");}
  myEnc.write(0); // Intialize the encoder with "0"
}

void loop() {
  // Every loop first read the tick position 
  pos = myEnc.read();
  
  // Time stamp the current loop
  unsigned long currentMillis = millis();
  unsigned long currentTime = now();

  // Check the serial for messages  
  char msg = Serial.read();
  switch (msg) {
    case 'B':
      if (debug) {Serial.println(msg);}
      // Enable cam pulsing
      onCam = true;
      break;
      
    case 'C':
      if (debug) {Serial.println(msg);}
      // Disable cam pulsing
      onCam = false;
      digitalWriteFast(CAM_PIN, LOW);
      digitalWriteFast(CAM_OUT, LOW);
      break;
      
    case 'S':
      if (debug) {Serial.println(msg);}
      // Initate stimulation protocol
      previousTime = now();
      onStim = true;
      onStimPulse = true;
      digitalWriteFast(LED_PIN, HIGH);
      break;

    case 'O':
      if (debug) {Serial.println(msg);}
      // Terminate stimulation protocol
      digitalWriteFast(STIM_PIN, LOW);
      digitalWriteFast(STIM_OUT, LOW);
      digitalWriteFast(LED_PIN, LOW);
      onStim = false;
      break;

    case 'T':
      if (debug) {Serial.println(msg);}
      // Terminate stimulation protocol
      digitalWriteFast(STIM_PIN, LOW);
      digitalWriteFast(STIM_OUT, LOW);
      digitalWriteFast(LED_PIN, LOW);
      onStim = false;
      break;
      
    case 'P':
      if (debug) {Serial.println(msg);}
      punishCount++;
      // Initate punishment protocol
      punishMillis = millis();
      onPunish = true;
      onPunishPulse = true;
      break;

    case 'R':
      if (debug) {Serial.println(msg);}
      rewardCount++;
      // Initate reward protocol
      rewardMillis = millis();
      onReward = true;
      onRewardPulse = true;
      break;

    default:
      break;
    }
    
  // speed estimation block starts
  if (!onPulse && currentMillis - previousMillis >= interval - pulseDur) {
    previousMillis = currentMillis;
    if (vrtest) {vel = pos;}
    else {
      vel = ((pos - prevPos) * 1000) / interval;
      if (vel < 0) {vel = 0;}
      else {vel = vel;}
      }
    b = (byte *) &vel;
    Serial.write(b, 4);
    if (onCam) {
      digitalWriteFast(CAM_PIN, HIGH); // trigger the camera
      digitalWriteFast(CAM_OUT, HIGH);
    }
    prevPos = pos;
    onPulse = !onPulse;
    }

  if (onPulse && currentMillis - previousMillis >= pulseDur) {
    previousMillis = currentMillis;
    if (onCam) {
      digitalWriteFast(CAM_PIN, LOW); // trigger the camera
      digitalWriteFast(CAM_OUT, LOW); // trigger the camera
    }
    onPulse = !onPulse;
    }
  // speed estimation block ends

  // Stimulation block starts
  // Initiate the stimulation protocol
  if (onStim) {
    // Allow stimulation for <stimDur> sec every <stimPer> seconds
    if (onStimPulse && currentTime - previousTime >= stimDur){
      previousTime = now();
      digitalWriteFast(LED_PIN, LOW);
      digitalWriteFast(STIM_PIN, LOW);
      digitalWriteFast(STIM_OUT, LOW);
      onTrigger = false;
      onStimPulse = false;
      }
    else if (!onStimPulse && currentTime - previousTime >= stimPer - stimDur) {
      previousTime = now();
      triggerMillis = millis();
      digitalWriteFast(LED_PIN, HIGH);
      onTrigger = true;
      onStimPulse = true;
      }

    // Pulse the laser if needed at <stimFreq>Hz
    if (onStimPulse) {
      if (onTrigger && currentMillis - triggerMillis >= stimInterval - pulseWidth) {
        triggerMillis = millis();
        digitalWriteFast(STIM_PIN, HIGH);
        digitalWriteFast(STIM_OUT, HIGH);
        onTrigger = false;
        }
      else if (!onTrigger && currentMillis - triggerMillis >= pulseWidth) {
        triggerMillis = millis();
        digitalWriteFast(STIM_PIN, LOW);
        digitalWriteFast(STIM_OUT, LOW);
        onTrigger = true;
        }
      }
    }
  // Stimulation block ends

  // Punish block starts
  if (onPunish) {
    if (onPunishPulse && currentMillis - punishMillis >= punishITI) {
          punishMillis = millis();
          digitalWriteFast(PUNISH_PIN, HIGH);
          counter++;
          onPunishPulse = false;
          }
    else if (!onPunishPulse && currentMillis - punishMillis >= punishPulse) {
          punishMillis = millis();
          digitalWriteFast(PUNISH_PIN, LOW);
          onPunishPulse = true;
          }
    // Terminate pulsing when the number of pulses is reached
    if (counter > punishCount) {
      digitalWriteFast(PUNISH_PIN, LOW);
      punishCount = 0;
      counter = 0;
      onPunish = false;
      }
    }
//  if(debug) {Serial.println(punishCount);}
  // Punish block ends

  // Reward block starts
  // Trigger a single reward of <rewardPulse>*<rewardCount> long
  if (onReward) {
    if (onRewardPulse && currentMillis - rewardMillis >= rewardITI) {
          rewardMillis = millis();
          digitalWriteFast(REWARD_PIN, HIGH);
          digitalWriteFast(LED_PIN, HIGH);
          counter++;
          onRewardPulse = false;
          }
    else if (!onRewardPulse && currentMillis - rewardMillis >= rewardPulse*rewardCount) {
          rewardMillis = millis();
          digitalWriteFast(REWARD_PIN, LOW);
          digitalWriteFast(LED_PIN, LOW);
          onRewardPulse = true;
          }
    // Terminate pulsing after a single reward delivery
    if (counter > 1) {
      digitalWriteFast(REWARD_PIN, LOW);
      digitalWriteFast(LED_PIN, LOW);
      rewardCount = 0;
      counter = 0;
      onReward = false;
      }
    }
  // Reward block ends

}
