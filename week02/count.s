#int main(void) {
#    int number, i;
#
#   printf("Enter a number: ");
#    scanf("%d", &number);
#
#    i = 1;
#    while (i <= number) {
#        printf("%d\n", i);
#        i = i + 1;
#    }

	.text
main:
	#Locals:
	# $t0: int number
	# $t1: int i

	li	$v0, 4		#syscall 4: print_string
	la	$a0, print_msg_1
	syscall			#printf("Enter a number: ");

	li	$v0, 5		#system call 5: scan_int
	syscall
	move	$t0, $v0	#scanf("%d", &number);

loop_i_to_number_init:
	li	$t1, 1		#initialise i = 1;

loop_i_to_number_cond:		# if i > number goto end
	bgt 	$t1, $t0, loop_i_to_number_end

loop_i_to_number_body:
	li	$v0, 1		#syscall 1: print_int
	move 	$a0, $t1
	syscall			#printf(""%d, i)

	li	$v0, 11		#syscall 11: print_char
	li	$a0, '\n'
	syscall			#putchar('\n')

loop_i_to_number_step:
	addi	$t1, $t1, 1	#i += 1;
	b	loop_i_to_number_cond

loop_i_to_number_end:
	li	$v0, 0
	jr	$ra		#return 0;

	.data
print_msg_1:
	.asciiz "Enter a number: "
