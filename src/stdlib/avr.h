
void writeRegister(uint8_t reg,uint8_t val);
uint8_t readRegister(uint8_t reg);
void setBit(uint8_t reg,uint8_t bit);
void clearBit(uint8_t reg, uint8_t bit);
uint8_t readBit(uint8_t reg, uint8_t bit);
void pinMode(uint8_t pin, uint8_t mode);
void digitalWrite(uint8_t pin, uint8_t val);
void drawPixel(uint8_t x, uint8_t y, uint8_t color);

#define INPUT 0x0
#define OUTPUT 0x1
#define INPUT_PULLUP 0x2

#define true 0x1
#define false 0x0
