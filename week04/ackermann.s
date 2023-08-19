########################################################################
# .DATA
# Here are some handy strings for use in your code.
	.data
prompt_m_str:	.asciiz	"Enter m: "
prompt_n_str:	.asciiz	"Enter n: "
result_str_1:	.asciiz	"Ackermann("
result_str_2:	.asciiz	", "
result_str_3:	.asciiz	") = "

########################################################################
# .TEXT <main>
	.text
main:

	# Args: void
	# Returns: int
	#
	# Frame:	[$ra, $s0, $s1]
	# Uses: 	[$v0, $a0, $s0, $s1, $t0]
	# Clobbers:	[$v0, $a0, $t0]
	#
	# Locals:
	#   - $s0: int m
	#   - $s1: int n
	#   - $t0: int f
	#
	# Structure:
	#   - main
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

main__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1

main__body:
	li	$v0, 4			# syscall 4: print_string
	la	$a0, prompt_m_str	#
	syscall				# printf("Enter m: ");

	li	$v0, 5			# syscall 5: read_int
	syscall				#
	move	$s0, $v0		# scanf("%d", &m);

	li	$v0, 4			# syscall 4: print_string
	la	$a0, prompt_n_str	#
	syscall				# printf("Enter n: ");

	li	$v0, 5			# syscall 5: read_int
	syscall				#
	move	$s1, $v0		# scanf("%d", &n);

	move	$a0, $s0
	move	$a1, $s1
	jal	ackermann
	move	$t0, $v0		# int f = ackermann(m, n);

	la	$a0, result_str_1	# syscall 4: print_string
	li	$v0, 4			#
	syscall				# printf("Ackermann(");

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $s0		#
	syscall				# printf("%d", m);

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str_2	#
	syscall				# printf(", ");

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $s1		#
	syscall				# printf("%d", n);

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str_3	#
	syscall				# printf(") = ");

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $t0		#
	syscall				# printf("%d", f);

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#	
	syscall				# putchar('\n');

main__epilogue:
	pop	$s1
	pop	$s0
	pop	$ra
	end

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .TEXT <ackermann>
	.text
ackermann:

	# Args:
	#   - $a0: int m
	#   - $a1: int n
	# Returns: int
	#
	# Frame:	[]
	# Uses: 	[]
	# Clobbers:	[]
	#
	# Locals:
	#   - .
	#
	# Structure:
	#   - ackermann
	#     -> [prologue]
	#     -> [body]
	#     -> [epilogue]

ackermann__prologue:
	begin
	push	$ra
	push	$s0

ackermann__body:
	move	$s0, $a0

	bnez	$a0, ackermann__m_ne_0	# if (m == 0) {

	addi	$v0, $a1, 1		#   return n + 1;
	b	ackermann__epilogue	# }

ackermann__m_ne_0:
	bnez	$a1, ackermann__n_ne_0	# if (n == 0) {

	addi	$a0, $a0, -1
	li	$a1, 1
	jal	ackermann		#   return ackermann(m - 1, 1);
	b	ackermann__epilogue	# }

ackermann__n_ne_0:
	addi	$a1, $a1, -1
	jal	ackermann		# ackermann(m, n - 1);

	addi	$a0, $s0, -1
	move	$a1, $v0
	jal	ackermann		# return ackermann(m - 1, ackermann(m, n - 1));

ackermann__epilogue:
	pop	$s0
	pop	$ra
	end

	jr	$ra