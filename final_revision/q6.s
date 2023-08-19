# int numbers[1000];

# int main (void) {
#     int i = 0;
#     int sum = 0;
#     while (sum < 42) {
#         int x;
#         scanf("%d", &x);
#         numbers[i] = x;
#         i++;
#         sum += x;
#     }

#     while (i > 0) {
#     i--;
#     printf("%d\n", numbers[i]);
#     } 
# }

.text
main:
	li	$t0, 0		# int i = 0;
	li	$t1, 0		# int sum = 0;

first_cond:
	bge	$t1, 42, first_end	# while (sum >= 42), go to first_end
first_body:
	li	$v0, 5		# scanf("%d", &x)
	syscall 		# x = $v0

	la	$t2, numbers	# load array's init address
	mul	$t3, $t0, 4	# calculate offset
	add	$t4, $t2, $t3	# address + offset
	sw	$v0, ($t4)	# store value into $t2 -> x

first_stepper:
	addi	$t0, $t0, 1	# i++
	add	$t1, $t1, $v0	# sum += x

	j	first_cond
first_end:

sec_cond:
	ble	$t0, 0, sec_end
sec_body:
	addi	$t0, $t0, -1	# i--
	# because the above value changed, we need to calculate the array again
	la	$t2, numbers
	mul 	$t3, $t0, 4
	add	$t4, $t2, $t3	# address + offset -> number[i]

	lw	$a0, ($t4)	
	li	$v0, 1		# syscall 1: print int
	syscall			# printf("%d", numbers[i]);

	li	$v0, 11
	la	$a0, '\n'
	syscall 		# printf("%d\n", numbers[i]);

	j 	sec_cond
sec_end:
	li	$v0, 0
	jr 	$ra		# return 0	

.data
	# int = 4byte -> 4*1000
	numbers: .space 4000
