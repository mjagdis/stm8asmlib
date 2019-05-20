	TIM_CR1_ARPE =: 7 ; Auto-reload preload enable
	TIM_CR1_OPM  =: 3 ; One pulse mode
	TIM_CR1_URS  =: 2 ; Update request source
	TIM_CR1_UDIS =: 1 ; Update disable
	TIM_CR1_CEN  =: 0 ; Counter enable

	TIM_EGR_TG   =: 6 ; Trigger generation (not TIM4)
	TIM_EGR_UG   =: 0 ; Update generation

	TIM_IER_TIE  =: 6 ; Trigger interrupt enable (not TIM4)
	TIM_IER_UIE  =: 0 ; Update interrupt enable

	TIM_SR1_TIF  =: 6 ; Trigger interrupt flag (not TIM4)
	TIM_SR1_UIF  =: 0 ; Update interrupt flag


	TIM_CR1_RESET_VALUE  =: 0x00
	TIM_IER_RESET_VALUE  =: 0x00
	TIM_SR1_RESET_VALUE  =: 0x00
	TIM_EGR_RESET_VALUE  =: 0x00
	TIM_CNTR_RESET_VALUE =: 0x00
	TIM_PSCR_RESET_VALUE =: 0x00
	TIM_ARR_RESET_VALUE  =: 0xFF


	.mdelete tim_arr_not_buffered
	.macro tim_arr_not_buffered n
		bres TIM'n'_CR1, #TIM_CR1_ARPE
	.endm

	.mdelete tim_arr_buffered
	.macro tim_arr_buffered n
		bset TIM'n'_CR1, #TIM_CR1_ARPE
	.endm


	.mdelete tim_disable_one_pulse_mode
	.macro tim_disable_one_pulse_mode n
		bres TIM'n'_CR1, #TIM_CR1_OPM
	.endm

	.mdelete tim_enable_one_pulse_mode
	.macro tim_enable_one_pulse_mode n
		bset TIM'n'_CR1, #_TIM_CR1_OPM
	.endm


	.mdelete tim_interrupt_on_update_and_overflow
	.macro tim_interrupt_on_update_and_overflow n
		bres TIM'n'_CR1, #TIM_CR1_URS
	.endm

	.mdelete tim_interrupt_on_overflow_only
	.macro tim_interrupt_on_overflow_only n
		bset TIM'n'_CR1, #TIM_CR1_URS
	.endm


	.mdelete tim_enable_updates
	.macro tim_enable_updates n
		bres TIM'n'_CR1, #TIM_CR1_UDIS
	.endm

	.mdelete tim_disable_updates
	.macro tim_disable_updates n
		bset TIM'n'_CR1, #TIM_CR1_UDIS
	.endm


	; CEN gates the _output_ of the prescaler not the input.
	; If you aren't deliberately stretching a clock pulse
	; you may want tim_enable_and_update below.
	.mdelete tim_enable
	.macro tim_enable n
		clk_enable TIM'n
		bset TIM'n'_CR1, #TIM_CR1_CEN
	.endm

	.mdelete tim_disable
	.macro tim_disable n
		bres TIM'n'_CR1, #TIM_CR1_CEN
		clk_disable TIM'n
	.endm

	.mdelete tim_enable_and_update
	.macro tim_enable_and_update n ?isenabled
		btjt TIM'n'_CR1, #TIM_CR1_CEN, isenabled
		clk_enable TIM'n
		; N.B. CEN gates the _output_ of the prescaler so an
		; update is necessary to reset to the start of a pulse.
		bset TIM'n'_CR1, #TIM_CR1_CEN
		bset TIM'n'_EGR, #TIM_EGR_UG
isenabled:
	.endm


	.mdelete tim_update_and_restart
	.macro tim_update_and_restart n
		bset TIM'n'_EGR, #TIM_EGR_UG
	.endm


	.mdelete tim_enable_trigger_interrupt
	.macro tim_enable_trigger_interrupt n
		.ifeq n - 4
			ERROR TIM4 does not support trigger
		.else
			bset TIM'n'_IER, #TIM_IER_TIE
		.endif
	.endm

	.mdelete tim_disable_trigger_interrupt
	.macro tim_disable_trigger_interrupt n
		.ifeq n - 4
			ERROR TIM4 does not support trigger
		.else
			bres TIM'n'_IER, #TIM_IER_TIE
		.endif
	.endm

	.mdelete tim_trigger_interrupt_ack
	.macro tim_trigger_interrupt_ack n
		.ifeq n - 4
			ERROR TIM4 does not support trigger
		.else
			bres TIM'n'_SR1, #TIM_SR1_TIF
		.endif
	.endm

	.mdelete tim_trigger
	.macro tim_trigger n
		.ifeq n - 4
			ERROR TIM4 does not support trigger
		.else
			bset TIM'n'_EGR, #TIM_EGR_TG
		.endif
	.endm


	.mdelete tim_enable_update_interrupt
	.macro tim_enable_update_interrupt n
		bset TIM'n'_IER, #TIM_IER_UIE
	.endm

	.mdelete tim_disable_update_interrupt
	.macro tim_disable_update_interrupt n
		bres TIM'n'_IER, #TIM_IER_UIE
	.endm

	.mdelete tim_update_interrupt_ack
	.macro tim_update_interrupt_ack n
		bres TIM'n'_SR1, #TIM_SR1_UIF
	.endm


	.mdelete tim_set_freq
	.macro tim_set_freq n f_PERIPH_MHz freq
		.ifeq n - 2
			timg_set_freq n f_PERIPH_MHz freq
		.else
		.ifeq n - 4
			timb_set_freq n f_PERIPH_MHz freq
		.else
		.ifeq n - 6
			timb_set_freq n f_PERIPH_MHz freq
		.else
			ERROR TIM'n is not handled in tim_set_freq
		.endif
		.endif
		.endif
	.endm


	.mdelete tim_set_time
	.macro tim_set_time n f_PERIPH_MHz ms
		.ifeq n - 2
			timg_set_time n f_PERIPH_MHz ms
		.else
		.ifeq n - 4
			timb_set_time n f_PERIPH_MHz ms
		.else
		.ifeq n - 6
			timb_set_time n f_PERIPH_MHz ms
		.else
			ERROR TIM'n is not handled in tim_set_time
		.endif
		.endif
		.endif
	.endm

	.mdelete timb_set_pscr_and_arr
	.macro timb_set_pscr_and_arr n pscr value
		; N.B. Some ranges may overlap and the higher PSCR may actually give
		; a closer match to the target the the lower PSCR. No account of this
		; is taken here. If you want best accuracy you have to program the
		; PSCR and ARR yourself.
		.iflt value - (256 << pscr)
			mov TIM'n'_PSCR, #pscr
			mov TIM'n'_ARR, #(value + ((1 << pscr) >> 1)) / (1 << pscr)
		.endif
	.endm

	.mdelete timb_set_freq
	.macro timb_set_freq n f_PERIPH_MHz freq
		tim_pscr_and_arr_value =: ((f_PERIPH_MHz * 1000000 + freq / 2) / freq)

		timb_set_pscr_and_arr n  0 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  1 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  2 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  3 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  4 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  5 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  6 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  7 tim_pscr_and_arr_value
	.endm


	.mdelete timb_set_time
	.macro timb_set_time n f_PERIPH_MHz ms
		tim_pscr_and_arr_value =: (ms * (f_PERIPH_MHz * 1000))

		timb_set_pscr_and_arr n  0 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  1 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  2 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  3 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  4 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  5 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  6 tim_pscr_and_arr_value
		timb_set_pscr_and_arr n  7 tim_pscr_and_arr_value
	.endm
