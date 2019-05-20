	STM8S003   =: 1
	STM8S007   =: 0
	STM8S103   =: 0
	STM8S105   =: 0
	STM8S207   =: 0
	STM8S208   =: 0
	STM8S903   =: 0
	STM8AF52Ax =: 0
	STM8AF62Ax =: 0

	.ifne STM8S003
	.include "asmlib/cpu/stm8s003.asm"
	.endif

	.ifne STM8S007
	.include "asmlib/cpu/stm8s007.asm"
	.endif

	.ifne STM8S103
	.include "asmlib/cpu/stm8s103.asm"
	.endif

	.ifne STM8S105
	.include "asmlib/cpu/stm8s105.asm"
	.endif

	.ifne STM8S207
	.include "asmlib/cpu/stm8s207.asm"
	.endif

	.ifne STM8S208
	.include "asmlib/cpu/stm8s208.asm"
	.endif

	.ifne STM8S903
	.include "asmlib/cpu/stm8s903.asm"
	.endif

	.ifne STM8AF52Ax
	.include "asmlib/cpu/stm8s903.asm"
	.endif

	.ifne STM8AF62Ax
	.include "asmlib/cpu/stm8s903.asm"
	.endif


	.include "asmlib/std.asm"
	.include "asmlib/hw/clk.asm"
	.include "asmlib/hw/itc.asm"


	DISASM_FRIENDLY =: 1

	; Interrupt priority mappings
	; Errata 2.6.2: You MUST avoid BTF=1 I2C conditions. You SHOULD use nested interrupts
	; and give I2C RxNE and TxE the highest priority. Although RM0016 documents a method
	; for operation at lower priorities and with possible interruption and delay the
	; errata states that this is unsafe.
	IRQ_PRIORITY_UART1_TX =: ITC_LEVEL_1
	IRQ_PRIORITY_UART1_RX =: ITC_LEVEL_2
	IRQ_PRIORITY_VUART    =: ITC_LEVEL_3

	; f_OSC_MHz is the frequency in MHz of the master oscillator being used. For HSI
	; this will be 16, for HSE it depends on the crystal used and is between 1 and 24.
	; If you use HSE you should be sure to set all *_HSIDIV* to 1 as HSE bypasses the
	; divider. (Except when the clock security system is in use, in which case you would
	; need to handle the interrupt and reconfigure appropriately. This is not explicitly
	; handled here but could possibly be done by careful use of two init paths each with
	; its own config.)
	f_OSC_MHz             =: 16

	; Default clock scaling.
	; Race to halt. In general best power efficiency is achieved by getting to halt as
	; soon as possible. We only slow down if we expect to have to wait.
	DEFAULT_HSIDIV        =: CLK_CKDIVR_HSIDIV_1
	DEFAULT_CPUDIV        =: CLK_CKDIVR_CPUDIV_1

	f_MASTER_MHz          =: (f_OSC_MHz >> DEFAULT_HSIDIV)


	UART1_BIDIR =: 1

	; Over-sampling is used to discriminate between signal and noise (RM0016 22.3.4).
	; For a baud rate of 115200 this means a clock frequency >= 2MHz is required.
	;
	; Specifically this must be true:
	;
	;     ((f_UART<n>_MHz * 1000000 + (baud >> 1)) / baud) >= 16
	;
	; Furthermore the middle two nibbles of the 16-bit value must not both be zero
	; (i.e. the value must be greater than or equal to 16 and must not be an exact
	; multiple of 0x1000) otherwise UART<n>_BRR1 will be set to zero which disables
	; the UART clock (RM0016: 22.7.3 note 1).
	UART1_HSIDIV       =: DEFAULT_HSIDIV
	f_UART1_MHz =: (f_OSC_MHz >> UART1_HSIDIV)

	; UART1 ring buffer size
	UART1_RINGBUF_SIZE =: 32


	; Since the pseudo-UART and UART1 are used together the clocking for the pseudo
	; UART MUST match that of the UART.
	VUART_HSIDIV =: UART1_HSIDIV
	f_VUART_MHz  =: f_UART1_MHz

	; A timer is required to clock in/out bits on the VUART.
	; We only need a basic timer so TIM4/6 is sufficient for normal baud rates but
	; these are often already used for other purposes (e.g. timeouts on I2C).
	VUART_TIMER =: 2

	; How many times we sample the data within each bit to reduce the impact of
	; noise and/or clock skew. This should be >= 3 and <= 126.
	; 6 gives best accuracy to 115200 given f_VUART_MHz = 16.
	VUART_OVERSAMPLE =: 1

	; VUART ring buffer size
	VUART_RINGBUF_SIZE =: 16

	VUART_DATA_BITS =: 8
