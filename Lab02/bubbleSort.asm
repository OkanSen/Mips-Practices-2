#bubblesort
#Okan Sen
##
## Notes for coder: Don't use this read array for monitor
#################################

	.text		
	.globl __start	

__start:
	li $s4, 1		# a constant
	
readArray:
	##---------------------------------------------------SET ARRAY SIZE HERE------------------------------------------------------
	la $a0, prompt1		# ask for array size
	li $v0, 4		# syscall 4 prints the string
	syscall

	li $v0, 5		# syscall 5 reads an integer
	syscall
	
	blt $v0, $s4, failedSize
	
	move $s1, $v0		# move input size to s1	
	move $a0, $s1		# storing size in a0 so we can allocate dynamic memory for how many bytes of space we need
	li $v0, 9 	
	syscall
	move $s0, $v0		# we must store v0 in s0 so that we do not lose the dynamic array address	
	move $v1, $s1		# after that simply place array size number to be stored in v1
	
	# s0 = array address, s1 = array size
	##---------------------------------------------------   DO NOT TOUCH    ------------------------------------------------------
	## Setting loop and limit variables
	li $t9, 0
	li $s7, 100
	##---------------------------------------------------   DO NOT TOUCH    ------------------------------------------------------
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
	
	#bgt $t1,$s7, failedArr
	#blt $t1,$0, failedArr
	
	sw $t1, ($t4)	# put t1 into array's t4 th index
	
	addi $t9, $t9, 1		# add 1 to loop counter
	addi $t4, $t4, 4
	
	blt $t9, $s1, lNums	# if t9 (counter is less than the array size loop again
	#LOOP ENDED
	
	li $t9, 0
	li $t4, 0
	li $t1, 0
	
	
	move $a0, $s0
	move $a1, $s1
	jal bubblesort
	
exit:
	li $v0,10		# system call to exit
	syscall			# bye bye	
	

failedArr:
	la $a0, prompt3		# output prompt message on terminal
	li $v0,4		# syscall 4 prints the string
	syscall	
	
	la $a0, endl		# output prompt message on terminal
	li $v0, 4		# syscall 4 prints the string
	syscall	
	
	j lNums	
# ------------------------------------------------------------------------

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
prompt2:		.asciiz "Enter integers to add into the indexes one by one[0,100]: "
prompt3:		.asciiz "Enter numbers between [0,100]!"
prompt4:		.asciiz "Size must be bigger than 0!"

msg1:			.asciiz "Address is: "
msg2:			.asciiz "Size is: "



endl:			.asciiz "\n"

##
## END OF bubblesort
