# Reads numbers into an array until a negative number is entered
# then print the numbers in reverse order.

# Constants
ARRAY_LEN = 1000				# This is equivalent to a #define in C.

main:
	# Registers:
	#   - $t0: int i
	#   - $t1: temporary result
	#   - $t2: temp storage for x
	#   - $v0: int x

read_loop__init:
	li	$t0, 0				# i = 0
read_loop__cond:
	bge	$t0, ARRAY_LEN, read_loop__end	# while (i < ARRAY_LEN) {

read_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#   scanf("%d", &x);
	move	$t2, $v0		

	blt	$v0, 0, read_loop__end		#   if (x < 0) break;
else:
	mul	$t1, $t0, 4			#   &numbers[i] = numbers + 4 * i
	
	sw	$t2, numbers($t1)		#   numbers[i] = x

	addi	$t0, $t0, 1			#   i++;
	j	read_loop__cond			# }
read_loop__end:

loop_cond:
	blez	$t0, loop_end			# while (i <= 0), break

loop_body:
	sub	$t0, $t0, 1			# i--
	
	li 	$v0, 1				# print_int
	mul	$t1, $t0, 4			# &numbers[i] = numbers + 4 * i
	lw	$a0, numbers($t1)		
	syscall					# printf("%d", numbers[i]);

	li	$v0, 11
	la	$a0, '\n'
	syscall					# printf("\n")

loop_step:
	j 	loop_cond

loop_end:
	li	$v0, 0
	jr	$ra				# return 0;

########################################################################
# .DATA
	.data
numbers:
	.space 4 * ARRAY_LEN			# int numbers[ARRAY_LEN];