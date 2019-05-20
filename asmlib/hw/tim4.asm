	.include "asmlib/hw/tim-basic.asm"


	TIM4_BaseAddress        =: 0x5340

	TIM4_CR1       =: TIM4_BaseAddress + 0 ; Control register 1
	.if STM8S003 + STM8S103
	TIM4_IER       =: TIM4_BaseAddress + 3 ; Interrupt enable register
	.else
	TIM4_IER       =: TIM4_BaseAddress + 1 ; Interrupt enable register
	.endif
	TIM4_SR1       =: TIM4_IER + 1 ; Status register 1
	TIM4_EGR       =: TIM4_IER + 2 ; Event generation register
	TIM4_CNTR      =: TIM4_IER + 3 ; Counter register
	TIM4_PSCR      =: TIM4_IER + 4 ; Prescaler register
	TIM4_ARR       =: TIM4_IER + 5 ; Auto-reload register


	.mdelete tim4
	.macro tim4 name arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		tim_'name 4 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
	.endm
