	; Disassemblers tend to just work linearly through memory rather than analysing
	; the flow to find out where jumps, returns and jump targets are so they get
	; thrown off by alignment gaps. If this is a concern you can use codebndry to
	; fill the gaps with nops.
	.mdelete codebndry
	.macro codebndry n
		.if DISASM_FRIENDLY
			.$.end = .
			.ifne (. - .$.end) % n
				nop
			.endif
			.ifne (. - .$.end) % n
				nop
			.endif
			.ifne (. - .$.end) % n
				nop
			.endif
		.else
			.bndry n
		.endif
	.endm


	; The  relocation  and/or  concatenation  of an area containing ".bndry"
	; directives to place code at specific boundaries will NOT maintain the
	; specified boundaries. Use "areabndry" in place of ".bndry" at the start
	; of sections/files in order to pad the section to the correct alignment
	; so that it will be preserved after linkage.
	.mdelete areabndry
	.macro areabndry n
		.if DISASM_FRIENDLY
			codebndry n
		.else
			.$.end = .
			.bndry n
			.ifne . - .$.end
				. = . - 1
				.ds 1
			.endif
		.endif
	.endm


	; Define _<name> with the positional value of the bit for use in bset, bres
	; and btj[tf] and <name> with the mathematical value of the bit for use with
	; and, or etc.
	; Mask may be specified as an optional argument to specify the width of the
	; field in which case bit specifies the position the LSB should be shifted
	; to in order to obtain the correct value/mask.
	.mdelete bit_and_value
	.macro bit_and_value name bit mask
		_'name =: bit
		.narg .narg
		.ifeq .narg - 2
			name =: (1 << bit)
		.else
			name =: (mask << bit)
		.endif
	.endm

	.mdelete bit_and_value_like
	.macro bit_and_value_like name like
		_'name =: _'like
		name =: like
	.endm


	__mmode_inline   =: 0
	__mmode_function =: 1
	__mmode_call     =: 2
	__mmode          =: __mmode_inline

	.mdelete .function
	.macro .function name a0 a1 a2 a3 a4 a5 a6 a7 a8 a9
		.area FUNCTIONS
		areabndry 4

		__mmode =: __mmode_function
name::
		name a0 a1 a2 a3 a4 a5 a6 a7 a8 a9
		ret
		__mmode =: __mmode_inline

		.area CODE
	.endm

	.mdelete .call
	.macro .call name a0 a1 a2 a3 a4 a5 a6 a7 a8 a9
		__mmode =: __mmode_call
		name a0 a1 a2 a3 a4 a5 a6 a7 a8 a9
		__mmode =: __mmode_inline
	.endm


	.mdelete std_wait_for_bit
	.macro std_wait_for_bit reg bit tf method level ?loop ?done
		itc_save_and_set_priority level
loop:
		btj'tf reg, #bit, done
		method
		jra loop
done:
		itc_restore_priority
	.endm


	; ISR <irq> [label]
	;
	; Statically assign an IRQ vector at link time. If label is given
	; the vector for the IRQ will point to that label otherwise it
	; will point to the current location counter. Thus the form without
	; a label can be used as a header to the portion of code that is to
	; service the IRQ while the form with a label can be freely placed.
	;
	; Note that the IRQ_ prefix to irq is not required and MUST be left off.
	.mdelete _ISR
	.macro _ISR irq area ?label
		.area IRQVECTORS (ABS,OVR)
		.org 0x8008 + (IRQ_'irq * 4)
		int label
		.narg .narg
		.ifeq .narg - 2
			.if area
				.area FUNCTIONS
			.else
				.area CODE
			.endif
			areabndry 4
label:
		.endif
	.endm

	.mdelete ISR
	.macro ISR irq label
		.narg .narg
		.ifeq .narg - 1
			_ISR irq 1 label

			; Errata 2.1.3: ISRs may run at level 0 due to a race condition.
			; Handlers must set priority level explicitly.
			itc_set_priority IRQ_PRIORITY_'irq
		.else
			_ISR irq 1 label
		.endif
	.endm

	.macro RESET label
		_ISR RESET 0 label
	.endm


	.mdelete std_clear_uninitialized_data
	.macro std_clear_uninitialized_data ?done ?loop
		.globl s_DATA
		.globl l_DATA

		ldw x, #l_DATA
		jreq done
loop:
		clr (s_DATA - 1, x)
		decw x
		jrne loop
done:
	.endm

	.mdelete std_set_initialized_data
	.macro std_set_initialized_data ?done ?loop
		.globl s_INITIALIZER
		.globl l_INITIALIZER
		.globl s_INITIALIZED

		ldw x, #l_INITIALIZER
		jreq done
loop:
		ld a, (s_INITIALIZER - 1, x)
		ld (s_INITIALIZED - 1, x), a
		decw x
		jrne loop
done:
	.endm
