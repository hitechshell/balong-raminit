#include "uart.h"

#define HI_UART0_REGBASE_ADDR 0x90007000

#define AMBA_UART_DR(base)	(*(volatile unsigned int *)((base) + 0x00))
#define AMBA_UART_LCRH(base)	(*(volatile unsigned int *)((base) + 0x2c))
#define AMBA_UART_CR(base)	(*(volatile unsigned int *)((base) + 0x30))
#define AMBA_UART_LSR(base)	(*(volatile unsigned int *)((base) + 0x14))

static inline void putc(int c)
{
	unsigned long base = HI_UART0_REGBASE_ADDR;

	while (!(AMBA_UART_LSR(base) & 0x20));

	AMBA_UART_DR(base) = c;
}

void print_info(const char *ptr)
{
	char c;

	while ((c = *ptr++) != '\0') {
		if (c == '\n')
			putc('\r');
		putc(c);
	}
}
