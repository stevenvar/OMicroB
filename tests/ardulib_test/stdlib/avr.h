void writeRegister(uint8_t reg,uint8_t val);
void setBit(uint8_t reg,uint8_t bit);
void clearBit(uint8_t reg, uint8_t bit);

#define digitalPinToBitMask(P) ( pgm_read_byte( digital_pin_to_bit_mask_PGM + (P) ) )

#define digitalPinToPort(P) ( pgm_read_byte( digital_pin_to_port_PGM + (P) ) )
