	FLASH_BaseAddress       =: 0x505A

	FLASH_CR1        =: FLASH_BaseAddress +  0 ; Flash control register 1
	FLASH_CR2        =: FLASH_BaseAddress +  1 ; Flash control register 2
	FLASH_NCR2       =: FLASH_BaseAddress +  2 ; Flash complementary control register 2
	FLASH_FPR        =: FLASH_BaseAddress +  3 ; Flash protection register
	FLASH_NFPR       =: FLASH_BaseAddress +  4 ; Flash complementary protection register
	FLASH_IAPSR      =: FLASH_BaseAddress +  5 ; Flash in-application programming status register
	;FLASH_RESERVED1 =: FLASH_BaseAddress +  6 ; Reserved byte
	;FLASH_RESERVED2 =: FLASH_BaseAddress +  7 ; Reserved byte
	FLASH_PUKR       =: FLASH_BaseAddress +  8 ; Flash program memory unprotection register
	;FLASH_RESERVED3 =: FLASH_BaseAddress +  9 ; Reserved byte
	FLASH_DUKR       =: FLASH_BaseAddress + 10 ; Data EEPROM unprotection register


	FLASH_CR1_RESET_VALUE   =: 0x00
	FLASH_CR2_RESET_VALUE   =: 0x00
	FLASH_NCR2_RESET_VALUE  =: 0xFF
	FLASH_IAPSR_RESET_VALUE =: 0x40
	FLASH_PUKR_RESET_VALUE  =: 0x00
	FLASH_DUKR_RESET_VALUE  =: 0x00

	FLASH_CR1_HALT          =: 3 ; Power down in Halt mode
	FLASH_CR1_AHALT         =: 2 ; Power down in Active-halt mode
	FLASH_CR1_IE            =: 1 ; Flash Interrupt enable
	FLASH_CR1_FIX           =: 0 ; Fixed byte programming time

	FLASH_CR2_OPT           =: 7 ; Write option bytes
	FLASH_CR2_WPRG          =: 6 ; Word programming
	FLASH_CR2_ERASE         =: 5 ; Block erasing
	FLASH_CR2_FPRG          =: 4 ; Fast block programming
	FLASH_CR2_PRG           =: 0 ; Standard block programming

	FLASH_NCR2_NOPT         =: 7 ; Complement of FLASH_CR2_OPT
	FLASH_NCR2_NWPRG        =: 6 ; Complement of FLASH_CR2_WPRG
	FLASH_NCR2_NERASE       =: 5 ; Complement of FLASH_CR2_ERASE
	FLASH_NCR2_NFPRG        =: 4 ; Complement of FLASH_CR2_FPRG
	FLASH_NCR2_NPRG         =: 0 ; Complement of FLASH_CR2_PRG

	FLASH_FPR_WPB           =: 0x3F ; User boot code area protection bits mask

	FLASH_NFPR_NWPB         =: 0x3F ; Complemented user boot code area protection bits mask

	FLASH_IAPSR_HVOFF       =: 6 ; End of high voltage flag
	FLASH_IAPSR_DUL         =: 3 ; Data EEPROM area unlocked flag
	FLASH_IAPSR_EOP         =: 2 ; End of programming (write or erase operation) flag
	FLASH_IAPSR_PUL         =: 1 ; Flash Program memory unlocked flag
	FLASH_IAPSR_WR_PG_DIS   =: 0 ; Write attempted to protected page flag

	FLASH_PUKR_PUK          =: 0xFF ; Main program memory unlock keys mask

	FLASH_DUKR_DUK          =: 0xFF ; Data EEPROM write unlock keys mask


	; Errata 2.2.3: f_CPU MUST be < 250kHz when halt is called otherwise we may
	; attempt to restart before the flash is ready again.
	.mdelete flash_enable_power_down_in_halt
	.macro flash_enable_power_down_in_halt
		bset FLASH_CR1, #FLASH_CR1_HALT
	.endm

	.mdelete flash_disable_power_down_in_halt
	.macro flash_disable_power_down_in_halt
		bres FLASH_CR1, #FLASH_CR1_HALT
	.endm

	; Errata 2.2.3: f_CPU MUST be < 250kHz when halt is called otherwise we may
	; attempt to restart before the flash is ready again.
	.mdelete flash_enable_power_down_in_active_halt
	.macro flash_enable_power_down_in_active_halt
		bset FLASH_CR1, #FLASH_CR1_AHALT
	.endm

	.mdelete flash_disable_power_down_in_active_halt
	.macro flash_disable_power_down_in_active_halt
		bres FLASH_CR1, #FLASH_CR1_AHALT
	.endm


	.mdelete flash_enable_option_write
	.macro flash_enable_option_write
		bset FLASH_CR2, #FLASH_CR2_OPT
		bres FLASH_NCR2, #FLASH_CR2_OPT
	.endm

	.mdelete flash_disable_option_write
	.macro flash_disable_option_write
		bres FLASH_CR2, #FLASH_CR2_OPT
		bset FLASH_NCR2, #FLASH_CR2_OPT
	.endm
