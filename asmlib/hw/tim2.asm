	.include "asmlib/hw/tim-general.asm"


	TIM2_BaseAddress        =: 0x5300

	TIM2_CR1       =: TIM2_BaseAddress + 0 ; control register 1
	.if STM8S003 + STM8S103
	TIM2_RESERVED1 =: TIM2_BaseAddress + 1 ; Reserved register
	TIM2_RESERVED2 =: TIM2_BaseAddress + 2 ; Reserved register
	TIM2_IER       =: TIM2_BaseAddress + 3 ; Interrupt enable register
	.else
	TIM2_IER       =: TIM2_BaseAddress + 1 ; Interrupt enable register
	.endif
	TIM2_SR1       =: TIM2_IER + 1 ; Status register 1
	TIM2_SR2       =: TIM2_IER + 2 ; Status register 1
	TIM2_EGR       =: TIM2_IER + 3 ; Event generation register
	TIM2_CCMR1     =: TIM2_IER + 4 ; Capture/compare mode register 1
	TIM2_CCMR2     =: TIM2_IER + 5 ; Capture/compare mode register 2
	TIM2_CCMR3     =: TIM2_IER + 6 ; Capture/compare mode register 3
	TIM2_CCER1     =: TIM2_IER + 7 ; Capture/compare enable register 1
	TIM2_CCER2     =: TIM2_IER + 8 ; Capture/compare enable register 2
	TIM2_CNTRH     =: TIM2_IER + 9 ; Counter high
	TIM2_CNTRL     =: TIM2_IER + 10 ; Counter low
	TIM2_PSCR      =: TIM2_IER + 11 ; Prescaler register
	TIM2_ARRH      =: TIM2_IER + 12 ; Auto-reload register high
	TIM2_ARRL      =: TIM2_IER + 13 ; Auto-reload register low
	TIM2_CCR1H     =: TIM2_IER + 14 ; Capture/compare register 1 high
	TIM2_CCR1L     =: TIM2_IER + 15 ; Capture/compare register 1 low
	TIM2_CCR2H     =: TIM2_IER + 16 ; Capture/compare register 2 high
	TIM2_CCR2L     =: TIM2_IER + 17 ; Capture/compare register 2 low
	TIM2_CCR3H     =: TIM2_IER + 18 ; Capture/compare register 3 high
	TIM2_CCR3L     =: TIM2_IER + 19 ; Capture/compare register 3 low


	.mdelete tim2
	.macro tim2 name arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		tim_'name 2 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
	.endm
