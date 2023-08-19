# Read a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number
#
# Before starting work on this task, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
#
# YOUR-NAME-HERE, DD/MM/YYYY

#![tabsize(8)]

#include <stdio.h>

# int main(void) {
#     int i, j, n, total, how_many;

#     printf("Enter how many: ");
#     scanf("%d", &how_many);

#     n = 1;

#     while (n <= how_many) {
#         total = 0;
#         j = 1;

#         while (j <= n) {
#             i = 1;
#             while (i <= j) {
#                 total = total + i;
#                 i = i + 1;
#             }
#             j = j + 1;
#         }
#         printf("%d\n", total);
#         n = n + 1;
#     }
#     return 0;
# }

main:				# int main(void) {

	li	$v0, 4
	la	$a0, prompt	# printf("Enter how many: ");
	syscall

	li	$v0, 5		# scanf("%d", number);
	syscall
	move	$t0, $v0	# $t0 = scanf("%d", &how_many);

	li	$t1, 1		# n = 1;

loop1:
	bgt	$t1, $t0, loop1_end
	li	$t2, 0		# total = 0;
	li	$t3, 1		# j = 1;

loop2:	
	bgt	$t3, $t1, loop2_end
	li	$t4, 1		# i = 1

loop3:
	bgt 	$t4, $t3, loop3_end

	add	$t2, $t2, $t4	# total = total + i;

	addi	$t4, $t4, 1	#i++

	j	loop3
loop3_end:
stepper2:
	addi	$t3, $t3, 1	# j++

	j	loop2
loop2_end:
	li	$v0, 1
	move	$a0, $t2	# printf("%d", total);
	syscall

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall
stepper1:
	addi	$t1, $t1, 1	# n++
	j 	loop1
loop1_end:
end:
	li	$v0, 0
	jr	$ra		# return 0

	.data
prompt:
	.asciiz "Enter how many: "