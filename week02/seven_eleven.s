#int main(void) {
 #   int number, i;
#
 #   printf("Enter a number: ");
  #  scanf("%d", &number);
#
#   i = 1;
#    while (i < number) {
#        if (i % 7 == 0 || i % 11 == 0) {
#            printf("%d\n", i);
#        }
#        i = i + 1;
#    }

	.text
main:

	#Locals:
	# $t0: int number
	# $t1: int i
	# $t2: mod_i

	li	$v0, 4		#syscall 4: print_string
	la	$a0, print_msg_1
	syscall			#printf("Enter a number: ");

	li	$v0, 5		#system call 5: scan_int
	syscall
	move	$t0, $v0	#scanf("%d", &number);

loop_init:
	li	$t1, 1		#initialise i = 1;

loop_cond:			# if i >= number goto end
	bge 	$t1, $t0, end

loop:
	rem	$t2, $t1, 7	#if (i % 7) == 0 goto if_mod_7_or_mod_11_eqn_0
	beqz	$t2, print

	rem	$t2, $t1, 11	#if (i % 11) == 0 goto if_mod_7_or_mod_11_eqn_0
	beqz	$t2, print

stepper:
	addi	$t1, $t1, 1	#i += 1;
	b	loop_cond

print:				#this should be the body part of loop. However, due to the order, 
				#I move it next to stepper, and let it jump back
	li	$v0, 1		#syscall 1: print_int
	move 	$a0, $t1
	syscall			#printf(""%d, i)

	li	$v0, 11		#syscall 11: print_char
	li	$a0, '\n'
	syscall			#putchar('\n')

	b	stepper

end:
	li	$v0, 0
	jr	$ra		#return 0;

	.data
print_msg_1:
	.asciiz "Enter a number: "





