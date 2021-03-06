; The following features are common to all the STM8S family:

	STM8S_HAS_AWU   =: 1
	STM8S_HAS_BEEP  =: 1
	STM8S_HAS_CFG   =: 1
	STM8S_HAS_CLK   =: 1
	STM8S_HAS_DM    =: 1
	STM8S_HAS_EXTI  =: 1
	STM8S_HAS_FLASH =: 1
	STM8S_HAS_GPIOA =: 1
	STM8S_HAS_GPIOB =: 1
	STM8S_HAS_GPIOC =: 1
	STM8S_HAS_GPIOD =: 1
	STM8S_HAS_GPIOE =: 1
	STM8S_HAS_GPIOF =: 1
	STM8S_HAS_I2C   =: 1
	STM8S_HAS_ITC   =: 1
	STM8S_HAS_IWDG  =: 1
	STM8S_HAS_OPT   =: 1
	STM8S_HAS_RST   =: 1
	STM8S_HAS_SPI   =: 1
	STM8S_HAS_SWIM  =: 1
	STM8S_HAS_TIM1  =: 1
	STM8S_HAS_WWDG  =: 1


	IRQ_RESET       =: -2 ; Reset
	IRQ_TRAP        =: -1 ; Trap
	IRQ_TLI         =:  0 ; External top level interrupt
	IRQ_AWU         =:  1 ; Auto wake up from halt
	IRQ_CLK         =:  2 ; Clock controller
	IRQ_EXTI0       =:  3 ; Port A external interrupts
	IRQ_GPIOA       =: IRQ_EXTI0
	IRQ_EXTI1       =:  4 ; Port B external interrupts
	IRQ_GPIOB       =: IRQ_EXTI1
	IRQ_EXTI2       =:  5 ; Port C external interrupts
	IRQ_GPIOC       =: IRQ_EXTI2
	IRQ_EXTI3       =:  6 ; Port D external interrupts
	IRQ_GPIOD       =: IRQ_EXTI3
	IRQ_EXTI4       =:  7 ; Port E external interrupts
	IRQ_GPIOE       =: IRQ_EXTI4
	IRQ_SPI         =: 10 ; SPI end of transfer
	IRQ_TIM1        =: 11 ; TIM1 update/overflow/underflow/trigger/break
	IRQ_TIM1_CAPCOM =: 12 ; TIM1 capture/compare
	IRQ_TIM2        =: 13 ; TIM2 update/overflow
	IRQ_TIM2_CAPCOM =: 14 ; TIM2 capture/compare
	IRQ_UART1_TX    =: 17 ; UART1 TX complete
	IRQ_UART1_RX    =: 18 ; UART1 receive register full
	IRQ_I2C         =: 19 ; I2C interrupt
	IRQ_ADC1        =: 22 ; ADC1 end of conversion/analog watchdog interrupt
	IRQ_TIM4        =: 23 ; TIM4 update/overflow
	IRQ_FLASH       =: 24 ; EOP/WR_PG_DIS
