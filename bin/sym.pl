#!/usr/bin/perl 
#
# Add symbols to a naken_util disassembly using built in standard symbols
# and symbols read from the sdas assembler output.
# See the Makefiles in the examples for usage.

use 5.010;
use strict;
use warnings;
use utf8;


my $stm8type = 'stm8s003';

my $STM8_HAS_UART2 = 0;
my $STM8_HAS_UART3 = 0;
my $STM8_HAS_TIM5 = 0;
my $STM8_HAS_TIM6 = 0;
my $STM8_HAS_ADC2 = 0;


sub tohex {
	return sprintf("%04x", $_[0]);
}


my %irqmap = (
	'8000' => 'IRQ_RESET',
	'8004' => 'IRQ_TRAP',
	'8008' => 'IRQ_TLI',
	'800c' => 'IRQ_AWU',
	'8010' => 'IRQ_CLK',
	'8014' => 'IRQ_EXTI0',
	'8018' => 'IRQ_EXTI1',
	'801c' => 'IRQ_EXTI2',
	'8020' => 'IRQ_EXTI3',
	'8024' => 'IRQ_EXTI4',
	'8028' => 'IRQ_RESVD_8',
	'802c' => 'IRQ_RESVD_9',
	'8030' => 'IRQ_SPI',
	'8034' => 'IRQ_TIM1',
	'8038' => 'IRQ_TIM1_CAPCOM',
	'803c' => 'IRQ_TIM2',
	'8040' => 'IRQ_TIM2_CAPCOM',
	'8044' => 'IRQ_RESVD_15',
	'8048' => 'IRQ_RESVD_16',
	'804c' => 'IRQ_UART1_TX',
	'8050' => 'IRQ_UART1_RX',
	'8054' => 'IRQ_I2C',
	'8058' => 'IRQ_RESVD_20',
	'805c' => 'IRQ_RESVD_21',
	'8060' => 'IRQ_ADC1',
	'8064' => 'IRQ_TIM4',
	'8068' => 'IRQ_FLASH',
	'806c' => 'IRQ_RESVD_25',
	'8070' => 'IRQ_RESVD_26',
	'8074' => 'IRQ_RESVD_27',
	'8078' => 'IRQ_RESVD_28',
	'807c' => 'IRQ_RESVD_29',
);


my $itc_ext_interrupt_sensitivity_bits = [ 'ITC_EXTI_FL', 'ITC_EXTI_R', 'ITC_EXTI_F', 'ITC_EXTI_FR', 'ITC_EXTI_RF', ];

my $uart_sr_bits = [
	'UART_SR_PE',
	'UART_SR_FE',
	'UART_SR_NF',
	'UART_SR_OR',
	'UART_SR_IDLE',
	'UART_SR_RXNE',
	'UART_SR_TC',
	'UART_SR_TXE',
];

my $uart_cr1_bits = [
	'UART_CR1_PIEN',
	'UART_CR1_PS',
	'UART_CR1_PCEN',
	'UART_CR1_WAKE',
	'UART_CR1_M',
	'UART_CR1_UARTD',
	'UART_CR1_T8',
	'UART_CR1_R8',
];

my $uart_cr2_bits = [
	'UART_CR2_SBK',
	'UART_CR2_RWU',
	'UART_CR2_REN',
	'UART_CR2_TEN',
	'UART_CR2_ILIEN',
	'UART_CR2_RIEN',
	'UART_CR2_TCIEN',
	'UART_CR2_TIEN',
];

my $uart_cr3_bits = [
	'UART_CR3_LBCL',
	'UART_CR3_CPHA',
	'UART_CR3_CPOL',
	'UART_CR3_CKEN',
	'UART_CR3_STOP',
	undef,
	'UART_CR3_LINEN',
	undef,
];

my $uart_cr4_bits = [
	[ 4, 'UART_CR4_ADD' ],
	'UART_CR4_LBDF',
	'UART_CR4_LBDL',
	'UART_CR4_LBDIEN',
	'RSVD7',
];

my $uart_cr5_bits = [
	'RSVD0',
	'UART_CR5_IREN',
	'UART_CR5_IRLP',
	'UART_CR5_HDSEL',
	'UART_CR5_NACK',
	'UART_CR5_SCEN',
	'RSVD6',
	'RSVD7',
];

my $uart_cr6_bits = [
	'UART_CR6_LDUM',
	'RSVD6',
	'UART_CR6_LSLV',
	'UART_CR6_LASE',
	'RSVD3',
	'UART_CR6_LHDIEN',
	'UART_CR6_LHDF',
	'UART_CR6_LSF',
];

my %symtab = (
	'50c0' => 'CLK_ICKR', [
		'CLK_ICKR_HSIEN',
		'CLK_ICKR_HSIRDY',
		'CLK_ICKR_FHWU',
		'CLK_ICKR_LSIEN',
		'CLK_ICKR_LSIRDY',
		'CLK_ICKR_REGAH',
		'RSVD6',
		'RSVD7',
	],

	'50c1' => 'CLK_ECKR', [
		'CLK_ECKR_HSEEN',
		'CLK_ECKR_HSERDY',
		'RSVD2',
		'RSVD3',
		'RSVD4',
		'RSVD5',
		'RSVD6',
		'RSVD7',
	],

	'50c2' => 'CLK_RESERVED',
	'50c3' => 'CLK_CMSR',

	'50c4' => [ 'CLK_SWR', {
		'e1' => 'CLK_SWR_HSI',
		'd2' => 'CLK_SWR_LSI',
		'b4' => 'CLK_SWR_HSE',
	}],

	'50c5' => [ 'CLK_SWCR', [
		'CLK_SWCR_SWBSY',
		'CLK_SWCR_SWEN',
		'CLK_SWCR_SWIEN',
		'CLK_SWCR_SWIF',
		'RSVD4',
		'RSVD5',
		'RSVD6',
		'RSVD7',
	]],

	'50c6' => [ 'CLK_CKDIVR', [
		[ 3, 'CLK_CKDIVR_CPU', [
			'CLK_CKDIVR_CPUDIV_1', 'CLK_CKDIVR_CPUDIV_2', 'CLK_CKDIVR_CPUDIV_4', 'CLK_CKDIVR_CPUDIV_8',
			'CLK_CKDIVR_CPUDIV_16', 'CLK_CKDIVR_CPUDIV_32', 'CLK_CKDIVR_CPUDIV_64', 'CLK_CKDIVR_CPUDIV_128',
		]],
		[ 2, 'CLK_CKDIVR_HSI', [
			'CLK_CKDIVR_HSIDIV_1', 'CLK_CKDIVR_HSIDIV_2', 'CLK_CKDIVR_HSIDIV_4', 'CLK_CKDIVR_HSIDIV_8',
		]],
		[ 2, undef ],
	]],
	'50c7' => [ 'CLK_PCKENR1', [
		'CLK_PCKENR_I2C',
		'CLK_PCKENR_SPI',
		'CLK_PCKENR_UART1',
		($STM8_HAS_UART2 ? 'CLK_PCKENR_UART2' : ($STM8_HAS_UART3 ? 'CLK_PCKENR_UART3' : 'CLK_PCKENR_UART1')),
		($STM8_HAS_TIM6 ? 'CLK_PCKENR_TIM6' : 'CLK_PCKENR_TIM4'),
		($STM8_HAS_TIM5 ? 'CLK_PCKENR_TIM5' : 'CLK_PCKENR_TIM2'),
		'CLK_PCKENR_TIM3',
		'CLK_PCKENR_TIM1',
	]],

	'50c8' => [ 'CLK_CSSR', [
		'CLK_CSSR_CSSEN',
		'CLK_CSSR_AUX',
		'CLK_CSSR_CSSDIE',
		'CLK_CSSR_CSSD',
		'RSVD4',
		'RSVD5',
		'RSVD6',
		'RSVD7',
	]],

	'50c9' => [ 'CLK_CCOR', [
		'CLK_CCOR_CCOEN',
		[ 4, 'CLK_CCOR_CCOSEL', [
			'CLK_CCOR_CCOSEL_HSIDIV', 'CLK_CCOR_CCOSEL_LSI',    'CLK_CCOR_CCOSEL_HSE',    'CLK_CCOR_CCOSEL_RSVD3',
			'CLK_CCOR_CCOSEL_CPU',    'CLK_CCOR_CCOSEL_CPU2',   'CLK_CCOR_CCOSEL_CPU4',   'CLK_CCOR_CCOSEL_CPU8',
			'CLK_CCOR_CCOSEL_CPU16',  'CLK_CCOR_CCOSEL_CPU32',  'CLK_CCOR_CCOSEL_CPU64',  'CLK_CCOR_CCOSEL_HSI',
			'CLK_CCOR_CCOSEL_MASTER', 'CLK_CCOR_CCOSEL_RSVD13', 'CLK_CCOR_CCOSEL_RSVD14', 'CLK_CCOR_CCOSEL_RSVD15',
		]],
		'CLK_CCOR_CCORDY',
		'CLK_CCOR_CCOBSY',
		'RSVD7',
	]],

	'50ca' => [ 'CLK_PCKENR2', [
		'RSVD0',
		'RSVD1',
		'CLK_PCKENR_AWU',
		($STM8_HAS_ADC2 ? 'CLK_PCKENR_ADC2' : 'CLK_PCKENR_ADC1'),
		'RSVD4',
		'RSVD5',
		'RSVD6',
		'CLK_PCKENR_CAN',
	]],

	'50cb' => 'CLK_CANCCR',
	'50cc' => 'CLK_HSITRIMR',
	'50cd' => 'CLK_SWIMCCR',


	'7f70' => [ 'ITC_SPR1', [
		[ 2, 'VECT0', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT1', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT2', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT3', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f71' => [ 'ITC_SPR2', [
		[ 2, 'VECT4', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT5', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT6', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT7', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f72' => [ 'ITC_SPR3', [
		[ 2, 'VECT8', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT9', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT10', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT11', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f73' => [ 'ITC_SPR4', [
		[ 2, 'VECT12', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT13', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT14', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT15', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f74' => [ 'ITC_SPR5', [
		[ 2, 'VECT16', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT17', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT18', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT19', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f75' => [ 'ITC_SPR6', [
		[ 2, 'VECT20', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT21', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT22', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT23', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f76' => [ 'ITC_SPR7', [
		[ 2, 'VECT24', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT25', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT26', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT27', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
	]],
	'7f77' => [ 'ITC_SPR8', [
		[ 2, 'VECT28', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 2, 'VECT29', [ 'ITC_LEVEL_2', 'ITC_LEVEL_1', 'ITC_LEVEL_0', 'ITC_LEVEL_3', ]],
		[ 4, 'RSVD' ],
	]],

	'50a0' => [ 'ITC_EXTI_CR1', [
		[ 2, 'ITC_EXTI_PAIS', $itc_ext_interrupt_sensitivity_bits ],
		[ 2, 'ITC_EXTI_PBIS', $itc_ext_interrupt_sensitivity_bits ],
		[ 2, 'ITC_EXTI_PCIS', $itc_ext_interrupt_sensitivity_bits ],
		[ 2, 'ITC_EXTI_PDIS', $itc_ext_interrupt_sensitivity_bits ],
	]],
	'50a1' => [ 'ITC_EXTI_CR2', [
		[ 2, 'ITC_EXTI_PEIS', $itc_ext_interrupt_sensitivity_bits ],
		[ 1, 'ITC_EXTI_TLIS', [ 'ITC_TLIS_FL', 'ITC_TLIS_R' ]],
		[ 5, 'RSVD' ],
	]],


	'5230' => [ 'UART1_SR', $uart_sr_bits ],
	'5231' => 'UART1_DR',
	'5232' => [ 'UART1_BRR1', [
		[ 8, 'UART_BRR1_DIV_MID' ],
	]],
	'5233' => [ 'UART1_BRR2', [
		[ 4, 'UART_BRR2_DIV_MSN' ],
		[ 4, 'UART_BRR2_DIV_LSN' ],
	]],
	'5234' => [ 'UART1_CR1', $uart_cr1_bits ],
	'5235' => [ 'UART1_CR2', $uart_cr2_bits ],
	'5236' => [ 'UART1_CR3', $uart_cr3_bits ],
	'5237' => [ 'UART1_CR4', $uart_cr4_bits ],
	'5238' => [ 'UART1_CR5', $uart_cr5_bits ],
	'5239' => 'UART1_GTR',
	'523a' => 'UART1_PSCR',
);


my $addr = 0x5000;
for my $set ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I') {
	$symtab{sprintf("%4x", $addr++)} = "GPIO${set}_ODR";
	$symtab{sprintf("%4x", $addr++)} = "GPIO${set}_IDR";
	$symtab{sprintf("%4x", $addr++)} = "GPIO${set}_DDR";
	$symtab{sprintf("%4x", $addr++)} = "GPIO${set}_CR1";
	$symtab{sprintf("%4x", $addr++)} = "GPIO${set}_CR2";
}


sub tim_basic {
	my $tim = shift;
	my $addr = shift;

	$symtab{tohex($addr++)} = [ "${tim}_CR1", [
		'TIM_CR1_CEN',
		'TIM_CR1_UDIS',
		'TIM_CR1_URS',
		'TIM_CR1_OPM',
		[ 3, undef ],
		'TIM_CR1_ARPE',
	]];

	if ($stm8type =~ /^stm8s[01]03/i) {
		$symtab{tohex($addr++)} = "${tim}_RESERVED1";
		$symtab{tohex($addr++)} = "${tim}_RESERVED2";
	}

	$symtab{tohex($addr++)} = [ "${tim}_IER", [
		'TIM_IER_UIE',
		[ 5, undef ],
		'TIM_IER_TIE',
		undef,
	]];

	return $addr;
}


sub tim_general {
	my $tim = shift;
	my $addr = shift;

	$addr = tim_basic($tim, $addr);

	$symtab{tohex($addr++)} = [ "${tim}_SR1", [
		'TIM_SR1_UIF',
		[ 5, undef ],
		'TIM_SR1_TIF',
		undef,
	]];
	$symtab{tohex($addr++)} = "${tim}_SR2";
	$symtab{tohex($addr++)} = [ "${tim}_EGR", [
		'TIM_EGR_UG',
		[ 5, undef ],
		'TIM_EGR_TG',
		undef,
	]];
	$symtab{tohex($addr++)} = "${tim}_CCMR1";
	$symtab{tohex($addr++)} = "${tim}_CCMR2";
	$symtab{tohex($addr++)} = "${tim}_CCMR3";
	$symtab{tohex($addr++)} = "${tim}_CCER1";
	$symtab{tohex($addr++)} = "${tim}_CCER2";
	$symtab{tohex($addr++)} = "${tim}_CNTRH";
	$symtab{tohex($addr++)} = "${tim}_CNTRL";
	$symtab{tohex($addr++)} = "${tim}_PSCR";
	$symtab{tohex($addr++)} = "${tim}_ARRH";
	$symtab{tohex($addr++)} = "${tim}_ARRL";
	$symtab{tohex($addr++)} = "${tim}_CCR1H";
	$symtab{tohex($addr++)} = "${tim}_CCR1L";
	$symtab{tohex($addr++)} = "${tim}_CCR2H";
	$symtab{tohex($addr++)} = "${tim}_CCR2L";
	$symtab{tohex($addr++)} = "${tim}_CCR3H";
	$symtab{tohex($addr++)} = "${tim}_CCR3L";

	return $addr;
}

tim_general('TIM2', 0x5300);


sub symtab {
	if (my $e = $symtab{$_[0]}) {
		if (ref($e) eq 'ARRAY') {
			return $e->[0];
		} else {
			return $e;
		}
	}

	if (scalar(@_) == 2) {
		if ($_[1]) {
			print VARS "var $_[1] rom[0x$_[0]]\n" if ($_[1] !~ /^\./);
			return ($symtab{$_[0]} = $_[1]);
		}

		return undef;
	}

	return "0x$_[0]";
}

sub targetsym {
	state $counter = 0;

	my $sym = symtab($_[0], undef);
	return $sym if ($sym);

	return ($symtab{$_[0]} = '.unlabelled' . $counter++);
}

sub bit2sym {
	my $addr = shift;
	my $val = shift;

	if (exists $symtab{$addr} && ref($symtab{$addr}) eq 'ARRAY') {
		my $map = $symtab{$addr}[1];

		if (ref($map) eq 'ARRAY') {
			for (my $bit = 0; $bit < scalar(@$map); $bit++) {
				if (ref($map->[$bit]) eq 'ARRAY') {
					$bit += $map->[$bit][0] - 1;
				} else {
					return $map->[$bit] if ($val == $bit);
				}
			}
		}
	}

	return $val;
}

sub val2sym_internal {
	my $addr = shift;
	my $val = shift;
	my $op = shift;

	my $sigbits = 0xff;

	if (ref($addr) eq 'ARRAY') {
		$sigbits = $addr->[1];
		$addr = $addr->[0];
	}

	if (exists $symtab{$addr} && ref($symtab{$addr}) eq 'ARRAY') {
		my $map = $symtab{$addr}[1];

		if (ref($map) eq 'ARRAY') {
			my @ret;

			my $bit = 0;
			for my $bspec (@$map) {
				if (ref($bspec) eq 'ARRAY') {
					my $mask = 0;
					$mask |= (1 << $_) for ($bit..$bit + $bspec->[0] - 1);

					my $i = ($val & $mask) >> $bit;

					if (!$val || $i) {
						if (scalar(@$bspec) == 2) {
							if (!defined($bspec->[1])) {
								# Reserved bits
								if ($i) {
									push(@ret, sprintf("0x%x", $val & $mask));
								}
							} else {
								push(@ret, '(' . sprintf("0x%02x", $i) . ' << ' . $bspec->[1] . ')');
							}
						} else {
							if ($op eq 'and' && $i == scalar(@{$bspec->[2]}) - 1) {
								push(@ret, '(' . $bspec->[1] . '_MASK)');
							} elsif (!defined($bspec->[2][$i])) {
								# Reserved bit pattern
								if ($i) {
									push(@ret, sprintf("0x%x", $val & $mask));
								}
							} else {
								if ($op ne 'or' || $i || ($sigbits & $mask)) {
									push(@ret, '(' . $bspec->[2][$i] . ' << ' . $bspec->[1] . ')');
								}
							}
						}
					}

					$bit += $bspec->[0];
				} else {
					if ($val & (1 << $bit)) {
						if ($bspec) {
							push(@ret, '(1 << ' . $bspec . ')')
						} else {
							# Avoid using reserved bits
							return undef;
						}
					}
					$bit++;
				}
			}

			return scalar(@ret) ? join(' | ', @ret) : undef;
		} elsif (ref($map) eq 'HASH') {
			return ($map->{sprintf("%02x", $val)} || undef);
		}
	}

	return undef;
}

sub val2sym {
	my $v = hex($_[1]);

	my $a = val2sym_internal($_[0], $v, $_[2]);
	my $b = val2sym_internal($_[0], 255 - $v, $_[2]);

	if (!defined($a)) {
		if (!defined($b)) {
			return "0x$_[1]";
		}
		return "~($b)";
	} elsif (!defined($b)) {
		return $a;
	} elsif (length($b) < length($a)) {
		return "~($b)";
	}

	return $a;
}


my (%areas, %arealen);

sub load_dis
{
	my $file = shift;

	if (open(FILE, '<', $file)) {
		while (my $line = <FILE>) {
			if ($line =~/^\s*0x([[:xdigit:]]{4}):\s*([\w.\$]+):/) {
				my $addr = lc($1);
				if ($2 !~ /^\d{5}\$$/) {
					symtab($addr, $2);
				}
			}
		}
		close(FILE);
	}
}

sub load_map
{
	my $file = shift;

	if (open(FILE, '<', $file)) {
		while (my $line = <FILE>) {
			#if ($line =~/^\s+0000([[:xdigit:]]{4})\s*((?:[ls]_)?)([\w.\$]+)/) {
			if ($line =~ /^\s+0*([[:xdigit:]]+)\s*((?:[ls]_)?)([\w.\$]+)/) {
				my $addr = lc($1);
				if ($2 eq 's_') {
					$areas{$addr} ||= [];
					push(@{$areas{$addr}}, $3);
				} elsif ($2 eq 'l_') {
					$arealen{$3} = hex($1);
				} elsif (substr($3, 0, 1) ne '.') {
					symtab($addr, $3);
				}
			}
		}
		close(FILE);
	}
}


sub load_rst
{
	my $file = shift;

	if (open(FILE, '<', $file)) {
		while (my $line = <FILE>) {
			next unless (length($line) > 40);

			my $addr = lc(substr($line, 8, 4));

			if (substr($line, 40) =~ /^([\w.\$]+):/) {
				symtab($addr, $1);
			}
		}
		close(FILE);
	}
}


sub pprint {
	my $pass = shift;
	if ($pass) {
		print(@_);
	}
}


my $basename = $ARGV[0];
$basename =~ s/\.[^.]*$//;

open(VARS, '>', "$basename.vars") || die;
my $output = "$basename.dis";

if (scalar(@ARGV) > 1) {
	$basename = $ARGV[1];
}

load_map("$basename.map");
#load_rst("$basename.rst"); # Discrepencies between .rst and .map?
load_dis($output);


open(STDOUT, '>', "$output.new") || die;

for my $pass (0, 1) {
	open(FILE, '<', "$ARGV[0]") || die;

	my %regsrc = ();

	while (my $line = <FILE>) {
		next unless ($line =~ /^0x([[:xdigit:]]{4}):/);

		my $addr = lc(substr($line, 2, 4));

		if (exists $areas{$addr} && grep { $_ eq '_END'; } @{$areas{$addr}}) {
			next if (scalar(@{$areas{$addr}}) == 1);

			print STDERR "Non-empty areas exist beyond start of _END. Fix your layout.asm!\n" if ($pass == 0);
		}

		my $hex = lc(substr($line, 9, 15));
		my $code = substr($line, 24);
		$code =~ s/\s+cycles=(\d+(?:-\d+)?)\s*\r?\n//;
		my $cycles = $1;

		pprint($pass, "\n", map { ' ' x 24 . "; AREA: $_\n"; } @{$areas{$addr}}) if (exists $areas{$addr});

		if (my $label = symtab($addr, undef)) {
			pprint($pass, "\n0x$addr:                         $label:\n");
		}

		$code =~ s/(b(?:set|res|tj\w+)\s+)\$([[:xdigit:]]{4})(,\s*#)(\d)(,|\s|$)/$1 . symtab($2) . $3 . bit2sym($2, $4) . $5/e;

		if ($code =~ /^(?:btj|jr|jp)/) {
			$code =~ s/\$([[:xdigit:]]{4})(?:\s+\(offset=-?\d+\))?\s*$/targetsym($1)/e;
		}

		$code =~ s/and\s+[aA],\s*#\K\$([[:xdigit:]]+)/$regsrc{'a'} ? (($regsrc{'a'}[1] &= ~hex($1)), (val2sym($regsrc{'a'}, $1, 'and') || "0x$1")) : "0x$1"/e;

		$code =~ s/(int\s+)\$([[:xdigit:]]{4})/$1 . symtab(lc($2), $irqmap{$addr})/e;

		$code =~ s/ld\s+[aA],\s*\K\$([[:xdigit:]]{4})/($regsrc{'a'} = [ $1, 0xff ]), symtab($1)/e;

		$code =~ s/(mov\s+)\$([[:xdigit:]]{4})(,\s*#)\$([[:xdigit:]]+)/$1 . symtab($2) . $3 . (val2sym($2, $4, 'mov') || "0x$4")/e;

		$code =~ s/or\s+[aA],\s*#\K\$([[:xdigit:]]+)/$regsrc{'a'} ? (val2sym($regsrc{'a'}, $1, 'or') || "0x$1") : "0x$1"/e;

		$code =~ s/[^#]\K\$([[:xdigit:]]+)/symtab($1)/eg;

		pprint($pass, "0x$addr:  $hex [", sprintf("%3s", $cycles), "]         $code\n");
	}
	close(FILE);
}

system('mv', "$output.new", $output);
