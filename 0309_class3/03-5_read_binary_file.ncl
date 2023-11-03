begin
;=========================================================
;open file
;=========================================================

 diri = "/data/course/2023_NCL_course/TA/0309_class3/"
 fname ="fnldata.dat"

;=========================================================
;information
;=========================================================

 nvar = 3

 nlev = 3
 nlat = 46
 nlon = 91

 dlat = 1.
 dlon = dlat

 level = (/200.,500.,1000./)

 y = ispan(1,nlat,1)
 lat = 20. + (y - 1)*dlat
 lat@units = "degree_north"

 x = ispan(1,nlon,1)
 lon = 80. + (x - 1)*dlon
 lon@units = "degree_east"

;=========================================================
;open matrix
;=========================================================

U = new((/nlev, nlat, nlon/), "float")
U = nameDim(U, (/"level", "lat", "lon"/), "U component", "m/s")

U&level = level
U&lat = lat
U&lon = lon

U@FillValue = 1.e30

V = new((/nlev, nlat, nlon/), "float")
V = nameDim(V, (/"level", "lat", "lon"/), "V component", "m/s")

V&level = level
V&lat = lat
V&lon = lon

V@FillValue = 1.e30


;=========================================================
;read data
;Reads binary records written by a Fortran direct access write or C write.
;=========================================================

U(:, :, :) = fbindirread(diri+fname, 1, (/nlev, nlat, nlon/), "float")
V(:, :, :) = fbindirread(diri+fname, 1, (/nlev, nlat, nlon/), "float")

printVarSummary(U)

 end



