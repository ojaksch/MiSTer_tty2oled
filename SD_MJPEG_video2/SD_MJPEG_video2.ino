#define MJPEG_FILENAME "/320_25fps.mjpeg"
#define MJPEG_BUFFER_SIZE (320 * 240 * 2 / 4)
#include <WiFi.h>
#include <SD.h>
#include <SD_MMC.h>

#include <Arduino_GFX_Library.h>
#define TFT_BRIGHTNESS 128

Arduino_DataBus *bus = new Arduino_ESP32PAR8(15 /* DC */, 33 /* CS */, 4 /* WR */, 2 /* RD */, 12 /* D0 */, 13 /* D1 */, 26 /* D2 */, 25 /* D3 */, 17 /* D4 */, 16 /* D5 */, 27 /* D6 */, 14 /* D7 */);
Arduino_ILI9341 *gfx = new Arduino_ILI9341(bus, 32 /* RST */, 1 /* rotation */);

#include "MjpegClass.h"
static MjpegClass mjpeg;

void setup()
{
  WiFi.mode(WIFI_OFF);
  Serial.begin(115200);

  // Init Video
  gfx->begin();
  gfx->fillScreen(BLACK);

#ifdef TFT_BL
  ledcAttachPin(TFT_BL, 1);     // assign TFT_BL pin to channel 1
  ledcSetup(1, 12000, 8);       // 12 kHz PWM, 8-bit resolution
  ledcWrite(1, TFT_BRIGHTNESS); // brightness 0 - 255
#endif

  // Init SD card
  if (!SD.begin())
  // if (!SD.begin(SS, SPI, 80000000)) /* SPI bus mode */
  // if ((!SD_MMC.begin()) && (!SD_MMC.begin())) /* 4-bit SD bus mode */
  // if ((!SD_MMC.begin("/sdcard", true)) && (!SD_MMC.begin("/sdcard", true))) /* 1-bit SD bus mode */
  {
    Serial.println(F("ERROR: SD card mount failed!"));
    gfx->println(F("ERROR: SD card mount failed!"));
  }
  else
  {
    File vFile = SD.open(MJPEG_FILENAME);
    // File vFile = SD_MMC.open(MJPEG_FILENAME);
    if (!vFile || vFile.isDirectory())
    {
      Serial.println(F("ERROR: Failed to open " MJPEG_FILENAME " file for reading"));
      gfx->println(F("ERROR: Failed to open " MJPEG_FILENAME " file for reading"));
    }
    else
    {
      uint8_t *mjpeg_buf = (uint8_t *)malloc(MJPEG_BUFFER_SIZE);
      if (!mjpeg_buf)
      {
        Serial.println(F("mjpeg_buf malloc failed!"));
      }
      else
      {
        Serial.println(F("MJPEG video start"));
        mjpeg.setup(vFile, mjpeg_buf, gfx, true);
        // Read video
        while (mjpeg.readMjpegBuf())
        {
          // Play video
          mjpeg.drawJpg();
        }
        Serial.println(F("MJPEG video end"));
        vFile.close();
      }
    }
  }
#ifdef TFT_BL
  delay(60000);
  ledcDetachPin(TFT_BL);
#endif
  gfx->displayOff();
  esp_deep_sleep_start();
}

void loop()
{
}
