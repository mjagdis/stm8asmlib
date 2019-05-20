	.include "asmlib/hw/uart.asm"

	UART1_BaseAddress       =: 0x5230

	UART1_SR   =: UART1_BaseAddress + UART_SR
	UART1_DR   =: UART1_BaseAddress + UART_DR
	UART1_BRR1 =: UART1_BaseAddress + UART_BRR1
	UART1_BRR2 =: UART1_BaseAddress + UART_BRR2
	UART1_CR1  =: UART1_BaseAddress + UART_CR1
	UART1_CR2  =: UART1_BaseAddress + UART_CR2
	UART1_CR3  =: UART1_BaseAddress + UART_CR3
	UART1_CR4  =: UART1_BaseAddress + UART_CR4
	UART1_CR5  =: UART1_BaseAddress + UART_CR5
	UART1_GTR  =: UART1_BaseAddress + UART1_GTR
	UART1_PSCR =: UART1_BaseAddress + UART1_PSCR

	UART1_SR_RESET_VALUE   =: 0xC0
	UART1_BRR1_RESET_VALUE =: 0x00
	UART1_BRR2_RESET_VALUE =: 0x00
	UART1_CR1_RESET_VALUE  =: 0x00
	UART1_CR2_RESET_VALUE  =: 0x00
	UART1_CR3_RESET_VALUE  =: 0x00
	UART1_CR4_RESET_VALUE  =: 0x00
	UART1_CR5_RESET_VALUE  =: 0x00
	UART1_GTR_RESET_VALUE  =: 0x00
	UART1_PSCR_RESET_VALUE =: 0x00


	.mdelete uart1_init
	.macro uart1_init dir f_clk_MHz baud bits parity stop
		uart_init 1 f_clk_MHz baud dir bits parity stop
	.endm

	.mdelete uart1_enable
	.macro uart1_enable
		uart_enable 1
	.endm

	.mdelete uart1_disable
	.macro uart1_disable
		uart_disable 1
	.endm


	.mdelete uart1_tx_empty_interrupt_enable
	.macro uart1_tx_empty_interrupt_enable
		uart_tx_empty_interrupt_enable 1
	.endm

	.mdelete uart1_tx_empty_interrupt_disable
	.macro uart1_tx_empty_interrupt_disable
		uart_tx_empty_interrupt_disable 1
	.endm


	.mdelete uart1_tx_complete_interrupt_enable
	.macro uart1_tx_complete_interrupt_enable
		uart_tx_complete_interrupt_enable 1
	.endm

	.mdelete uart1_tx_complete_interrupt_disable
	.macro uart1_tx_complete_interrupt_disable
		uart_tx_complete_interrupt_disable 1
	.endm


	.mdelete uart1_tx_isr
	.macro uart1_tx_isr
		uart_tx_isr 1
	.endm

	.mdelete uart1_tx
	.macro uart1_tx len buf
		uart_tx 1 len buf
	.endm
