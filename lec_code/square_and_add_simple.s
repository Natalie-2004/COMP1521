#3.6.23
#int a, b;

#printf("Enter a number:");
#scanf("%d", &a);

#printf("Enter another number:");
#scanf("%d", &b);

#printf("The sum of the square of");
#printf("%d", a);
#printf(" and ");
#printf("%d", b);
#printf(" is ");

#a = a * a;
#b = b * b;
##printf("%d", a+b);
#putchar('\n');

        .text

main:
        #locals:
        #$t0: int a
        #$t1: int b

        li      $v0, 4          #syscall 4: print_string
        la      $a0, prompt1_msg  
        syscall

        #TODO: scan in first number
        li      $v0, 5          #syscall 5: read_int
        syscall
        move    $t0, $v0        #scanf("%d", &a)

        li      $v0, 4          #syscall 4: print_string
        la      $a0, prompt2_msg
        syscall

        #TODO: scan in second number
        li      $v0, 5          #syscall 5: read_int
        syscall
        move    $t1, $v0        #scanf("%d", &a)

        li      $v0, 4          #syscall 4: print_string
        la      $a0, result_msg_1
        syscall

        #TODO: print a
        li      $v0, 1          #syscall 1: print_int
        move    $a0, $t0
        syscall                 #printf("%d", a)

        li      $v0, 4          #syscall 4: print_string
        la      $a0, result_msg_2
        syscall

        #TODO: print b
        li      $v0, 1          #syscall 1: print_int
        move    $a0, $t1
        syscall                 #printf("%d", b)

        li      $v0, 4          #syscall 4: print_string
        la      $a0, result_msg_3
        syscall

        #TODO: compute sum of squares
        mul     $t0, $t0, $t0   # a = a * a;
        mul     $t1, $t1, $t1   # b = b * b;

        li      $v0, 1          #syscall 1: print_int
        add     $a0, $t0, $t1   
        syscall                 #print("%d", a + b)


        li      $v0, 11          #syscall 11: print_char
        la      $a0, '\n'           
        syscall
        
        li      $v0, 0
        jr      $ra             #return 0;

        .data
prompt1_msg:
        .asciiz "Enter a number:"
prompt2_msg:
        .asciiz "Enter another number"
result_msg_1:
        .asciiz "The sume of the squares of"
result_msg_2:
        .asciiz " and "
result_msg_3:
        .asciiz " is "
