#include <stdio.h>

# int main (void) {
#     int x, y;

#     scanf("%d", &x);
#     scanf("%d", &y);
#     printf("%d\n", x*x - y*y);

#     return 0;

# }

.text
main:

    li      $v0, 5      # syscall 5: scan x
    syscall 
    move    $t0, $v0    # x in $t0
    
    li      $v0, 5      # sycall 5: scan y
    syscall 
    move    $t1, $v0    # y in $t1

    mul     $t0, $t0, $t0   # t0 = x^2
    mul     $t1, $t1, $t1   # t1 = y^2
    sub     $t2, $t0, $t1   # t2 = x^2 - y^2

    li      $v0, 1      # print t2
    move    $a0, $t2
    syscall 

    li      $v0, 11     # printf("%d\n", x*x - y*y);
    la      $a0, '\n' 
    syscall 

    li      $v0, 0      # return 0;
    jr      $ra


.data
