	CLK_BaseAddress =: 0x50C0

	CLK_ICKR        =: CLK_BaseAddress + 0  ; Internal Clocks Control Register
	CLK_ECKR        =: CLK_BaseAddress + 1  ; External Clocks Control Register
	CLK_RESERVED    =: CLK_BaseAddress + 2  ; Reserved byte
	CLK_CMSR        =: CLK_BaseAddress + 3  ; Clock Master Status Register
	CLK_SWR         =: CLK_BaseAddress + 4  ; Clock Master Switch Register
	CLK_SWCR        =: CLK_BaseAddress + 5  ; Switch Control Register
	CLK_CKDIVR      =: CLK_BaseAddress + 6  ; Clock Divider Register
	CLK_PCKENR1     =: CLK_BaseAddress + 7  ; Peripheral Clock Gating Register 1
	CLK_CSSR        =: CLK_BaseAddress + 8  ; Clock Security Sytem Register
	CLK_CCOR        =: CLK_BaseAddress + 9  ; Configurable Clock Output Register
	CLK_PCKENR2     =: CLK_BaseAddress + 10 ; Peripheral Clock Gating Register 2
	CLK_CANCCR      =: CLK_BaseAddress + 11 ; CAN external clock control Register (only STM8S208)
	CLK_HSITRIMR    =: CLK_BaseAddress + 12 ; HSI Calibration Trimmer Register
	CLK_SWIMCCR     =: CLK_BaseAddress + 13 ; SWIM clock control register

	CLK_ICKR_RESET_VALUE     =: 0x01
	CLK_ECKR_RESET_VALUE     =: 0x00
	CLK_CMSR_RESET_VALUE     =: 0xE1
	CLK_SWR_RESET_VALUE      =: 0xE1
	CLK_SWCR_RESET_VALUE     =: 0x00
	CLK_CKDIVR_RESET_VALUE   =: 0x18
	CLK_PCKENR1_RESET_VALUE  =: 0xFF
	CLK_PCKENR2_RESET_VALUE  =: 0xFF
	CLK_CSSR_RESET_VALUE     =: 0x00
	CLK_CCOR_RESET_VALUE     =: 0x00
	CLK_CANCCR_RESET_VALUE   =: 0x00
	CLK_HSITRIMR_RESET_VALUE =: 0x00
	CLK_SWIMCCR_RESET_VALUE  =: 0x00

	CLK_ICKR_REGAH  =: 5 ; Regulator power off in Active Halt/Halt modes
	CLK_ICKR_LSIRDY =: 4 ; Low speed internal oscillator ready
	CLK_ICKR_LSIEN  =: 3 ; Low speed internal RC oscillator enable
	CLK_ICKR_FHWU   =: 2 ; Fast Wake-up from Active Halt/Halt mode
	CLK_ICKR_HSIRDY =: 1 ; High speed internal RC oscillator ready
	CLK_ICKR_HSIEN  =: 0 ; High speed internal RC oscillator enable

	CLK_ECKR_HSERDY =: 1 ; High speed external crystal oscillator ready
	CLK_ECKR_HSEEN  =: 0 ; High speed external crystal oscillator enable

	CLK_SWR_HSI     =: 0xE1 ; VALUE: HSI selected as master clock source (reset value)
	CLK_SWR_LSI     =: 0xD2 ; VALUE: LSI selected as master clock source
	CLK_SWR_HSE     =: 0xB4 ; VALUE: HSE selected as master clock source

	CLK_SWCR_SWIF   =: 3 ; Clock switch interrupt flag
	CLK_SWCR_SWIEN  =: 2 ; Clock switch interrupt enable
	CLK_SWCR_SWEN   =: 1 ; Switch start/stop
	CLK_SWCR_SWBSY  =: 0 ; Switch busy

	CLK_CKDIVR_HSIDIV =: 3 ; Bits [4:3]: High speed internal clock prescaler
		CLK_CKDIVR_HSIDIV_1  =: (0b00 << CLK_CKDIVR_HSIDIV) ; f_HSI = f_HSI RC output
		CLK_CKDIVR_HSIDIV_2  =: (0b01 << CLK_CKDIVR_HSIDIV) ; f_HSI = f_HSI RC output / 2
		CLK_CKDIVR_HSIDIV_4  =: (0b10 << CLK_CKDIVR_HSIDIV) ; f_HSI = f_HSI RC output / 4
		CLK_CKDIVR_HSIDIV_8  =: (0b11 << CLK_CKDIVR_HSIDIV) ; f_HSI = f_HSI RC output / 8

	CLK_CKDIVR_CPUDIV =: 0 ; MASK: CPU clock prescaler
		CLK_CKDIVR_CPUDIV_1   =: (0b000 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output
		CLK_CKDIVR_CPUDIV_2   =: (0b001 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 2
		CLK_CKDIVR_CPUDIV_4   =: (0b010 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 4
		CLK_CKDIVR_CPUDIV_8   =: (0b011 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 8
		CLK_CKDIVR_CPUDIV_16  =: (0b100 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 16
		CLK_CKDIVR_CPUDIV_32  =: (0b101 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 32
		CLK_CKDIVR_CPUDIV_64  =: (0b110 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 64
		CLK_CKDIVR_CPUDIV_128 =: (0b111 << CLK_CKDIVR_CPUDIV) ; f_CPU = f_MASTER RC output / 128

	.if STM8S_HAS_TIM1
		CLK_PCKENR_TIM1 =: 7 ; BIT: Timer 1 clock enable
	.endif
	.if STM8S_HAS_TIM3
		CLK_PCKENR_TIM3 =: 6 ; BIT: Timer 3 clock enable
	.endif
	.if STM8S_HAS_TIM2
		CLK_PCKENR_TIM2 =: 5 ; BIT: Timer 2 clock enable
	.endif
	.if STM8S_HAS_TIM5
		CLK_PCKENR_TIM5 =: 5 ; BIT: Timer 5 clock enable
	.endif
	.if STM8S_HAS_TIM4
		CLK_PCKENR_TIM4 =: 4 ; BIT: Timer 4 clock enable
	.endif
	.if STM8S_HAS_TIM6
		CLK_PCKENR_TIM6 =: 4 ; BIT: Timer 6 clock enable
	.endif
	.if STM8S_HAS_UART1
		CLK_PCKENR_UART1 =: 3 ; BIT: UART1 clock enable
		.if STM8S208
			CLK_PCKENR_UART1 =: 2 ; BIT: UART1 clock enable
		.endif
		.if STM8S207
			CLK_PCKENR_UART1 =: 2 ; BIT: UART1 clock enable
		.endif
		.if STM8S007
			CLK_PCKENR_UART1 =: 2 ; BIT: UART1 clock enable
		.endif
		.if STM8AF52Ax
			CLK_PCKENR_UART1 =: 2 ; BIT: UART1 clock enable
		.endif
		.if STM8AF62Ax
			CLK_PCKENR_UART1 =: 2 ; BIT: UART1 clock enable
		.endif
	.endif
	.if STM8S_HAS_UART2
		CLK_PCKENR_UART2 =: 3 ; BIT: UART2 clock enable
	.endif
	.if STM8S_HAS_UART3
		CLK_PCKENR_UART3 =: 3 ; BIT: UART3 clock enable
	.endif
	.if STM8S_HAS_SPI
		CLK_PCKENR_SPI   =: 1 ; BIT: SPI clock enable
	.endif
	.if STM8S_HAS_I2C
		CLK_PCKENR_I2C   =: 0 ; BIT: I2C clock enable
	.endif

	.if STM8S_HAS_CAN
		CLK_PCKENR_CAN =: 8+7 ; BIT: CAN clock enable
	.endif
	.if STM8S_HAS_ADC1
		CLK_PCKENR_ADC =: 8+3 ; BIT: ADC clock enable
	.endif
	.if STM8S_HAS_ADC2
		CLK_PCKENR_ADC =: 8+3 ; BIT: ADC clock enable
	.endif
	.if STM8S_HAS_AWU
		CLK_PCKENR_AWU =: 8+2 ; BIT: AWU clock enable
	.endif

	CLK_CSSR_CSSD   =: 3 ; BIT: Clock security sytem detection
	CLK_CSSR_CSSDIE =: 2 ; BIT: Clock security system detection interrupt enable
	CLK_CSSR_AUX    =: 1 ; BIT: Auxiliary oscillator connected to master clock
	CLK_CSSR_CSSEN  =: 0 ; BIT: Clock security system enable

	CLK_CCOR_CCOBSY =: 6 ; BIT: Configurable clock output busy
	CLK_CCOR_CCORDY =: 5 ; BIT: Configurable clock output ready
	CLK_CCOR_CCOSEL =: 0x1E ; MASK: Configurable clock output selection
		CLK_CCOR_CCOSEL_HSIDIV =: (0b0000 << 1); VALUE: f_HSIDIV
		CLK_CCOR_CCOSEL_LSI    =: (0b0001 << 1); VALUE: f_LSI
		CLK_CCOR_CCOSEL_HSE    =: (0b0010 << 1); VALUE: f_HSE
		;CLK_CCOR_CCOSEL_RES   =: (0b0011 << 1); VALUE: Reserved
		CLK_CCOR_CCOSEL_CPU    =: (0b0100 << 1); VALUE: f_CPU
		CLK_CCOR_CCOSEL_CPU2   =: (0b0101 << 1); VALUE: f_CPU/2
		CLK_CCOR_CCOSEL_CPU4   =: (0b0110 << 1); VALUE: f_CPU/4
		CLK_CCOR_CCOSEL_CPU8   =: (0b0111 << 1); VALUE: f_CPU/8
		CLK_CCOR_CCOSEL_CPU16  =: (0b1000 << 1); VALUE: f_CPU/16
		CLK_CCOR_CCOSEL_CPU32  =: (0b1001 << 1); VALUE: f_CPU/32
		CLK_CCOR_CCOSEL_CPU64  =: (0b1010 << 1); VALUE: f_CPU/64
		CLK_CCOR_CCOSEL_HSI    =: (0b1011 << 1); VALUE: f_HSI
		CLK_CCOR_CCOSEL_MASTER =: (0b1100 << 1); VALUE: f_MASTER
		;CLK_CCOR_CCOSEL_CPU   =: (0b1101 << 1); VALUE: f_CPU
		;CLK_CCOR_CCOSEL_CPU   =: (0b1110 << 1); VALUE: f_CPU
		;CLK_CCOR_CCOSEL_CPU   =: (0b1111 << 1); VALUE: f_CPU
	CLK_CCOR_CCOEN  =: 0 ; BIT: Configurable clock output enable

	CLK_CANCCR_CANDIV =: 0x07 ; MASK: External CAN clock divider

	CLK_HSITRIMR_HSITRIM =: 0x07 ; MASK: High speed internal oscillator trimmer

	CLK_SWIMCCR_SWIMDIV =: 0 ; BIT: SWIM Clock Dividing Factor


	; Enable clock switch interrupts
	.mdelete clk_enable_switch_interrupts
	.macro clk_enable_switch_interrupts
		bset CLK_SWCR, #CLK_SWCR_SWIF
	.endm

	; Disable clock switch interrupts
	.mdelete clk_disable_switch_interrupts
	.macro clk_disable_switch_interrupts
		bres CLK_SWCR, #CLK_SWCR_SWIF
	.endm

	; If there is a pending clock change wait for the new oscillator to
	; become ready. If SWEN is set the change will then happen immediately
	; otherwise it will happen when SWEN is set.
	;
	; RM0016 9.9.4 [SWRs] contents are write protected while a clock switch is
	; ongoing (while the SWBSY bit is set) although a pending change can be
	; cancelled by manually clearing the SWBSY bit.
	.mdelete clk_wait_for_pending_change
	.macro clk_wait_for_pending_change level ?loop ?done
		std_wait_for_bit CLK_SWCR CLK_SWCR_SWBSY f wfi level
	.endm

	.mdelete clk_set_auto
	.macro clk_set_auto clock
		bset CLK_SWCR, #CLK_SWCR_SWEN
		mov  CLK_SWR, #clock
	.endm


	.mdelete clk_set_dividers
	.macro clk_set_dividers hsidiv cpudiv
		mov CLK_CKDIVR, #((hsidiv << CLK_CKDIVR_HSIDIV) + (cpudiv << CLK_CKDIVR_CPUDIV))
	.endm


	; RM0016 9.9.1: oscillators are enabled as required by hardware but only
	; disabled by software. Not leaving oscillators running when not required
	; is important for power saving.
	;
	; Errata 2.2.1: HSI RC oscillator cannot be switched off in Run mode even if
	;     the HSIEN bit is programmed to 0.
	.mdelete clk_oscillator_disable
	.macro clk_oscillator_disable osc
		bres CLK_ICKR, #CLK_ICKR_'osc'EN
	.endm


	.mdelete clk_enable
	.macro clk_enable peripheral
		.iflt CLK_PCKENR_'peripheral-8
			bset CLK_PCKENR1, #CLK_PCKENR_'peripheral
		.else
			bset CLK_PCKENR2, #(CLK_PCKENR_'peripheral-8)
		.endif
	.endm

	.mdelete clk_disable
	.macro clk_disable peripheral
		.iflt CLK_PCKENR_'peripheral-8
			bres CLK_PCKENR1, #CLK_PCKENR_'peripheral
		.else
			bres CLK_PCKENR2, #(CLK_PCKENR_'peripheral-8)
		.endif
	.endm

	.mdelete clk_disable_all
	.macro clk_disable_all
		mov CLK_PCKENR1, #0
		.if STM8S_HAS_CAN | STM8S_HAS_ADC1 | STM8S_HAS_ADC2 | STM8S_HAS_AWU
			mov CLK_PCKENR2, #0
		.endif
	.endm


	; Turn regulator off in active-halt mode - low power, increased latency on wake up
	.mdelete clk_mvr_off_in_active_halt
	.macro clk_mvr_off_in_active_halt
		bset CLK_ICKR, #CLK_ICKR_REGAH
	.endm

	; Keep regulator on in active-halt mode
	.mdelete clk_mvr_on_in_active_halt
	.macro clk_mvr_on_in_active_halt
		bres CLK_ICKR, #CLK_ICKR_REGAH
	.endm


	.mdelete clk_enable_fast_wakeup_from_halt
	.macro clk_enable_fast_wakeup_from_halt
		bset CLK_ICKR, #CLK_ICKR_FHWU
	.endm

	.mdelete clk_disable_fast_wakeup_from_halt
	.macro clk_disable_fast_wakeup_from_halt
		bres CLK_ICKR, #CLK_ICKR_FHWU
	.endm
