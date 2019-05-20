ASMLIB_DIR = ../..

SYM = ../../bin/sym.pl

ASM = sdasstm8
ASMFLAGS = -b -l -s -a -I$(ASMLIB_DIR)
LD = sdldstm8
LDFLAGS = -nimuxw -b _CODE=0x8000 -b RAM=0x0001

CPUTYPE = stm8s003f3

TARGET = xconnect
ASMSOURCES = $(TARGET).asm
ASMINCLUDES = config.asm \
	      $(ASMLIB_DIR)/asmlib/*.asm \
	      $(ASMLIB_DIR)/asmlib/cpu/* \
	      $(ASMLIB_DIR)/asmlib/hw/*


OBJECTS=$(ASMSOURCES:.asm=.rel)


.PHONY:	all clean factory flash always


all:	$(TARGET).ihx $(TARGET).dis


debug:	$(TARGET).ihx always
	#sdcdb -mstm8 --directory=.:asmlib:asmlib/hw: $(TARGET)
	sstm8 -t S003 -X 16M -S uart=1,port=10000 $<

factory:
	stm8flash -c stlinkv2 -p '$(CPUTYPE)' -s opt -w 'factory/$(CPUTYPE).bin'

flash:	$(TARGET).ihx
	stm8flash -c stlinkv2 -p '$(CPUTYPE)' -w $<

live.bin:
	stm8flash -c stlinkv2 -p '$(CPUTYPE)' -r live.bin

live.DIS:	live.bin
	naken_util -stm8 -disasm -address 0x8000 -bin live.bin > live.DIS
	rm -f live.dis

live.dis:	live.DIS always
	$(SYM) live.DIS $(TARGET)

$(TARGET).ihx:	$(OBJECTS) $(INCLUDES)
	$(LD) $(LDFLAGS) $@ $(OBJECTS)

$(TARGET).DIS:	$(TARGET).ihx
	naken_util -stm8 -disasm $< > $(TARGET).DIS
	rm -f $(TARGET).dis

$(TARGET).dis:	$(TARGET).DIS always
	$(SYM) $(TARGET).DIS

always:

clean:
	rm -f $(OBJECTS) $(ASMSOURCES:.asm=.lst) $(ASMSOURCES:.asm=.rst) $(ASMSOURCES:.asm=.sym)


%.rel:	%.asm $(ASMINCLUDES)
	$(ASM) $(ASMFLAGS) -o $<
