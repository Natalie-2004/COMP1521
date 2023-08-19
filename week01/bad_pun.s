#A simple program translated from C to MIPS
#3.6.23
		.text
main:
		li			$v0, 4			#syscall 4: print_string
		la			$a0, msg
		syscall

		li			$v0, 0
		jr			$ra				#return 0;

		.data
msg:
		.asciiz "Well, this was a MIPStake!\n"