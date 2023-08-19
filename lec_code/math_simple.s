#3.6.23
#translate this c into mips
#int x = 17;
#int y = 25;
#
#int z = x+y;
#z = 2*z;
#
#printf("%d", z);
#putchar('\n');
#
#return 0;

		.text
main:
		#Locals:
		# - $t0: int x
		# - $t1: int y
		# - $t2: int z

		li 		$t0, 17		#(Rs) int x = 17
		li		$t1, 25		#(Rt) int y = 25

		add 	$t2, $t0, $t1		#int z = x + y
		mul		$t2, $t2, 2			#z = z * 2

		li		$v0, 1		#syscall 1: print_int -> expect the argument inside a0, not t2. 
		move 	$a0, $t2	#so do a copy -> take take a0 and make it equal to value of t2
		syscall				#printf("%d", z)

		#alternative way
		#li		$v0, 1
		#add 	$a0, $t0, $t1	#int z = x + y
		#mul 	$a0, $a0, 2		#z = z * 2
		#syscall				#printf("%d", 2 * (x + y))

		li 		$v0, 11		# syscall 11： print_char
		li 		$a0, '\n'	#
		syscall				# putchar ('\n')

		li		$v0, 0
		jr		$ra			#return 0;

