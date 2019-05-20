	AWU_BaseAddress     =: 0x50F0

	AWU_CSR             =: AWU_BaseAddress + 0 ; AWU Control status register
	AWU_APR             =: AWU_BaseAddress + 1 ; AWU Asynchronous prescalar buffer
	AWU_TBR             =: AWU_BaseAddress + 2 ; AWU Time base selection register

	AWU_CSR_RESET_VALUE =: 0x00 ; VALUE: CSR value after reset
	AWU_APR_RESET_VALUE =: 0x3F ; VALUE: APR value after reset
	AWU_TBR_RESET_VALUE =: 0x00 ; VALUE: TBR value after reset

	AWU_CSR_AWUF        =: 5 ; Auto-wakeup / interrupt flag
	AWU_CSR_AWUEN       =: 4 ; Auto Wake-up enable
	AWU_CSR_MSR         =: 0 ; Measurement enable

	AWU_APR_RESERVED    =: 0xC0 ; MASK: APR reserved bits
	AWU_APR_APR         =: 0    ; Bits[5:0]: Asynchronous prescaler divider

	AWU_TBR_RESERVED    =: 0xF0 ; MASK: TBR reserved bits
	AWU_TBR_AWUTB       =: 0    ; Bits[3:0]: Timebase selection


	.mdelete awu_prescalar
	.macro awu_prescalar value
		ld a, AWU_APR
		and a, #AWU_APR_RESERVED
		or a, #value
		ld AWU_APR, a
	.endm

	.mdelete awu_timebase
	.macro awu_timebase value
		ld a, AWU_TBR
		and a, #AWU_TBR_RESERVED
		or a, #value
		ld AWU_TBR, a
	.endm


	; Disable the AWU and adjust for minimum power use.
	;
	; RM0016: 12.3.1:
	;   The counters only start when the MCU enters active-halt mode after
	;   a HALT instruction.
	; and:
	;   If the AWU is not in use, then the AUUTB[3:0] bits [in] the TImebase
	;   selection register (AWU_TBR) should be loaded with 0b0000 to reduce
	;   power consumption.
	;
	; FIXME: how necessary is this? Is it sufficient just to disable the AWU?
	; Do we need to both disconnect the clock AND clear the timebase?
	.mdelete awu_disable
	.macro awu_disable
		ld a, AWU_TBR
		and a, #AWU_TBR_RESERVED
		ld AWU_TBR, a
		bres AWU_CSR, #AWU_CSR_AWUEN
		clk_disable AWU
	.endm

	; Enable the AWU, connect the clock and set the timebase.
	.mdelete awu_enable
	.macro awu_enable timebase
		awu_timebase timebase
		clk_enable AWU
		bset AWU_CSR, #AWU_CSR_AWUEN
	.endm
