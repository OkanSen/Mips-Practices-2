#print
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
	jal print
	
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
prompt2:		.asciiz "Enter integers to add into the indexes one by one[0,100]: "
prompt3:		.asciiz "Enter numbers between [0,100]!"
prompt4:		.asciiz "Size must be bigger than 0!"

msg1:			.asciiz "Address is: "
msg2:			.asciiz "Size is: "





endl:			.asciiz "\n"

##
## END OF print
