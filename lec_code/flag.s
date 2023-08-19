N_ROWS = 6
N_COLS = 12
    .text
main:
    #Locals:
    # $t0: int row
    # $t1: int col

row_loop__init:
    li      $t0,0               #int row = 0

col_loop_body:
    li      $v0, 11             #syscall 11: print_char
    mul     $t2, $t0, N_COLS    # (row * N_COLS
    add     $t2, $t2, $t1       # + col)
    mul     $t2, $t2, 1         #sizeof(char)

    lb      $a0, flag($t2
    syscall                     #puchar(flag[row][col])
    
    .data
flag:

    .byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#' 
    .byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#' 
    .byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
    .byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
    .byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#' 
    .byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#' 