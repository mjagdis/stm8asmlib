	.include "asmlib/hw/uart.asm"

	UART2_BaseAddress       =: 0x5230

	UART2_SR   =: UART2_BaseAddress + UART_SR
	UART2_DR   =: UART2_BaseAddress + UART_DR
	UART2_BRR1 =: UART2_BaseAddress + UART_BRR1
	UART2_BRR2 =: UART2_BaseAddress + UART_BRR2
	UART2_CR1  =: UART2_BaseAddress + UART_CR1
	UART2_CR2  =: UART2_BaseAddress + UART_CR2
	UART2_CR3  =: UART2_BaseAddress + UART_CR3
	UART2_CR4  =: UART2_BaseAddress + UART_CR4
	UART2_CR5  =: UART2_BaseAddress + UART_CR5
	UART2_CR6  =: UART2_BaseAddress + UART_CR6
	UART2_GTR  =: UART2_BaseAddress + UART_GTR
	UART2_PSCR =: UART2_BaseAddress + UART_PSCR

	UART2_SR_RESET_VALUE   =: 0xC0
	UART2_BRR1_RESET_VALUE =: 0x00
	UART2_BRR2_RESET_VALUE =: 0x00
	UART2_CR1_RESET_VALUE  =: 0x00
	UART2_CR2_RESET_VALUE  =: 0x00
	UART2_CR3_RESET_VALUE  =: 0x00
	UART2_CR4_RESET_VALUE  =: 0x00
	UART2_CR5_RESET_VALUE  =: 0x00
	UART2_CR6_RESET_VALUE  =: 0x00
	UART2_GTR_RESET_VALUE  =: 0x00
	UART2_PSCR_RESET_VALUE =: 0x00


	.mdelete uart2_init
	.macro uart2_init dir f_clk_MHz baud bits parity stop
		uart_init 2 f_clk_MHz baud dir bits parity stop
	.endm

	.mdelete uart2_enable
	.macro uart2_enable
		uart_enable 2
	.endm

	.mdelete uart2_disable
	.macro uart2_disable
		uart_disable 2
	.endm


	.mdelete uart2_tx_empty_interrupt_enable
	.macro uart2_tx_empty_interrupt_enable
		uart_tx_empty_interrupt_enable 2
	.endm

	.mdelete uart2_tx_empty_interrupt_disable
	.macro uart2_tx_empty_interrupt_disable
		uart_tx_empty_interrupt_disable 2
	.endm


	.mdelete uart2_tx_complete_interrupt_enable
	.macro uart2_tx_complete_interrupt_enable
		uart_tx_complete_interrupt_enable 2
	.endm

	.mdelete uart2_tx_complete_interrupt_disable
	.macro uart2_tx_complete_interrupt_disable
		uart_tx_complete_interrupt_disable 2
	.endm


	.mdelete uart2_tx_isr
	.macro uart2_tx_isr
		uart_tx_isr 2
	.endm

	.mdelete uart2_tx
	.macro uart2_tx len buf
		uart_tx 2 len buf
	.endm
