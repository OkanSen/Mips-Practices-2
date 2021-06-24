#monitor
#Okan Sen
##

#################################

	.text		
	.globl __start	

__start:
	li $s4,1		# a constant
	
readArray:
	##---------------------------------------------------SET ARRAY SIZE HERE------------------------------------------------------
	la $a0, prompt1		# ask for array size
	li $v0, 4		# syscall 4 prints the string
	syscall

	li $v0, 5		# syscall 5 reads an integer
	syscall
	
	blt $v0, $s4, failedSize
	
	move $s1, $v0		# move input size to s1	
	move $a0, $s1		# storing size in 10 so we can allocate dynamic memory for how many bytes of space we need
	li $v0, 9 	
	syscall
	move $s0, $v0		# we must store v0 in s0 so that we do not lose the dynamic array address	
	
	
	# s0 = array address, s1 = array size
	
	## Setting loop and limit variables
	li $t9, 0
	move $t4, $s0  #put address of array in t4 for loop
	
	j lNums
	
failedSize:
	la $a0, prompt4		# print this if the entered size is not acceptable
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	j readArray		
	##---------------------------------------------------SET ARRAY SIZE HERE------------------------------------------------------
	
	
	# Entering Integers into the Array
lNums:	
	la $a0, prompt2		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall

	li $v0, 5		# syscall 5 reads an integer
	syscall
	
	move $t1, $v0		# move number to t1
	
	sw $t1, ($t4)	# put t1 into array's t4 th index
	

	addi $t9, $t9, 1		# add 1 to loop counter
	addi $t4, $t4, 4
	
	blt $t9, $s1, lNums	# if t9 (counter is less than the array size loop again
	#LOOP ENDED
	
	li $t9, 0
	li $t4, 0
	li $t1, 0
	
	
	j Menu
	
	##------------------------------------------                     MENU                         ------------------------------------------------------------------------
	##--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Menu:

	la $a0, msg1		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	la $a0, msg2		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	la $a0, msg3		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	la $a0, msg4		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	la $a0, msg5		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	la $a0, msg6		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	
EnterChoice:

	
	la $a0, msg6.5		# put msg119 address into a0
	li $v0, 4		# system call to print
	syscall			#   out the msg119 string

	li $v0, 5		# system call to read  
	syscall			# in the integer

	move $s2, $v0		# move choice into $s2
	
# BUBBLE SORT CHOICE ------------------------------------------------------	
T1:	bne $s2, 1, T2		# if s2 = 1, do these things. Else go to T2 test

	move $a0, $s0		# move array address into a0
	move $a1, $s1		# move array size into a1
	
	
	jal bubblesort
	
	j Menu
	
# Third min max CHOICE ------------------------------------------------------		
T2:	bne $s2, 2,  T3	# if s2 = 2, do these things. Else go to T3 test

	move $a0, $s0		# move array address into a0
	move $a1, $s1		# move array size into a1
	
	jal tmtm
	
	move $t0, $v0
	move $t1, $v1
	
	la $a0, msgmin
	li $v0, 4
	syscall
	
	move $a0, $t0	# print result
	li $v0, 1
	syscall
	
	li $t0, 0
	
	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, msgmax
	li $v0, 4
	syscall
	
	move $a0, $t1	# print result
	li $v0, 1
	syscall
	
	li $t1, 0
	
	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	j Menu
	
# MODE CHOICE ------------------------------------------------------		
T3:	bne $s2, 3, T4	# if s2 = 3, do these things. Else go to T4 test
	
	move $a0, $s0		# move array address into a0
	move $a1, $s1		# move array size into a1
	
	jal mode
	
	move $t0, $v0
	
	la $a0, msgmode
	li $v0, 4
	syscall
	
	move $a0, $t0	# print result
	li $v0, 1
	syscall
	
	li $t0, 0
	
	la $a0, endl
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	j Menu
	
# PRINTCHOICE ------------------------------------------------------	
T4:	bne $s2, 4, T5	# if s2 = 4, do these things. Else go to T5 test
	
	move $a0, $s0		# move array address into a0
	move $a1, $s1		# move array size into a1
	
	jal print
	
	la $a0, endl
	li $v0, 4
	syscall


# QUIT CHOICE ------------------------------------------------------	
T5:	bne $s2, 5, T6	# if s2 = 4, do these things. Else go to T5 test

	j exit
	
	
# INVALID CHOICE ------------------------------------------------------	
T6:
	la $a0, msg7		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	j Menu	
	
exit:
	li $v0,10		# system call to exit
	syscall			# bye bye

##-----------------------------    METHODS    -------------------------------------------------------
##---------------------------------------------------------------------------------------------------
##---------------------------------------------------------------------------------------------------
## BUBBLESORT SUBPROGRAM
bubblesort:
	subi $a2, $a1, 1		# for loop halt
	li $t4, 1			# a constant for negativity check
	move $t2, $a0			# array address, t2 holds the "i"th address
	addi $t3, $t2, 4		# one index more, t3 holds the "i+1"th address
	li $t7, 0			# swap counter	
	bbloop1:
		move $t2, $a0			# array address, t2 holds the "i"th address
		addi $t3, $t2, 4		# one index more, t3 holds the "i+1"th address
		bbloop2:
			
			bge $t9, $a2, bbloop2done
			
			lw $t0, ($t2)
			lw $t1, ($t3)
			
			# if t0 is negative increase t5 to keep info and get abs of it
			t0n: bge $t0, $0, t1n
				addi $t5, $t5, 1
				abs $t0, $t0
			# same for t1
			t1n: bge $t1, $0, doswap
				addi $t6, $t6, 1
				abs $t1, $t1
			# continue with normal swaps
			doswap:	
				bge $t0, $t1, bbNG	# if arr[i] > arr[i+1] continue to below
					
				# these three lines of code swaps t0 and t1 without the usage of extra variables
				add $t0, $t0, $t1	
				sub $t1, $t0, $t1
				sub $t0, $t0, $t1
			
			# get the negatives back regarding kept info with t5 and t6 but since the values are swapped t5 now corresponds to t1 and vice versa
			dot0n: 	bne $t5, $t4, dot1n
				mul $t1, $t1, -1
				subi $t5, $t5, 1
			# for t0
			dot1n: 	bne $t6, $t4, storeword
				mul $t0, $t0, -1
				subi $t6, $t6, 1
			# store the swapped values into array	
			storeword:
				# store the swapped values
				sw $t0, ($t2)
				sw $t1, ($t3)
			
				addi $t9, $t9, 1		# loop counter
				addi $t7, $t7, 1		# swap counter increment
				addi $t2, $t2, 4		# add 4 to current address
				addi $t3, $t2, 4		# add 4 to current address to get next address
			
				j bbloop2
			
			bbNG:
			
			# if the values are not swapped we must get the negatives back anyways but not like in reverse in the previous form
				bt0n: 	bne $t5, $t4, bt1n
					mul $t0, $t0, -1
					subi $t5, $t5, 1
				# for t1
				bt1n: bne $t6, $t4, increment
					mul $t1, $t1, -1
					subi $t6, $t6, 1
				increment:
					addi $t9, $t9, 1
					addi $t2, $t2, 4		# add 4 to current address
					addi $t3, $t2, 4		# add 4 to current address to get next address
					j bbloop2
		bbloop2done:
			beqz $t7, bbloop1done
			
			li $t9, 0
			li $t7,0
			
			j bbloop1
	bbloop1done:	
		li $t0, 0
		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		li $t5, 0
		li $t6, 0
		li $t7, 0
		li $t9, 0
		
		jr $ra

##------------------------------------------------------------------------------------
## THIRD MIN THIRD MAX SUBPROGRAM
tmtm:
	li $t9, 0		# t9 will be i 
	li $t5, 0		# for max
	li $t4, 0 		# for min
	
	move $t8, $a0
	move $t6, $a0
	
	li $s4, 2		# keep constant for thirds check
	
	tmtmloop1:
		bge $t9, $a1, tmtmloop1done
		
		lw $t0, ($t8)	
		
		li $t7, 0		# t7 will be j 
		move $t6, $a0
		
		tmtmloop2:
			bge $t7, $a1, tmtmloop2done
			
			beq $t7, $t9, tmtmequalind
			
			lw $t1, ($t6)
			
			# First Check
			ble $t1, $t0, tmtmcheckFM		# if t1, s less than t0 then go to check if its greater than
			# else we know t0 is greater than t1
				addi $t4, $t4, 1
				addi $t7, $t7, 1
				addi $t6, $t6, 4
				j tmtmloop2
			
			# Second Check
			tmtmcheckFM:	beq $t1, $t0, tmtmeqVal
				addi $t5, $t5, 1
				addi $t7, $t7, 1
				addi $t6, $t6, 4
				j tmtmloop2
			# If Values are Equal
			tmtmeqVal:
				addi $t7, $t7, 1
				addi $t6, $t6, 4
				j tmtmloop2
			
			# If indexes are Equal
			tmtmequalind:
				addi $t7, $t7, 1
				addi $t6, $t6, 4
				j tmtmloop2
				
		tmtmloop2done:
			beq $t4, $s4, tmtmisMax
			beq $t5, $s4, tmtmisMin
		
		tmtmcont:
			li $t4, 0
			li $t5, 0
			li $t6, 0
			li $t7, 0
			li $t1, 0
			addi $t9, $t9, 1
			addi $t8, $t8, 4
			j tmtmloop1
			
			tmtmisMin:
				move $v0, $t0
				j tmtmcont
			
			tmtmisMax:
				move $v1, $t0
				beq $t5, $s4, tmtmisMin		# if t0 is also the third min jump to isMin
				j tmtmcont

	tmtmloop1done:
		li $t0, 0
		li $t8, 0
		li $t9, 0
		li $s4, 0
		
		jr $ra

##------------------------------------------------------------------------------------
## MODE SUBPROGRAM
mode:

	li $t9, 0		# t9 will be i and t8 will be 4 times t9 for address
	li $t4, 0		# for occurences
	li $t5, 0 		# for max occ
	li $t2, 0		# current mode
	move $t8, $a0	# address for second loop
	move $t6, $a0	# address for first loop
	
	#for first iteration set mode to first value
	lw $t2, ($t6)
	
	modeLoop1:
		bge $t9, $a1, modeLoop1done
		
		lw $t0, ($t6)	
		
		li $t7, 0		# t7 will be j and t6 will be 4 times t7 for address
		move $t8, $s0
		modeLoop2:
			bge $t7, $a1, modeLoop2done
			
			beq $t7, $t9, modeEqualind		# if indexes are equal jump there
			
			lw $t1, ($t8)
			
			bne $t0, $t1, modeNE
			
			addi $t4, $t4, 1				# If there is another one of the same value add 1 to occurences counter
			addi $t7, $t7, 1				# increase loop counter
			addi $t8, $t8, 4				# increase address
			j modeLoop2
			
			modeNE:
				addi $t8, $t8, 4			# increase address
				addi $t7, $t7, 1			# increase loop counter
				j modeLoop2
			
			modeEqualind:		# to skip unnecessary check
				addi $t8, $t8, 4			# increase address
				addi $t7, $t7, 1			# increase loop counter
				j modeLoop2
				
		modeLoop2done:
			ble $t4, $t5, NEO		# if t4 count is not higher than t5 then it is not enough occurences
			
			move $t5, $t4		# if it is, make most occurences count t5
			move $t2, $t0		# and set mode to t0
			
			j occNE
			
			NEO:
				bne $t4, $t5, occNE	# if occurences are equal get under here
				
					bge $t0, $t2, occNE	# if occcurences are equal and t0 is less than t2
					
					move $t2, $t0		# set mode to t0
				occNE:
				
					li $t7, 0
					#li $t6, 0
					li $t4, 0
					li $t1, 0
					
					move $s5, $s0		# reset temporary address to array's start
					
					addi $t6, $t6, 4
					addi $t9, $t9, 1
					j modeLoop1
					
	modeLoop1done:
		move $v0, $t2
		
		li $t0, 0
		li $t5, 0
		li $t2, 0
		li $t9, 0
		#li $t8, 0
		
		li $t6, 0
		li $t8, 0

		jr $ra

##------------------------------------------------------------------------------------
## PRINT SUBPROGRAM

print:
	li $t9,0
	move $t2, $a0
	
	ploop:
		bge $t9, $a1, ploopdone
		
		lw $t0, ($t2)
		
		move $a0, $t0	# print result
		li $v0, 1
		syscall
		
		la $a0, endl
		li $v0, 4
		syscall
		
		addi $t9, $t9, 1
		addi $t2, $t2, 4
		
		j ploop
	
	ploopdone:
		li $t9, 0
		li $t0, 0
		li $t2, 0
			
		jr $ra

##------------------------------------------------------------------------------------
##------------------------------------------------------------------------------------
##------------------------------------------------------------------------------------	
	
	
		

#################################
#					 	#
#     	 data segment		#
#						#
#################################

	.data
arr:			.space 400
prompt1:		.asciiz "Enter array length: "
prompt2:		.asciiz "Enter integers to add into the indexes one by one: "

prompt4:		.asciiz "Size must be bigger than 0!"

msg1:			.asciiz "Welcome to Lab01! Here are your choices! \n"
msg2:			.asciiz "1 - Bubbe sort the array.\n"
msg3:			.asciiz "2 - Find third minimum and third maxmums of the array. \n"
msg4:			.asciiz "3 - Find the mode of the array (Most occuring value, if two values have same occurences minimum is returned). \n"
msg5: 		.asciiz "4 - Print array. \n"
msg6:			.asciiz "5 - Quit. \n"

msg6.5:		.asciiz "Enter your choice: "

msg7:			.asciiz "Select one of the choices!! \n"

msgmode:		.asciiz "Mode is: "

msgmin:			.asciiz "Third min is: "
msgmax:			.asciiz "Third max is: "




endl:			.asciiz "\n"

##
## END OF monitor
