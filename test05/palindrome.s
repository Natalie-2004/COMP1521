# Reads a line and prints whether it is a palindrome or not

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - ...

	li	$v0, 4				# syscall 4: print_string
	la	$a0, line_prompt_str		#
	syscall					# printf("Enter a line of input: ");

	li	$v0, 8				# syscall 8: read_string
	la	$a0, line			#
	la	$a1, LINE_LEN			#
	syscall					# fgets(buffer, LINE_LEN, stdin)

while_init:
	li	$t0, 0				# int i = 0;
while_cond:
	la	$a0, line			# Load the address of line into $a0
	add	$t1, $a0, $t0			# get &line[i] by adding base address and offset 
	lb	$t2, ($t1)			# load byte into line[i]

	beqz	$t2, while_end			# while (line[i] == 0), go to while_end
while_body:
while_step:
	addi	$t0, $t0, 1			# i++

	j	while_cond			# jump back
while_end:
j_k_init:
	li	$t3, 0				# int j = 0;
	sub	$t4, $t0, 2			# int k = i - 2;

j_k_cond:
	bge	$t3, $t4, j_k_end		# while (j >= k), go to j_k_end

j_k_body:
	# get line[j]
	la	$a0, line			# Load the address of line into $a0
	add	$s0, $a0, $t3			# get &line[j] by adding base address and offset 
	lb	$s1, ($s0)			# load byte into line[j]

	# get line[k]
	la	$a0, line			# Load the address of line into $a0
	add	$s2, $a0, $t4			# get &line[k] by adding base address and offset 
	lb	$s3, ($s2)			# load byte into line[k]

	beq 	$s1, $s3, j_k_step		# if (line[j] == line[k]), break

	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_not_palindrome_str	#
	syscall					# printf("not palindrome\n");

	j 	return_0

j_k_step:
	addi 	$t3, $t3, 1			# j++
	sub	$t4, $t4, 1			# k--

	j	j_k_cond			# jump back to loop

j_k_end:
	li	$v0, 4				# syscall 4: print_string
	la	$a0, result_palindrome_str	#
	syscall					# printf("palindrome\n");

return_0:
	li	$v0, 0
	jr	$ra				# return 0;


########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_not_palindrome_str:
	.asciiz	"not palindrome\n"
result_palindrome_str:
	.asciiz	"palindrome\n"

# Line of input stored here
line:
	.space	LINE_LEN

