	OPT_BaseAddress         =: 0x4800

	OPT_OPT0      =: OPT_BaseAddress +  0 ; Read-out protection (not accessible in IAP mode)
	OPT_OPT1      =: OPT_BaseAddress +  1 ; User boot code
	OPT_NOPT1     =: OPT_BaseAddress +  2 ; Complement of option byte 1
	OPT_OPT2      =: OPT_BaseAddress +  3 ; Alternate function remapping
	OPT_NOPT2     =: OPT_BaseAddress +  4 ; Complement of option byte 2
	OPT_OPT3      =: OPT_BaseAddress +  5 ; Watchdog option
	OPT_NOPT3     =: OPT_BaseAddress +  6 ; Complement of option byte 3
	OPT_OPT4      =: OPT_BaseAddress +  7 ; Clock option
	OPT_NOPT4     =: OPT_BaseAddress +  8 ; Complement of option byte 4
	OPT_OPT5      =: OPT_BaseAddress +  9 ; HSE clock startup
	OPT_NOPT5     =: OPT_BaseAddress + 10 ; Complement of option byte 5

	OPT_OPT0_RESET_VALUE      =: 0x00
	OPT_OPT1_RESET_VALUE      =: 0x00
	OPT_NOPT1_RESET_VALUE     =: 0XFF
	OPT_OPT2_RESET_VALUE      =: 0x00
	OPT_NOPT2_RESET_VALUE     =: 0XFF
	OPT_OPT3_RESET_VALUE      =: 0x00
	OPT_NOPT3_RESET_VALUE     =: 0XFF
	OPT_OPT4_RESET_VALUE      =: 0x00
	OPT_NOPT4_RESET_VALUE     =: 0XFF
	OPT_OPT5_RESET_VALUE      =: 0x00
	OPT_NOPT5_RESET_VALUE     =: 0XFF
	OPT_RESERVED1_RESET_VALUE =: 0x00
	OPT_RESERVED2_RESET_VALUE =: 0x00
	OPT_OPT7_RESET_VALUE      =: 0x00
	OPT_NOPT7_RESET_VALUE     =: 0XFF


	OPT_OPT0_ROP            =: 0xAA ; VALUE: Readout protection enabled

	; Alternate function remapping bits.
	; These are different for different CPU lines. See the datasheets for details.
	.ifne STM8S003
	OPT_OPT2_AFR7           =: 7    ; 32pin reserved,                 20pin C3=TIM1_CH1N, C4=TIM1_CH2N
	OPT_OPT2_AFR6           =: 6    ; 32pin D7=TIM1_CH4,              20pin reserved
	OPT_OPT2_AFR5           =: 5    ; 32pin D0=CLK_CCO,               20pin reserved
	OPT_OPT2_AFR4           =: 4    ; 32pin reserved,                 20pin B4=ADC_ETR, B5=TIM1_BKIN
	OPT_OPT2_AFR3           =: 3    ; 32pin reserved,                 20pin C3=TLI
	OPT_OPT2_AFR2           =: 2    ; 32pin reserved,                 20pin reserved
	OPT_OPT2_AFR1           =: 1    ; 32pin A3=SPI_NSS, D2=TIM2_CH3,  20pin A3=SPI_NSS, D2=TIM2_CH3
	OPT_OPT2_AFR0           =: 0    ; 32pin reserved,                 20pin C5=TIM2_CH1, C6=TIM1_CH1, C7=TIM1_CH2
	.endif

	OPT_OPT3_HSITRIM        =: 4    ; High-speed internal clock trimming register size (0=3bit, 1=4bit)
	OPT_OPT3_LSI_EN         =: 3    ; Low speed internal clock available as CPU source
	OPT_OPT3_IWDG_HW        =: 2    ; Independent watchdog activation (0=SW, 1=HW)
	OPT_OPT3_WWDG_HW        =: 1    ; Window watchdog activation (0=SW, 1=HW)
	OPT_OPT3_WWDG_HALT      =: 0    ; Window watchdog reset on halt

	OPT_OPT4_EXTCLK         =: 3    ; External clock selection (0=crystal, 1=signal)
	OPT_OPT4_CKAWU          =: 2    ; Auto wakeup unit/clock (0=LSI, 1=HSE)
	OPT_OPT4_PRSC           =: 0    ; Bits [1:0]: AWU clock prescalar
		OPT_OPT4_PRSC_16_TO_128 =: (0b00 << OPT_OPT4_PRSC) ; 16MHz to 128kHz prescalar
		OPT_OPT4_PRSC_8_TO_128  =: (0b10 << OPT_OPT4_PRSC) ; 8MHz to 128kHz prescalar
		OPT_OPT4_PRSC_4_TO_128  =: (0b11 << OPT_OPT4_PRSC) ; 4MHz to 128kHz prescalar

	OPT_OPT5_HSECNT2048     =: 0x00 ; VALUE: HSE stabilizes in 2048 cycles
	OPT_OPT5_HSECNT128      =: 0xB4 ; VALUE: HSE stabilizes in 128 cycles
	OPT_OPT5_HSECNT8        =: 0xD2 ; VALUE: HSE stabilizes in 8 cycles
	OPT_OPT5_HSECNT0_5      =: 0xE1 ; VALUE: HSE stabilizes in 0.5 cycles


	.mdelete opt_lsi_available_as_cpu_clock_source
	.macro opt_lsi_available_as_cpu_clock_source
	bset OPT_OPT3, #OPT_OPT3_LSI_EN
	bres OPT_NOPT3, #OPT_OPT3_LSI_EN
	.endm
