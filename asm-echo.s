.section __DATA, __const
space: .ascii " "
space_end: SPACE_LEN = space_end-space
newline: .ascii "\n"
newline_end: NEWLINE_LEN = newline_end-newline

.section __TEXT, __text
.globl _main
_main:
	lea 16(%rsp), %rbx			# 16(%rsp)=pointer to 1st parameter
.argvforloop:
	mov (%rbx), %rsi			# Move current cmd line parameter pointer into %rsi
	cmp $0x0, %rsi				# Exit if 0
	je .exit
	
	xor %rdx, %rdx				# Zero out %rdx as it will act as our string index
.strForLoop:					# Find string length
	inc %rdx
	cmpb $0, -1(%rsi, %rdx)			# Is previous character 0 (nul)
	jne .strForLoop
	dec %rdx				# Decrement so as to not include nul
	

	# sys_write syscall:
    	# rdi = output device
    	# rsi = pointer to string (command line argument)
    	# rdx = length
	mov $0x1, %rdi				# 0x1 = STDOUT
	mov $0x2000004, %rax			# 0x2000004 = SYS_WRITE
	syscall
	
	add $8, %rbx				# Get next cmd argument
	mov (%rbx), %rsi			# Set the %rsi pointer to the value at %rbx
	cmp $0x0, %rsi				# %rsi == 0 ? exit :  printspace() 
	je .exit

.printspace:					# Print space between words
    mov $SPACE_LEN, %rdx
    lea space(%rip), %rsi
    mov $0x2000004, %rax
    syscall
	jmp .argvforloop
	
.exit:
    mov $NEWLINE_LEN, %rdx			
    lea newline(%rip), %rsi
    mov $0x1, %rdi
    mov $0x2000004, %rax			# Print newline (\n)
    syscall
    
    dec %rdi
    mov $0x2000001, %rax
    syscall					# exit(0)
 

