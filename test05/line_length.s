# Reads a line and print its length

LINE_LEN = 256

########################################################################
# .TEXT <main>
main:
	# Locals:
	#   - $t0: int i
	#   - $t1: temp storage 

	li	$v0, 4			# syscall 4: print_string
	la	$a0, line_prompt_str	#
	syscall				# printf("Enter a line of input: ");

	li	$v0, 8			# syscall 8: read_string
	la	$a0, line		# load &line
	la	$a1, LINE_LEN		# load &LINE_LEN
	syscall				# fgets(buffer, LINE_LEN, stdin)

while_init:
	li	$t0, 0			# int i = 0;
while_cond:
	la	$a0, line		# Load the address of line into $a0
	add	$t1, $a0, $t0		# get &line[i] by adding base address and offset 
	lb	$a0, ($t1)		# load value into line[i]

	beqz	$a0, while_end		# while (line[i] == 0), go to while_end
while_body:
while_step:
	addi	$t0, $t0, 1		# i++

	j	while_cond		# jump back

while_end:

	li	$v0, 4			# syscall 4: print_string
	la	$a0, result_str		#
	syscall				# printf("Line length: ");

	li	$v0, 1			# syscall 1: print_int
	move	$a0, $t0	
	syscall				# printf("%d", i);

	li	$v0, 11			# syscall 11: print_char
	li	$a0, '\n'		#
	syscall				# putchar('\n');

	li	$v0, 0
	jr	$ra			# return 0;

########################################################################
# .DATA
	.data
# String literals
line_prompt_str:
	.asciiz	"Enter a line of input: "
result_str:
	.asciiz	"Line length: "

# Line of input stored here
line:
	.space	LINE_LEN

