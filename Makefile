export CORE_ROOT=$(shell pwd)

all: icarus

icarus: icarus_compile
		vvp $(CORE_ROOT)/temp/UART_8bit_tb.vvp

icarus_compile:
		mkdir -p temp
		iverilog -f flist -o  $(CORE_ROOT)/temp/UART_8bit_tb.vvp  $(CORE_ROOT)/testbench/UART_8bit_tb.v

clean:
		rm -rf temp