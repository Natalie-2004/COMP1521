main:
	# Labels:
	# - $t0 -> int x
	# - $t1 -> int y
	# - $t2 -> int i

	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move	$t0, $v0

	li	$v0, 5		# scanf("%d", &y);
	syscall			#
	move	$t1, $v0
 
loop_init:
	addi $t2, $t0, 1	#int i = x + 1

loop_con:
	bge $t2, $t1, end # while (i >= y)

loop_body:
	beq $t2, 13, loop_stepper # if (i == 13)

	move $a0, $t2		# printf("%d", i);
	li	$v0, 1
	syscall				# syscall 1: print int

	li	$a0, '\n'		# printf("%c", '\n');
	li	$v0, 11
	syscall	

loop_stepper:
	addi $t2, $t2, 1	# i++
	j loop_con			# finish one loop, go back to loop condition for next loop

end:
	li	$v0, 0         # return 0
	jr	$ra
