This project aims to be a simple "Hello World" for working with AVR
microcontrollers. It has been written for [ATmega8][atmega8], but should be
fairly easy to port for other microcontrollers from the [AVR family][avr].

Quick description of the files:

* `c-with-gcc/`: Source-code written in C for compiling with GCC.
* `asm-with-gcc/`: Source-code written in assembly for compiling with GCC.
* `asm-with-tavrasm/`: Source-code written in assembly for compiling with [tavrasm][tavrasm], [AVRA][avra], or Atmel's assembler.
* `atmega8-blinking-leds*`: Circuit schematic diagram (drawn in [Inkscape][inkscape]).
* `Makefile.tpl`: Template Makefile from [Psychogenic Inc][makefile].

For full details, please read the posts in my blog:

* [First contact with ATmega8 microcontroller (part 1)](http://denilson.sa.nom.br/blog/2007-10-25/first-contact-with-atmega8-microcontroller-part-1/)

[atmega8]: http://www.atmel.com/dyn/products/product_card.asp?part_id=2004
[avr]: http://en.wikipedia.org/wiki/Atmel_AVR
[inkscape]: http://www.inkscape.org/
[tavrasm]: http://www.tavrasm.org/
[avra]: http://avra.sourceforge.net
[makefile]: http://electrons.psychogenic.com/modules/arms/art/8/AVRProjectOrganizationStandardizedAVRMakefileTemplate.php
