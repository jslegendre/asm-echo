all: output clean

output: 
	as asm-echo.s -o asm-echo.o
	ld asm-echo.o -e _main -o asm-echo

clean:
	rm asm-echo.o
