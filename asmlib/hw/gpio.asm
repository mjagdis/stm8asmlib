	.if STM8S_HAS_GPIOA
		GPIOA =: 0x5000
	.endif
	.if STM8S_HAS_GPIOB
		GPIOB =: 0x5005
	.endif
	.if STM8S_HAS_GPIOC
		GPIOC =: 0x500A
	.endif
	.if STM8S_HAS_GPIOD
		GPIOD =: 0x500F
	.endif
	.if STM8S_HAS_GPIOE
		GPIOE =: 0x5014
	.endif
	.if STM8S_HAS_GPIOF
		GPIOF =: 0x5019
	.endif
	.if STM8S_HAS_GPIOG
		GPIOG =: 0x501E
	.endif
	.if STM8S_HAS_GPIOH
		GPIOH =: 0x5023
	.endif
	.if STM8S_HAS_GPIOI
		GPIOI =: 0x5028
	.endif

	GPIO_ODR =: 0 ; Output Data Register
	GPIO_IDR =: 1 ; Input Data Register
	GPIO_DDR =: 2 ; Data Direction Register
	GPIO_CR1 =: 3 ; Configuration Register 1
	GPIO_CR2 =: 4 ; Configuration Register 2

	GPIO_ODR_RESET_VALUE =: 0x00
	GPIO_DDR_RESET_VALUE =: 0x00
	GPIO_CR1_RESET_VALUE =: 0x00
	GPIO_CR2_RESET_VALUE =: 0x00


	; RM0016 11.4: All I/O pins are generally input floating under reset (i.e. during
	;   the reset phase and at reset state (i.e. after reset release).
	; RM0016 11.5: Unused I/O pins must not be left floating to avoid extra current
	;   consumption.
	; We set them all as inputs with  pull-ups initially. Initialization of other
	; components is expected to adjust as necessary.
	.mdelete gpio_power_save
	.macro gpio_power_save
		.if STM8S_HAS_GPIOA
			mov GPIOA+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOB
			mov GPIOB+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOC
			mov GPIOC+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOD
			mov GPIOD+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOE
			mov GPIOE+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOF
			mov GPIOF+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOG
			mov GPIOG+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOH
			mov GPIOH+GPIO_CR1, #0xff
		.endif
		.if STM8S_HAS_GPIOI
			mov GPIOI+GPIO_CR1, #0xff
		.endif
	.endm


	.mdelete gpio_enable_interrupt
	.macro gpio_enable_interrupt port pin
		bset port + GPIO_CR2, #pin
	.endm

	.mdelete gpio_disable_interrupt
	.macro gpio_disable_interrupt port pin
		bres port + GPIO_CR2, #pin
	.endm
