# Reads 10 numbers into an array and prints numbers which are
# larger than the final number read.

# Constants
ARRAY_LEN = 10

main:
 # Registers:
 #  - $t0: int i
 #  - $t1: temporary result
 #  - $t2: temporary result
 #  - $t3: int final_number

scan_loop__init:
 li $t0, 0    # i = 0
scan_loop__cond:
 bge $t0, ARRAY_LEN, scan_loop__end # while (i < ARRAY_LEN) {

scan_loop__body:
 li $v0, 5    #   syscall 5: read_int
 syscall      #   
      #
 mul $t1, $t0, 4   #   calculate &numbers[i] == numbers + 4 * i
 li $t2, numbers   #
 add $t2, $t2, $t1   #

 # sw -> Stores a word from a register into a specfic position of the array in memory
 # ie. reading integers into the array
 sw $v0, ($t2)   #   scanf("%d", &numbers[i]);

 move $t3, $v0   #   final_number = numbers[i]

 addi $t0, $t0, 1   #   i++;
 j scan_loop__cond   # }
scan_loop__end:

print_loop__init:
 li $t0, 0    # i = 0
print_loop__cond:
 bge $t0, ARRAY_LEN, print_loop__end # while (i < ARRAY_LEN) {

print_loop__body:
 mul $t1, $t0, 4   #   calculate &numbers[i] == numbers + 4 * i
 li $t2, numbers   #
 add $t2, $t2, $t1   #
 # lw -> when you want to load a value from a specific position of the array in memory into a register.
 # ie comparing elements of the array
 lw $a0, ($t2)  #
 bge $a0, $t3, print_loop__continue #   if (numbers[i] >= final_number) {

 li $v0, 1    #     syscall 1: print_int
 syscall     #     printf("%d", numbers[i])

 li $v0, 11    #     syscall 11: print_char
 li $a0, '\n'   #
 syscall     #     printf("%c", '\n');
      #   }
print_loop__continue:
 addi $t0, $t0, 1   #   i++
 j print_loop__cond  # }
print_loop__end:


	.data
numbers:
 	.word 0:ARRAY_LEN   # int numbers[ARRAY_LEN] = {0};







