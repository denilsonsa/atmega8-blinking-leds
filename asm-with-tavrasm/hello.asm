; See also: AVR Assembler User Guide
; http://www.atmel.com/atmel/acrobat/doc1022.pdf

.device atmega8

.equ	SPH 	=0x3E
.equ	SPL 	=0x3D
.equ	DDRC	=0x14
.equ	PORTC	=0x15


.cseg	; Start of code segment
.org 0
	rjmp	main

.org 0x26	; After the reset/interrupt table
main:
	ldi	r16, 0x5F	; Setting up the SP (stack pointer)
	ldi	r17, 0x04
	out	SPL, r16
	out	SPH, r17

	ldi r17, 0x0F	; This goes to DDRC
	ldi r16, 0x00	; This goes to PORTC
	out DDRC, r17
	out PORTC, r16
	ldi r17, 1
	ldi r18, 2
	ldi r19, 4
	ldi r20, 8

main_loop:
	rcall wait_some_time
	eor r16, r17
	out PORTC, r16
	rcall wait_some_time
	eor r16, r18
	out PORTC, r16
	rcall wait_some_time
	eor r16, r19
	out PORTC, r16
	rcall wait_some_time
	eor r16, r20
	out PORTC, r16
	rjmp main_loop


wait_some_time:
	push r24
	push r25
	ldi r24, 0xFF
	ldi r25, 0xFF
wait_some_time_loop:
	sbiw r24, 1
	brne wait_some_time_loop
	pop r25
	pop r24
	ret


.dseg	; Start of data segment (located in SRAM)

.eseg	; Start of EEPROM segment
