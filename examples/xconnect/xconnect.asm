	.module xconnect
	.optsdcc -mstm8
	

	.include "config.asm"

	; This MUST be the first thing after config in the FIRST
	; file to be linked. It defines how the various areas are
	; combined into the FLASH/RAM/EPROM.
	.include "asmlib/layout.asm"


	.include "asmlib/hw/cfg.asm"
	.include "asmlib/hw/flash.asm"
	.include "asmlib/hw/gpio.asm"
	.include "asmlib/hw/vuart.asm"
	.include "asmlib/hw/tim4.asm"
	.include "asmlib/hw/uart1.asm"
	.include "asmlib/ringbuf.asm"


	.area DATA

	ringbuf uart1_tx UART1_RINGBUF_SIZE

	vuart_declare


	.macro uart1_tx_empty
		ringbuf_empty uart1_tx
	.endm

	.macro uart1_tx_next
		ringbuf_next uart1_tx UART1_RINGBUF_SIZE
	.endm

	.macro uart1_tx_put what ?queue ?done
		.narg .narg
		.if .narg
			ld a, what
		.endif
		.ifeq __mmode - __mmode_call
			call uart1_tx_put
		.else
			push cc
			sim
			uart1_tx_empty
			jrne queue
			btjf UART1_SR, #UART_SR_TXE, queue
			ld UART1_DR, a
			uart1_tx_empty_interrupt_enable
			jra done
queue:
			ringbuf_put uart1_tx UART1_RINGBUF_SIZE
done:
			pop cc
		.endif
	.endm

	.macro uart1_tx_get
		ringbuf_get uart1_tx UART1_RINGBUF_SIZE
	.endm

	.macro uart1_tx_current
		ringbuf_current uart1_tx
	.endm


	ISR UART1_RX
	;itc_set_priority_if_higher IRQ_PRIORITY_UART1_RX IRQ_PRIORITY_VUART
	sim

	; Whatever UART1 receives is simply queued for the VUART to TX.
	vuart_tx_put UART1_DR
	iret


	ISR UART1_TX
	sim

	; Either the TX buffer is empty or the transmission has completed.
	; If the transmit buffer is empty we load up the next character if
	; there is one. Otherwise we go idle.
	; FIXME: is there any value to disabling the TX side of the UART if
	; we go idle? (If so we need to set the GPIO pin paired with TX to
	; be output, high to avoid false starts.)
	btjt UART1_SR, #UART_SR_TC, 00001$

	uart1_tx_empty
	jreq 00002$

	uart1_tx_get
	ld UART1_DR, a
	iret

00002$:	uart1_tx_empty_interrupt_disable
	iret

00001$:	bres UART1_SR, #UART_SR_TC
	iret


	.area CODE

	; Start here...
	RESET

	clk_set_dividers DEFAULT_HSIDIV DEFAULT_CPUDIV
	;clk_set_dividers CLK_CKDIVR_HSIDIV_2 CLK_CKDIVR_CPUDIV_4
	clk_disable_all

	std_clear_uninitialized_data
	std_set_initialized_data

	; Set interrupt priorities
	itc_irq_priority IRQ_UART1_TX IRQ_PRIORITY_UART1_TX
	itc_irq_priority IRQ_UART1_RX IRQ_PRIORITY_UART1_RX
	itc_irq_priority IRQ_VUART    IRQ_PRIORITY_VUART

	; DEBUG
	;bset GPIOC + GPIO_DDR, #5 ; PC5 is output
	;bset GPIOC + GPIO_CR1, #5 ; PC5 is push-pull
	;bres GPIOC + GPIO_CR2, #5 ; PC5 is non-fast mode
	;bset GPIOC + GPIO_ODR, #5

	; Configure UART1 for 115k2 8n1 with the given peripheral clock frequency.
	uart1_init UART_TXRX f_UART1_MHz 115200 UART_8BIT UART_PARITY_NONE UART_STOP_1
	uart1_enable

	; Create a VUART with TX on D2, RX on D3 and everything received
	; handed off to uart1_tx_put (which is a macro).
	vuart_init GPIOD 2 GPIOD 3 uart1_tx_put f_VUART_MHz 115200

	.call vuart_tx_put #'H'
	.call vuart_tx_put #'i'
	.call vuart_tx_put #0x0D
	.call vuart_tx_put #0x0A

	;rim

	; This should be once the ESP8266 says "ready". This may be a bit too early.
	;.call uart1_tx_put #'A'
	;.call uart1_tx_put #'T'
	;.call uart1_tx_put #'+'
	;.call uart1_tx_put #'G'
	;.call uart1_tx_put #'M'
	;.call uart1_tx_put #'R'
	;.call uart1_tx_put #0x0D
	;.call uart1_tx_put #0x0A

	;.call uart1_tx_put #'A'
	;.call uart1_tx_put #'T'
	;.call uart1_tx_put #'+'
	;.call uart1_tx_put #'G'
	;.call uart1_tx_put #'S'
	;.call uart1_tx_put #'L'
	;.call uart1_tx_put #'P'
	;.call uart1_tx_put #'='
	;.call uart1_tx_put #'3'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #'0'
	;.call uart1_tx_put #0x0D
	;.call uart1_tx_put #0x0A

	; Go back to waiting after handling an interrupt. Nothing else
	; happens here so we just keep waiting until someone changes the
	; activation mode back to main.
	; DEBUG
	cfg_activation_interrupt_only

	flash_enable_power_down_in_halt
forever:
	; FIXME: If the vuart timer is enabled we use wfi otherwise halt.
	; FIXME: if we disable the vuart timer we should change back to
	; cfg_activation_main so that we can switch to halt.

	; If we halt we must either keep flash enabled or drop the f_CPU
	; to 250kHz or lower before entering low power mode otherwise
	; the first flash read on wakeup may return incorrect values.
	; Errata: 2.2.3
	;clk_set_dividers CLK_CKDIVR_HSIDIV_1 CLK_CKDIVR_CPUDIV_64
	;halt
	;clk_set_dividers DEFAULT_HSIDIV DEFAULT_CPUDIV
	wfi
	; DEBUG
	;btjt GPIOC + GPIO_ODR, #5, debug_set
	;bres GPIOC + GPIO_ODR, #5
	;jp forever
debug_set:
	;bset GPIOC + GPIO_ODR, #5
	jp forever

	;.function uart1_tx_put
	.function vuart_tx_put
