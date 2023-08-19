#A simple program translated from C to MIPS
#Calculates the Gaussian sum between two numbers
#3.6.23

        .text
main:
        #locals:
        # $t0 -> int number 1
        # $t1 -> int number 2
        # $t2 -> int result1
        # $t3 -> int result2

        li          $v0, 4          #syscall 4: print_string
        la          $a0, print_msg_1
        syscall                     #ptintf("Enter first number:")

        #read number 1
        li          $v0, 5          #syscall 5: read_int
        syscall
        move        $t0, $v0        #scanf("%d", &number1)

        li          $v0, 4          #syscall 4: print_string
        la          $a0, print_msg_2
        syscall                     #ptintf("Enter second number:")

        #read number 2
        li          $v0, 5
        syscall
        move        $t1, $v0        #scanf("%d", &number2)

        #compute number 2 - number 1 + 1
        sub         $t2, $t1, $t0   #result1 = number 2 - number 1
        addi        $t2, $t2, 1     #resut1 = result1 + 1

        #compute number 1 + number 2
        add         $t3, $t0, $t1    #reuslt2 = number 1 + number 2

        #compute result1 * result2
        mul         $t2, $t2, $t3    #result1 = result1 * result2

        #compute result1 / 2
        srl         $t2, $t2, 1      #result1 = result1 >> 1 (divide by 2)

        #print result
        li          $v0, 4          #syscall 4: print_string
        la          $a0, string1
        syscall                     #ptintf("The sum of all numbers between ")

        #Before passing values of num1, num2, gaussian_sum,
        #we do need to make sure the arguments are correclty place in registers.
        #in this case, $a0 stores signle value/address as argument to system call. 
        
        li          $v0, 1           #syscall 1: print_int
        move        $a0, $t0         #copy number 1 into $a0
        syscall                      #print number 1

        li          $v0, 4          #syscall 4: print_string
        la          $a0, string2
        syscall                     #ptintf(" and ")

        li          $v0, 1           #syscall 1: print_int
        move        $a0, $t1         #copy number 2 into $a0
        syscall                      #print number 2

        li          $v0, 4          #syscall 4: print_string
        la          $a0, string3
        syscall                     #ptintf(" (inclusive) is: ")

        li          $v0, 1           #syscall 1: print_int
        move        $a0, $t2         #copy result1 into $a0
        syscall                      #print result1

        li          $v0, 11          #syscall 11: print_char
        la          $a0, '\n'
        syscall

        li          $v0, 0
        jr          $ra              #return 0;

        .data
print_msg_1:
        .asciiz "Enter first number: "
print_msg_2:
        .asciiz "Enter second number: "
string1:
        .asciiz "The sum of all numbers between "
string2:
        .asciiz " and "
string3:
        .asciiz " (inclusive) is: "

