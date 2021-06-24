#mode
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
	
	bgt $t1,$s7, failedArr
	blt $t1,$0, failedArr
		
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
	jal mode
	
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


mode:

	li $t9, 0		# t9 will be i
	li $t4, 0		# for occurences
	li $t5, 0 		# for max occ
	li $t2, 0		# current mode
	
	move $t8, $a0
	move $t6, $a0
	#for first iteration set mode to first value
	lw $t2, ($t8)
	modeLoop1:
		bge $t9, $a1, modeLoop1done
		
		lw $t0, ($t8)	
		
		li $t7, 0		# t7 will be j 
		move $t6, $a0
		
		modeLoop2:
			bge $t7, $a1, modeLoop2done
			
			
			beq $t7, $t9, modeEqualind		# if indexes are equal jump there
			
			lw $t1, ($t6)
			
			bne $t0, $t1, modeNE
			
			addi $t4, $t4, 1
			addi $t7, $t7, 1
			addi $t6, $t6, 4
			j modeLoop2
			
			modeNE:
				addi $t7, $t7, 1
				addi $t6, $t6, 4
				j modeLoop2
			
			modeEqualind:		# to skip unnecessary check
				addi $t7, $t7, 1
				addi $t6, $t6, 4
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
					li $t6, 0
					li $t4, 0
					li $t1, 0
					
					addi $t9, $t9, 1
					addi $t8, $t8, 4
					j modeLoop1
					
	modeLoop1done:
		move $v0, $t2
		
		li $t0, 0
		li $t5, 0
		li $t2, 0
		li $t9, 0
		li $t8, 0

		jr $ra



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
## END OF mode
