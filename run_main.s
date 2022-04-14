#   322807629   Hadas Babayov

.data
scanf_int:
    .string "%d"
scanf_num_one_byte:
    .string "%hhu"
scanf_str:
    .string "%s"

.text
.global run_main

run_main:
        pushq   %rbp                       # save the old frame pointer
        movq    %rsp, %rbp                 # create the new frame pointer

        pushq   %r12                       # push callee registers
        pushq   %r13

        sub     $272, %rsp                 # memory allocation for the first pstring
        xor     %rax, %rax
        movq    $scanf_num_one_byte, %rdi
        movq    %rsp, %rsi
        call    scanf                      # get the length of this pstring
        movq    %rsp, %r12                 # save this length in %r12

        xor     %rax, %rax
        movq    $scanf_str, %rdi
        leaq    1(%rsp), %rsi
        call    scanf                      # get the string for this pstring

        sub     $272, %rsp                 # memory allocation for the second pstring
        xor     %rax, %rax
        movq    $scanf_num_one_byte, %rdi
        movq    %rsp, %rsi
        call    scanf                      # get the length of this pstring
        movq    %rsp, %r13                 # save this length in %r13

        xor     %rax, %rax
        movq    $scanf_str, %rdi
        leaq    1(%rsp), %rsi
        call    scanf                      # get the string for this pstring

        sub     $16, %rsp                  # memory allocation for the number (switch case)
        xor     %rax, %rax
        movq    $scanf_int, %rdi
        leaq    (%rsp), %rsi
        call    scanf                      # get this number

        movq    (%rsp), %rdi               # put the number for the switch case in %rdi
        movq    %r12, %rsi                 # put the first pstring in %rsi
        movq    %r13, %rdx                 # put thr second pstring in %rdx
        call    run_func

        popq    %r13                       # pop the callee registers
        popq    %r12
        movq    %rbp, %rsp                 # restore the old stack pointer
        popq    %rbp                       # restore old frame pointer
        ret                                # return to caller function


