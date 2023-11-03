
;************************************************************
;       test.ncl: test ex0.so and ex0_fun.so
;************************************************************
external mySum "./ex0.so"
external mySum2 "./ex0_fun.so"
begin

;---Test fortran subroutine (ex0.so)-------------------
	a = 5
	b = 0
	mySum::ex0(a,b)
	print("b = "+b)


;/;
;---Test fortran function (ex0_fun.so)-------------------
	c = mySum2::ex0_fun(a)
	print("c = "+c)
;/

end
