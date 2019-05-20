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
