########################################################################
# COMP1521 23T2 -- Assignment 1 -- Pacman!
#
#
# !!! IMPORTANT !!!
# Before starting work on the assignment, make sure you set your tab-width to 8!
# It is also suggested to indent with tabs only.
# Instructions to configure your text editor can be found here:
#   https://cgi.cse.unsw.edu.au/~cs1521/23T2/resources/mips-editors.html
# !!! IMPORTANT !!!
#
#
# This program was written by Natalie (z5453932)
# on 27.6.23. Translating pacman.c into pacman.s
#
# Version 1.0 (12-06-2023): Team COMP1521 <cs1521@cse.unsw.edu.au>
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

# Bools
FALSE = 0
TRUE  = 1

# Directions
LEFT  = 0
UP    = 1
RIGHT = 2
DOWN  = 3
TOTAL_DIRECTIONS = 4

# Map
MAP_WIDTH  = 13
MAP_HEIGHT = 10
MAP_DOTS   = 53
NUM_GHOSTS = 3

WALL_CHAR   = '#'
DOT_CHAR    = '.'
PLAYER_CHAR = '@'
GHOST_CHAR  = 'M'
EMPTY_CHAR  = ' '

# Other helpful constants
GHOST_T_X_OFFSET          = 0
GHOST_T_Y_OFFSET          = 4
GHOST_T_DIRECTION_OFFFSET = 8
SIZEOF_GHOST_T            = 12
SIZEOF_INT                = 4

########################################################################
# DATA SEGMENT
# !!! DO NOT ADD, REMOVE, MODIFY OR REORDER ANY OF THESE DEFINITIONS !!!
	.data
map:
	.byte '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'
	.byte '#', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '#', '#', '#', '#', '.', '#'
	.byte '#', '.', '#', ' ', '#', '.', '.', '.', '.', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '.', '#', '#', '#', '.', '#'
	.byte '#', '.', '.', '.', '.', '.', '#', '.', '#', '.', '.', '.', '#'
	.byte '#', '.', '#', '#', '#', '#', '#', '.', '#', '#', '#', '.', '#'
	.byte '#', '.', '#', '.', '#', '.', '.', '.', '#', '.', '.', '.', '#'
	.byte '#', '.', '.', '.', '.', '.', '#', '.', '.', '.', '#', '.', '#'
	.byte '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#', '#'

	.align 2
ghosts:
	.word 3, 3, UP		# ghosts[0]
	.word 4, 5, RIGHT	# ghosts[1]
	.word 9, 7, LEFT	# ghosts[2]

player_x:
	.word 7
player_y:
	.word 5

map_copy:
	.space	MAP_HEIGHT * MAP_WIDTH

	.align 2
valid_directions:
	.space	4 * TOTAL_DIRECTIONS
dots_collected:
	.word	0
x_copy:
	.word	0
y_copy:
	.word	0

lfsr_state:
	.space	4

# print_welcome strings
welcome_msg:
	.asciiz "Welcome to 1521 Pacman!\n"
welcome_msg_wall:
	.asciiz " = wall\n"
welcome_msg_you:
	.asciiz " = you\n"
welcome_msg_dot:
	.asciiz " = dot\n"
welcome_msg_ghost:
	.asciiz " = ghost\n"
welcome_msg_objective:
	.asciiz "\nThe objective is to collect all the dots.\n"
welcome_msg_wasd:
	.asciiz "Use WASD to move.\n"
welcome_msg_ghost_move:
	.asciiz "Ghosts will move every time you move.\nTouching them will end the game.\n"

# get_direction strings
choose_move_msg:
	.asciiz "Choose next move (wasd): "
invalid_input_msg:
	.asciiz "Invalid input! Use the wasd keys to move.\n"

# main strings
dots_collected_msg_1:
	.asciiz "You've collected "
dots_collected_msg_2:
	.asciiz " out of "
dots_collected_msg_3:
	.asciiz " dots.\n"

# check_ghost_collision strings
game_over_msg:
	.asciiz "You ran into a ghost, game over! :(\n"

# collect_dot_and_check_win strings
game_won_msg:
	.asciiz "All dots collected, you won! :D\n"



# ------------------------------------------------------------------------------
#                                 Text Segment
# ------------------------------------------------------------------------------

	.text

############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions,
# and check these boxes as you finish implementing each function.
#
#  SUBSET 0
#  - [ ] print_welcome
#  SUBSET 1
#  - [ ] main
#  - [ ] get_direction
#  - [ ] play_tick
#  SUBSET 2
#  - [ ] copy_map
#  - [ ] get_valid_directions
#  - [ ] print_map
#  - [ ] try_move
#  SUBSET 3
#  - [ ] check_ghost_collision
#  - [ ] collect_dot_and_check_win
#  - [ ] do_ghost_logic
#     (and also the ghosts part of print_map)
#  PROVIDED
#  - [X] get_seed
#  - [X] random_number

################################################################################
# .TEXT <print_welcome>
	.text
print_welcome:
	# Subset:   0
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0]
	# Clobbers: [ ]
	#
	# Locals:
	#   - n/a
	#
	# Structure:
	#   print_welcome
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]
        # Description:  prints the welcome messgae, return nothing

print_welcome__prologue:
	begin 
	push    $ra
	
print_welcome__body:
	
	li      $v0, 4			# syscall 4: prunt string
	la      $a0, welcome_msg	# printf("Welcome to 1521 Pacman!\n");
	syscall 

	li      $v0, 11			# syscall 11: print char
	la      $a0, WALL_CHAR
	syscall				# printf("%c = wall\n", WALL_CHAR)

	li      $v0, 4			# syscall 4: print string
	la      $a0, welcome_msg_wall
	syscall				# printf(" = wall\n")

	li      $v0, 11			# syscall 11: print char
	la      $a0, PLAYER_CHAR
	syscall				# printf("%c = you\n", PLAYER_CHAR)

	li      $v0, 4			# syscall 4: print string
	la      $a0, welcome_msg_you	# printf("= you\n");
	syscall 			

	li      $v0, 11			# syscall 11: print char
	la      $a0, DOT_CHAR
	syscall				# # printf("%c = dot\n")

	li      $v0, 4			# syscall 4: prnt string
	la      $a0, welcome_msg_dot	
	syscall 			# printf(" = dot\n");

	li      $v0, 11			# syscall 11: print char
	la      $a0, GHOST_CHAR
	syscall				# printf("%c = ghost\n")

	li      $v0, 4			# syscall 4: prnt string
	la      $a0, welcome_msg_ghost	# printf(" = ghost\n");
	syscall 

	li      $v0, 4			# syscall 4: prnt string
	la      $a0, welcome_msg_objective	
	syscall                         # printf("\nThe objective is to collect all the dots.\n");

	li      $v0, 4			# syscall 4: prnt string
	la      $a0, welcome_msg_wasd	# printf("Use WASD to move.\n");
	syscall 

	li      $v0, 4			# syscall 4: prnt string
	la      $a0, welcome_msg_ghost_move	
	syscall                         # printf("Ghosts will move every time you move.\nTouching them will end the game.\n");

print_welcome__epilogue:

	push    $ra
	end 

	jr	$ra


################################################################################
# .TEXT <main>
	.text
main:
	# Subset:   1
	#
	# Args:     void
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [$ra]
	# Uses:     [$a0, $v0, $ra]
	# Clobbers: [$a0]
	#
	# Locals:
	#   	- n/a
	# Structure:
	#   main
	#   -> [prologue]     
	#       -> main_body
        #       -> main_init
        #       -> main_cond
	#   -> [epilogue]
        # Description:  call get seed, prints welcome msg, and loop the game until play_tick returns FALSE, return 0

main__prologue:

	begin 
	push    $ra			# save $ra onto stack

body:

	jal     get_seed                # get_seed();
	jal     print_welcome           # print_welcome();

main_body:
	                                # do_main, enter the body first and check cond
	jal     print_map

	li      $v0, 4 			# syscall 4: print string
	la      $a0, dots_collected_msg_1
	syscall				# printf("You've collected ")

	li      $v0, 1			# syscall 1: print int
	lw      $a0, dots_collected
	syscall				# printf("%d", dots_collected)
	
	li      $v0, 4 			# syscall 4: print string
	la      $a0, dots_collected_msg_2
	syscall				# printf(" out of ")

	li      $v0, 1			# syscall 1: print int
	la      $a0, MAP_DOTS 
	syscall				# printf ("%d", MAP_DOT)

	li      $v0, 4 			# syscall 4: print string
	la      $a0, dots_collected_msg_3
	syscall				# printf("dots.\n")

main_inti:
	                                # use a for argument when calling the functions 
	la      $a0, dots_collected	# $a0 = &dots_collected

	jal     play_tick               # while (play_tick(&dots_collected))

main_cond:
	
	beqz 	$v0, main__epilogue	# if (play_tic($a0) == 0) go to main_epilogue

	j 	main_body		# at the end, loop back to the body

main__epilogue:

	pop 	$ra
	end 

	li 	$v0, 0			# return 0
	jr	$ra



################################################################################
# .TEXT <get_direction>
	.text
get_direction:
	# Subset:   1
	#
	# Args:     void
	#
	# Returns:
	#    - $v0: int
	# 
	# Frame:    [$ra]
	# Uses:     [$v0, $a0, $t0, $t1]
	# Clobbers: [$v0]
	#
	# Locals:
	#   	- $t0 - int temp storage for boolean 
	#   	- $t1 - char input 
	# Structure:
	#   get_direction
	#   -> [prologue]
        #       -> get_direction__body
	#       -> get__init
	#	-> get__cond
	#	-> get__body 
	#	-> get__end
	#   -> [epilogue]
        # Description:  let user input the direction(wasd), looping while the boolean is TRUE, return nothing
get_direction__prologue:
	begin
	push 	$ra

get_direction__body:

	li 	$v0, 4 			# syscall 4: print string
	la 	$a0, choose_move_msg
	syscall 			# printf("Choose next move (wasd): ")

get__init:
	li 	$t0, TRUE		# assign $t0 = 1

get__cond:
	bne 	$t0, TRUE, get__end	# while (!TRUE) -> while (!1), go to end

get__body:
	                                # calls the getchar first
	                                # and then store the input character inside $t1
	li 	$v0, 12			# syscall 12: read_char
	syscall                         # int input = getchar()
	move 	$t1, $v0		# store the input character in $t1

	beq 	$t1, 'a', go_to_left	# if (input == 'a')

	beq 	$t1, 'w', go_to_up	# if (input == 'w')

	beq 	$t1, 'd', go_to_right	# if (input == 'd')

	beq 	$t1, 's', go_to_down	# if (input == 's')
	
	beq 	$t1, '\n', go_to_continue	# if (input == '\n'), go to go_to_continue

	li 	$v0, 4			# syscall 4: print string
	la 	$a0, invalid_input_msg
	syscall				# printf("Invalid input! Use the wasd keys to move.\n")

	j 	get__body	        # Jump back to the body until valid input is recognised. 

go_to_left:
	                                # input == 'a'
	li 	$v0, LEFT		# return LEFT;
	j 	get_direction__epilogue
	
go_to_up:
	                                # input == 'w'
	li 	$v0, UP			# return UP;
	j 	get_direction__epilogue

go_to_right:
	                                # input == 'd'
	li 	$v0, RIGHT		# return RIGHT;
	j 	get_direction__epilogue

go_to_down:
	                                # input == 'w'
	li 	$v0, DOWN		# return DOWN;
	j 	get_direction__epilogue

go_to_continue:
	#continue

get__end:
	j 	get__cond	        # loop back to check condition 
get_direction__epilogue:

	pop 	$ra
	end

	jr	$ra


################################################################################
# .TEXT <play_tick>
	.text
play_tick:
	# Subset:   1
	#
	# Args:
	#    - $a0: int *dots_collected
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [$s0, $ra]
	# Uses:     [$s0, $a0, $a1, $a2, $v0]
	# Clobbers: [$a0, $a1, $a2]
	#
	# Locals:
        #       - $s0 - copy of *dots
	# Structure:
	#   play_tick
	#   -> [prologue]
	#       -> play_tick_body
        #               -> if_check_ghost_1
        #       -> call_ghost_logic
        #               -> if_check_ghost_2
        #       -> return_collect_dot_check_win
        #               -> collect_dot_check_win_false
        #               -> collect_dot_check_win_true
	#   -> [epilogue]
        # Description:  call try_move function, check if the ghost catch the player, then return FALSE; 
        #               if not, update the ghost location and check again. Return boolean -> checks dots collected

play_tick__prologue:
	begin
	push 	$ra
	push 	$s0

play_tick__body:
	
	move 	$s0, $a0		# preserved int *dots at $s0 register
	
	jal 	get_direction		# call get_direction()

	move 	$a2, $v0		# pass the value from $v0 to $a2

	                                # load address after the functions are being call
	la 	$a0, player_x		# $a1 = &player_x
	la 	$a1, player_y		# $a2 = &plater_y

	jal	try_move		# try_move(&player_x, &player_y, get_direction());

if_check_ghost_1:
	jal 	check_ghost_collision
	beqz 	$v0, 	call_ghost_logic	# if (check_ghost_collision() == 0), exit go next
	li 	$v0, 	FALSE		# return FALSE -> go to epilogue directly

	j 	play_tick__epilogue		

call_ghost_logic:
	jal 	do_ghost_logic		# do_ghost_logic();

if_check_ghost_2:
	jal	check_ghost_collision
	beqz	$v0, 	return_collect_dot_check_win	# if (check_ghost_collision() == 0), exit next loop
	li 	$v0, 	FALSE		# return FALSE -> go to epilogue directly

	j 	play_tick__epilogue		

return_collect_dot_check_win:
	move 	$a0, $s0		# call back the prevsered value
	jal 	collect_dot_and_check_win
                                        #return !collect_dot_and_check_win(dots);
                                        #if (collect_dot_and_check_win(dots) == 0(FALSE)) {
                                        #	return 1; -> TRUE
                                        #} else {
                                        #	return 0; -> FALSE
                                        #}
return_collect_dot_check_win_false:
	beqz	$v0, return_collect_dot_check_win_true	# if (collect_dot_and_check_win(dots) == 0), go to else
	li	$v0, 0		        # return FALSE -> go to epilogue directly
	j 	play_tick__epilogue	

return_collect_dot_check_win_true:
                                        # otherwise, 
	li	$v0, 1		        # return TRUE
	

play_tick__epilogue:
	pop $s0
	pop $ra	
	end	
	
	jr	$ra			# exit


################################################################################
# .TEXT <copy_map>
	.text
copy_map:
	# Subset:   2
	#
	# Args:
	#    - $a0: char dst[MAP_HEIGHT][MAP_WIDTH]
	#    - $a1: char src[MAP_HEIGHT][MAP_WIDTH]
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$a0, $a1, $t0, $t1, $t2, $t3]
	# Clobbers: []
	#
	# Locals:
        #        - $t0 -> int i
	#        - $t1 -> int j
        #        - $t2 -> temp storage for calculate &source
	#        - $t3 -> temp storage for source[i][j]
	# Structure:
	#   copy_map
	#   -> [prologue]
	#       -> body
        #       -> c_height_init
        #       -> c_height_body
        #               -> c_width_init
        #               -> c_width_body
        #               -> c_width_step
        #               -> c_width_end
        #       -> c_height_step
        #       -> c_height_end
	#   -> [epilogue]
        # Description:  copies the game map from source to destination, return nothing 

copy_map__prologue:
	begin
	push    $ra

copy_map__body:

c_height_init:
	li	$t0, 0                  # int i = 0

c_height_body:		
	bge	$t0, MAP_HEIGHT, c_height_end	# while (i >= MAP_HEIGHT), break outer loop

c_width_init:
	li 	$t1, 0			# int j = 0
	
c_width_body:
	bge	$t1, MAP_WIDTH, c_width_end	# while (i >= MAP_WIDTH), break inner loop

	# get source[i][j]
    	mul 	$t2, $t0, MAP_WIDTH     # i offset = i * MAP_WIDTH
    	add 	$t2, $t2, $t1           # i * MAP_WIDTH + j
    	#mul 	$t0, $t0, 1             # offset in bytes = (i * MAP_WIDTH + j) * 1 skip
	lb	$t3, ($a1)		# get byte from sorce[i][j] and storex in $t3
	sb	$t3, ($a0)		# put thie byte into destination[i][j]
					# dest[i][j] = source[i][j];

c_width_step:
	addi	$t1, $t1, 1		# j++

	addi 	$a0, $a0, 1		# update both pointers to point of next element
	addi	$a1, $a1, 1

	j       c_width_body

c_width_end:
c_height_step:

	addi    $t0, $t0, 1	        # i++

	j       c_height_body

c_height_end:
copy_map__epilogue:

	pop     $ra
	end

	jr	$ra			# return 


################################################################################
# .TEXT <get_valid_directions>
	.text
get_valid_directions:
	# Subset:   2
	#
	# Args:
	#    - $a0: int x
	#    - $a1: int y
	#    - $a2: int dir_array[TOTAL_DIRECTIONS]
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5]
	# Uses:     [$ra, $s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1, $t2, $t3, $t4]
	# Clobbers: [$t0, $t1, $t3, $t4, $a0, $a1, $a2]
	#
	# Locals:
	#       - $s0: presversed the value of valid_dirs
        #       - $s1: presversed the value of dirs
        #       - $s2: presversed the &dir_array[TOTAL_DIRECTION]
        #       - $s4: x_copy
	#       - $s5: y_copy
        #       - $t0: int valid_dirs = 0
        #       - $t1: int dirs = 0
        #       - $t2: temp storage for offset -> &dir_array
        #       - $t3: &x_copy
        #       - $t4: &y_copy
	# Structure:
	#   get_valid_directions
	#   -> [prologue]
	#       -> body
        #       -> get_valid_inti
        #       -> get_val_cond
        #       -> get_val_body
        #               -> get_val_try_move
        #       -> get_val_skip
        #       -> get_valid_step
        #       -> get_val_end
	#   -> [epilogue]
        # Description:  check if there's a path to allow character move within a given coordinate, 
        #               returns the number of moveable spots

get_valid_directions__prologue:

	begin
	push 	$ra
	push 	$s0
	push 	$s1
	push 	$s2
	push 	$s3
	push	$s4
	push 	$s5

get_val_directions__body:
	li  	$t0, 0		        # int valid_dirs = 0
	move 	$s0, $t0	        # store valid_dirs into $s0

get_val_inti:
	li  	$t1, 0		        # int dir = 0
	move 	$s1, $t1	        # store dir into $s1
	move 	$s3, $a2	        # save the address of dir_array[TOTAL_DIRECTION]

	                                # save before to avoid clobber
	move 	$s4, $a0                # x_copy = x
        move	$s5, $a1                # y_copy = y

get_val_cond:
	bge 	$s1, TOTAL_DIRECTIONS, get_val_end	#  if dir >= TOTAL_DIRECTION, go to end

get_val_body:

	la 	$t3, x_copy             # load x_copy into $s4
        la 	$t4, y_copy             # load y_copy into $s5

	sw	$s4, ($t3)	        # store the value of x_copy
	sw	$s5, ($t4)              # store the value of y_copy

        move 	$a0, $t3                # store &x_copy in $a0
        move 	$a1, $t4                # store &y_copy in $a1
        move 	$a2, $s1      	        # store dir in $a2

	jal 	try_move	        # try_move($a0, $a1, $a2)

get_val_try_move:
	beqz 	$v0, get_val_skip	# if try_move(&x_copy, &y_copy, dir) != 0, skip dir_array

	mul 	$t2, $s0, 4	        # offset = valid_dir * 4
	add	$t2, $t2, $s3	        # add valid_dir offset to &dir_array
	sw 	$s1, ($t2)              # store $s1 back into dir_array[valid_dirs] -> dir_array[valid_dirs] = dir;

	addi 	$s0, $s0, 1    	        # valid_dirs++

get_val_skip:
get_val_step:
	addi 	$s1, $s1, 1	        # dir++

	j 	get_val_cond

get_val_end:
	move 	$v0, $s0		# return valid_dirs

get_valid_directions__epilogue:

	pop	$s5
	pop 	$s4
	pop 	$s3
	pop 	$s2
	pop 	$s1
	pop 	$s0
	pop 	$ra
	end

	jr	$ra                     # exit


################################################################################
# .TEXT <print_map>
	.text
print_map:
	# Subset:   2
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$ra, $s0, $s1, $a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $v0]
	# Clobbers: [$a0, $a1]
	#
	# Locals:
        #       - $t0 -> player_y
        #       - $t1 -> player_x
	#       - $t2 -> store the value of PLAYER_CHAR
	#       - $t3 -> temp memory calcuate the offset of map_copy[player_y][player_x]
        #       - $t4 -> int i = 0
        #       - $t5 -> int j = 0
        #       - $t6 -> temp memory calcuate the offset of map_copy[i][j]
        #       - $t7 -> temp storage for laoding the element at map_copy[i][j]
        #       - $s0 -> map_copy
        #       - $s1 -> map
	# Structure:
	#   print_map
	#   -> [prologue]
	#       -> body
        #       -> print_outer_inti
        #       -> print_outer_cod
        #       -> print_outer_body
        #               -> print_inner_inti
        #               -> print_inner_cod
        #               -> print_inner_body
        #               -> print_inner_step
        #               -> print_inner_end
        #               -> print_putchar
        #       -> print_outer_step
        #       -> print_outer_end
	#   -> [epilogue]
        # Description:  print the game map, calls copy_map function and locate PLAYER_CHAR
        #               update the ghost and player's location every loop, return nothing

print_map__prologue:
	begin
	push	$ra
	push	$s0
	push	$s1
 
print_map__body:

 	la	$a0, map_copy	        # laod value for map_copy in $a0
	la	$a1, map                # load value fro map in $a1

	move	$s0, $a0	        #store the value of $a0 into $s0
	move	$s1, $a1                #store the value of $a1 into $s1

 	jal  	copy_map   	        # copy_map(map_copy, map);

 	lw   	$t0, player_y     	# load int of player_y on $t0
 	lw   	$t1, player_x       	# load int of player_x on $t1

        li  	$t2, PLAYER_CHAR   	# $t2 = PLAYER_CHAR

 	mul  	$t3, $t0, MAP_WIDTH 	# offset = plyer_y * MAP_WIDTH
 	add 	$t3, $t3, $t1		# plyer_y * MAP_WIDTH + player_x
 	#mul 	$t3, $t3, 1             # skip because of char size
 	add 	$t3, $s0, $t3  		# base address of dir_array + (plyer_y * MAP_WIDTH + player_x)
 	sb 	$t2, ($t3)  		# map_copy[player_y][player_x] = PLAYER_CHAR;

 	                                #skip put ghost on map

print_outer_inti:
	li 	$t4, 0			# int i = 0
print_outer_cod:
	bge 	$t4, MAP_HEIGHT, print_outer_end # if (i >= MAP_HEIGHT), break
print_outer_body:
print_inner_inti:
	li 	$t5, 0   		# int j = 0
print_inner_cod:
	bge  	$t5, MAP_WIDTH, print_inner_end  # if (i >= MAP_WIDTh), break
print_inner_body:
	mul  	$t6, $t4, MAP_WIDTH 	# i * MAP_WIDTH
	add 	$t6, $t5, $t6  		# i * MAP_WIDTH + j
	add	$t6, $t6, $s0		# array address + (i * MAP_WIDTH + j)
	lb 	$t7, ($t6)  		# load byte from copy_map stores at $t6
	
	move	$a0, $t7                # pass map_copy[i][j] into $a0
	li 	$v0, 11   		# syscall 11: print char
	syscall 			# putchar('\n');

print_inner_step:
	addi 	$t5, $t5, 1  		# j++
	j  	print_inner_cod

print_inner_end:
print_putchar:
	li 	$v0, 11   	        # syscall 11: print char
	li 	$a0, '\n'
	syscall    		        # putchar('\n');

print_outer_step:
	addi  	$t4, $t4, 1  	# i++
	j  	print_outer_cod

print_outer_end:
print_map__epilogue:

	pop 	$s1
	pop	$s0
	pop	$ra
	end

	jr 	$ra



################################################################################
# .TEXT <try_move>
	.text
try_move:
	# Subset:   2
	#
	# Args:
	#    - $a0: int *x
	#    - $a1: int *y
	#    - $a2: int directions
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [$ra, $s0, $s1]
	# Uses:     [$ra, $s0, $s1, $a0, $a1, $a2, $v0, $t0, $t1, $t2, $t3, $v0]
	# Clobbers: [$t0, $t1]
	#
	# Locals:
	#       - $s0 - copy of int *x
	#       - $s1 - copy of int *y
        #       - $t0 - int new_x
        #             - new value of new_X
        #       - $t1 - int new_y
        #             - new value of new_y
        #       - $t2 - temp storage for &map
        #       - $t3 - temp storage the value of map[new_y][new_x]
	# Structure:
	#   try_move
	#   -> [prologue]
	#       -> body
        #       -> try_left
        #       -> try_up
        #       -> try_right
        #       -> try_down
        #       -> try_wall_char
        #       -> try_return_false
        #       -> try_return_true
	#   -> [epilogue]
        # Description:  update the coordinates (x,y) based on a specified direction
        #               return TRUE if the move is valid and FALSE if it encounters a wall.

try_move__prologue:
        begin
        push    $ra
	push	$s0
	push	$s1

try_move__body:

	move 	$s0, $a0	        # pass *x into $s0
	move	$s1, $a1	        # pass *y into $s1

	lw	$t0, ($a0)	        # int new_x = *x
	lw	$t1, ($a1)	        # int new_y = *y

try_left:
        bne     $a2, LEFT, try_up       # try_move(direction ！= LEFT), go to try_up
        sub     $t0, $t0, 1             # new_x--
        j       try_wall_char
try_up:
        bne     $a2, UP, try_right      # try_move(direction ！= UP), go to try_right
        sub     $t1, $t1, 1             # new_y--;
        j       try_wall_char
try_right:
        bne     $a2, RIGHT, try_down     # try_move(direction ！= right), go to try_down
        addi    $t0, $t0, 1             # new_x++
        j       try_wall_char
try_down:
        bne     $a2, DOWN, try_wall_char	# try_move(direction ！= down), go to try_wall_char
        addi    $t1, $t1, 1             # new_y++

try_wall_char:
        mul     $t2, $t1, MAP_WIDTH     # offset = new_y * MAP_WIDTH
        add     $t2, $t0, $t2           # new_y * MAP_WIDTH + new_x
        #mul    $t2, $t2, 1             # (new_y * MAP_WIDTH + new_x) * sizeof(char), skip
        lb      $t3, map($t2)           # &map[new_y][new_x] stores in $t3

try_return_false:
        bne     $t3, WALL_CHAR, try_return_true     #if (map[new_y][new_x] != WALL_CHAR), go to true

        li      $v0, FALSE              # return FALSE
        j     	try_move__epilogue

try_return_true:
        sw      $t0, ($a0)              # *x = new_x;
        sw      $t1, ($a1)              # *y = new_y;

        li      $v0, TRUE               # return TRUE
        j     	try_move__epilogue
        
try_move__epilogue:

	pop	$s1
	pop	$s0
        pop     $ra
        end
        jr      $ra


################################################################################
# .TEXT <check_ghost_collision>
	.text
check_ghost_collision:
	# Subset:   3
	#
	# Args:     void
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   check_ghost_collision
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

check_ghost_collision__prologue:

check_ghost_collision__body:

check_ghost_collision__epilogue:
	jr	$ra


################################################################################
# .TEXT <collect_dot_and_check_win>
	.text
collect_dot_and_check_win:
	# Subset:   3
	#
	# Args:
	#    - $a0: int *dots_collected
	#
	# Returns:
	#    - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   collect_dot_and_check_win
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

collect_dot_and_check_win__prologue:

collect_dot_and_check_win__body:

collect_dot_and_check_win__epilogue:
	jr	$ra


################################################################################
# .TEXT <do_ghost_logic>
	.text
do_ghost_logic:
	# Subset:   3
	#
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - ...
	#
	# Structure:
	#   do_ghost_logic
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]

do_ghost_logic__prologue:

do_ghost_logic__body:

do_ghost_logic__epilogue:
	jr	$ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

	.data
get_seed_prompt_msg:
	.asciiz "Enter a non-zero number for the seed: "
invalid_seed_msg:
	.asciiz "Seed can't be zero.\n"

################################################################################
# .TEXT <get_seed>
	.text
get_seed:
	# Args:     void
	#
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0, $a0]
	# Clobbers: [$v0, $a0]
	#
	# Locals:
	#   - $v0: copy of lfsr_state
	#
	# Structure:
	#   get_seed
	#   -> [prologue]
	#       -> body
	#       -> loop_start
	#       -> loop_end
	#   -> [epilogue]
	#
	# PROVIDED FUNCTION — DO NOT CHANGE

get_seed__prologue:
	begin
	push	$ra

get_seed__body:
get_seed__loop:					# while (TRUE) {
	li	$v0, 4				#   syscall 4: print_string
	la	$a0, get_seed_prompt_msg
	syscall					#   printf("Enter a non-zero number for the seed: ");

	li	$v0, 5				#   syscall 5: read_int
	syscall
	sw	$v0, lfsr_state			#   scanf("%u", &lfsr_state);

	bnez	$v0, get_seed__loop_end		#   if (lfsr_state != 0) break;

	li	$v0, 4				#   syscall 4: print_string
	la	$a0, invalid_seed_msg
	syscall					#   printf("Seed can't be zero.\n");

	b	get_seed__loop			# }

get_seed__loop_end:
get_seed__epilogue:
	pop	$ra
	end

	jr	$ra


################################################################################
# .TEXT <random_number>
	.text
random_number:
	# Args:     void
	#
	# Returns:
	#    - $v0: uint32_t
	#
	# Frame:    [$ra]
	# Uses:     [$t0, $t1, $t2, $v0]
	# Clobbers: [$t0, $t1, $t2, $v0]
	#
	# Locals:
	#   - $t0: uint32_t bit
	#   - $t1: copy of lfsr_state
	#   - $t2: temporary shift result
	#
	# Structure:
	#   random_number
	#   -> [prologue]
	#       -> body
	#   -> [epilogue]
	#
	# PROVIDED FUNCTION — DO NOT CHANGE

random_number__prologue:
	begin
	push	$ra

random_number__body:
	lw	$t1, lfsr_state		# load lfsr_state
	move	$t0, $t1		# uint32_t bit = lfsr_state;

	srl	$t2, $t1, 10		# lfsr_state >> 10
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 10;

	srl	$t2, $t1, 30		# lfsr_state >> 30
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 30;

	srl	$t2, $t1, 31		# lfsr_state >> 31
	xor	$t0, $t0, $t2		# bit ^= lfsr_state >> 31;

	andi	$t0, $t0, 1		# bit &= 0x1u;

	sll	$t1, $t1, 1		# lfsr_state <<= 1;
	or	$t1, $t1, $t0		# lfsr_state |= bit;

	sw	$t1, lfsr_state		# store lfsr_state
	move	$v0, $t1		# return lfsr_state;

random_number__epilogue:
	pop	$ra
	end

	jr	$ra