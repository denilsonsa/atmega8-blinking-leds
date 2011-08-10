AS  = avr-as
CC  = avr-gcc
CXX = avr-g++
CFLAGS   = -mmcu=$(MCU) -std=c99 -pipe -Os -Wall
CFLAGS  += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CXXFLAGS = $(CFLAGS)
LDFLAGS  = $(GENTOO_LD_PATH_WORKAROUND)
#LDFLAGS += -Wl,-Map=$(subst $(suffix $<),.map,$<)
#ASFLAGS  = -Wa,-adhlns=$(<:.S=.lst)
ASFLAGS  = -Wa,-adhlns=$(subst $(suffix $<),.lst,$<)


NM      = avr-nm
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE    = avr-size


MCU = atmega8
PROGRAMMER_MCU = atmega8
AVRDUDE_PROGRAMMERID = bsd
AVRDUDE_PORT = /dev/parport0


# See:
# http://bugs.gentoo.org/show_bug.cgi?id=147155
# http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=336170

GENTOO_LD_PATH_WORKAROUND = -L/usr/i686-pc-linux-gnu/avr/lib


PROGNAME = hello


#Basic rules
.PHONY: all clean erase dump uisp-dump
all: $(PROGNAME).hex $(PROGNAME).eep $(PROGNAME).lss

clean:
	rm -f $(PROGNAME).{o,s,elf,hex,eep,lss,lst,map,sym}

program:
	avrdude -p $(PROGRAMMER_MCU) -c $(AVRDUDE_PROGRAMMERID) -P $(AVRDUDE_PORT) \
		-E noreset \
		-U flash:w:$(PROGNAME).hex:i
#		-U eeprom:w:$(PROGNAME).eep:i
# If you uncommented the previous line, remember to add a backslash at the end of the line before it.
	@echo Note: EEPROM was not written.
erase:
	avrdude -p $(PROGRAMMER_MCU) -c $(AVRDUDE_PROGRAMMERID) -P $(AVRDUDE_PORT) \
		-E noreset -e
dump:
	avrdude -p $(PROGRAMMER_MCU) -c $(AVRDUDE_PROGRAMMERID) -P $(AVRDUDE_PORT) \
		-E noreset \
		-U flash:r:flash.dump:i \
		-U eeprom:r:eeprom.dump:i \
		-U hfuse:r:hfuse.dump:b \
		-U lfuse:r:lfuse.dump:b \
		-U lock:r:lock.dump:b \
		-U signature:r:signature.dump:h

# I like avrdude, it's so simple and powerful.
# So, I'm making no effort to make uisp work.
# But the next command makes a firmware dump using uisp.
uisp-dump:
	uisp -dprog=bsd -dpart=atmega8 -dlpt=/dev/parport0 --rd_fuses --download of=uisp.dump


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

