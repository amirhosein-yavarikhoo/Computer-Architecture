addi R1,R0,1000 #first data location initialization
lw R2,0(R) #loading first data and considering it the min value
addi R3,R0,0 #R3: index of the min data in list
addi R4,R0,0 #R4 : for loop index
loop: addi R1,R1,4 #next data
addi R4,R4,1 #i++
slti R5,R4,20 #check to see if list is finished
beq R5,R0,end #if i=20, program is done
lw R6,0(R1) #loading data to compare it with current min 
slt R7,R6,R2 #comparing
beq R5,R0,loop #if it is not lower than the current min, go to the next data
add R2,R0,R6 #replacing new min value
add R3,R6,R4 #replacing new index
j loop
end: sw R2,2000(R0) #storing min value
sw R3,2004(R0) #storing index of the min value
