TAVRASM = tavrasm

MCU = atmega8
PROGRAMMER_MCU = atmega8
AVRDUDE_PROGRAMMERID = bsd
AVRDUDE_PORT = /dev/parport0


PROGNAME = hello

#Basic rules
.PHONY: all clean erase dump uisp-dump
all: $(PROGNAME).hex

clean:
	rm -f $(PROGNAME).{hex,eep,lst}

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


$(PROGNAME).hex: $(PROGNAME).asm

#The variables:
# $@ - The name of the target of the rule.
# $? - The names of all the prerequisites that are newer than the target.
# $< - The name of the first prerequisite.
# $^ - The names of all the prerequisites.

#Pattern-rules
%.hex: %.asm
	$(TAVRASM) $< -o $@ -e $(subst $(suffix $<),.lst,$<) -r $(subst $(suffix $<),.eep,$<)
