# #include <assert.h>
# #include <stdlib.h>
# #include <stdint.h>

# // 255 -> 8 jin zhi
# #define MASK_8_BIT 0xff 

# // given a uint32_t value, return 1 iff the least significant byte is euqla to the 2nd least significant byte
# // and return 0 otherwise

# int q1 (uint32_t value) {

#     // 提取哪部分就把哪部分设为1
#     // mask_size = high - low + 1
#     // mask = mask << mask_size - 1
#     // mask = mask << low
#     uint32_t mask = 1;
#     // mask << 8;
#     // mask -= 1;

#     // i.e 0x4859
#     // now extract '13'
#     uint32_t bottom = value & MASK_8_BIT;
#     int result = 0;

#     // right shift to cancel '13', then use & to extract the '20'
#     uint32_t sec_signal = (value >> 8) & MASK_8_BIT;

#     if (bottom == sec_signal) {
#         result = 1;
#         return result;
#     }

#     return result;
# }
# Rewrite this in MIPS
# Note: 

.text
main:

    	li	$v0, 5   
    	syscall
    	move   	$t0, $v0	# $t0 = value 

    	li 	$t1, 0		# $t1 = equal(result)
    	and 	$t2, $t0, 0xff	# t2 = bottom

	# 只有 srlv 和 sllv是对应 right shift / left shift
    	li	$t3, 8		# t3 = 8
    	srlv	$t4, $t2, $t3	# (value >> 8)
	and 	$t5, $t4, 0xff	# sec_signal = (value >> 8) & MASK_8_BIT

	bne 	$t5, $t2, print	# if (bottom != sec_signal), jump to print

	li	$t1, 1		# equal(result) = 1

print:
	move 	$a0, $t1	# copy $t1 into $a0
	li	$v0, 1		
	syscall 		# syscall 1: print int
				# printf("%d", result)

	li      $v0, 0      	# return 0;
    	jr      $ra


.data