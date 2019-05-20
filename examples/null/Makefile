ASMLIB_DIR = ../..

SYM = ../../bin/sym.pl

ASM = sdasstm8
ASMFLAGS = -b -l -s -I$(ASMLIB_DIR)
LD = sdldstm8
LDFLAGS = -nimuxw -b _CODE=0x8000 -b RAM=0x0001

CPUTYPE = stm8s003f3

TARGET = null
ASMSOURCES = $(TARGET).asm
ASMINCLUDES = config.asm \
	      $(ASMLIB_DIR)/asmlib/*.asm \
	      $(ASMLIB_DIR)/asmlib/cpu/* \
	      $(ASMLIB_DIR)/asmlib/hw/*


OBJECTS=$(ASMSOURCES:.asm=.rel)


.PHONY:	all clean factory flash always


all:	$(TARGET).ihx $(TARGET).dis


factory:
	stm8flash -c stlinkv2 -p '$(CPUTYPE)' -s opt -w 'factory/$(CPUTYPE).bin'

flash:	$(TARGET).ihx
	stm8flash -c stlinkv2 -p '$(CPUTYPE)' -w $<

$(TARGET).ihx:	$(OBJECTS) $(INCLUDES)
	$(LD) $(LDFLAGS) $@ $(OBJECTS)

$(TARGET).DIS:	$(TARGET).ihx
	naken_util -stm8 -disasm $< > $(TARGET).DIS
	rm -f $(TARGET).dis

$(TARGET).dis:	$(TARGET).DIS always
	$(SYM) $(TARGET).DIS


clean:
	rm -f $(OBJECTS) $(ASMSOURCES:.asm=.lst) $(ASMSOURCES:.asm=.rst) $(ASMSOURCES:.asm=.sym)

always:


%.DIS:	%.ihx
	naken_util -stm8 -disasm $< > $@

%.dis:	%.DIS always
	$(SYM) $< > $@

%.rel:	%.asm $(ASMINCLUDES)
	$(ASM) $(ASMFLAGS) -o $<
