#thirdMinThirdMax
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
	jal tmtm
	
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
			blt $t1, $t0, tmtmcheckFM		# if t1, s less than t0 then go to check if its greater than
			bgt $t1, $t0, tmtmcheckFG
				# if the values are equal just get back to loop with increased counters
				addi $t7, $t7, 1	# increase second loop counter
				addi $t6, $t6, 4	# increase second loop address
				j tmtmloop2
			
			tmtmcheckFG:
			# else we know t0 is greater than t1
				addi $t4, $t4, 1	# add for min count
				addi $t7, $t7, 1	# increase second loop counter
				addi $t6, $t6, 4	# increase second loop address
				j tmtmloop2
			
			# Second Check
			tmtmcheckFM:
				addi $t5, $t5, 1	# add for max count
				addi $t7, $t7, 1	# increase second loop counter
				addi $t6, $t6, 4	# increase second loop address
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
## END OF thirdMinThirdMax
