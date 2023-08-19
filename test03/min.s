#  print the minimum of two integers
main:
	# Labels:
	# - $t0 -> int x
	# - $t1 -> int y

	li	$v0, 5		# scanf("%d", &x);
	syscall			#
	move $t0, $v0

	li	$v0, 5		# scanf("%d", &y);
	syscall			#
	move $t1, $v0

if:
	bge $t0, $t1, else	# if (x >= y), break go to else

	move $a0, $t0		# printf("%d", x);
	li	$v0, 1
	syscall				# syscall 1: print int

	li	$a0, '\n'		# printf("%c", '\n');
	li	$v0, 11
	syscall

	j end				# finish condition, go to end

else:
	move $a0, $t1		# printf("%d", y);
	li	$v0, 1
	syscall				# syscall 1: print int

	la	$a0, '\n'		# printf("%c", '\n');
	li	$v0, 11			# syscall 11: print char
	syscall

end:
	li	$v0, 0		# return 0
	jr	$ra
