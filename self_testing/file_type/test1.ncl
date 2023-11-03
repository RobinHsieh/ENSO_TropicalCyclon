begin

; Create a 10x10 array of temperature values
t = random_normal(0, 10, (/10, 10/))

; Create coordinate variables for the x and y dimensions

;a = (/1, 2/)
b = (/(/3, 0/), (/4, 0/)/)
;print(a)
bs = b(:,0)
;print(bs)
; a := array_append_record(a, bs, 0)
;print(a)

; Assume you have a two-dimensional variable called 'data'
data = (/ (/1, 2, 3/), (/4, 5, 6/) /)   ; data[2,3] 

; Assign the second column of 'data' to a one-dimensional variable called 'column'
column = data(:,1)                      ; column[2]

print(column)

c = (/1, 2, 3/)
c@_FillValue = 7
print(c)
delete(c@_FillValue)
print(c)

if(c(1) .lt. 3) then
  print("no whf?")
end if

end
