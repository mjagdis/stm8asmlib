	.include "asmlib/hw/tim-basic.asm"


	TIM1_BaseAddress =: 0x5250

	TIM1_CR1   =: TIM1_BaseAddress +  0 ; control register 1
	TIM1_CR2   =: TIM1_BaseAddress +  1 ; control register 2
	TIM1_SMCR  =: TIM1_BaseAddress +  2 ; Synchro mode control register
	TIM1_ETR   =: TIM1_BaseAddress +  3 ; external trigger register
	TIM1_IER   =: TIM1_BaseAddress +  4 ; interrupt enable register*/
	TIM1_SR1   =: TIM1_BaseAddress +  5 ; status register 1
	TIM1_SR2   =: TIM1_BaseAddress +  6 ; status register 2
	TIM1_EGR   =: TIM1_BaseAddress +  7 ; event generation register
	TIM1_CCMR1 =: TIM1_BaseAddress +  8 ; CC mode register 1
	TIM1_CCMR2 =: TIM1_BaseAddress +  9 ; CC mode register 2
	TIM1_CCMR3 =: TIM1_BaseAddress + 10 ; CC mode register 3
	TIM1_CCMR4 =: TIM1_BaseAddress + 11 ; CC mode register 4
	TIM1_CCER1 =: TIM1_BaseAddress + 12 ; CC enable register 1
	TIM1_CCER2 =: TIM1_BaseAddress + 13 ; CC enable register 2
	TIM1_CNTRH =: TIM1_BaseAddress + 14 ; counter high
	TIM1_CNTRL =: TIM1_BaseAddress + 15 ; counter low
	TIM1_PSCRH =: TIM1_BaseAddress + 16 ; prescaler high
	TIM1_PSCRL =: TIM1_BaseAddress + 17 ; prescaler low
	TIM1_ARRH  =: TIM1_BaseAddress + 18 ; auto-reload register high
	TIM1_ARRL  =: TIM1_BaseAddress + 19 ; auto-reload register low
	TIM1_RCR   =: TIM1_BaseAddress + 20 ; Repetition Counter register
	TIM1_CCR1H =: TIM1_BaseAddress + 21 ; capture/compare register 1 high
	TIM1_CCR1L =: TIM1_BaseAddress + 22 ; capture/compare register 1 low
	TIM1_CCR2H =: TIM1_BaseAddress + 23 ; capture/compare register 2 high
	TIM1_CCR2L =: TIM1_BaseAddress + 24 ; capture/compare register 2 low
	TIM1_CCR3H =: TIM1_BaseAddress + 25 ; capture/compare register 3 high
	TIM1_CCR3L =: TIM1_BaseAddress + 26 ; capture/compare register 3 low
	TIM1_CCR4H =: TIM1_BaseAddress + 27 ; capture/compare register 3 high
	TIM1_CCR4L =: TIM1_BaseAddress + 28 ; capture/compare register 3 low
	TIM1_BKR   =: TIM1_BaseAddress + 39 ; Break Register
	TIM1_DTR   =: TIM1_BaseAddress + 30 ; dead-time register
	TIM1_OISR  =: TIM1_BaseAddress + 31 ; Output idle register


	TIM1_CR1_RESET_VALUE   =: 0x00
	TIM1_CR2_RESET_VALUE   =: 0x00
	TIM1_SMCR_RESET_VALUE  =: 0x00
	TIM1_ETR_RESET_VALUE   =: 0x00
	TIM1_IER_RESET_VALUE   =: 0x00
	TIM1_SR1_RESET_VALUE   =: 0x00
	TIM1_SR2_RESET_VALUE   =: 0x00
	TIM1_EGR_RESET_VALUE   =: 0x00
	TIM1_CCMR1_RESET_VALUE =: 0x00
	TIM1_CCMR2_RESET_VALUE =: 0x00
	TIM1_CCMR3_RESET_VALUE =: 0x00
	TIM1_CCMR4_RESET_VALUE =: 0x00
	TIM1_CCER1_RESET_VALUE =: 0x00
	TIM1_CCER2_RESET_VALUE =: 0x00
	TIM1_CNTRH_RESET_VALUE =: 0x00
	TIM1_CNTRL_RESET_VALUE =: 0x00
	TIM1_PSCRH_RESET_VALUE =: 0x00
	TIM1_PSCRL_RESET_VALUE =: 0x00
	TIM1_ARRH_RESET_VALUE  =: 0xFF
	TIM1_ARRL_RESET_VALUE  =: 0xFF
	TIM1_RCR_RESET_VALUE   =: 0x00
	TIM1_CCR1H_RESET_VALUE =: 0x00
	TIM1_CCR1L_RESET_VALUE =: 0x00
	TIM1_CCR2H_RESET_VALUE =: 0x00
	TIM1_CCR2L_RESET_VALUE =: 0x00
	TIM1_CCR3H_RESET_VALUE =: 0x00
	TIM1_CCR3L_RESET_VALUE =: 0x00
	TIM1_CCR4H_RESET_VALUE =: 0x00
	TIM1_CCR4L_RESET_VALUE =: 0x00
	TIM1_BKR_RESET_VALUE   =: 0x00
	TIM1_DTR_RESET_VALUE   =: 0x00
	TIM1_OISR_RESET_VALUE  =: 0x00


	TIM1_CR1_ARPE =: TIMbasic_CR1_ARPE
	TIM1_CR1_CMS  =: 5 ; Bits [6:5]: Center-aligned mode selection
		TIM1_CR1_CMS_EDGE    =: (0b00 << _TIM1_CR1_CMS)
		TIM1_CR1_CMS_CENTER1 =: (0b01 << _TIM1_CR1_CMS)
		TIM1_CR1_CMS_CENTER2 =: (0b10 << _TIM1_CR1_CMS)
		TIM1_CR1_CMS_CENTER3 =: (0b11 << _TIM1_CR1_CMS)
	TIM1_CR1_DIR  =: 4 ; Direction
	TIM1_CR1_OPM  =: TIMbasic_CR1_OPM
	TIM1_CR1_URS  =: TIMbasic_CR1_URS
	TIM1_CR1_UDIS =: TIMbasic_CR1_UDIS
	TIM1_CR1_CEN  =: TIMbasic_CR1_CEN

	TIM1_CR2_MMS  =: 4 ; Bits [6:4]: MMS selection
		TIM1_CR2_MMS_UPDATE =: (0b010 << _TIM1_CR2_MMS)
		TIM1_CR2_MMS_MATCH1 =: (0b011 << _TIM1_CR2_MMS)
		TIM1_CR2_MMS_OC1REF =: (0b100 << _TIM1_CR2_MMS)
		TIM1_CR2_MMS_OC2REF =: (0b101 << _TIM1_CR2_MMS)
		TIM1_CR2_MMS_OC3REF =: (0b110 << _TIM1_CR2_MMS)
		TIM1_CR2_MMS_OC4REF =: (0b111 << _TIM1_CR2_MMS)
	TIM1_CR2_COMS =: 2 ; Capture/compare control update selection
	TIM1_CR2_CCPC =: 0 ; Capture/compare preloaded control

	TIM1_SMCR_MSM =: 7 ; Master/slave mode
	TIM1_SMCR_TS  =: 4 ; Bits [6:4]: trigger selection
		TIM1_SMCR_TS_ITR0    =: (0b000 << _TIM1_SMCR_TS)
		TIM1_SMCR_TS_ITR3    =: (0b011 << _TIM1_SMCR_TS)
		TIM1_SMCR_TS_TI1F_ED =: (0b100 << _TIM1_SMCR_TS)
		TIM1_SMCR_TS_TI1FP1  =: (0b101 << _TIM1_SMCR_TS)
		TIM1_SMCR_TS_TI1FP2  =: (0b110 << _TIM1_SMCR_TS)
		TIM1_SMCR_TS_ETRF    =: (0b111 << _TIM1_SMCR_TS)
	TIM1_SMCR_SMS =: 0 ; Bits [2:0]: slave mode selection
		TIM1_SMCR_SMS_MODE1 =: (0b001 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_MODE2 =: (0b010 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_MODE3 =: (0b011 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_RESET =: (0b100 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_GATED =: (0b101 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_STD   =: (0b110 << _TIM1_SMCR_SMS)
		TIM1_SMCR_SMS_EXT   =: (0b111 << _TIM1_SMCR_SMS)

	TIM1_ETR_ETP  =: 7 ; External trigger polarity
	TIM1_ETR_ECE  =: 6 ; External clock
	TIM1_ETR_ETPS =: 4 ; Bits [5:4]: external trigger prescaler
		TIM1_ETR_ETPS_OFF  =: (0b00 << _TIM1_ETR_ETPS)
		TIM1_ETR_ETPS_DIV2 =: (0b01 << _TIM1_ETR_ETPS)
		TIM1_ETR_ETPS_DIV4 =: (0b10 << _TIM1_ETR_ETPS)
		TIM1_ETR_ETPS_DIV8 =: (0b11 << _TIM1_ETR_ETPS)
	TIM1_ETR_ETF  =: 0 ; Bits [3:0]: external trigger filter
		TIM1_ETR_ETPS_N2      =: (0b0001 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_N4      =: (0b0010 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_N8      =: (0b0011 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV2N6  =: (0b0100 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV2N8  =: (0b0101 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV4N6  =: (0b0110 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV4N8  =: (0b0111 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV8N6  =: (0b1000 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV8N8  =: (0b1001 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV16N5 =: (0b1010 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV16N6 =: (0b1011 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV16N8 =: (0b1100 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV32N5 =: (0b1101 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV32N6 =: (0b1110 << _TIM1_ETR_ETF)
		TIM1_ETR_ETPS_DIV32N8 =: (0b1111 << _TIM1_ETR_ETF)

	TIM1_IER_BIE   =: 7 ; Break interrupt enable
	TIM1_IER_TIE   =: 6 ; Trigger interrupt enable
	TIM1_IER_COMIE =: 5 ; Commutation interrupt enable
	TIM1_IER_CC4IE =: 4 ; Capture/compare 4 interrupt enable
	TIM1_IER_CC3IE =: 3 ; Capture/compare 3 interrupt enable
	TIM1_IER_CC2IE =: 2 ; Capture/compare 2 interrupt enable
	TIM1_IER_CC1IE =: 1 ; Capture/compare 1 interrupt enable
	TIM1_IER_UIE   =: TIMbasic_IER_UIE

	TIM1_SR1_BIF   =: 7 ; Break interrupt flag
	TIM1_SR1_TIF   =: 6 ; Trigger interrupt flag
	TIM1_SR1_COMIF =: 5 ; Commutation interrupt flag
	TIM1_SR1_CC4IF =: 4 ; Capture/compare 4 interrupt flag
	TIM1_SR1_CC3IF =: 3 ; Capture/compare 3 interrupt flag
	TIM1_SR1_CC2IF =: 2 ; Capture/compare 2 interrupt flag
	TIM1_SR1_CC1IF =: 1 ; Capture/compare 1 interrupt flag
	TIM1_SR1_UIF   =: TIMbasic_SR1_UIF

	TIM1_SR2_CC4OF =: 4 ; Capture/compare 4 overcapture flag
	TIM1_SR2_CC3OF =: 3 ; Capture/compare 3 overcapture flag
	TIM1_SR2_CC2OF =: 2 ; Capture/compare 2 overcapture flag
	TIM1_SR2_CC1OF =: 1 ; Capture/compare 1 overcapture flag

	TIM1_EGR_BG   =: 7 ; Break generation
	TIM1_EGR_TG   =: 6 ; Trigger generation
	TIM1_EGR_COMG =: 5 ; Capture/compare control update generation
	TIM1_EGR_CC4G =: 4 ; Capture/compare 4 generation
	TIM1_EGR_CC3G =: 3 ; Capture/compare 3 generation
	TIM1_EGR_CC2G =: 2 ; Capture/compare 2 generation
	TIM1_EGR_CC1G =: 1 ; Capture/compare 1 generation
	TIM1_EGR_UG   =: TIMbasic_EGR_UG

	TIM1_CCMR_OCxCE  =: 7 ; Output compare x clear enable
	TIM1_CCMR_OCxM   =: 4 ; Bits [6:4]: output compare x mode
		TIM1_CCMR_OCxM_FROZEN         =: (0b000 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_MATCH_ACTIVE   =: (0b001 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_MATCH_INACTIVE =: (0b010 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_TOGGLE         =: (0b011 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_FORCE_INACTIVE =: (0b100 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_FORCE_ACTIVE   =: (0b101 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_PWM_MODE1      =: (0b110 << _TIM1_CCMR_OCxM)
		TIM1_CCMR_OCxM_PWM_MODE2      =: (0b111 << _TIM1_CCMR_OCxM)
	TIM1_CCMR_OCxPE  =: 3       ; Output compare x preload enable
	TIM1_CCMR_OCxFE  =: 2       ; Output compare x fast enable

	TIM1_CCMR_ICxF   =: 4 ; Bits [7:4]: input capture x filter
		TIM1_CCMR_ICxF_NONE    =: (0b0000 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_N2      =: (0b0001 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_N4      =: (0b0010 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_N8      =: (0b0011 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV2N6  =: (0b0100 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV2N8  =: (0b0101 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV4N6  =: (0b0110 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV4N8  =: (0b0111 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV8N6  =: (0b1000 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV8N8  =: (0b1001 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV16N5 =: (0b1010 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV16N6 =: (0b1011 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV16N8 =: (0b1100 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV32N5 =: (0b1101 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV32N6 =: (0b1110 << _TIM1_CCMR_ICxF)
		TIM1_CCMR_ICxF_DIV32N8 =: (0b1111 << _TIM1_CCMR_ICxF)
	TIM1_CCMR_ICxPSC =: 2 ; Bits [3:2]: Input capture x prescaler
		TIM1_CCMR_ICxPSC_NONE   =: (0b00 << _TIM1_CCMR_ICxPSC)
		TIM1_CCMR_ICxPSC_EVERY2 =: (0b01 << _TIM1_CCMR_ICxPSC)
		TIM1_CCMR_ICxPSC_EVERY4 =: (0b10 << _TIM1_CCMR_ICxPSC)
		TIM1_CCMR_ICxPSC_EVERY8 =: (0b11 << _TIM1_CCMR_ICxPSC)

	TIM1_CCMR_CCxS   =: 0 ; Bits [1:0]: capture/compare x selection
		TIM1_CCMR_CCxS_OUTPUT =: (0b00 << _TIM1_CCMR_CCxS)
		TIM1_CCMR_CCxS_TI1FP1 =: (0b01 << _TIM1_CCMR_CCxS)
		TIM1_CCMR_CCxS_TI2FP1 =: (0b10 << _TIM1_CCMR_CCxS)
		TIM1_CCMR_CCxS_TRC    =: (0b11 << _TIM1_CCMR_CCxS)

	TIM1_CCER1_CC2NP =: 7 ; Capture/compare 2 complementary output polarity
	TIM1_CCER1_CC2NE =: 6 ; Capture/compare 2 complementary output enable
	TIM1_CCER1_CC2P  =: 5 ; Capture/compare 2 output polarity
	TIM1_CCER1_CC2E  =: 4 ; Capture/compare 2 output enable
	TIM1_CCER1_CC1NP =: 3 ; Capture/compare 1 complementary output polarity
	TIM1_CCER1_CC1NE =: 2 ; Capture/compare 1 complementary output enable
	TIM1_CCER1_CC1P  =: 1 ; Capture/compare 1 output polarity
	TIM1_CCER1_CC1E  =: 0 ; Capture/compare 1 output enable

	TIM1_CCER2_CC4P  =: 5 ; capture/compare 4 output polarity
	TIM1_CCER2_CC4E  =: 4 ; capture/compare 4 output enable
	TIM1_CCER2_CC3NP =: 3 ; capture/compare 3 complementary output polarity
	TIM1_CCER2_CC3NE =: 2 ; capture/compare 3 complementary output enable
	TIM1_CCER2_CC3P  =: 1 ; capture/compare 3 output polarity
	TIM1_CCER2_CC3E  =: 0 ; capture/compare 3 output enable

	TIM1_BKR_MOE  =: 7 ; Main output enable
	TIM1_BKR_AOE  =: 6 ; Automatic output enable
	TIM1_BKR_BKP  =: 5 ; Break polarity
	TIM1_BKR_BKE  =: 4 ; Break enable
	TIM1_BKR_OSSR =: 3 ; Off-state selection for run mode
	TIM1_BKR_OSSI =: 2 ; Off-state selection for idle mode
	TIM1_BKR_LOCK =: 0 ; Bits [1:0]: lock configuration
		TIM1_BKR_LOCK_OFF    =: (0b00 << _TIM1_BKR_LOCK)
		TIM1_BKR_LOCK_LEVEL1 =: (0b01 << _TIM1_BKR_LOCK)
		TIM1_BKR_LOCK_LEVEL2 =: (0b10 << _TIM1_BKR_LOCK)
		TIM1_BKR_LOCK_LEVEL3 =: (0b11 << _TIM1_BKR_LOCK)

	TIM1_OISR_OIS4  =: 6 ; Output Idle state 4 (OC4 output)
	TIM1_OISR_OIS3N =: 5 ; Output Idle state 3 (OC3N output)
	TIM1_OISR_OIS3  =: 4 ; Output Idle state 3 (OC3 output)
	TIM1_OISR_OIS2N =: 3 ; Output Idle state 2 (OC2N output)
	TIM1_OISR_OIS2  =: 2 ; Output Idle state 2 (OC2 output)
	TIM1_OISR_OIS1N =: 1 ; Output Idle state 1 (OC1N output)
	TIM1_OISR_OIS1  =: 0 ; Output Idle state 1 (OC1 output)


	.mdelete tim1_wait_for
	.macro tim1_wait_for what ?loop
loop:
	btjf TIM1_SR1, #TIM1_SR1_'what, loop
	.endm



	.mdelete tim1_arr_not_buffered
	.macro tim1_arr_not_buffered
		tim_arr_not_buffered 1
	.endm

	.mdelete tim1_arr_buffered
	.macro tim1_arr_buffered
		tim_arr_buffered 1
	.endm


	.mdelete tim1_disable_one_pulse_mode
	.macro tim1_disable_one_pulse_mode
		tim_disable_one_pulse_mode 1
	.endm

	.mdelete tim1_enable_one_pulse_mode
	.macro tim1_enable_one_pulse_mode
		tim_enable_one_pulse_mode 1
	.endm


	.mdelete tim1_interrupt_on_update_and_overflow
	.macro tim1_interrupt_on_update_and_overflow
		tim_interrupt_on_update_and_overflow 1
	.endm

	.mdelete tim1_interrupt_on_overflow_only
	.macro tim1_interrupt_on_overflow_only
		tim_interrupt_on_overflow_only 1
	.endm


	.mdelete tim1_enable_updates
	.macro tim1_enable_updates
		tim_enable_updates 1
	.endm

	.mdelete tim1_disable_updates
	.macro tim1_disable_updates
		tim_disable_updates 1
	.endm


	.mdelete tim1_enable
	.macro tim1_enable
		tim_enable 1
	.endm

	.mdelete tim1_disable
	.macro tim1_disable
		tim_disable 1
	.endm


	.mdelete tim1_restart
	.macro tim1_restart
		tim_restart 1
	.endm


	.mdelete tim1_enable_update_interrupt
	.macro tim1_enable_update_interrupt
		tim_enable_update_interrupt 1
	.endm

	.mdelete tim1_disable_update_interrupt
	.macro tim1_disable_update_interrupt
		tim_disable_update_interrupt 1
	.endm


	.mdelete tim1_ack_interrupt
	.macro tim1_ack_interrupt
		tim_ack_interrupt 1
	.endm


	.mdelete tim4_set_time
	.macro tim4_set_time f_PERIPH_MHz ms
		; ticks per second = f_PERIPH_MHz * 1000000 / 2^PSCR
		; ticks for ms = (f_PERIPH_MHz * 1000000 / 2^PSCR) / ms
		; FIXME: should we use the smallest prescalar we can or the largest.
		; What is the accuracy/power trade off and do we care.
		tim4_ticks = ms * (f_PERIPH_MHz * 1000)
		.iflt tim4_ticks - 256
			mov TIM4_PSCR, #0
			mov TIM4_ARR, #(tim4_ticks)
		.else
		.iflt tim4_ticks - 512
			mov TIM4_PSCR, #1
			mov TIM4_ARR, #((tim4_ticks + 1) / 2)
		.else
		.iflt tim4_ticks - 1024
			mov TIM4_PSCR, #2
			mov TIM4_ARR, #((tim4_ticks + 2) / 4)
		.else
		.iflt tim4_ticks - 2048
			mov TIM4_PSCR, #3
			mov TIM4_ARR, #((tim4_ticks + 4) / 8)
		.else
		.iflt tim4_ticks - 4096
			mov TIM4_PSCR, #4
			mov TIM4_ARR, #((tim4_ticks + 8) / 16)
		.else
		.iflt tim4_ticks - 8192
			mov TIM4_PSCR, #5
			mov TIM4_ARR, #((tim4_ticks + 16) / 32)
		.else
		.iflt tim4_ticks - 16384
			mov TIM4_PSCR, #6
			mov TIM4_ARR, #((tim4_ticks + 32) / 64)
		.else
		.iflt tim4_ticks - 32768
			mov TIM4_PSCR, #7
			mov TIM4_ARR, #((tim4_ticks + 64) / 128)
		.else
			ERROR delay is too great
		.endif
		.endif
		.endif
		.endif
		.endif
		.endif
		.endif
		.endif
	.endm
