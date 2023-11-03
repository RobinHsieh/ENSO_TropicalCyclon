;-------------------------------------------
;   Function 
;-------------------------------------------
    function MySumF(a:integer)
    begin

    b = 0
    do i = 1, a
      b = b+i
    end do
    return(b)

    end

;-------------------------------------------
;   Procedure 
;-------------------------------------------
    procedure MySumP(a:integer)
    begin

    b = 0
    do i = 1, a
      b = b+i
    end do
    print(b)

    end 
    
    procedure MySumP2(a:integer,b:integer)
    begin

    b = 0
    do i = 1, a
      b = b+i
    end do
    return(b)

    end 
;****************************************
;   Main Program
;****************************************
;load "./sum.ncl"
begin


    a = 5
;/;
    b = MySumF(a)
    print(b)
exit

;MySumP(a)
exit

;/
b = 0
MySumP2(a,b)
print(b)



end
