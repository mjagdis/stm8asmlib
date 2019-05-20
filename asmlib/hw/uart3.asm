	.include "asmlib/hw/uart.asm"

	UART3_BaseAddress       =: 0x5230

	UART3_SR   =: UART3_BaseAddress + UART_SR
	UART3_DR   =: UART3_BaseAddress + UART_DR
	UART3_BRR1 =: UART3_BaseAddress + UART_BRR1
	UART3_BRR2 =: UART3_BaseAddress + UART_BRR2
	UART3_CR1  =: UART3_BaseAddress + UART_CR1
	UART3_CR2  =: UART3_BaseAddress + UART_CR2
	UART3_CR3  =: UART3_BaseAddress + UART_CR3
	UART3_CR4  =: UART3_BaseAddress + UART_CR4
	UART3_CR6  =: UART3_BaseAddress + UART_CR6

	UART3_SR_RESET_VALUE   =: 0xC0
	UART3_BRR1_RESET_VALUE =: 0x00
	UART3_BRR2_RESET_VALUE =: 0x00
	UART3_CR1_RESET_VALUE  =: 0x00
	UART3_CR2_RESET_VALUE  =: 0x00
	UART3_CR3_RESET_VALUE  =: 0x00
	UART3_CR4_RESET_VALUE  =: 0x00
	UART3_CR6_RESET_VALUE  =: 0x00


	.mdelete uart3_init
	.macro uart3_init dir f_clk_MHz baud bits parity stop
		uart_init 3 f_clk_MHz baud dir bits parity stop
	.endm

	.mdelete uart3_enable
	.macro uart3_enable
		uart_enable 3
	.endm

	.mdelete uart3_disable
	.macro uart3_disable
		uart_disable 3
	.endm


	.mdelete uart3_tx_empty_interrupt_enable
	.macro uart3_tx_empty_interrupt_enable
		uart_tx_empty_interrupt_enable 3
	.endm

	.mdelete uart3_tx_empty_interrupt_disable
	.macro uart3_tx_empty_interrupt_disable
		uart_tx_empty_interrupt_disable 3
	.endm


	.mdelete uart3_tx_complete_interrupt_enable
	.macro uart3_tx_complete_interrupt_enable
		uart_tx_complete_interrupt_enable 3
	.endm

	.mdelete uart3_tx_complete_interrupt_disable
	.macro uart3_tx_complete_interrupt_disable
		uart_tx_complete_interrupt_disable 3
	.endm


	.mdelete uart3_tx_isr
	.macro uart3_tx_isr
		uart_tx_isr 3
	.endm

	.mdelete uart3_tx
	.macro uart3_tx len buf
		uart_tx 3 len buf
	.endm
