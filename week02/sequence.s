	.text
main:
	#Labels:
	# $t0 - start
	# $t1 - stop
	# $t2 - step
	# $t3 - i

assigning:
        li              $t3, 0                          #assign i = 0.

print_scan:
 	li          	$v0, 4          	        #syscall 4: print_string
        la          	$a0, print_msg_1
        syscall                    		        #ptintf("Enter atarting number:")

        #read starting number
        li          	$v0, 5          	        #syscall 5: read_int
        syscall
        move        	$t0, $v0        	        #scanf("%d", &start)

        li          	$v0, 4          	        #syscall 4: print_string
        la          	$a0, print_msg_2
        syscall                    		        #ptintf("Enter stopping number:")

        #read stopping number
        li          	$v0, 5			        #syscall 5: read_int
        syscall
        move        	$t1, $v0        	        #scanf("%d", &stopping)

	li          	$v0, 4          	        #syscall 4: print_string
        la          	$a0, print_msg_3
        syscall                    		        #ptintf("Enter step size: ")

	#read step number
        li          	$v0, 5			        #syscall 5: read_int
        syscall
        move        	$t2, $v0        	        #scanf("%d", &step)

stop_bge_start:
	bge		$t1, $t0, stop_smq_start     # if (stop >= start), break, goto, stop_smq_start

step_bg_zero:
	bgez		$t2, stop_smq_start             #if (step >= 0), break, goto stop_smq_start

first_loop_int:
	move            $t3, $t0		        #initialise i = start;

first_loop_con:
        blt            $t3, $t1, stop_smq_start         #when i < stopping number, break, goto    

first_loop_body:
        li              $v0, 1                          # system 1: print_int
        move            $a0, $t3
        syscall                                         # printf("%d", i)

        li              $v0, 11                         # system 11: print_char
        la              $a0, '\n'
        syscall                                         #putchar("\n")

first_loop_stepper:
        add             $t3, $t3, $t2                   #i += step
        b               first_loop_con

stop_smq_start:                                         # if stop <= start, break, goto loop_end                         
        ble             $t1, $t0, loop_end

stop_bigger_zero:
        blez            $t2, loop_end                   # if step <= 0, break, goto loop_end

sec_loop_int:
	move            $t3, $t0		        #initialise i = start;

sec_loop_con:                                           #when i > stop number,  break, goto
        bgt             $t3, $t1, loop_end

sec_loop_body:
        li              $v0, 1                          # system 1: print_int
        move            $a0, $t3
        syscall                                         # printf("%d", i)

        li              $v0, 11                         # system 11: print_char
        la              $a0, '\n'
        syscall                                         #putchar("\n")

sec_loop_stepper:
        add             $t3, $t3, $t2                   #i += step
        b               sec_loop_con

loop_end:
        li	        $v0, 0
	jr	        $ra	                        #return 0;

	.data
print_msg_1:
	.asciiz "Enter the starting number: "
print_msg_2:
	.asciiz "Enter the stopping number: "
print_msg_3:
	.asciiz "Enter the step size: "

