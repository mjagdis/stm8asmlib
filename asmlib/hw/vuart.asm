	.include "asmlib/hw/gpio.asm"
	.include "asmlib/hw/tim2.asm"
	.include "asmlib/hw/tim4.asm"
	.include "asmlib/ringbuf.asm"


	.ifeq VUART_TIMER - 1
		IRQ_VUART =: IRQ_TIM1
	.else
	.ifeq VUART_TIMER - 2
		IRQ_VUART =: IRQ_TIM2
	.else
	.ifeq VUART_TIMER - 3
		IRQ_VUART =: IRQ_TIM3
	.else
	.ifeq VUART_TIMER - 4
		IRQ_VUART =: IRQ_TIM4
	.else
	.ifeq VUART_TIMER - 5
		IRQ_VUART =: IRQ_TIM5
	.else
	.ifeq VUART_TIMER - 6
		IRQ_VUART =: IRQ_TIM6
	.else
	.endif
	.endif
	.endif
	.endif
	.endif
	.endif

	.macro vuart_timer arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.ifeq VUART_TIMER - 1
			tim1 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.ifeq VUART_TIMER - 2
			tim2 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.ifeq VUART_TIMER - 3
			tim3 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.ifeq VUART_TIMER - 4
			tim4 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.ifeq VUART_TIMER - 5
			tim5 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.ifeq VUART_TIMER - 6
			tim6 arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9
		.else
		.endif
		.endif
		.endif
		.endif
		.endif
		.endif
	.endm


	.mdelete vuart_set_baud
	.macro vuart_set_baud f_PERIPH_MHz baud
		vuart_freq =: (baud * VUART_OVERSAMPLE)
		vuart_timer set_freq f_PERIPH_MHz vuart_freq
	.endm


	.mdelete vuart_tx_put
	.macro vuart_tx_put what
		.narg .narg
		.if .narg
			ld a, what
		.endif
		.ifeq __mmode - __mmode_call
			call vuart_tx_put
		.else
			ringbuf_put vuart_tx VUART_RINGBUF_SIZE
			vuart_timer enable_and_update
		.endif
	.endm


	.mdelete vuart_declare
	.macro vuart_declare
		.area RAM
		.ifgt VUART_OVERSAMPLE - 1
vuart_tx_sample: .ds 1
		.endif
vuart_tx_state:  .ds 1
vuart_tx:        .ds 1

		.ifgt VUART_OVERSAMPLE - 1
vuart_rx_sample: .ds 1
		.endif
vuart_rx_state:  .ds 1
vuart_rx:        .ds 1
vuart_rx_bit:    .ds 1

		ringbuf vuart_tx VUART_RINGBUF_SIZE
		.area DATA
	.endm

	.mdelete vuart_init
	.macro vuart_init tx_port tx_pin rx_port rx_pin rx_handler_macro f_PERIPH_MHz baud
		ringbuf_init vuart_tx VUART_RINGBUF_SIZE
		mov vuart_tx_state, #-1
		mov vuart_rx_state, #-1
		.ifgt VUART_OVERSAMPLE - 1
			mov vuart_tx_sample, #1
		.endif

		bset tx_port + GPIO_DDR, #tx_pin ; TX is output
		bset tx_port + GPIO_CR1, #tx_pin ; TX is push-pull
		bres tx_port + GPIO_CR2, #tx_pin ; TX is non-fast mode
		bset tx_port + GPIO_ODR, #tx_pin ; TX is initially high
		bres rx_port + GPIO_DDR, #rx_pin ; RX is input
		bres rx_port + GPIO_CR1, #rx_pin ; RX has no pull-up (TX drives)
		bset rx_port + GPIO_CR2, #rx_pin ; RX does interrupt
		itc_gpio_interrupt rx_port rx_pin ITC_EXTI_F ; Interrupt on falling edge only

		vuart_set_baud f_PERIPH_MHz baud

		vuart_timer interrupt_on_update_and_overflow
		vuart_timer enable_update_interrupt


		IRQ_PRIORITY_'rx_port =: IRQ_PRIORITY_VUART

		ISR rx_port
		sim
		gpio_disable_interrupt rx_port rx_pin
		mov vuart_rx_state, #(1 + VUART_DATA_BITS + 1)
		.ifgt VUART_OVERSAMPLE - 1
			mov vuart_rx_sample, #VUART_OVERSAMPLE - 1
		.endif
		mov vuart_rx_bit, #-1
		; If the timer was disabled this resyncs us with our peer. If we had not gone
		; idle (the timer was still enabled) we could be skewed by up to one sampling
		; interval. This, of course, has implications for the minimum usable
		; sampling interval...
		vuart_timer enable_and_update
		iret

		ISR VUART
		sim
		vuart_timer update_interrupt_ack

		; TX
		.ifgt VUART_OVERSAMPLE - 1
			; Have we reached the next bit?
			dec vuart_tx_sample
			jrne rx
			mov vuart_tx_sample, #VUART_OVERSAMPLE
		.endif

		ld a, vuart_tx_state
		jrmi tx_done

		dec vuart_tx_state
		jrmi tx_stop

		; TX next bit
		rrc vuart_tx
		jrc tx_bit_1
		nop
		bres tx_port + GPIO_ODR, #tx_pin
		jra rx
tx_bit_1:
		bset tx_port + GPIO_ODR, #tx_pin
		jra rx

tx_stop:
		; TX stop
		bset tx_port + GPIO_ODR, #tx_pin
		jra rx

tx_done:
		; TX done
		; Advance to next character
		ringbuf_empty vuart_tx
		jreq tx_idle
		bres tx_port + GPIO_ODR, #tx_pin
		ringbuf_get vuart_tx VUART_RINGBUF_SIZE
		ld vuart_tx, a
		mov vuart_tx_state, #(1 + VUART_DATA_BITS - 1)
		jra rx

tx_idle:
		; If RX is also idle we disable the timer and wait.
		ld a, vuart_rx_state
		jrpl rx_have_a
		vuart_timer disable
		.ifgt VUART_OVERSAMPLE - 1
			mov vuart_tx_sample, #1
		.endif
		iret


rx:
		; RX
		ld a, vuart_rx_state
rx_have_a:
		jrmi rx_done

rx_active:
		; Sample the RX pin
		; The dec and inc here mean that vuart_rx_bit will be -ve if
		; the sampling averages to a 1 so the MSB of vuart_rx_bit is
		; the bit to use as data.
		btjf rx_port + GPIO_IDR, #rx_pin, rx_sample_1
		dec vuart_rx_bit
		dec vuart_rx_bit
rx_sample_1:
		inc vuart_rx_bit

		.ifgt VUART_OVERSAMPLE - 1
			; Have we reached the next bit?
			dec vuart_rx_sample
			jrsle rx_next_bit
			iret
		.endif
rx_next_bit:
		.ifgt VUART_OVERSAMPLE - 1
			mov vuart_rx_sample, #VUART_OVERSAMPLE
		.endif

		dec a
		ld vuart_rx_state, a
		jrmi rx_idle
		jreq rx_stop

		cp a, #(1 + VUART_DATA_BITS + 1)
		jrne rx_data
		; Start bit. If it is not 0 it was just noise.
		rlc vuart_rx_bit
		jrc rx_idle
rx_done:
		iret

rx_data:
		; RX data
		rlc vuart_rx_bit
		rrc vuart_rx
		clr vuart_rx_bit
		iret

rx_idle:
		; Watch for the next start bit.
		gpio_enable_interrupt rx_port rx_pin
		iret

rx_stop:
		; RX stop bit
		; FIXME: optional: if we do not see a high now we have a framing error.
		ld a, vuart_rx
		rx_handler_macro
		iret

		.area CODE
	.endm
