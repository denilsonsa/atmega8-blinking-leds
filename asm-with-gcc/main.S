#include <avr/io.h>

.global main
main:
	ldi r17, 0x0F	; This goes to DDRC
	ldi r16, 0x00	; This goes to PORTC
	out _SFR_IO_ADDR(DDRC), r17
	out _SFR_IO_ADDR(PORTC), r16
	ldi r17, 1
	ldi r18, 2
	ldi r19, 4
	ldi r20, 8

main_loop:
	rcall wait_some_time
	eor r16, r17
	out _SFR_IO_ADDR(PORTC), r16
	rcall wait_some_time
	eor r16, r18
	out _SFR_IO_ADDR(PORTC), r16
	rcall wait_some_time
	eor r16, r19
	out _SFR_IO_ADDR(PORTC), r16
	rcall wait_some_time
	eor r16, r20
	out _SFR_IO_ADDR(PORTC), r16
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


#if 0
/* This is another way of implementing this function. */
wait_some_time:
	push r16
	push r17
	ldi r17, 0xFF
wait_some_time_high_byte:
	ldi r16, 0xFF
wait_some_time_low_byte:
	dec r16
	brne wait_some_time_low_byte
	dec r17
	brne wait_some_time_high_byte
	pop r17
	pop r16
	ret
#endif
