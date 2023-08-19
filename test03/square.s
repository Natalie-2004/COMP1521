	.text
main:
	# Labels:
	# - $t0 -> int x
	# - $t1 -> int i
	# - $t2 -> int j

	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0

loop_init: 
	li $t1, 0		# assign i = 0;

loop_con:
	bge $t1, $t0, end	# while (i >= x), break

loop_body:
	li $t2, 0		# assign j = 0;

sec_con:
	bge $t2, $t0, loop_stepper	# while (i >= x), break

sec_body:
	li $v0, 4		# syscall 4: print string
	la $a0, msg_1
	syscall			# printf("*");

sec_stepper:
	addi $t2, $t2, 1 	# j++

	j sec_con		# finish one loop, go back to loop condition for next loop

loop_stepper:
	addi $t1, $t1, 1 	# i++

	li	$a0, '\n'	# printf("%c", '\n');
	li	$v0, 11
	syscall	

	j loop_con 		# finish one loop, go back to loop condition for next loop

end:
	li	$v0, 0		# return 0
	jr	$ra

	.data
msg_1:
	.asciiz "*"
