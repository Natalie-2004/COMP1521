# Reads 10 numbers into an array, bubblesorts them
# and then prints the 10 numbers
# YOUR-NAME-HERE, DD/MM/YYYY

# Constants
ARRAY_LEN = 10

main:
	# Registers:
	#  - $t0: int i
	#  - $t1: temporary result
	#  - $t2: temporary result
	#  - $t3: int swapped
	#  - $t4: int x
	#  - $t5: int y
	#  - $t6: temporary result

scan_loop__init:
	li	$t0, 0				# i = 0

scan_loop__cond:
	bge	$t0, ARRAY_LEN, scan_loop__end	# while (i < ARRAY_LEN) {

scan_loop__body:
	li	$v0, 5				#   syscall 5: read_int
	syscall					#
						
	mul	$t1, $t0, 4				#   calculate &numbers[i] == numbers + 4 * i
	li	$t2, numbers			#
	add	$t2, $t2, $t1			#
	sw	$v0, ($t2)				#   scanf("%d", &numbers[i]);

scan_loop_stepper:
	addi	$t0, $t0, 1			#   i++;
	b	scan_loop__cond			# }
scan_loop__end:
	# null

swap_loop__init:
	li	$t3, 1				# swapped = 1;
swap_loop__cond:
	beqz	$t3, swap_loop__end		# while (swapped) {
swap_loop__body:
	li	$t3, 0				#   swapped = 0;

sort_loop__init:
	li	$t0, 1				#   i = 1
sort_loop__cond:
	bge	$t0, ARRAY_LEN, sort_loop__end	#   while (i < ARRAY_LEN) {

	mul	$t1, $t0, 4			#   &numbers[i] = numbers + 4 * i
	li	$t2, numbers			#
	add	$t2, $t2, $t1			#
	lw	$t4, ($t2)			#   x = numbers[i];

	addi	$t6, $t2, -4	#     &numbers[i - 1] = &numbers[i] - 4
	lw	$t5, ($t6)			#     y = numbers[i - 1]

	bge	$t4, $t5, sort_loop__step	#     if (x < y) {

	sw	$t5, ($t2)			#       numbers[i] = y;
	sw	$t4, ($t6)			#       numbers[i - 1] = x;
	li	$t3, 1				#       swapped = 1
sort_loop__step:
	addi	$t0, $t0, 1			#     i++;
	b	sort_loop__cond			#   }
sort_loop__end:
	b	swap_loop__cond			# }
swap_loop__end:
	#null

print_loop__init:
	li	$t0, 0				# i = 0
print_loop__cond:
	bge	$t0, ARRAY_LEN, print_loop__end	# while (i < ARRAY_LEN) {

print_loop__body:
	mul	$t1, $t0, 4			#   calculate &numbers[i] == numbers + 4 * i
	li	$t2, numbers			#
	add	$t2, $t2, $t1			#
	lw	$a0, ($t2)		#
	li	$v0, 1				#   syscall 1: print_int
	syscall					#   printf("%d", numbers[i])

	li	$v0, 11				#   syscall 11: print_char
	li	$a0, '\n'
	syscall					#   printf("%c", '\n');

print_loop_step:
	addi	$t0, $t0, 1			#   i++
	b	print_loop__cond		# }
print_loop__end:
	li	$v0, 0
	jr	$ra				# return 0;


	.data
numbers:
	.word	0:ARRAY_LEN			# int numbers[ARRAY_LEN] = {0};