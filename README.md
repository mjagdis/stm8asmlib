# Assembly support library for STM8 MCUs

A library of definitions and macros to support building applications
in assembly for the STM8 series of microcontrollers.


## Examples

### null

An empty application that does nothing useful. For use as a template
when creating your own apps.

### xconnect

An application that demonstrates how to use the library to define a
virtual UART that does RX/TX on a pair of GPIO pins which is then
cross-connected with the HW UART1 such that data received on one
is sent back out via the other.


## Errata considerations

2.1.3: ISRs MUST set the current priority level in CCR on entry.

2.1.4: If a DIV/DIVW is used inside an ISR the current priority MUST be
       masked using:

           push cc
	   pop a
	   and a, #$BF
	   push a
	   pop cc

2.2.1: HSI cannot be switched off even if HSIEN is set to 0.

2.2.3: f_CPU MUST be <250kHz during active wait or halt if flash/EEPROM
       is configured to power down. It is sufficient to set the clock
       divider before waiting. If the ISR reconfigures the clock divisor
       it MUST restore it before returning in case the activation level
       is set to interrupt-only.

2.4.1: You MUST NOT use any multi-cycle instructions between reading the
       MSB and LSB of a 16-bit counter register.

2.6.1: I2C events MUST be handled before the current byte transfer ends
       and the ACK is sent. Nested interrupts SHOULD be used with I2C
       using the highest priority.

2.6.2: You MUST avoid BTF=1 I2C conditions. You SHOULD use nested interrupts
       and give I2C RxNE and TxE the highest priority.

2.6.3: You SHOULD implement a timeout on I2C operations and reset by setting
       SWRST in I2C_CR2 if the bus appears hung.

2.6.4: Reduce I2C frequency below 88kHz or use fast mode to avoid out-of-spec
       bus timings.

2.6.6: I2C clock stretching MUST be enabled to allow time for the CPU to be
       woken up to handle a received byte.
       If the I2C bus remains busy (BUSY set in I2C_SR3) for too long it
       SHOULD be reset.
