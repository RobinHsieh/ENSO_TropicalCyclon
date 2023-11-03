;*****************************************************
;   test.ncl: test input array to Fortran subroutine
;*****************************************************

external ex2_sum "./ex2_sum.so"
begin

;--- Test: Input: 2-dimensional matrix
	c = 5
	d = 10
	a = new((/d,c/), float)
	do i = 1, c
		a(:,i-1) = i
	end do
	b = new(c, float)
	ex2_sum::ex2_sum(a,b,c,d)



end
