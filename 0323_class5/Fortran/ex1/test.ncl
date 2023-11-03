;*****************************************************
;   test.ncl: test input array to Fortran subroutine
;*****************************************************

external ex1_sum "./ex1_sum.so"
begin

;--- Test: Input: 2-dimensional matrix
	a = new((/5,2/), float)
	a(:,0) = 1
	a(:,1) = 2
	printVarSummary(a)
	b = new(2, float)
	ex1_sum::ex1_sum(a,b)
	print("ex1: "+b(1))



end
