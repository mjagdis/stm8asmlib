	.include "asmlib/hw/tim4.asm"

	I2C_BaseAddress =: 0x5210

	I2C_CR1        =: I2C_BaseAddress + 0 ; I2C control register 1
	I2C_CR2        =: I2C_BaseAddress +  1 ; I2C control register 2
	I2C_FREQR      =: I2C_BaseAddress +  2 ; I2C frequency register
	I2C_OARL       =: I2C_BaseAddress +  3 ; I2C own address register LSB
	I2C_OARH       =: I2C_BaseAddress +  4 ; I2C own address register MSB
	I2C_RESERVED_1 =: I2C_BaseAddress +  5 ; Reserved byte
	I2C_DR         =: I2C_BaseAddress +  6 ; I2C data register
	I2C_SR1        =: I2C_BaseAddress +  7 ; I2C status register 1
	I2C_SR2        =: I2C_BaseAddress +  8 ; I2C status register 2
	I2C_SR3        =: I2C_BaseAddress +  9 ; I2C status register 3
	I2C_ITR        =: I2C_BaseAddress + 10 ; I2C interrupt register
	I2C_CCRL       =: I2C_BaseAddress + 11 ; I2C clock control register low
	I2C_CCRH       =: I2C_BaseAddress + 12 ; I2C clock control register high
	I2C_TRISER     =: I2C_BaseAddress + 13 ; I2C maximum rise time register


	I2C_CR1_RESET_VALUE    =: 0x00
	I2C_CR2_RESET_VALUE    =: 0x00
	I2C_FREQR_RESET_VALUE  =: 0x00
	I2C_OARL_RESET_VALUE   =: 0x00
	I2C_OARH_RESET_VALUE   =: 0x00
	I2C_DR_RESET_VALUE     =: 0x00
	I2C_SR1_RESET_VALUE    =: 0x00
	I2C_SR2_RESET_VALUE    =: 0x00
	I2C_SR3_RESET_VALUE    =: 0x00
	I2C_ITR_RESET_VALUE    =: 0x00
	I2C_CCRL_RESET_VALUE   =: 0x00
	I2C_CCRH_RESET_VALUE   =: 0x00
	I2C_TRISER_RESET_VALUE =: 0x02


	I2C_CR1_NOSTRETCH     =: 7 ; Clock stretching disable (slave mode)
	I2C_CR1_ENGC          =: 6 ; General call enable
	I2C_CR1_PE            =: 0 ; Peripheral enable

	I2C_CR2_SWRST         =: 7 ; Software reset
	I2C_CR2_POS           =: 3 ; Acknowledge
	I2C_CR2_ACK           =: 2 ; Acknowledge enable
	I2C_CR2_STOP          =: 1 ; Stop generation
	I2C_CR2_START         =: 0 ; Start generation

	I2C_FREQR_FREQ        =: 0 ; Bits [5:0]: peripheral clock frequency
	                             ; RM0016 21.7.3: minimum 1MHz for standard mode, 4MHz for fast mode

	I2C_OARL_ADD          =: 1 ; Bits [7:1]: Interface address bits 7:1
	I2C_OARL_ADD0         =: 0 ; Bit  [0]: Interface address bit 0

	I2C_OARH_ADDMODE      =: 7 ; Addressing mode (slave mode)
	I2C_OARH_ADDCONF      =: 6 ; Address mode configuration
	I2C_OARH_ADD          =: 1 ; Bits [2:1]: interface address bits [9..8]

	I2C_SR1_TXE           =: 7 ; Data register empty (transmitters)
	I2C_SR1_RXNE          =: 6 ; Data register not empty (receivers)
	I2C_SR1_RESERVED_5    =: 5
	I2C_SR1_STOPF         =: 4 ; Stop detection (slave mode)
	I2C_SR1_ADD10         =: 3 ; 10-bit header sent (master mode)
	I2C_SR1_BTF           =: 2 ; Byte transfer finished
	I2C_SR1_ADDR          =: 1 ; Address sent (master mode)/matched (slave mode)
	I2C_SR1_SB            =: 0 ; Start bit (master mode)

	I2C_SR2_RESERVED_6    =: 6 ; Bits [7:6]
	I2C_SR2_WUFH          =: 5 ; Wake-up from halt
	I2C_SR2_RESERVED_4    =: 4
	I2C_SR2_OVR           =: 3 ; Overrun/underrun
	I2C_SR2_AF            =: 2 ; Acknowledge failure
	I2C_SR2_ARLO          =: 1 ; Arbitration lost (master mode)
	I2C_SR2_BERR          =: 0 ; Bus error

	I2C_SR3_DUALF         =: 7 ; Dual flag (Slave mode)
	I2C_SR3_RESERVED_5    =: 5 ; Bits [6:5]
	I2C_SR3_GENCALL       =: 4 ; General call header (slave mode)
	I2C_SR3_RESERVED_3    =: 3
	I2C_SR3_TRA           =: 2 ; Transmitter/receiver
	I2C_SR3_BUSY          =: 1 ; Bus busy
	I2C_SR3_MSL           =: 0 ; Master/slave

	I2C_ITR_RESERVED_3    =: 3 ; Bits [7:3]
	I2C_ITR_ITBUFEN       =: 2 ; Buffer interrupt enable
	I2C_ITR_ITEVTEN       =: 1 ; Event interrupt enable
	I2C_ITR_ITERREN       =: 0 ; Error interrupt enable

	I2C_CCRH_FS           =: 7 ; Master mode selection
	I2C_CCRH_DUTY         =: 6 ; Fast mode duty cycle
	I2C_CCRH_RESERVED_4   =: 4 ; Bits [5:4]
	I2C_CCRH_CCR          =: 0 ; Bits [3:0]: Clock control register in fast/standard mode (master mode) bits [11:8]

	I2C_TRISER_RESERVED_6 =: 6 ; Bits [7:6]
	I2C_TRISER_TRISE      =: 0 ; Bits [5:0] Maximum rise time in fast/standard mode (master mode)


	.ifle I2C_FREQ_kHz - 100
		I2C_MAX_SCL_RISE_NS =: 1000
	.else
		.ifle I2C_FREQ_kHz - 400
			I2C_MAX_SCL_RISE_NS =: 300
		.endif
	.endif

	.mdelete i2c_wait_for_completion
	.macro i2c_wait_for_completion level ?loop ?done
		std_wait_for_bit I2C_SR3 I2C_SR3_MSL f wfi level
	.endm

	.mdelete i2c_reset
	.macro i2c_reset
		bset I2C_CR2, #I2C_CR2_SWRST
	.endm


	.mdelete i2c_enable
	.macro i2c_enable
		clk_enable I2C
		bset I2C_CR1, #I2C_CR1_PE
	.endm

	.mdelete i2c_disable
	.macro i2c_disable
		bres I2C_CR1, #I2C_CR1_PE
		clk_disable I2C
	.endm


	.mdelete i2c_enable_ack
	.macro i2c_enable_ack
		bset I2C_CR2, #I2C_CR2_ACK
	.endm

	.mdelete i2c_disable_ack
	.macro i2c_disable_ack
		bres I2C_CR2, #I2C_CR2_ACK
	.endm


	.mdelete i2c_send_start
	.macro i2c_send_start
		bset I2C_CR2, #I2C_CR2_START
	.endm

	.mdelete i2c_send_stop
	.macro i2c_send_stop
		bset I2C_CR2, #I2C_CR2_STOP
	.endm


	.mdelete i2c_nack_next
	.macro i2c_nack_next
		bset I2C_CR2, #I2C_CR2_POS
	.endm

	.mdelete i2c_ack_current
	.macro i2c_ack_current
		bres I2C_CR2, #I2C_CR2_POS
	.endm


	.mdelete i2c_clear_all_errors
	.macro i2c_clear_all_errors
		clr I2C_SR2
	.endm


	.mdelete i2c_init
	.macro i2c_init clk_freq_MHz i2c_freq_kHz i2c_timeout_ms
		; STM8S003F3 Datasheet 5.2: SCL = PB4 and SDA = PB5.
		; RM0016 11.7.1: For alternate function input, you should select floating
		;     or pull-up input configuration in the DDR and CR1 registers.
		; RM0016 11.5: Unused I/O pins must not be left floating to avoid extra
		;     current consumption.
		; Therefore we need PB4/PB5 configured as inputs with pull-ups.
		; This is the same as the main power save config that may be applied during
		; the application start up.
		bset GPIOB+GPIO_CR1, #4
		bres GPIOB+GPIO_DDR, #4
		bset GPIOB+GPIO_CR1, #5
		bres GPIOB+GPIO_DDR, #5

		; TIM4 is used to generate timeouts for I2C transactions.
		; ARR is buffered, interrupt only on overflow/underflow.
		mov TIM4_CR1, #((1 << TIM_CR1_ARPE) | (1 << TIM_CR1_URS))
		tim4 enable_update_interrupt
		tim4 set_time clk_freq_MHz i2c_timeout_ms

		mov I2C_FREQR, #clk_freq_MHz
		mov I2C_TRISER, #(I2C_MAX_SCL_RISE_NS * clk_freq_MHz / 1000 + 1)

		.ifle i2c_freq_kHz - 100
			; Standard mode
			__speed	=: clk_freq_MHz * 1000 / (i2c_freq_kHz << 1)
			.iflt __speed - 4
				__speed	=: 4
			.endif
			mov I2C_CCRL, #(__speed & 0xff)
			mov I2C_CCRH, #((__speed >> 8) & I2C_CCRH_CCR)
		.else
			.ifle i2c_freq_kHz - 400
				; Fast mode, 16:9 duty cycle.
				; Fast mode speed calculation with Tlow/Thigh = 16/9
				__speed	=: clk_freq_MHz * 1000 / (i2c_freq_kHz * 25)
				.iflt __speed - 1
					__speed	=: 1
				.endif
				mov I2C_CCRL, #(__speed & 0xff)
				mov I2C_CCRH, #((__speed >> 8) & I2C_CCRH_CCR) | (1 << I2C_CCRH_FS) | (1 << I2C_CCRH_DUTY)
			.else
				ERROR Unsupported value for i2c_freq_kHz
			.endif
		.endif

		; Enable buffer, event and error interrupts.
		mov I2C_ITR, #((1 << I2C_ITR_ITBUFEN) | (1 << I2C_ITR_ITEVTEN) | (1 << I2C_ITR_ITERREN))
	.endm

	.mdelete i2c_set_address
	.macro i2c_set_address addr
		; Set own address
		.iflt addr - 0x8000
			; 7-bit address mode
			mov I2C_OARL, #(addr << 1)
			bset I2C_OARH, #I2C_OARH_ADDCONF
		.else
			.ifne I2C_FEATURE_10BIT
				; 10-bit address mode
				mov I2C_OARL, #(addr & 0xff)
				ld a, I2C_OARH
				and a, #(0b11 << I2C_OARH_ADD)
				or a, #(((addr >> 8) & 0b11) << I2C_OARH_ADD) | I2C_OARH_ADDMODE | I2C_OARH_ADDCONF
			.else
				ERROR 10-bit address given but I2C_FEATURE_10BIT is zero
			.endif
		.endif

		; Be ready to ack our address
		i2c_enable_ack

		; And listen for it...
		i2c_enable
	.endm


	.mdelete i2c_read
	.macro i2c_read addr nbytes buf
		movw i2c_addr, #addr
		clr i2c_direction
		mov i2c_nbytes, #nbytes
		movw i2c_buf, #buf
	.endm

	.mdelete i2c_write
	.macro i2c_write addr nbytes buf
		movw i2c_addr, #addr
		mov i2c_direction, #1
		mov i2c_nbytes, #nbytes
		movw i2c_buf, #buf
	.endm

	.mdelete i2c_exec
	.macro i2c_exec
		i2c_enable
		i2c_enable_ack
		i2c_send_start
		tim4 enable
		i2c_wait_for_completion	IRQ_PRIORITY_I2C
	.endm
