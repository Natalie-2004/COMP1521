# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

# Constants
ARRAY_LEN = 1000

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: int j
	#  - $t2: int temp

loop__init:
	li	$t0, 2					# i = 2;
loop__cond:
	bge	$t0, ARRAY_LEN, loop__end	# while (i < ARRAY_LEN)

loop__body:
	lb	$t2, prime($t0)
	beqz	$t2, loop__stepper	#   if (prime[i]) {

	li	$v0, 1					#     syscall 1: print_int
	move	$a0, $t0				
	syscall						#     printf("%d", i);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, '\n'				
	syscall						#     putchar('\n');

inner__init:
	mul	$t1, $t0, 2				#     j = 2 * i;

inner__cond:
	bge	$t1, ARRAY_LEN, inner_end	#     while (j < ARRAY_LEN) {
	
inner__body:
	sb 	$zero, prime($t1)			#       prime[j] = 0;

inner_stepper:
	add	$t1, $t1, $t0				#       j += i;
	j	inner__cond			

inner_end:
loop__stepper:
	add	$t0, $t0, 1				#     i++;
	j	loop__cond			

loop__end:					
	li	$v0, 0
	jr	$ra					# return 0;

	.data
prime:
	.byte	1:ARRAY_LEN				# uint8_t prime[ARRAY_LEN] = {1, 1, ...};