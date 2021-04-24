
//#define XDEBUG

#define USE_LINE_BUFFER  // Enable for faster rendering

#include <FS.h>
#include <SD.h>
#include <TFT_eSPI.h>			// Hardware-specific library
#include "U8g2_for_TFT_eSPI.h"		// Display Library
TFT_eSPI tft = TFT_eSPI();		// Invoke custom library
U8g2_for_TFT_eSPI u8f;       // U8g2 font instance

#include <TFT_eFEX.h>              // Include the extension graphics functions library  https://github.com/Bodmer/TFT_eFEX
TFT_eFEX  fex = TFT_eFEX(&tft);    // Create TFT_eFX object "efx" with pointer to "tft" object

#include <AnimatedGIF.h>
AnimatedGIF gif;

// ------------ Variables ----------------

// Strings
String newCore = "";             // Received Text, from MiSTer without "\n\r" currently (2021-01-11)
String oldCore = "";             // Buffer String for Text change detection
String picfnam = "";
int baudrate = 115200;           // 115200, 921600
#define DispWidth tft.width()
#define DispHeight tft.height()


// ================ SETUP ==================
void setup(void) {
  // Init Serial
  Serial.begin(baudrate);          // 115200 for MiSTer ttyUSBx Device CP2102 Chip on ESP32

  // Set all chip selects high to avoid bus contention during initialisation of each peripheral
  digitalWrite(22, HIGH); // Touch controller chip select (if used)
  digitalWrite(15, HIGH); // TFT screen chip select
  digitalWrite( 5, HIGH); // SD card chips select, must use GPIO 5 (ESP32 SS)

  // Init Random Generator with empty Analog Port value
  randomSeed(analogRead(34));

  // Init Display
  tft.begin();
  tft.setRotation(1);   // landscape
  tft.fillScreen(random(TFT_BLACK));
  tft.setSwapBytes(true);                    // Swap the colour byte order when rendering

  u8f.begin(tft);
  if (!SD.begin()) {
    tft.drawString("Card Mount Failed", 10, 20);
    return;
  }
}

// ================ MAIN LOOP ===================
void loop(void) {
  if (Serial.available()) {
    newCore = Serial.readStringUntil('\n');                  // Read string from serial until NewLine "\n" (from MiSTer's echo command) is detected or timeout (1000ms) happens.

  #ifdef XDEBUG
    Serial.printf("Received Corename or Command: %s\n", (char*)newCore.c_str());
    tft.drawString("Received Corename or Command: %s\n", (char*)newCore.c_str(), 10, 10);
  #endif
  }  // end serial available

  if (newCore!=oldCore) {                                    // Proceed only if Core Name changed
    // Many if an elses as switch/case is not working (maybe later with an array).

    // -- First Transmission --
    if (newCore.endsWith("QWERTZ")) {                        // TESTING: Process first Transmission after PowerOn/Reboot.
        // Do nothing, just receive one string to clear the buffer.
    }                    

    // -- Test Commands --
    else if (newCore=="cls")          tft.fillScreen(TFT_BLACK);
    else if (newCore=="red")          tft.fillScreen(TFT_RED);
//    else if (newCore=="sorg")         oled_mistertext();
//    else if (newCore=="bye")          oled_drawlogo64h(sorgelig_icon64_width, sorgelig_icon64);
    else if (SD.exists(picfnam)) {                                // Boot-Splash Animation
      String picfnam = String("/" + newCore + ".gif");
      gifPlay((char*)picfnam.c_str());
      gif.reset();
      picfnam = String("/" + newCore + "-static.gif");     // wenn auch ein *-static.gif existiert, dieses permanent anzeigen (Logo)
      if (SD.exists(picfnam)) {
        gifPlay((char*)picfnam.c_str());
        gif.reset();
      }
    }
    // -- Unidentified Core Name, just write it on screen
    else {
      tft.fillScreen(TFT_BLACK);
      u8f.setFontMode(0);
      u8f.setForegroundColor(random(0xFFFF));
      //u8f.setFont(u8g2_font_logisoso50_tf);
      u8f.setFont(u8g2_font_inr33_mf);
      int x = 321;
      while (x >= -270) {
        u8f.setCursor(x, 135);
        u8f.print("Loading... ");
        x--;
      }
      delay(1000);
      unsigned int StringLength = newCore.length();
      u8f.setCursor(DispWidth/2-(StringLength*13), 135);
      u8f.print(newCore);
    }  // end ifs
    oldCore=newCore;         // Update Buffer
  } // end newCore!=oldCore
} // End Main Loop


//========================== End of main routines ================================
