begin
; ----------------------------------------------
first_term = 1
common_difference = 3
last_term = 1000

; Calculate ans of sequence
ans = 0     ; Initialize sum variable
do i = first_term, last_term, common_difference
  ans = ans + i
end do

; Print the result
print(ans)

; -------------------------------------------------

; Define the dimensions of the array
D1 = 2
D2 = 3

; Create the array variable with _FillValue and type of float
myvar_1 = new((/D1,D2/), "float")
myvar_1@_FillValue = -999

myvar_1!0 = "lat"
myvar_1!1 = "lon"

myvar_2 = (/(/1., 1./), (/2., 2./), (/3., 3./)/)
myvar_2!0 = "lat"
myvar_2!1 = "lon"
; Print the variable information
print(myvar_1)
print(myvar_2)
myvar_2(:, 1) = 7
print(myvar_2)

end

