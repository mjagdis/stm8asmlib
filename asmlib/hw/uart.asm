	.include "asmlib/hw/clk.asm"


	UART_SR    =:  0 ; UART status register
	UART_DR    =:  1 ; UART data register
	UART_BRR1  =:  2 ; UART baud rate register
	UART_BRR2  =:  3 ; UART DIV mantissa[11:8] SCIDIV fraction
	UART_CR1   =:  4 ; UART control register 1
	UART_CR2   =:  5 ; UART control register 2
	UART_CR3   =:  6 ; UART control register 3
	UART_CR4   =:  7 ; UART control register 4
	UART_CR5   =:  8 ; UART control register 5
	UART_CR6   =:  9 ; UART control register 6  ; UART1 does not have CR6 so GTR and PSCR are moved up
	UART_GTR   =: 10 ; UART guard time register ; UART3 does not have GTR
	UART1_GTR  =:  9 ; UART guard time register
	UART_PSCR  =: 10 ; UART prescaler register  ; UART3 does not have PSCR
	UART1_PSCR =: 11 ; UART prescaler register

	UART_SR_TXE  =: 7 ; Transmit Data Register Empty
	UART_SR_TC   =: 6 ; Transmission Complete
	UART_SR_RXNE =: 5 ; Read Data Register Not Empty
	UART_SR_IDLE =: 4 ; IDLE line detected
	UART_SR_OR   =: 3 ; OverRun error
	UART_SR_NF   =: 2 ; Noise Flag
	UART_SR_FE   =: 1 ; Framing Error
	UART_SR_PE   =: 0 ; Parity Error

	UART_BRR1_DIV_MID =: 0 ; Bits [7:0]: 2nd and 3rd nibbles of the 16-bit UART divider (UART_DIV)

	UART_BRR2_DIV_MSN =: 4 ; Bits [7:4]: Most Significant Nibble of the 16-bit UART divider (UART_DIV)
	UART_BRR2_DIV_LSN =: 0 ; Bits [3:0]: Least Significant Nibble of the 16-bit UART divider (UART_DIV)

	UART_CR1_R8    =: 7 ; Receive Data bit 8
	UART_CR1_T8    =: 6 ; Transmit data bit 8
	UART_CR1_UARTD =: 5 ; UART Disable (for low power consumption)
	UART_CR1_M     =: 4 ; Word length
	UART_CR1_WAKE  =: 3 ; Wake-up method
	UART_CR1_PCEN  =: 2 ; Parity Control Enable
	UART_CR1_PS    =: 1 ; Parity Selection
	UART_CR1_PIEN  =: 0 ; Parity Interrupt Enable

	UART_CR2_TIEN  =: 7 ; Transmitter Interrupt Enable
	UART_CR2_TCIEN =: 6 ; Transmission Complete Interrupt Enable
	UART_CR2_RIEN  =: 5 ; Receiver Interrupt Enable
	UART_CR2_ILIEN =: 4 ; IDLE Line Interrupt Enable
	UART_CR2_TEN   =: 3 ; Transmitter Enable
	UART_CR2_REN   =: 2 ; Receiver Enable
	UART_CR2_RWU   =: 1 ; Receiver Wake-Up
	UART_CR2_SBK   =: 0 ; Send Break

	UART_CR3_LINEN =: 6 ; LIN mode enable
	UART_CR3_STOP  =: 4 ; Bits [5:4]: STOP bits
	UART_CR3_CKEN  =: 3 ; Clock Enable
	UART_CR3_CPOL  =: 2 ; Clock Polarity
	UART_CR3_CPHA  =: 1 ; Clock Phase
	UART_CR3_LBCL  =: 0 ; Last Bit Clock Pulse

	UART_CR4_LBDIEN =: 6 ; LIN Break Detection Interrupt Enable
	UART_CR4_LBDL   =: 5 ; LIN Break Detection Length
	UART_CR4_LBDF   =: 4 ; LIN Break Detection Flag
	UART_CR4_ADD    =: 0 ; Bits [3:0]: Address of the UART node

	UART_CR5_SCEN   =: 5 ; Smart Card Enable
	UART_CR5_NACK   =: 4 ; Smart Card Nack Enable
	UART_CR5_HDSEL  =: 3 ; Half-Duplex Selection
	UART_CR5_IRLP   =: 2 ; Irda Low Power Selection
	UART_CR5_IREN   =: 1 ; Irda Enable

	UART_CR6_LDUM   =: 7 ; LIN Divider Update Method
	UART_CR6_LSLV   =: 5 ; LIN Slave Enable
	UART_CR6_LASE   =: 4 ; LIN Automatice Resynchronization Enable
	UART_CR6_LHDIEN =: 2 ; LIN Header Detection Interrupt Enable
	UART_CR6_LHDF   =: 1 ; LIN Header Detection Flag
	UART_CR6_LSF    =: 0 ; LIN Sync Field


	UART_TXONLY      =: ((1 << UART_CR2_TEN))
	UART_RXONLY      =: ((1 << UART_CR2_REN) | (1 << UART_CR2_RIEN))
	UART_TXRX        =: (UART_TXONLY | UART_RXONLY)

	UART_7BIT        =: (0 << UART_CR1_M)
	UART_8BIT        =: (0 << UART_CR1_M)
	UART_9BIT        =: (1 << UART_CR1_M)

	UART_PARITY_NONE =: (0 << UART_CR1_PCEN) | (0 << UART_CR1_PS) | (0 << UART_CR1_PIEN)
	UART_PARITY_EVEN =: (1 << UART_CR1_PCEN) | (0 << UART_CR1_PS) | (1 << UART_CR1_PIEN)
	UART_PARITY_ODD  =: (1 << UART_CR1_PCEN) | (1 << UART_CR1_PS) | (1 << UART_CR1_PIEN)

	UART_STOP_1      =: (0b00 << UART_CR3_STOP) ; 1 stop bit
	UART_STOP_15     =: (0b11 << UART_CR3_STOP) ; 1.5 stop bits
	UART_STOP_2      =: (0b10 << UART_CR3_STOP) ; 2 stop bits


	.mdelete uart_init
	.macro uart_init num f_clk_MHz baud dir bits parity stop
		mov UART'num'_CR1, #((1 << UART_CR1_UARTD) | bits | parity)
		mov UART'num'_CR2, #(dir)
		mov UART'num'_CR3, #(stop)

		; RM0016 22.3.4: UART_DIV must be greater than or equal to 16.
		; This is a requirement of the over-sampling technique used for noise
		; detection and recovery.
		; For a baud rate of 115200 that implies a clock frequency >= 2MHz

		uart'num'_div =: ((f_clk_MHz * 1000000 + (baud >> 1)) / baud)

		mov UART'num'_BRR2, #((uart'num'_div >> 8) & 0xf0) | (uart'num'_div & 0x0f)
		mov UART'num'_BRR1, #(uart'num'_div >> 4)
	.endm

	.mdelete uart_enable
	.macro uart_enable num
		clk_enable UART'num
		bres UART'num'_CR1, #UART_CR1_UARTD
	.endm

	.mdelete uart_disable
	.macro uart_disable num
		bset UART'num'_CR1, #UART_CR1_UARTD
		clk_disable UART'num
	.endm


	.mdelete uart_tx_empty_interrupt_enable
	.macro uart_tx_empty_interrupt_enable num
		bset UART'num'_CR2, #UART_CR2_TIEN
	.endm

	.mdelete uart_tx_empty_interrupt_disable
	.macro uart_tx_empty_interrupt_disable num
		bres UART'num'_CR2, #UART_CR2_TIEN
	.endm


	.mdelete uart_tx_complete_interrupt_enable
	.macro uart_tx_complete_interrupt_enable num
		bset UART'num'_CR2, #UART_CR2_TCIEN
	.endm

	.mdelete uart_tx_complete_interrupt_disable
	.macro uart_tx_complete_interrupt_disable num
		bres UART'num'_CR2, #UART_CR2_TCIEN
	.endm


	.mdelete uart_tx_isr
	.macro uart_tx_isr num ?done ?complete
		.ifeq __mmode - __mmode_function
			.area DATA
_uart'num'_tx_len::	.ds 2
_uart'num'_tx_buf::	.ds 2

			ISR	UART'num'_TX

			; If it is a TXE queue the next character if we have one.
			btjt	UART'num'_SR, #UART_SR_TC, complete

			ldw x, _uart'num'_tx_buf
			tnz _uart'num'_tx_len
			jreq done

			ld a, (x)
			incw x
			ld UART'num'_DR, a
			ldw _uart'num'_tx_buf, x
			iret

done:			uart'num'_tx_empty_interrupt_disable
			iret

complete:
			; If the UART is bidirectional we leave it enabled so we can
			; still receive. If not we disable it as soon as we are done
			; in order to save power.
			bres UART'num'_SR, #UART_SR_TC
			.ifne UART'num'_BIDIR
				uart'num'_disable
			.endif
			iret
		.endif
	.endm


	.mdelete uart_tx
	.macro uart_tx num len buf ?loop ?tx_complete ?done
		.ifeq __mmode - __mmode_call
			ld a, len
			ldw x, buf
			call uart'num'_tx
			.mexit
		.endif

		; We need to be at IRQ_PRIORITY_UART<num>_TX or higher
		push cc
		push a
		sim
		
loop:
		; Wait for any existing transfer to drain.
		tnz _uart'num'_tx_len
		jreq tx_complete
		wfi
		jp loop

tx_complete:
		.ifeq __mmode - __mmode_function
			pop a
			ld _uart'num'_tx_len, a
		.else
			mov _uart'num'_tx_len, len
			ldw x, buf
		.endif
		ldw _uart'num'_tx_buf, x

		; If the TX empty interrupt is not disabled we got in before the
		; last character drained so we do not need to do anything. Otherwise
		; we need to (re)enable the UART and send the first character.
		; FIXME: which is the common case here? Starting afresh or adding
		; to an existing TX?
		btjt UART'num'_CR2, #UART_CR2_TIEN, done

		uart'num'_enable
		ldw x, _uart'num'_tx_buf
		dec _uart'num'_tx_len
		ld a, (x)
		ld UART'num'_DR, a
		incw x
		ldw _uart'num'_tx_buf, x
		uart'num'_tx_empty_interrupt_enable
done:
		pop cc
	.endm
