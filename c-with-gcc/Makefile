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

AS  = avr-as
CC  = avr-gcc
CXX = avr-g++

NM      = avr-nm
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size

CFLAGS   = -mmcu=$(MCU) -std=c99 -pipe -Os -Wall
CFLAGS  += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CXXFLAGS = $(CFLAGS)
ASFLAGS  = -Wa,-adhlns=$(subst $(suffix $<),.lst,$<)
LDFLAGS  = -Wl,-Map=$(PROGNAME).map
#LDFLAGS += $(GENTOO_LD_PATH_WORKAROUND)

# See:
# http://bugs.gentoo.org/show_bug.cgi?id=147155
# http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=336170

#GENTOO_LD_PATH_WORKAROUND = -L/usr/i686-pc-linux-gnu/avr/lib
#GENTOO_LD_PATH_WORKAROUND = -L/usr/x86_64-pc-linux-gnu/avr/lib

# ln -snf ../../lib/binutils/avr/2.*/ldscripts/ /usr/avr/lib/ldscripts


### Make targets ###

#Basic rules
.PHONY: all help clean writeflash writeeeprom erase dump

all: $(PROGNAME).hex $(PROGNAME).eep $(PROGNAME).lss

help:
	@echo 'make all         - Build the project'
	@echo 'make clean       - Deletes all built files'
	@echo
	@echo 'make writeflash  - Writes the flash memory of the microcontroller'
	@echo 'make writeeeprom - Writes the EEPROM of the microcontroller'
	@echo 'make erase       - Perform a chip erase'
	@echo 'make dump        - Dumps all memory from the microcontroller'

clean:
	rm -f $(PROGNAME).{o,s,elf,hex,eep,lss,lst,map,sym}

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


$(PROGNAME).s: $(PROGNAME).c
$(PROGNAME).o: $(PROGNAME).c
$(PROGNAME).elf: $(PROGNAME).o


#The variables:
# $@ - The name of the target of the rule.
# $? - The names of all the prerequisites that are newer than the target.
# $< - The name of the first prerequisite.
# $^ - The names of all the prerequisites.

#Pattern-rules
%.s: %.c
	$(CC) -S $(CPPFLAGS) $(CFLAGS) $(ASFLAGS) -o $@ $<
%.o: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(ASFLAGS) -o $@ $<
%.o: %.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $(ASFLAGS) -o $@ $<
%.o: %.h
%.elf: %.o
	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $<

# Create final output files (.hex, .eep) from ELF output file.
# Use -O ihex for Intel Hex format
# Use -O binary for binary format
%.hex: %.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	#$(OBJCOPY) -j .text -j .data -O ihex $< $@
%.eep: %.elf
	$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
	--change-section-lma .eeprom=0 -O ihex $< $@

# Create extended listing file from ELF output file.
%.lss: %.elf
	$(OBJDUMP) -h -S -C $< > $@

# Create a symbol table from ELF output file.
%.sym: %.elf
	$(NM) -n $< > $@

