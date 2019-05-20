	.mdelete ringbuf
	.macro ringbuf prefix size
		.area DATA
prefix'_w:	.ds 2
prefix'_r:	.ds 2
		.area RAM
prefix'_buf:	.ds size
		.area DATA
	.endm


	.mdelete ringbuf_init
	.macro ringbuf_init prefix size
		mov prefix'_r, #(size - 1)
		mov prefix'_w, #(size - 1)
	.endm

	.mdelete ringbuf_empty
	.macro ringbuf_empty prefix
		ldw x, prefix'_r
		cpw x, prefix'_w
	.endm

	.mdelete ringbuf_count
	.macro ringbuf_count prefix size ?done
		ldw x, prefix'_r
		rcf
		sub x, prefix'_w
		jrpl done
		addw x, #size
done:
	.endm

	.mdelete .ringbuf_advance
	.macro .ringbuf_advance index size ?nowrap
		decw x
		jrpl nowrap
		ldw x, #(size - 1)
nowrap:		ldw index, x
	.endm

	.mdelete ringbuf_put
	.macro ringbuf_put prefix size
		ldw x, prefix'_w
		ld (prefix'_buf,x), a
		.ringbuf_advance prefix'_w size
	.endm

	.mdelete ringbuf_current_addr
	.macro ringbuf_current_addr prefix
		ldw x, #prefix'_buf
		addw x, prefix'_r
	.endm

	.mdelete ringbuf_current
	.macro ringbuf_current prefix
		ldw x, prefix'_r
		ld a, (prefix'_buf,x)
	.endm

	.mdelete ringbuf_next
	.macro ringbuf_next prefix size
		ldw x, prefix'_r
		.ringbuf_advance prefix'_r size
	.endm

	.mdelete ringbuf_get
	.macro ringbuf_get prefix size
		ldw x, prefix'_r
		ld a, (prefix'_buf,x)
		.ringbuf_advance prefix'_r size
	.endm
