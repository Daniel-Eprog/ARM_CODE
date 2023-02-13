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

    #set x23 == x19
    add x23, x19, 0
    
    #test if y == 0
    sub x9, x20, 0
    CBZ x9, y0
    
    #test if y == 1
    sub x9, x20, 1
    CBZ x9, y1

    #test if y is even
    add x9, x20, 0
    #shift left by 4 to isolate position 0
    lsl x9, x9, 4
    #shifting back by 4 leaves 0 in potions 1-4 and original
    #value in position 0
    lsr x9, x9, 4
    #testing it against 0 with logical or
    #if value is not zero then value is odd
    #else value is even
    eor x9, x9, xzr
    cbz x9, makexpos

makexpos:
    #for negative number leading digit is reserved
    #1 if negative otherwise 0
    #shifting eliminates leading digit
    lsl x19, x19, 1
    lsr x19, x19, 1

    #test if x < 0
    adds x9, x19, 0
    #jumps to negative val loop
    b.lt xneg

#positive x val loop iterates by subtracting to x counter
loop:
     subs x11, x20, 1
     b.eq print
     sub x20, x20, 1
     mul x19, x19, x19
     b loop
     add x21, x19, 0
xpos2:
     subs x12, x21, 0
     b.eq updatepos
     add x22, x22, x23
     sub x21, x21, 1
     b xpos2

#negative x val loop iterates by adding to x counter
xneg:
     subs x11, x20, 1
     b.eq print
     sub x20, x20, 1
     sub x22, x22, x22
     add x21, x19, 0
xneg2:
     subs x12, x21, 0
     b.eq updateneg
     add x22, x22, x23
     add x21, x21, 1
     b xneg2

#updates next iteration of x val and returns to respective loop
updatepos:
     add x23, x22, 0
     b xpos

updateneg:
    add x23, x22, 0
    b xneg

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
