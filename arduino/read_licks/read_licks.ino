#define LICK_PIN 2

byte *b;

long lick = 0L;

unsigned int LickState = 0;
unsigned int LickCounter = 0;
unsigned int lastLickState = 0;


void setup() {  
  Serial.begin(115200);
  // Wait for serial port to connect
  while (!Serial) {
    ; // do nothing as you wait
    }
}


void loop() {
  unsigned int LickState = digitalRead(LICK_PIN);
  if (LickState != lastLickState) {
      if (LickState == HIGH) {
        LickCounter++;
        lick = 2L;
      }
      else {lick = 0L;}
  }
  else {lick = 0L;}
  lastLickState = LickState;

  b = (byte *) &lick;
  Serial.write(b, 2);
  delay(50);
}
