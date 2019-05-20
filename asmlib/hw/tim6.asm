	.include "asmlib/hw/tim-basic.asm"


	TIM6_BaseAddress        =: 0x5340

	TIM6_CR1       =: TIM6_BaseAddress + 0 ; Control register 1
	TIM6_CR2       =: TIM6_BaseAddress + 1 ; Control register 2
	TIM6_SMCR      =: TIM6_BaseAddress + 2 ; Slave mode control register
	TIM6_IER       =: TIM6_BaseAddress + 3 ; Interrupt enable register
	TIM6_SR1       =: TIM6_BaseAddress + 1 ; Status register 1
	TIM6_EGR       =: TIM6_BaseAddress + 2 ; Event generation register
	TIM6_CNTR      =: TIM6_BaseAddress + 3 ; Counter register
	TIM6_PSCR      =: TIM6_BaseAddress + 4 ; Prescaler register
	TIM6_ARR       =: TIM6_BaseAddress + 5 ; Auto-reload register


	.mdelete tim6
	.macro tim6 name arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		tim_'name 6 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
	.endm
