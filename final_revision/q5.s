# int main(void) {
#     int product = 1;
#     while (product < 256) {
#         int x;
#         scanf("%d", &x);
#         product = product * x;
#     }
#     printf("%d\n", product);
#     return 0;
# }

.text
main:
loop_inti:
        li      $t0, 1          # int product = 1;
loop_cond:
        bge     $t0, 256, loop_end      # while (product >= 256) {, jump to end
loop_body:
        li      $v0, 5          # scanf("%d", &x);
        syscall 
        # move    $t1, $v0        # x in $t1

        mul     $t0, $t0, $v0   # product = product * x

        j       loop_cond       # loop back to start, and here's no stepper
loop_end:
        move    $a0, $t0   
        li      $v0, 1       
        syscall                 # printf("%d", product);

        li      $v0, 11
        la      $a0, '\n'
        syscall                 # printf("%d\n", product);

        li      $v0, 0
        jr      $ra             # return 0;

.data
