#include "timer.h"

#define CFG_CLK_CPU_M3_BOOT (120*1000*1000)
void udelay(unsigned int us)
{
    while(us--) {
		unsigned long t = (CFG_CLK_CPU_M3_BOOT/3)/1000000;
		while(t--)
			__asm__ __volatile__("nop");
	}
}
