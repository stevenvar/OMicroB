#ifndef __EEPROM_H_
#define __EEPROM_H_ 1

/* For AVR */
#if defined(__AVR__)
    #include <avr/io.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif


uint8_t eeprom_read_byte(uint8_t *index);
void eeprom_write_byte(uint8_t *index, uint8_t in);

#ifdef __cplusplus
}
#endif


#endif /* __EEPROME_H_ */
