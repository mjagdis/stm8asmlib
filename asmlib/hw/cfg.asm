	CFG_BaseAddress     =: 0x7F60

	CFG_GCR             =: CFG_BaseAddress + 0

	CFG_GCR_RESET_VALUE =: 0x00

	CFG_GCR_SWD         =: 0 ; Swim disable bit mask
	CFG_GCR_AL          =: 1 ; Activation Level bit mask


	.mdelete cfg_swim_disable
	.macro cfg_swim_disable
		bset CFG_GCR, #CFG_GCR_SWD
	.endm

	.mdelete cfg_swim_enable
	.macro cfg_swim_enable
		bres CFG_GCR, #CFG_GCR_SWD
	.endm


	; Setting the activation level to interrupt-only causes ISRs to exit to low power
	; mode efficiently. It is up to ISRs to set the activation level back to main
	; in order to allow the main program to continue.
	; Errata 2.1.1: this setting is ignored by HALT but works as stated with WFI.
	.mdelete cfg_activation_main
	.macro cfg_activation_main
		bres CFG_GCR, #CFG_GCR_AL
	.endm

	.mdelete cfg_activation_interrupt_only
	.macro cfg_activation_interrupt_only
		bset CFG_GCR, #CFG_GCR_AL
	.endm
