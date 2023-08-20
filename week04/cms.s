# A simple program to manage student marks.
# YOUR-NAME-HERE, INSERT-DATE-HERE

#![tabsize(8)]

# Constant definitions.
# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE DEFINITIONS !!!

# NULL pointer
NULL = 0x0

# Constants for accessing `struct student`
STRUCT_STUDENT_ID_OFFSET = 0
STRUCT_STUDENT_MARK_OFFSET = STRUCT_STUDENT_ID_OFFSET + 4
SIZEOF_STRUCT_STUDENT = STRUCT_STUDENT_MARK_OFFSET + 4

# Other constants
CLASS_SIZE = 6
UNKNOWN_MARK = -1

################################################################################
# DATA SEGMENT
# !!! DO NOT ADD, REMOVE, MODIFY OR REORDER ANY OF THESE DEFINITIONS !!!
	.data
# Global variables	
students:			# struct student students[CLASS_SIZE] = {
	.word	5123456		#   { int id,
	.word	UNKNOWN_MARK	#    int mark },
	.word	5308310		#   { int id,
	.word	UNKNOWN_MARK	#     int mark },
	.word	5417087		#   { int id,
	.word	UNKNOWN_MARK	#     int mark },
	.word	3456789		#   { int id,
	.word	UNKNOWN_MARK	#     int mark },
	.word	5345678		#   { int id,
	.word	UNKNOWN_MARK	#     int mark },
	.word	5234567		#   { int id,
	.word	UNKNOWN_MARK	#     int mark }
				# };

# String literals
update_student_mark__id_prompt:
	.asciiz	"Please enter the student ID: "
update_student_mark__mark_prompt:
	.asciiz	"Please enter the student mark: "
update_student_mark__invalid_id:
	.asciiz	"Student not found in class!\n"
print_report__header:
	.asciiz	"ID\tMark\n"
print_report__unknown_mark:
	.asciiz	"?\n"

################################################################################
# You will need to complete the following functions below this line:
# - [ ] find_student_by_id
# - [ ] update_student_mark
# - [ ] print_report
# The following function is provided for you:
# - [X] main
################################################################################

################################################################################
# .TEXT find_student_by_id
	.text
find_student_by_id:
	# Args:
	#	- $a0: int id
	# Returns:
	#	- $v0: struct student *
	#
	# Stack:	[]
	# Uses:		[]
	# Clobbers:	[]
	#
	# Locals:
	#
	# Structure:
	#	-> [prologue]
	#	-> [body]
	#	-> [epilogue]
find_student_by_id__prologue:
	begin
find_student_by_id__body:
find_student_by_id__loop__init:
	li	$t0, 0
find_student_by_id__loop__cond:
	bge	$t0, CLASS_SIZE, find_student_by_id__loop__end
find_student_by_id__loop__body:
	mul	$t1, $t0, SIZEOF_STRUCT_STUDENT
	addi	$t1, students
	lw	$t2, STRUCT_STUDENT_ID_OFFSET($t1)

	bne	$t2, $a0, find_student_by_id__loop__step
	move	$v0, $t1
	j	find_student_by_id__epilogue

find_student_by_id__loop__step:
	addi	$t0, 1
	j	find_student_by_id__loop__cond

find_student_by_id__loop__end:
	li	$v0, NULL
find_student_by_id__epilogue:
	end
	jr	$ra

################################################################################
# .TEXT update_student_mark
	.text
update_student_mark:
	# Args:		void
	# Returns:	void
	#
	# Stack:	[]
	# Uses:		[]
	# Clobbers:	[]
	#
	# Locals:
	#
	# Structure:
	#	-> [prologue]
	#	-> [body]
	#	-> [epilogue]
update_student_mark__prologue:
	begin
	push	$ra
update_student_mark__body:
	li	$v0, 4
	la	$a0, update_student_mark__id_prompt
	syscall

	li	$v0, 5
	syscall
	move	$a0, $v0
	jal	find_student_by_id

	bne	$v0, NULL, update_student_mark__found_student
	
	li	$v0, 4
	la	$a0, update_student_mark__invalid_id
	syscall
	j	update_student_mark__epilogue

update_student_mark__found_student:
	move	$t0, $v0

	li	$v0, 4
	la	$a0, update_student_mark__mark_prompt
	syscall

	li	$v0, 5
	syscall
	sw	$v0, STRUCT_STUDENT_MARK_OFFSET($t0)

update_student_mark__epilogue:
	pop	$ra
	end
	jr	$ra

################################################################################
# .TEXT print_report
	.text
print_report:
	# Args:		void
	# Returns:	void
	#
	# Stack:	[]
	# Uses:		[]
	# Clobbers:	[]
	#
	# Locals:
	#
	# Structure:
	#	-> [prologue]
	#	-> [body]
	#	-> [epilogue]
print_report__prologue:
	begin
print_report__body:
	li	$v0, 4
	la	$a0, print_report__header
	syscall

print_report__loop__init:
	li	$t0, 0
print_report__loop__cond:
	bge	$t0, CLASS_SIZE, print_report__loop__end
print_report__loop__body:
	mul	$t1, $t0, SIZEOF_STRUCT_STUDENT
	addi	$t1, students
	lw	$a0, STRUCT_STUDENT_ID_OFFSET($t1)
	li	$v0, 1
	syscall

	li	$v0, 11
	li	$a0, '\t'
	syscall

	lw	$t2, STRUCT_STUDENT_MARK_OFFSET($t1)
	bne	$t2, UNKNOWN_MARK, print_report__loop__mark_known

	li	$v0, 4
	la	$a0, print_report__unknown_mark
	syscall
	j	print_report__loop__step

print_report__loop__mark_known:
	li	$v0, 1
	move	$a0, $t2
	syscall

	li	$v0, 11
	li	$a0, '\n'
	syscall

print_report__loop__step:
	addi	$t0, 1
	j	print_report__loop__cond

print_report__loop__end:
print_report__epilogue:
	end
	jr	$ra

################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
# You should NOT edit any code below this line.
# Options for selection
OPTION_UPDATE_MARK = 1
OPTION_PRINT_REPORT = 2
OPTION_EXIT = 3

	.data
main__welcome_message:
	.asciiz	"=== Welcome to the Class Management System ===\n"
main__menu:
	.ascii	"Options:\n"
	.ascii	"1. Update student mark\n"
	.ascii	"2. Print class report\n"
	.ascii	"3. Exit\n"
	.asciiz	"Please select an option [1-3]: "
main__invalid_option:
	.asciiz	"Invalid option!\n"
main__exit_message:
	.asciiz	"=== Exiting cms. Goodbye! ===\n"
################################################################################
# .TEXT main
	.text
main:
	# Args:		void
	# Returns:	int
	#
	# Stack:	[$ra]
	# Uses:		[]
	# Clobbers:	[]
	#
	# Locals:
	#	- $t0: int option
	#
	# Structure:
	#	-> [prologue]
	#	-> [body]
	#	  -> option_loop
	#	    -> [body]
	#	      -> update_mark
	#	      -> print_report
	#	      -> exit
	#	    -> [end]
	#	-> [epilogue]

main__prologue:
	begin
	push	$ra

main__body:
	li	$v0, 4						# syscall 4: print_string
	la	$a0, main__welcome_message			#
	syscall							# printf("=== Welcome to the Class Management System ===\n");

main__option_loop__body:
	li	$v0, 4						# syscall 4: print_string
	la	$a0, main__menu					#
	syscall							# printf("Options:\n...");

	li	$v0, 5						# syscall 5: read_int
	syscall							# 
	move	$t0, $v0					# scanf("%d", &option);

	beq	$t0, OPTION_UPDATE_MARK , main__update_mark	# if (option == OPTION_UPDATE_MARK) goto main__update_mark;
	beq	$t0, OPTION_PRINT_REPORT, main__print_report	# if (option == OPTION_PRINT_REPORT) goto main__print_report;
	beq	$t0, OPTION_EXIT	, main__exit		# if (option == OPTION_EXIT) goto main__exit;

	li	$v0, 4						# syscall 4: print_string
	la	$a0, main__invalid_option			#
	syscall							# printf("Invalid option!\n");

	j	main__option_loop__body				# goto main__option_loop__body;

main__update_mark:
	jal	update_student_mark				# update_student_mark();
	j	main__option_loop__body				# goto main__option_loop__body;

main__print_report:
	jal	print_report					# print_report();
	j	main__option_loop__body				# goto main__option_loop__body;

main__exit:
	j	main__option_loop__end				# goto main__option_loop__end;

main__option_loop__end:
	li	$v0, 4						# syscall 4: print_string
	la	$a0, main__exit_message				#
	syscall							# printf("=== Exiting cms. Goodbye! ===\n");

main__epilogue:
	pop	$ra
	end

	li	$v0, 0
	jr	$ra						# return 0;
