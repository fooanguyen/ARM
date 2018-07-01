

	.text
			.global main
			
;;;;;Parsing num1;;;;;;;;;;;;;;;;;;;;;
main:			
			
			ldr 	r0, =A		;load A to r0
			mov		r14, #0
			mov		r9, #0		;counter before the dot
			mov 	r8, #0		;counter after the dot
			mov		r7, #0		;temp counter holder

parse1:
			ldrb 	r1, [r0, r7] ;load and single bite of r0 form position r7
			cmp		r1, #45		; check for sign
			beq		sign
			cmp		r1, #46		;check if dot is found
			beq		dot			;if dot is found move to afterdot
			sub		r1, r1, #48 ; this line of code may not actually do anything!!!!
			add		r9, r9, #1
			add		r7, r7, #1
			b		parse1

sign:
			mov		r14, #1
			ldr		r13, =B ;load B into r13
			str		r14, [r13] ; store value of r14 into B
			
		
			add		r7, r7, #1 ;increment temp counter
			b		parse1 ;unconditional branch to parsel
			
dot:			
			add		r7, r7, #1	;increment r7

		
dotcont:
			ldrb 	r1, [r0, r7] ;load and single bite of r0 form position r7
			cmp		r1, #0		;searching for null value. And since this is .asciz the null value is always at the end
			beq		readin	;if null value is found branch to reading
			sub		r1, r1, #48 ; again this value is being overwriten when it calls itself, is this really doing anything?
			add		r8, r8, #1 ;increment r8
			add		r7, r7, #1	; increment r7
			b		dotcont	;uncondition branch back to itself
		


readin:
			mov		r0, #0 ;clear r0
			mov		r7, #0 ;clear temp counter
			ldr		r2, =C 
			str		r9, [r2] ;stores the counter before the dot in C
			ldr		r3, =D
			str		r8, [r3] ; stores counter after the dot at D
			mov		r10, #10
			ldr 	r0, =A ;loads A into r0
			
startread:
			ldrb 	r1, [r0, r7]	;load the "r7" placed bit from r0 to r1
			cmp		r1, #45 ;check for sign
			beq		sign2 ; if value is the sign branch to r1
			
			sub		r1, r1, #48 ;subtract 48 from asciz value to get decimal value
			cmp		r9, #1 ;
			bgt		aa ;if r9 is greater then 1 branch to aa
			add		r6, r6, r1	;add r6 to r1
			add 	r7, r7, #1	;r7++
			sub		r9, r9, #1 ;subtract counter before dot
			cmp		r9, #0
			beq		storing ; go to storing if counter before dot is equal to 0
			
			
aa:
		bl		multiply; branch to multiply set lr to startread
		b		startread
		
multiply:
			mul		r5, r1, r10 ;multiples newest value by 10
			mul		r2, r6, r10 ; multiples old value by 10
			add		r2,r2, r5 ; adds old and new values.
			mov		r6, r2	; updates old value
			add 	r7, r7, #1	;r7++
			sub		r9, r9, #1	;r9--
			bx		lr
			
sign2:		
			add 	r7, r7, #1 ;r7++
			b		startread
			
					
storing:
		
			ldr 	r2, =F
			str		r6, [r2] ; store value of r6 (the number before the dot) into F
			
			mov		r6, #0 ;clearing r6
			
readinAfter:			
			;pretty much does the same thing as start read, but for the value after the dot
			ldrb 	r1, [r0, r7]
			cmp		r1, #46 ;check if dot is found
			beq		dot2
			sub		r1, r1, #48
			cmp		r8, #1
			bgt		bb
			add		r6, r6, r1
			add		r7, r7, #1
			sub		r8, r8, #1
			cmp		r8, #0
			beq		storing2

bb:
		bl		multiply2
		b		readinAfter			

multiply2:
			mul		r5, r1, r10
			mul		r2, r6, r10
			add		r2, r2, r5
			mov		r6, r2
			add 	r7, r7, #1
			sub		r8, r8, #1
			bx		lr
			
dot2:			
			add		r7, r7, #1
			b  		readinAfter

storing2:
			ldr 	r2, =G ;stores number after dot
			str		r6, [r2]

			
;;;;;;;Parsing num2;;;;;;;;;;;;;;;;;;
;does the same thing as the top code above, but for the second number,only major diffrenses are were the values are stored
;and that the registers are cleared before the start.
main2:			
			
			ldr 	r0, =AA		;load AA to r0
			;clear alregisters r1-r14 with the exceptions of r11, r12, and r13
			mov		r1, #0
			mov		r2, #0
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r10,#0
			mov		r14,#0
			mov		r9, #0		;counter before the dot
			mov 	r8, #0		;counter after the dot
			mov		r7, #0		;temp counter holder

parse2:
			ldrb 	r1, [r0, r7]
			cmp		r1, #45
			beq		sign3
			cmp		r1, #46		;check if dot is found
			beq		dot3			;if dot is found move to afterdot
			sub		r1, r1, #48  ;do i even need to say it?
			add		r9, r9, #1
			add		r7, r7, #1
			b		parse2

sign3:
			mov		r14, #1
			ldr		r13, =J
			str		r14, [r13]
			
		
			add		r7, r7, #1
			b		parse2
			
dot3:			
			add		r7, r7, #1

		
dotcont2:
			ldrb 	r1, [r0, r7]
			cmp		r1, #0
			beq		readin2
			sub		r1, r1, #48 ;and this is never getting old
			add		r8, r8, #1
			add		r7, r7, #1
			b		dotcont2
		


readin2:
			mov		r0, #0
			mov		r7, #0
			ldr		r2, =K
			str		r9, [r2]
			ldr		r3, =L
			str		r8, [r3]
			mov		r10, #10
			ldr 	r0, =AA
			
startread2:
			ldrb 	r1, [r0, r7]
			cmp		r1, #45
			beq		sign4
			
			sub		r1, r1, #48
			cmp		r9, #1
			bgt		aa2
			add		r6, r6, r1
			add 	r7, r7, #1
			sub		r9, r9, #1
			cmp		r9, #0
			beq		storing3
			
			
aa2:
		bl		multiply3
		b		startread2
		
multiply3:
			mul		r5, r1, r10
			mul		r2, r6, r10
			add		r2,r2, r5
			mov		r6, r2
			add 	r7, r7, #1
			sub		r9, r9, #1
			bx		lr
			
sign4:		
			add 	r7, r7, #1
			b		startread2
			
					
storing3:
		
			ldr 	r2, =M
			str		r6, [r2]
			ldr 	r3, =M
			ldr 	r3, [r3]
			mov		r6, #0
			
readinAfter2:			
			
			ldrb 	r1, [r0, r7]
			cmp		r1, #46
			beq		dot4
			sub		r1, r1, #48
			cmp		r8, #1
			bgt		bb2
			add		r6, r6, r1
			add		r7, r7, #1
			sub		r8, r8, #1
			cmp		r8, #0
			beq		storing4

bb2:
		bl		multiply4
		b		readinAfter2		

multiply4:
			mul		r5, r1, r10
			mul		r2, r6, r10
			add		r2, r2, r5
			mov		r6, r2
			add 	r7, r7, #1
			sub		r8, r8, #1
			bx		lr
			
dot4:			
			add		r7, r7, #1
			b  		readinAfter2

storing4:
			ldr 	r2, =N
			str		r6, [r2]
			

			
;;;;;;;;Get exponent of num1;;;;;;;;;;;	
clear:
			mov		r1, #2; r1 = 2
			mov		r2, #2; r2 = 2
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r10,#0
			mov		r11,#0
			mov		r12,#0
			mov		r13,#0
			mov		r14,#0
			mov		r0, #0
			;mov		r14,#0
			mov		r9, #0		
			mov 	r8, #0		
			mov		r7, #0		
			
expnum1:
			ldr 	r0, =F ;load address of F into r0
			ldr		r0, [r0]; load value of F into r0 (the number before the dot)
			
exp1:
			cmp		r1, r0 ;r1 starts out at
			bgt		expadd; if r1 is greater the r0 branch to expadd
			mul		r4, r1, r2 ;multiplyes r1 by 2 then stores value in r4.
			mov		r1, r4; updates r1 with r4. (the places of a binary number is shifted
			add		r7, r7, #1; r7++
			b		exp1
			
	
expadd:
			add		r7, r7, #127; add bias to get exponent
			ldr		r5, =expn1
			str		r7, [r5]; storing exponet
			b		clear2	; don't really thing this line of code is nessary as even without it, it will just go to next
			
;;;;;;;;;;;Get exponent of num2;;;;;;;;;;;;;;;;;;;
clear2:
			mov		r1, #2
			mov		r2, #2
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r10,#0
			mov		r11,#0
			mov		r12,#0
			mov		r13,#0
			mov		r14,#0
			mov		r0, #0
			mov		r14,#0
			mov		r9, #0		
			mov 	r8, #0		
			mov		r7, #0				
expnum2:
			ldr 	r0, =M ;addres of number before the dot of the second input number
			ldr		r0, [r0];value 
			
exp2:
			cmp		r1, r0
			bgt		expadd2
			mul		r4, r1, r2
			mov		r1, r4
			add		r7, r7, #1
			b		exp2
			
			
expadd2:
			add		r7, r7, #127
			ldr		r5, =expn2
			str		r7, [r5]		
			
			
			

;;;;;;;;;;Compare exponent to shift to match ;;;;;;;;;;;;;;;;;;
;not sure if clear3 is nessisary at all
clear3:
			mov		r0, #0
			mov		r1, #0
			mov		r2, #0
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r11,#0
			mov		r12,#0
			mov		r13,#0
			mov		r0, #0
			mov		r14,#0
			mov		r10,#0
			mov		r9, #0		
			mov 	r8, #0	
			mov		r7, #0	

			ldr		r0, =expn1
			ldr		r0, [r0]
			
			ldr		r1, =expn2
			ldr		r1, [r1]

			cmp		r0, r1
			;beq		bothEqual
			;bgt    	num1isgreater
			;blt		num2isgreater
			
;;;;num1 shifter;;;;;
clear4:
			mov		r0, #0
			mov		r1, #0
			mov		r2, #0
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r11,#2
			mov		r12,#0
			mov		r13,#2
			mov		r0, #0
			mov		r14,#0
			mov		r10,#0
			mov		r9, #0		
			mov 	r8, #0	
			mov		r7, #0		

getdata:
			ldr		r0, =F ;again value before the dot (number 1)
			ldr		r0, [r0]
			mov		r2, r0, lsl #16; logical shift left by 16
			mov		r10, r2

			ldr		r1, =G ;address of value after the dot
			ldr		r1, [r1]; actual fractual value 
			

			
Gexp: 
			cmp		r11, r1 ;rll starts off at 2
			bgt		continueF1 ;if r11 is greater then r1
			mul		r12, r13, r11 ;multiplyes r13(2) by r11, and puts that in r12
			mov		r11, r12 ;replace r11 with r12
			add		r7, r7, #1 ;++r7
			b		Gexp
			
			
			
continueF1:		
			mov		r5, #15
			mov		r3, #0
			mov		r11, #10
			mov		r9, #1
			mov		r7, #2
			mov		r14, #1
			ldr		r4, =D;loads address of number counter after the dot for num1
			ldr		r4, [r4]
			add		r4, r4, #1 ;adds 1 to it
			
continueF2:		
			cmp		r4, #1	;compares r4 to 1
			beq		continueF22 ; branches when equal
			mul 	r8, r9, r11 ;multiples r9 by 10 and puts it in r8
			mov		r9, r8 ; replaces r9 with r8
			sub		r4, r4, #1 ;r4--
			b 		continueF2
			
continueF22:
			cmp		r5, #0 ;r5 starts at 15
			beq		continueF4
			mul		r8, r1, r7;multiples fractal value of num1 by 2 and stores it in r8
			cmp		r8, r9
			beq		continueF3
			bgt		continueF3 
			blt		continueF33

			
continueF3:
			sub		r1, r8, r9
			mov		r12, r14, lsl r5
			add		r3, r12, r3
			sub		r5, r5, #1
			b 		continueF22
			
continueF33:	
			cmp		r8, #0
			beq		continueF4
			mov		r1, r8
			sub		r5, r5, #1
			b		continueF22
		
							
continueF4:	
		
			ldr		r6, = expn1
			ldr		r6, [r6]
			
			sub		r5, r6, #127
			mov		r4, #16
			add		r13, r5, r4
			sub		r4, r4, r5
			mov		r9, r2, lsl r4
			mov		r2, r9, lsr r4
			add		r9, r2, r3
			cmp		r2, #8388608  ;2^23
			beq		equal23
			bgt		greater23
			blt		lower23
			
equal23:
			
			b		addexp
			
greater23:
			sub		r13, r13, #23
			b		shifter

					
shifter:			
			mov		r8, r9, lsr r13
			mov		r9, r8
			b		addexp

			
lower23:
			mov		r11, #2
			mov		r12, #2
			mov		r7, #0
			cmp		r9, #8388608  ;2^23
			blt		lowerExp
			b		addexp
			
	
lowerExp:
			cmp		r11, r10
			bgt		shifter2
			mul		r5, r11, r12
			mov		r11, r5
			add		r7, r7, #1
			b		lowerExp
			
shifter2:			
			mov		r8, #23
			sub		r7, r8, r7
			mov		r8, r9, lsl r7
			mov		r9, r8
			b		addexp


addexp:			
			mov		r4, r6, lsl #23
			add		r14, r4, r9
			mov		r4, r14
			b		checksign		

checksign:
			ldr 	r5, =B
			ldr		r5, [r5]
			
			cmp		r5, #1
			beq		addsign
			b		storenum1FP
			
addsign:			
			mov		r7, r5, lsl #31
			add		r4, r7, r4

storenum1FP:			
			ldr		r8, =num1FP
			str		r4, [r8]
			
;;;;num2 shifter;;;;;

clear5:
			mov		r0, #0
			mov		r1, #0
			mov		r2, #0
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			mov		r11,#2
			mov		r12,#0
			mov		r13,#2
			mov		r0, #0
			mov		r14,#0
			mov		r10,#0
			mov		r9, #0		
			mov 	r8, #0	
			mov		r7, #0		

getdata2:
			ldr		r0, =M
			ldr		r0, [r0]
			mov		r2, r0, lsl #16
			mov		r10, r2

			ldr		r1, =N
			ldr		r1, [r1]
			

			
Gexp2: 
			cmp		r11, r1
			bgt		continueG1
			mul		r12, r13, r11
			mov		r11, r12
			add		r7, r7, #1
			b		Gexp2
			
			
			
continueG1:		
			mov		r5, #15
			mov		r3, #0
			mov		r11, #10
			mov		r9, #1
			mov		r7, #2
			mov		r14, #1
			ldr		r4, =L
			ldr		r4, [r4]
			add		r4, r4, #1
			
continueG2:		
			cmp		r4, #1
			beq		continueG22
			mul 	r8, r9, r11
			mov		r9, r8
			sub		r4, r4, #1
			b 		continueG2
			
continueG22:
			cmp		r5, #0
			beq		continueG4
			mul		r8, r1, r7
			cmp		r8, r9
			beq		continueG3
			bgt		continueG3 
			blt		continueG33

			
continueG3:
			sub		r1, r8, r9
			mov		r12, r14, lsl r5
			add		r3, r12, r3
			sub		r5, r5, #1
			b 		continueG22
			
continueG33:	
			cmp		r8, #0
			beq		continueG4
			mov		r1, r8
			sub		r5, r5, #1
			b		continueG22
		
							
continueG4:	
		
			ldr		r6, = expn2
			ldr		r6, [r6]
			
			sub		r5, r6, #127
			mov		r4, #16
			add		r13, r5, r4
			sub		r4, r4, r5
			mov		r9, r2, lsl r4
			mov		r2, r9, lsr r4
			add		r9, r2, r3
			cmp		r2, #8388608  ;2^23
			beq		equal223
			bgt		greater223
			blt		lower223
			
equal223:
			
			b		addexp2
			
greater223:
			sub		r13, r13, #23
			b		shifterx

					
shifterx:			
			mov		r8, r9, lsr r13
			mov		r9, r8
			b		addexp2

			
lower223:
			mov		r11, #2
			mov		r12, #2
			mov		r7, #0
			cmp		r9, #8388608  ;2^23
			blt		lowerExp2
			b		addexp2
			
	
lowerExp2:
			cmp		r11, r10
			bgt		shiftery
			mul		r5, r11, r12
			mov		r11, r5
			add		r7, r7, #1
			b		lowerExp2
			
shiftery:			
			mov		r8, #23
			sub		r7, r8, r7
			mov		r8, r9, lsl r7
			mov		r9, r8
			b		addexp2


addexp2:			
			mov		r4, r6, lsl #23
			add		r14, r4, r9
			mov		r4, r14
			b		checksign2		

checksign2:
			ldr 	r5, =J
			ldr		r5, [r5]
			
			cmp		r5, #1
			beq		addsign2
			b		storenum2FP
			
addsign2:			
			mov		r7, r5, lsl #31
			add		r4, r7, r4

storenum2FP:			
			ldr		r8, =num2FP
			str		r4, [r8]
			

clear6:
			mov		r0, #0
			mov		r1, #0
			mov		r2, #0
			mov		r3, #0
			mov		r4, #0
			mov		r5, #0
			mov		r6, #0
			;mov		r11,#0
			;mov		r12,#0
			;mov		r13,#0
			mov		r0, #0
			;mov		r14,#0
			;mov		r10,#0
			mov		r9, #0		
			mov 	r8, #0	
			mov		r7, #0	
			
TestingArea:
			b 		DoMultiplication
			;b		DoAddition
			;b		DoSubtraction
			
DoMultiplication:
			ldr 		r1, =num1FP ; first floating point number
			ldr 		r1, [r1]
			ldr 		r2, =num2FP ; second floating point number
			ldr 		r2, [r2]
			;fmul		r3,r1,r2
			bl 		mulFP
			b		Finish
DoAddition:
			ldr 		r1, =num1FP ; first floating point number
			ldr 		r1, [r1]
			ldr 		r2, =num2FP ; second floating point number
			ldr 		r2, [r2]
			;fadd		r3, r1, r2
			bl 		addFP
			b		Finish
DoSubtraction:
			ldr 		r1, =num1FP ; first floating point number
			ldr 		r1, [r1]
			ldr 		r2, =num2FP ; second floating point number
			ldr 		r2, [r2]
			;fsub		r3,r1,r2
			bl 		subFP
			b		Finish

Finish:			
			swi 0x11

; r0 = r1 * r2
mulFP:
			;stmfd sp!, {lr}
			and r3, r1, #0x80000000         ; get the sign of the first operand
			and r4, r2, #0x80000000         ; get the sign of the second operand

			eor r0, r3, r4                  ; get the new sign bit

			ldr r9, =0x7f800000
			and r3, r1, r9                  ; extract exponents
			and r4, r2, r9                  ; extract exponents

			mov r3, r3, lsr #23
			mov r4, r4, lsr #23
			sub r3, r3, #127        ; remove exponent bias
			sub r4, r4, #127

			add r5, r3, r4          ; add exponents, r5 now holds the new exponent

			ldr r9, =0x007fffff
			and r3, r1, r9                  ; extract fractions from operand1
			and r4, r2, r9                  ; extract fractions from operand2
			orr r3, r3, #0x00800000         ; add implied 1 to front of fraction one
			orr r4, r4, #0x00800000         ; add implied 1 to front of fraction one

			; r6 high r7 low = r3 * r4. r9 is used as high sigbits for r4
			stmfd sp!, {r3-r4, r8-r9}              ; Save r8 and r9 registers
			mov r6, #0
			mov r7, #0                      
			mov r9, #0                      ; Zero out r6 and r7 for result

mul:
			ands r8, r3, #1                 ; Test to see if there's a 1 in the LSB. r8 is used temporarily here for the test
			beq Dont_add                   ; Ands will set the zero flag if the LSB doesn't exist. "eq" jumps when the zero flag is present

			adds r7, r7, r4
			adc r6, r6, r9                   ; Add r4 to the low significance register if the LSB in r3 is a 1, then add carry to high reg along with high sig register

Dont_add:
			mov r9, r9, lsl #1
			movs r4, r4, lsl #1
			adc r9, r9, #0                 ; Shift r4 to the left, move carry bit and add overflow into r9

			movs r3, r3, lsr #1             ; Shift r3 to the right and set flags
			bne mul                         ; The previous movs will set the zero flag if we move zero into r3, causing a branch if r3 is not yet zero

			ldmfd sp!, {r3-r4, r8-r9}       ; Restore previously saved values

; if bit 48 from the multiplication is 1 then we need to shift right one and add one to the exponent 
creatfraction:
			ands r8, r6, #0x00008000         ; check to see if bit 16 of the hi bits 
			
			; bit 48 of multiplication was a one so add one to the exponent and create fraction
			addne r5, r5, #1         ; if ne is true that means the ands above resulted in a non-zero value indicating the 16th bit was a 1
			movne r6, r6, lsl #16    ; make room to pull in low bits from multiply, if bit 16 was 1 shift 16
			movne r7, r7, lsr #16     ; move the low bits right so they can be merged with the high bits
			
			; no normalization necessary just combine the first 23 bits from high and low
			moveq r6, r6, lsl #17    ; make room to pull in low bits from multiply, if bit 16 was not 1 shift 17  
			moveq r7, r7, lsr #15     ; move the low bits right so they can be merged with the high bits
			
			; or the fraction parts together
			orr r6, r6, r7           ; put the fraction halves together
			mov r6, r6, lsr #8       ; make the fraction only use 24 bits
			bic r6, r6, #0x00800000         ; clear the implied 1 from the fraction

done:
			add r5, r5, #127        ; re-add bias to the exponent
			mov r5, r5, lsl #23     ; shift exponent into its ieee754 position
			orr r0, r0, r5          ; merge exponent into the result register r0
			orr r0, r0, r6          ; merge fraction into the result register r0

finish:
			;ldmfd sp!, {lr}
			mov pc, lr              ; Return to caller

; r0 = r1 - r2
subFP:
			mov r11, lr
			ldr r10, =0x80000000
			eor r2, r2, r10             ; Exclusive or r2 with 0x80000000 to toggle the sign bit
			bl addFP
			mov lr, r11
			mov pc, lr                  ; Return to caller

; r0 = r1 + r2
addFP:
			ldr r10, =0x7f800000		;  7f80 hex = 0111 1111 1000 0000 binary
			and r4, r1, r10             ; use a bitmask to capture the first number's exponent
			and r5, r2, r10             ; use a bitmask to capture the second number's exponent
			cmp r4, r5

			movcc r3, r1
			movcc r1, r2
			movcc r2, r3                ; swap r1 with r2 if r2 has the higher exponent
			andcc r4, r1, r10 
			andcc r5, r2, r10           ; update exponents if swapped

			mov r4, r4, lsr #23
			mov r5, r5, lsr #23         ; move exponents to least significant position

			sub r3, r4, r5              ; subtract exponents to get shift amount
			ldr r10, =0x007fffff     
			and r5, r1, r10             ; grab first number's fractional part
			and r6, r2, r10             ; grab second number's fractional part
			ldr r10, =0x00800000
			orr r5, r5, r10             ; add implied 1 to first fractional part
			orr r6, r6, r10             ; add implied 1 to second fractional part
			mov r6, r6, lsr r3          ; shift r6 to the right by the difference in exponents

			ldr r10, =0x80000000
			ands r0, r1, r10            ; check msb for negative bit
			movne r0, r5                ; this "not equal" works because the "ands" will set the zero flag if the result is zero
			mov r9, lr
			blne Negate        	    ; two's complement fractional first number if it's supposed to be negative
			mov lr, r9
			movne r5, r0

			ands r0, r2, r10             ; check msb for negative bit
			movne r0, r6
			mov r9, lr
			blne Negate        ; two's complement fractional second number if it's supposed to be negative
			mov lr, r9
			movne r6, r0

			add r5, r5, r6              ; add the fractional portions. r5 contains the result.

			ands r0, r5, r10             ; check msb to see if the result is negative
			movne r0, r5
			mov r9, lr
			blne Negate        ; two's complement result if negative
			mov lr, r9
			movne r5, r0
			ldrne r0, =0x80000000       ; put a 1 as result's msb if the result was negative
			moveq r0, #0                ; put a 0 as result's msb if the result was positive

			mov r3, #0
			ldr r10, =0x80000000

bitShiftLoop:
			cmp r10, r5
			addhi r3, r3, #1
			movhi r10, r10, lsr #1
			bhi bitShiftLoop       	    ; count how many times you have to shift before hitting a 1 in the result

			cmp r3, #8                  ; if it's shifted 8 times it's already in the right place
			subhi r3, r3, #8            ; if it needs shifting left, determine how many times
			movhi r5, r5, lsl r3        ; shift as needed
			subhi r4, r4, r3            ; subtract shift amount from exponent to reflect shift
			movcc r10, #8
			subcc r3, r10, r3           ; if it needs shifting right, determine how many times
			movcc r5, r5, lsr r3        ; shift as needed
			addcc r4, r4, r3            ; add shift amount to exponent to relfect shift

			mov r4, r4, lsl #23         ; shift exponent into place
			orr r0, r0, r4              ; or exponent into number
			ldr r10, =0x007fffff
			and r5, r5, r10             ; get rid of implied 1 in fraction
			orr r0, r0, r5              ; attach fractional part

			mov pc, lr

; r0 = -r0
Negate:
			mvn r0, r0                  ; negate r0
			add r0, r0, #1              ; add 1
			mov pc, lr                  ; Return to caller
end:	
			swi			0x11	
			
			
			.data	
A:			.asciz		"-30.99"
AA:			.asciz		"17.58"
	
B:			.word		0;store num1 sign bit
C:			.word		0;store num1 counter before dot
D:			.word		0;store num1 counter after dot
F:			.word		0;store num1 before dot
G:			.word		0;store num1 after dot
expn1:		.word		0;store num1 exp
num1FP:		.word		0;store num1 floating point


J:			.word		0;store num2 sign bit
K:			.word		0;store num2 counter before dot
L:			.word		0;store num2 counter after dot
M:			.word		0;store num2 before dot
N:			.word		0;store num2 after dot
expn2:		.word		0;store num2 exp
num2FP:		.word		0;store num2 floating point
			.end	
