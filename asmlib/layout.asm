;--------------------------------------------------------
; FLASH data
;
; Contains:
;     _CODE       - standard code
;     CODE        - application code (SDCC compatible)
;     FUNCTIONS   - functions, ISRs etc.
;     INITIALIZER - data for initialized global variables
;
; We would really like to call the first area FLASH, set
; the address for that at link time and have everything else
; follow from there. However the default _CODE area is already
; created by SDAS so there is no way to move it after a FLASH
; area. If don't want use of _CODE to fail badly it MUST be
; first here and it MUST be the thing we set the address for
; at link time.
;--------------------------------------------------------
	; Since _CODE already exists (it is built in) this
	; does NOT place it in the area order. Rather,
	; _CODE is ALREADY at the head of the area list so
	; its presence below is merely a reminder that it
	; is there. Do NOT try and move it!
	.area _CODE (REL,CON)
__interrupt_vect:			; SDCC compat
	int _boot			; RESET
	int _isr_unused			; TRAP
	.rept 29
		int _isr_unused
	.endm

	; The above is overlaid by IRQVECTORS<n> which will set
	; the actual handlers defined elsewhere in the code.
	; (See the ISR macro in asmlib/std.asm)

_isr_unused:
	iret

	; Functions and initialized data come first because they
	; are less likely to change and so a smart flash programmer
	; will be able to avoid rewriting those blocks.
	.area FUNCTIONS (REL,CON)
	.area INITIALIZER (REL,CON)	; SDCC compat
	.area CODE (REL,CON)		; SDCC compat
_boot:

	.area _END (REL,CON)


;--------------------------------------------------------
; RAM data
;
; Contains:
;     RAM         - uninitialized variables
;     DATA        - uninitialized but zeroed variables (BSS)
;     INITIALIZED - initialized variables
;     SSEG        - stack
;--------------------------------------------------------
	.area RAM (REL,CON)
	.area DATA (REL,CON)
	.area INITIALIZED (REL,CON)
	.area SSEG (REL,CON)
	.ds 1 ; Make it not empty...


	; Leave the current area as CODE.
	.area CODE
