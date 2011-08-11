### Project configuration ###

# The main project file (without extension)
PROGNAME = hello


### Microcontroller and programmer configuration ###

# $(MCU) is passed to GCC
MCU = atmega8

# $(PROGRAMMER_MCU) is passed to avrdude
PROGRAMMER_MCU = atmega8

# For parallel port programmer:
#AVRDUDE_PARAMS = -p $(PROGRAMMER_MCU) -c bsd -P /dev/parport0 -E noreset
# For USBasp
AVRDUDE_PARAMS = -p $(PROGRAMMER_MCU) -c usbasp


### Compiling tools configuration ###

TAVRASM = tavrasm


### Make targets ###

#Basic rules
.PHONY: all help clean writeflash writeeeprom erase dump

all: $(PROGNAME).hex

help:
	@echo 'make all         - Build the project'
	@echo 'make clean       - Deletes all built files'
	@echo
	@echo 'make writeflash  - Writes the flash memory of the microcontroller'
	@echo 'make writeeeprom - Writes the EEPROM of the microcontroller'
	@echo 'make erase       - Perform a chip erase'
	@echo 'make dump        - Dumps all memory from the microcontroller'

clean:
	rm -f $(PROGNAME).{hex,eep,lst}

writeflash:
	avrdude $(AVRDUDE_PARAMS) \
		-U flash:w:$(PROGNAME).hex:i

writeeeprom:
	avrdude $(AVRDUDE_PARAMS) \
		-U eeprom:w:$(PROGNAME).eep:i

erase:
	avrdude $(AVRDUDE_PARAMS) \
		-e
dump:
	avrdude $(AVRDUDE_PARAMS) \
		-U flash:r:flash.dump:i \
		-U eeprom:r:eeprom.dump:i \
		-U hfuse:r:hfuse.dump:b \
		-U lfuse:r:lfuse.dump:b \
		-U lock:r:lock.dump:b \
		-U signature:r:signature.dump:h


$(PROGNAME).hex: $(PROGNAME).asm


#The variables:
# $@ - The name of the target of the rule.
# $? - The names of all the prerequisites that are newer than the target.
# $< - The name of the first prerequisite.
# $^ - The names of all the prerequisites.

#Pattern-rules
%.hex: %.asm
	$(TAVRASM) $< -o $@ -e $(subst $(suffix $<),.lst,$<) -r $(subst $(suffix $<),.eep,$<)
