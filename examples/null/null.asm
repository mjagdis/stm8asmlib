	.module null
	.optsdcc -mstm8
	

	.include "config.asm"

	; This MUST be the first thing after config in the FIRST
	; file to be linked. It defines how the various areas are
	; combined into the FLASH/RAM/EPROM.
	.include "asmlib/layout.asm"


	RESET
loop:
	wfi
	jra loop
