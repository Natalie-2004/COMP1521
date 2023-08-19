#read a mark and print the corresponding UNSW grade

#include <stdio.h>

#int main(void) {
    #int mark;

    #printf("Enter a mark: ");
    #scanf("%d", &mark);

    #if (mark < 50) {			// if (mark < 50) goto "printf("FL\n");"
        #printf("FL\n");
    #} else if (mark < 65) {		// if (mark < 65) goto #printf("PS\n");
        #printf("PS\n");
    #} else if (mark < 75) {
        #printf("CR\n");
    #} else if (mark < 85) {
        #printf("DN\n");
    #} else {				// else, break, goto condition_end
        #printf("HD\n");
    #}

	.text
main:

	#Locals:
	#$t0, int mark

	li	$v0, 4		#system call 4: print_string
	la	$a0, print_msg_1
	syscall			#printf("Enter a mark: ");

	li	$v0, 5		#system call 5: scan_int
	syscall
	move	$t0, $v0	#scanf("%d", &mark);

	#put end_note at the end of every branches
	ble	$t0, 49, if_compare_mark_less_50

	ble	$t0, 65, if_compare_mark_less_65

	ble	$t0, 75, if_compare_mark_less_75

	ble	$t0, 84, if_compare_mark_less_85

	bge	$t0, 85, if_compare_mark_greater_85

if_compare_mark_less_50:
	li	$v0, 4
	la	$a0, print_mark_50
	syscall

	b	exit_if_else
if_compare_mark_less_65:
	li	$v0, 4
	la	$a0, print_mark_65
	syscall

	b	exit_if_else
if_compare_mark_less_75:
	li	$v0, 4
	la	$a0, print_mark_75
	syscall

	b	exit_if_else
if_compare_mark_less_85:
	li	$v0, 4
	la	$a0, print_mark_85
	syscall

	b	exit_if_else
if_compare_mark_greater_85:
	li	$v0,4
	la	$a0, print_else
	syscall

	b	exit_if_else
exit_if_else:
	li	$v0, 0
	jr	$ra		#return 0;


	.data
print_msg_1:
	.asciiz "Enter a mark: "
print_mark_50:
	.asciiz "FL\n"
print_mark_65:
	.asciiz "PS\n"
print_mark_75:
	.asciiz "CR\n"
print_mark_85:
	.asciiz "DN\n"
print_else:
	.asciiz "HD\n"
#incase
print_break:
	.asciiz "\n"