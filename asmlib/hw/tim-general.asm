	.include "asmlib/hw/tim-basic.asm"


	TIM_IER_CC3IE =: 3 ; Capture/compare 3 interrupt enable
	TIM_IER_CC2IE =: 2 ; Capture/compare 2 interrupt enable
	TIM_IER_CC1IE =: 1 ; Capture/compare 1 interrupt enable

	TIM_SR1_CC3IF =: 3 ; Capture/compare 3 interrupt flag
	TIM_SR1_CC2IF =: 2 ; Capture/compare 2 interrupt flag
	TIM_SR1_CC1IF =: 1 ; Capture/compare 1 interrupt flag

	TIM_SR2_CC3OF =: 3 ; Capture/compare 3 overcapture flag
	TIM_SR2_CC2OF =: 2 ; Capture/compare 2 overcapture flag
	TIM_SR2_CC1OF =: 1 ; Capture/compare 1 overcapture flag

	TIM_EGR_CC3G  =: 3 ; Capture/compare 3 generation
	TIM_EGR_CC2G  =: 2 ; Capture/compare 2 generation
	TIM_EGR_CC1G  =: 1 ; Capture/compare 1 generation

	TIM_CCMR1_OC1M   =: 4 ; Bits [6:4]: Output compare 1 mode
	TIM_CCMR1_OC1PE  =: 3 ; Output compare 1 preload enable
	TIM_CCMR1_CC1S   =: 0 ; Bits [1:0]: Output compare 1 selection

	TIM_CCMR1_IC1F   =: 4 ; Bits [7:4]: Input capture 1 filter
	TIM_CCMR1_IC1PSC =: 2 ; Bits [3:2]: Input capture 1 prescaler

	TIM_CCMR2_OC2M   =: 4 ; Bits [6:4]: Output compare 2 mode
	TIM_CCMR2_OC2PE  =: 3 ; Output compare 2 preload enable
	TIM_CCMR2_CC2S   =: 0 ; Bits [1:0]: Output compare 2 selection

	TIM_CCMR2_IC2F   =: 4 ; Bits [7:4]: Input capture 2 filter
	TIM_CCMR2_IC2PSC =: 2 ; Bits [3:2]: Input capture 2 prescaler

	TIM_CCMR3_OC3M   =: 4 ; Bits [6:4]: Output compare 3 mode
	TIM_CCMR3_OC3PE  =: 3 ; Output compare 3 preload enable
	TIM_CCMR3_CC3S   =: 0 ; Bits [1:0]: Output compare 3 selection

	TIM_CCMR3_IC3F   =: 4 ; Bits [7:4]: Input capture 3 filter
	TIM_CCMR3_IC3PSC =: 2 ; Bits [3:2]: Input capture 3 prescaler

	TIM_CCER1_CC2P =: 5 ; Capture/compare 2 output polarity
	TIM_CCER1_CC2E =: 4 ; Capture/compare 2 output enable
	TIM_CCER1_CC1P =: 1 ; Capture/compare 1 output polarity
	TIM_CCER1_CC1E =: 0 ; Capture/compare 1 output enable

	TIM_CCER2_CC3P =: 1 ; Capture/compare 3 output polarity
	TIM_CCER2_CC3E =: 0 ; Capture/compare 3 output enable

	TIM_PSCR_PSC   =: 0 ; Bits [3:0]: Prescaler value


	TIM_SR2_RESET_VALUE =: 0x00
	TIM_CCMR1_RESET_VALUE =: 0x00
	TIM_CCMR2_RESET_VALUE =: 0x00
	TIM_CCMR3_RESET_VALUE =: 0x00
	TIM_CCER1_RESET_VALUE =: 0x00
	TIM_CCER2_RESET_VALUE =: 0x00
	TIM_CNTRH_RESET_VALUE =: 0x00
	TIM_CNTRL_RESET_VALUE =: 0x00
	TIM_PSCR_RESET_VALUE =: 0x00
	TIM_ARRH_RESET_VALUE =: 0xFF
	TIM_ARRL_RESET_VALUE =: 0xFF
	TIM_CCR1H_RESET_VALUE =: 0x00
	TIM_CCR1L_RESET_VALUE =: 0x00
	TIM_CCR2H_RESET_VALUE =: 0x00
	TIM_CCR2L_RESET_VALUE =: 0x00
	TIM_CCR3H_RESET_VALUE =: 0x00
	TIM_CCR3L_RESET_VALUE =: 0x00


	.mdelete tim_enable_capcom_interrupt
	.macro tim_enable_capcom_interrupt n channel
		.ifeq channel - 1
			bset TIM'n'_IER, #TIM_IER_CC1IE
		.else
		.ifeq channel - 2
			bset TIM'n'_IER, #TIM_IER_CC2IE
		.else
		.ifeq channel - 3
			bset TIM'n'_IER, #TIM_IER_CC3IE
		.else
		.endif
		.endif
		.endif
	.endm

	.mdelete tim_disable_capcom_interrupt
	.macro tim_disable_capcom_interrupt n channel
		.ifeq channel - 1
			bres TIM'n'_IER, #TIM_IER_CC1IE
		.else
		.ifeq channel - 2
			bres TIM'n'_IER, #TIM_IER_CC2IE
		.else
		.ifeq channel - 3
			bres TIM'n'_IER, #TIM_IER_CC3IE
		.else
		.endif
		.endif
		.endif
	.endm


	.mdelete tim_capcom_interrupt_ack
	.macro tim_capcom_interrupt_ack n channel
		.ifeq channel - 1
			bres TIM'n'_SR1, #TIM_SR1_CC1IF
		.else
		.ifeq channel - 2
			bres TIM'n'_SR1, #TIM_SR1_CC2IF
		.else
		.ifeq channel - 3
			bres TIM'n'_SR1, #TIM_SR1_CC3IF
		.else
		.endif
		.endif
		.endif
	.endm


	.mdelete tim_capcom_if_overcapture
	.macro tim_capcom_if_overcapture channel label
		.ifeq channel - 1
			btjt TIM'n'_SR2, #TIM_SR2_CC1OF, label
		.else
		.ifeq channel - 2
			btjt TIM'n'_SR2, #TIM_SR2_CC2OF, label
		.else
		.ifeq channel - 3
			btjt TIM'n'_SR2, #TIM_SR2_CC3OF, label
		.else
		.endif
		.endif
		.endif
	.endm

	.mdelete tim_capcom_clear_overcapture
	.macro tim_capcom_clear_overcapture n channel
		.ifeq channel - 1
			bres TIM'n'_SR2, #TIM_SR2_CC1OF
		.else
		.ifeq channel - 2
			bres TIM'n'_SR2, #TIM_SR2_CC2OF
		.else
		.ifeq channel - 3
			bres TIM'n'_SR2, #TIM_SR2_CC3OF
		.else
		.endif
		.endif
		.endif
	.endm

	.mdelete tim_capcom
	.macro tim_capcom n channel
		.ifeq channel - 1
			bset TIM'n'_EGR, #TIM_EGR_CC1G
		.else
		.ifeq channel - 2
			bset TIM'n'_EGR, #TIM_EGR_CC2G
		.else
		.ifeq channel - 3
			bset TIM'n'_EGR, #TIM_EGR_CC3G
		.else
		.endif
		.endif
		.endif
	.endm


	.mdelete timg_set_pscr_and_arr
	.macro timg_set_pscr_and_arr n pscr value
		.ifeq tim_pscr_and_arr_done
			; N.B. Some ranges may overlap and the higher PSCR may actually give
			; a closer match to the target then the lower PSCR. No account of this
			; is taken here. If you want best accuracy you have to program the
			; PSCR and ARR yourself.
			.iflt value - (65536 << pscr)
				mov TIM'n'_PSCR, #pscr
				mov TIM'n'_ARRH, #((value + ((1 << pscr) >> 1)) / (1 << pscr)) >> 8
				mov TIM'n'_ARRL, #((value + ((1 << pscr) >> 1)) / (1 << pscr)) & 0xff
				tim_pscr_and_arr_done =: 1
			.endif
		.endif
	.endm


	.mdelete timg_set_freq
	.macro timg_set_freq n f_PERIPH_MHz freq
		tim_pscr_and_arr_value =: ((f_PERIPH_MHz * 1000000 + freq / 2) / freq)

		tim_pscr_and_arr_done =: 0
		timg_set_pscr_and_arr n  0 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  1 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  2 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  3 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  4 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  5 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  6 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  7 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  8 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  9 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 10 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 11 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 12 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 13 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 14 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 15 tim_pscr_and_arr_value
	.endm


	.mdelete timg_set_time
	.macro timg_set_time n f_PERIPH_MHz ms
		tim_pscr_and_arr_value =: (ms * (f_PERIPH_MHz * 1000))

		tim_pscr_and_arr_done =: 0
		timg_set_pscr_and_arr n  0 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  1 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  2 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  3 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  4 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  5 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  6 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  7 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  8 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n  9 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 10 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 11 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 12 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 13 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 14 tim_pscr_and_arr_value
		timg_set_pscr_and_arr n 15 tim_pscr_and_arr_value
	.endm
