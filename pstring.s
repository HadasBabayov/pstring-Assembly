#   322807629   Hadas Babayov

.data
print_invalid:
    .string "invalid input!\n"

.text
.global pstrlen
.global replaceChar
.global pstrijcpy
.global pstrijcmp
.global swapCase

pstrlen:
    movzbq      (%rdi), %rax         # put the length in %rax
    ret                              # return to caller function


replaceChar:
    pushq   %r14                      # push callee registers
    movq    %rdi, %r14                # %r14 pointer to the pstring
    leaq    1(%r14), %r14             # get the pointer to the first char at the pstring

    cmpb    $0, (%r14)                # check if the first char is '\0'
    je      .L35                      # jump to return

.L36:                                 # while loop
    cmpb    (%r14), %sil              # check if the current char is the old char
    je      .L38                      # if it is - jump to replace it

.L37:
    leaq    1(%r14), %r14             # get the pointer to the next char
    cmpb    $0, (%r14)                # check if this char is '\0'
    jne     .L36                      # if not - continue the loop
    je      .L35                      # if this char is '\0', jump to return

.L38:
    movb     %dl, (%r14)              # replace the old char.
    jmp     .L37                      # go to check the next char

.L35:
    movq    %rdi, %rax               # put the pstring after the change in %rax to return
    popq    %r14                     # pop the callee registers
    ret                              # return to caller function



pstrijcpy:
    pushq   %r14                     # push callee registers
    pushq   %r15
    movq    %rdi, %r15               # %r15 pointer to the pstring

    cmpb    %dl, %cl                 # check if i > j
    jb      .L7                      # jump to print invalid and return
    cmpb    %cl, (%rdi)              # check if j >= dst.len
    jbe     .L7                      # jump to print invalid and return
    cmpb    %cl, (%rsi)              # check if j >= src.len
    jbe     .L7                      # jump to print invalid and return

    add     $1, %dl                  # add 1 to i (because the first byte is the size of the string)
    add     $1, %cl                  # add 1 to j (because the first byte is the size of the string)

.L15:                                # while i <= j
    cmpb    %cl, %dl
    ja      .L27                     # if i > j --> finish

    movb    (%rsi, %rdx), %r14b      # put src[i] in %r14b
    movb     %r14b ,(%rdi, %rdx)     # put %r14b in dst[i]

    add     $1, %dl                  # add 1 to i
    jmp     .L15                     # continue to the next char

.L7:
    xor     %rax, %rax
    movq    $print_invalid, %rdi
    call    printf                   # print invalid
    jmp     .L27

.L27:
    movq    %r15, %rax               # put the pstring after the change in %rax to return
    popq    %r15                     # pop the callee registers
    popq     %r14
    ret                              # return to caller function



pstrijcmp:
    pushq   %r12                      # push callee registers
    pushq   %r13

    cmpb    %dl, %cl                  # check if i > j
    jb      .L8                       # jump to print invalid and return
    cmpb    %cl, (%rdi)               # check if j >= dst.len
    jbe     .L8                       # jump to print invalid and return
    cmpb    %cl, (%rsi)               # check if j >= src.len
    jbe     .L8                       # jump to print invalid and return

    add     $1, %dl                   # add 1 to i (because the first byte is the size of the string)
    add     $1, %cl                   # add 1 to j (because the first byte is the size of the string)

.L16:                                 # while i <= j
    cmpb    %cl, %dl
    ja      .L17                      # if i > j --> jump to return 0

    movb    (%rdx, %rdi), %r12b       # put pstr1[i] in %r12
    movb    (%rdx, %rsi), %r13b       # put pstr2[i] in %r13
    cmpb    %r12b, %r13b
    jg      .L20                      # p2[i] > p1[i]  --> jump to return -1
    jl      .L21                      # p2[i] < p1[i]  --> jump to return 1

    add     $1, %dl                   # add 1 to i
    jmp     .L16                      # continue to the next char

.L20:
    movq    $-1, %rax                 # put -1 in %rax to return
    popq    %r13                      # pop the callee registers
    popq    %r12
    ret                               # return to caller function

.L21:
    movq     $1, %rax                 # put 1 in %rax to return
    popq     %r13                     # pop the callee registers
    popq     %r12
    ret                               # return to caller function

.L17:
    movq    $0, %rax                  # put 0 in %rax to return
    popq    %r13                      # pop the callee registers
    popq    %r12
    ret                               # return to caller function

.L8:
    xor     %rax, %rax
    movq    $print_invalid, %rdi
    call    printf                   # print invalid
    movq    $-2, %rax                # put -2 in %rax to return
    popq    %r13                     # pop the callee registers
    popq    %r12
    ret                              # return to caller function



swapCase:
    pushq   %r14                    # push callee registers
    movq    %rdi, %r14              # %r14 pointer to the pstring

    leaq    1(%r14), %r14           # get the pointer to the first char at the pstring
    cmpb    $0, (%r14)              # check if the first char is '\0'
    je      .L10                    # jump to return

.L9:                                # while loop
    cmpb    $97, (%r14)             # compare the current char with 'a'
    jge     .L30

    cmpb    $65, (%r14)             # compare the current char with 'A'
    jge     .L31

.L13:
    leaq    1(%r14), %r14           # get the pointer to the next char
    cmpb    $0, (%r14)              # check if this char is '\0'
    jne     .L9                     # if not - continue the loop
    je      .L10                    # if this char is '\0', jump to return

.L30:
    cmpb    $122, (%r14)           # compare the current char with 'z'
    jle     .L12                   # jump to replace to upper case
    jmp     .L13

.L31:
    cmpb    $90, (%r14)            # compare the current char with 'Z'
    jle     .L11                   # jump to replace to lower case
    jmp     .L13

.L11:                              # up to low
    addb    $32, (%r14)
    jmp     .L13                   # go to check the next char

.L12:                              # low to up
    subb    $32, (%r14)
    jmp     .L13                   # go to check the next char

.L10:
    movq    %rdi, %rax             # put the pstring after the change in %rax to return
    popq    %r14
    ret                            # return to caller function
