include config/balong_product_config.mk

CC		= $(CROSS_COMPILE)gcc
AR    	= $(CROSS_COMPILE)ar
AS		= $(CROSS_COMPILE)as
LINK	= $(CROSS_COMPILE)ld 
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

CFLAGS	= -mcpu=cortex-m3 -mthumb -O2 -fno-builtin -nostartfiles -g -mlong-calls -Wall -D__CMSIS_RTOS -c

ASMFLAGS = -mcpu=cortex-m3 -mthumb -D__ASSEMBLY__ -x assembler-with-cpp

CFILES 	= main.c timer.c uart.c

SFILES	= 

CFLAGS += -I./config -I.

ifeq ($(strip $(CFG_BSP_CONFIG_V7R2_ASIC)),YES)
CFILES	+= mddrc_v7r2_asic.c
endif

ifeq ($(strip $(CFG_BSP_CONFIG_V711_ASIC)),YES)
ifeq ($(strip $(CFG_BSP_CONFIG_EMU)),YES)
CFILES	+= mddrc_v711_emu.c
else
CFILES	+= mddrc_v711_asic.c
endif
endif

ifeq ($(strip $(CFG_BSP_CONFIG_V711_PORTING)),YES)
CFILES	+= mddrc_v711_porting.c
endif

ifeq ($(strip $(CFG_BSP_CONFIG_V7R2_SFT)),YES)
CFILES	+= mddrc_v7r2_porting.c
endif

ifeq ($(strip $(CFG_BSP_CONFIG_P531_ASIC)),YES)
CFILES	+= mddrc_p531_asic_333.c
CFLAGS	+= -DRAMINIT_CHIP_P531
endif

ifeq ($(strip $(CFG_BSP_CONFIG_P532_ASIC)),YES)
CFILES	+= mddrc_p532_asic_533.c
endif

ifeq ($(strip $(CFG_BSP_CONFIG_HI6950)),YES)

ifneq ($(strip $(CFG_BSP_CONFIG_SFT)),YES)
ifneq ($(strip $(CFG_BSP_CONFIG_EMU_PALADIN)),YES)
CFILES	+= mddrc_v7r5_asic.c
endif
endif
ifeq ($(strip $(CFG_BSP_CONFIG_SFT)),YES)
CFILES	+= mddrc_v7r5_porting.c
endif
ifeq ($(strip $(CFG_BSP_CONFIG_EMU_PALADIN)),YES)
CFILES	+= mddrc_v7r5_porting.c
endif

endif
#start of CFG_BSP_CONFIG_HI6932
ifeq ($(strip $(CFG_BSP_CONFIG_HI6932)),YES)

ifneq ($(strip $(CFG_BSP_CONFIG_SFT)),YES)
ifneq ($(strip $(CFG_BSP_CONFIG_EMU_PALADIN)),YES)
CFILES	+= mddrc_v722_asic.c
endif
endif
ifeq ($(strip $(CFG_BSP_CONFIG_SFT)),YES)
CFILES	+= mddrc_v722_porting.c
endif
ifeq ($(strip $(CFG_BSP_CONFIG_EMU_PALADIN)),YES)
CFILES	+= mddrc_v722_porting.c
endif

endif
#end of CFG_BSP_CONFIG_HI6932


OBC_LOCAL_INC_DIR  := \
	./include
# include path
FULL_SRC_INC_PATH  := $(foreach lib_inc_path, $(OBC_LOCAL_INC_DIR), -I$(lib_inc_path))


COBJFILES = $(subst .c,.o, $(CFILES))	
SOBJFILES = $(subst .s,.o, $(SFILES))	

all:ramInit.bin

ramInit.bin:ramInit.elf
	$(Q)$(OBJCOPY) -O binary ramInit.elf ramInit.bin
	
ramInit.elf:$(SOBJFILES) $(COBJFILES)
	$(Q)$(LINK) -T link.ld -o ramInit.elf $(SOBJFILES) $(COBJFILES)
	
$(COBJFILES):%o:%c
	$(CC) $(CFLAGS) $(FULL_SRC_INC_PATH) -T link.ld -o $@ $<

$(SOBJFILES):%o:%s
	$(CC) $(ASMFLAGS) -T link.ld -o $@ -c $<
	
clean:
	$(Q)-rm -rf *.bin *.o *.elf
