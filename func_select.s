#   322807629   Hadas Babayov

.section .rodata
scanf_char:
    .string " %c"
scanf_int:
    .string "%hhu"
print1:
    .string "first pstring length: %d, second pstring length: %d\n"
print2:
    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
print3:
    .string "length: %d, string: %s\n"
print4:
    .string "compare result: %d\n"
print_invalid:
    .string "invalid option!\n"

.align 8

.L1:
    .quad .L50 # case 50 / 60
    .quad .L2  # default case
    .quad .L52 # case 52
    .quad .L53 # case 53
    .quad .L54 # case 54
    .quad .L55 # case 55
    .quad .L2  # default case
    .quad .L2  # default case
    .quad .L2  # default case
    .quad .L2  # default case
    .quad .L50 # case 50 / 60
.text
.global run_func


run_func:

    leaq    -50(%rdi), %rdi        # substract 50 from the number of the switch case
    cmpq    $10, %rdi              # check if it the default case
    ja      .L2                    # jump to this case
    jmp     *.L1(,%rdi,8)          # if not, jump to the appropriate case

.L2:                               # default case
    xor     %rax, %rax
    movq    $print_invalid, %rdi
    call     printf                # print "invalid option!"
    ret                            # return to caller function

.L50:
    pushq   %r12                   # push callee registers
    pushq   %r13

    movq    %rsi, %rdi             # %rdi pointer to the first pstring
    call    pstrlen
    movq    %rax, %r12             # %r12 save the lenght of the first pstring

    movq    %rdx, %rdi             # %rdi pointer to the second pstring
    call    pstrlen
    movq    %rax, %r13             # %r13 save the lenght of the second pstring

    movq    $print1, %rdi          # put the output string in %rdi
    movq    %r12, %rsi             # put the first length in %rsi
    movq    %r13, %rdx             # put the second length in %rdx
    xor     %rax, %rax
    call    printf                 # print the length of the two pstrings

    popq    %r13                   # pop the callee registers
    popq    %r12
    ret                            # return to caller function


.L52:
    pushq   %rbp                 # save the old frame pointer
    movq    %rsp, %rbp           # create the new frame pointer

    pushq   %r12                 # push callee registers
    pushq   %r13
    movq    %rsi, %r12           # %r12 pointer to the first pstring
    movq    %rdx, %r13           # %r13 pointer to the second pstring

    subq    $8, %rsp             # memory allocation for the input char
    xor     %rax, %rax
    movq    $scanf_char, %rdi
    movq    %rsp, %rsi
    call    scanf                # scan first char

    xor     %rax, %rax
    movq    $scanf_char, %rdi
    leaq    4(%rsp), %rsi
    call    scanf               # scan second char

    #first replace
    movq    %r12, %rdi          # %rdi pointer to the first pstring
    movb    (%rsp), %sil        # put the first char in %rsi
    movb    4(%rsp), %dl        # put the second char in %rdx
    call    replaceChar
    movq    %rax, %r12          # %r12 pointer to the first pstring after the replace

    #second replace
    movq    %r13, %rdi          # %rdi pointer to the second pstring
    movb    (%rsp), %sil        # put the first char in %rsi
    movb    4(%rsp), %dl        # put the second char in %rdx
    call    replaceChar
    movq    %rax, %r13          # %r13 pointer to the second pstring after the replace

    #print all
    movq    $print2, %rdi       # put the output string in %rdi
    movb    (%rsp), %sil        # put the first char in %rsi
    movb    4(%rsp), %dl        # put the second char in %rdx
    leaq    1(%r12), %rcx       # %rcx pointer to the first pstring after the replace (without size)
    leaq    1(%r13), %r8        # %r8 pointer to the second pstring after the replace (without size)
    xor     %rax, %rax
    call    printf

    popq    %r13                # pop the callee registers
    popq    %r12
    movq    %rbp, %rsp          # restore the old stack pointer
    popq    %rbp
    ret                         # return to caller function



.L53:
    pushq   %rbp                # save the old frame pointer
    movq    %rsp, %rbp          # create the new frame pointer
    pushq   %r12                # push callee registers
    pushq   %r13
    pushq   %r14
    pushq   %r15

    movq    %rsi, %r12           # %r12 pointer to the dst pstring
    movq    %rdx, %r13           # %r13 pointer to the src pstring

    subq    $24, %rsp            # memory allocation for the input int
    movq    $scanf_int, %rdi
    movq    %rsp, %rsi
    xor     %rax, %rax
    call    scanf                # scan first int

    movq    $scanf_int, %rdi
    leaq    8(%rsp), %rsi
    xor     %rax, %rax
    call    scanf                # scan second int

    #call pstrijcpy
    movq    %r12, %rdi           # put the first pstring in %rdi
    movq    %r13, %rsi           # put the second pstring in %rsi
    movl    (%rsp), %r15d
    xor     %rdx, %rdx
    movb    %r15b, %dl           # put the first index in %rdx
    movl    8(%rsp), %r15d
    xor     %rcx, %rcx
    movb    %r15b, %cl           # put the second index in %rcx
    call    pstrijcpy
    movq    %rax, %r12           # put the result at %r12

    #print the result of dst
    movq    $print3, %rdi        # put the output string in %rdi
    xor     %rsi, %rsi
    movb    (%r12), %sil         # put the length of the pstring at %rsi
    leaq    1(%r12), %rdx        # put the pstring (without size) at %rdx
    xor     %rax, %rax
    call    printf               # print the result

    #print the result of src
    movq    $print3, %rdi        # put the output string in %rdi
    xor     %rsi, %rsi
    movb    (%r13), %sil         # put the length of the pstring at %rsi
    leaq    1(%r13), %rdx        # put the pstring (without size) at %rdx
    xor     %rax, %rax
    call    printf               # print the result

    popq    %r15                 # pop the callee registers
    popq    %r14
    popq    %r13
    popq    %r12
    movq    %rbp, %rsp           # restore the old stack pointer
    popq    %rbp                 # restore old frame pointer
    ret                          # return to caller function



.L54:
    pushq   %r12                  # push callee registers
    pushq   %r13

    movq    %rsi, %r12            # %r12 pointer to the first pstring
    movq    %rdx, %r13            # %r13 pointer to the second pstring

    movq    %r12, %rdi            # call swapCase to the first pstring
    call    swapCase
    movq    %rax, %r12            # save the result at %r12

    movq    $print3, %rdi         # put the output string in %rdi
    xor     %rsi, %rsi
    movb    (%r12), %sil          # put the length of the pstring at %rsi
    leaq    1(%r12), %rdx         # put the pstring (without size) at %rdx
    xor     %rax, %rax
    call    printf                # print the result of swapCase

    movq    %r13, %rdi            # call swapCase to the second pstring
    call    swapCase
    movq    %rax, %r13            # save the result at %r13

    movq    $print3, %rdi         # put the output string in %rdi
    xor     %rsi, %rsi
    movb    (%r13), %sil          # put the length of the pstring at %rsi
    leaq    1(%r13), %rdx         # put the pstring (without size) at %rdx
    xor     %rax, %rax
    call    printf                # print the result of swapCase

    popq    %r13                  # pop the callee registers
    popq    %r12
    ret                           # return to caller function



.L55:
    pushq   %rbp                 # save the old frame pointer
    movq    %rsp, %rbp           # create the new frame pointer

    pushq   %r12                 # push callee registers
    pushq   %r13

    movq    %rsi, %r12           # %r12 pointer to the first pstring
    movq    %rdx, %r13           # %r13 pointer to the second pstring

    sub     $16, %rsp            # memory allocation for the input int
    xor     %rax, %rax
    movq    $scanf_int, %rdi
    leaq    0(%rsp), %rsi
    call    scanf                # scan first int

    xor     %rax, %rax
    movq    $scanf_int, %rdi
    leaq    8(%rsp), %rsi
    call    scanf               # scan second int

    #call pstrijcmp
    movq    %r12, %rdi          # put the first pstring in %rdi
    movq    %r13, %rsi          # put the second pstring in %rsi
    xor     %rdx, %rdx
    movb    (%rsp), %dl         # put the first index in %rdx
    movb    8(%rsp), %cl        # put the second index in %rcx
    call    pstrijcmp
    movq    %rax, %r12          # save the result at %r12

    movq    $print4, %rdi       # put the output string in %rdi
    xor     %rsi, %rsi
    movq    %r12, %rsi          # put thr result in %rsi
    xor     %rax, %rax
    call    printf              # print the result of pstrijcmp

    popq    %r13                # pop the callee registers
    popq    %r12
    movq    %rbp, %rsp          # restore the old stack pointer
    popq    %rbp                # restore old frame pointer
    ret                         # return to caller function


