begin

;=========================================================
;open file
;=========================================================

 diri = "/data/course/TOGA-COARE/TOGA_IFA/" ; directory input
 fname = "fields.txt" ; file name


;=========================================================
;read data
;=========================================================

nrow = numAsciiRow(diri + fname)
ncol = numAsciiCol(diri + fname)

data = asciiread(diri + fname, nrow/480, "string")







   
;=========================================================
;open data
;=========================================================

 p = new(nrow/480-1,"float")   ;第一行是時間
 z = new(nrow/480-1,"float")
 u = new(nrow/480-1,"float")
 v = new(nrow/480-1,"float")

do i = 1, 41
    element := str_split(data(i), " ")
    p(i - 1) = tofloat(element(0))
    z(i - 1) = tofloat(element(1))
    u(i - 1) = tofloat(element(2))
    v(i - 1) = tofloat(element(3))
end do









;=========================================================
;write information     命名 綁定
;=========================================================

 p!0 = "level"
 p&level = p

 copy_VarMeta(p, u) ;copy the attribute, named dimensions and coordinate variables



 u@units = "m/s"
 u@longname = "u component"
 u@data = "TOGA"

 printVarSummary(u)

end
