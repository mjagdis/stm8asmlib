	ITC_SPR_BaseAddress   =: 0x7F70
	ITC_EXTI_BaseAddress  =: 0x50A0

	; Software priority registers
	ITC_SPR1             =: ITC_SPR_BaseAddress + 0 ; Interrupt Software Priority register 1
	ITC_SPR2             =: ITC_SPR_BaseAddress + 1 ; Interrupt Software Priority register 2
	ITC_SPR3             =: ITC_SPR_BaseAddress + 2 ; Interrupt Software Priority register 3
	ITC_SPR4             =: ITC_SPR_BaseAddress + 3 ; Interrupt Software Priority register 4
	ITC_SPR5             =: ITC_SPR_BaseAddress + 4 ; Interrupt Software Priority register 5
	ITC_SPR6             =: ITC_SPR_BaseAddress + 5 ; Interrupt Software Priority register 6
	ITC_SPR7             =: ITC_SPR_BaseAddress + 6 ; Interrupt Software Priority register 7
	ITC_SPR8             =: ITC_SPR_BaseAddress + 7 ; Interrupt Software Priority register 8

	; External interrupt sensitivity registers
	ITC_EXTI_CR1          =: ITC_EXTI_BaseAddress + 0
	ITC_EXTI_CR2          =: ITC_EXTI_BaseAddress + 1


	; Interrupt priority levels
	ITC_LEVEL_0           =: 0b10 ; Priority level 0 (main)
	ITC_LEVEL_1           =: 0b01 ; Priority level 1 (low)
	ITC_LEVEL_2           =: 0b00 ; Priority level 2 (medium)
	ITC_LEVEL_3           =: 0b11 ; Priority level 3 (high)

	; External interrupt sensitivity
	ITC_EXTI_FL            =: 0b00       ; Falling edge and low level
	ITC_EXTI_R             =: 0b01       ; Rising edge only
	ITC_EXTI_F             =: 0b10       ; Falling edge only
	ITC_EXTI_FR            =: 0b11       ; Falling and rising edge
	ITC_EXTI_RF            =: ITC_EXTI_FR ; Rising and falling edge


	; Set the priority for an interrupt vector.
	.mdelete itc_irq_priority
	.macro itc_irq_priority vector level
		ld a, ITC_SPR_BaseAddress + (vector / 4)
		and a, #255 - (0b11 << ((vector % 4) << 1))
		or a, #level << ((vector % 4) << 1)
		ld ITC_SPR_BaseAddress + (vector / 4), a
	.endm


	; Set the current interrupt priority level.
	; This does NOT preserve flags.
	;
	; Errata 2.1.3: ISRs may run at level 0 due to a race condition.
	; Handlers must set priority level explicitly.
	.mdelete itc_set_priority
	.macro itc_set_priority level
		push #((level & 0b10) << 4) + ((level & 0b01) << 3)
		pop cc
	.endm


	.mdelete itc_set_priority_if_higher
	.macro itc_set_priority_if_higher current new
		.ifeq current - ITC_LEVEL_3
			; Already maximum
		.else
		.ifeq current - ITC_LEVEL_2
			.ifeq new - ITC_LEVEL_3
				itc_set_priority new
			.endif
		.else
		.ifeq current - ITC_LEVEL_1
			.ifeq new - ITC_LEVEL_3
				itc_set_priority new
			.else
			.ifeq new - ITC_LEVEL_2
				itc_set_priority new
			.endif
			.endif
		.else
		.ifeq current - ITC_LEVEL_0
			.ifne new - ITC_LEVEL_0
				itc_set_priority new
			.endif
		.endif
		.endif
		.endif
		.endif
	.endm

	.mdelete itc_save_and_set_priority
	.macro itc_save_and_set_priority level
		push cc
		itc_set_priority level
	.endm

	.mdelete itc_restore_priority
	.macro itc_restore_priority
		pop cc
	.endm


	.mdelete itc_gpio_interrupt
	.macro itc_gpio_interrupt port pin mode
		.if port = GPIOE
			ld a, ITC_EXTI_CR2
			and a, #~0b11
			or a, #mode
			ld ITC_EXTI_CR2, a
		.else
			ld a, ITC_EXTI_CR1
			and a, #~(0b11 << (((port - GPIOA) / (GPIOB - GPIOA))) << 2)
			or a, #~(mode << (((port - GPIOA) / (GPIOB - GPIOA))) << 2)
			ld ITC_EXTI_CR1, a
		.endif
	.endm
