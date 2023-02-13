.section .data

input_x_prompt:   .asciz  "Please enter x: "
input_y_prompt  :   .asciz  "Please enter y: "
input_spec  :   .asciz  "%d"
result      :   .asciz  "x^y = %d\n"

.section .text

.global main

main:
    
    #create room on stack for x
    sub sp, sp, 8
    # input x prompt
    ldr x0, = input_x_prompt
    bl printf
    #get input x value
    # spec input
    ldr x0, = input_spec
    mov x1, sp
    bl scanf
    ldr x19, [sp]

    #get y input value
    # enter y output
    ldr x0, = input_y_prompt
    bl printf
    # spec input
    ldr x0, = input_spec
    mov x1, sp
    bl scanf
    ldr x20, [sp]

    #set x22 == x19
    #x22 is going to be the return value
    add x22, x19, 0
    
    #test if y == 0
    sub x9, x20, 0
    CBZ x9, y0
    
    #test if y == 1
    sub x9, x20, 1
    CBZ x9, y1

#positive x val loop iterates by subtracting to x counter
loop:
     subs x11, x20, 1
     b.eq print
     sub x20, x20, 1
     mul x22, x22, x19
     b loop
    
y0:
  sub x22, x22, x22
  add x22, x22, 1
  b print
y1:
  add x22, x19, 0
  b print
 
print:
       mov x1, x22
       ldr x0, =result
       bl printf
    
    #exit branch
    b exit

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret
