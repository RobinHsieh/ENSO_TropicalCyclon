begin

;==========================================
;open file
;==========================================

 diri = "/data/course/ASCII/"
 path = (/"2018_TC_JTWC_Lat/","2018_TC_JTWC_Lon/"/)

;==========================================
;read lat & lon (1980)
;==========================================

year_start = 1980 
year_end = 2015

 lat_all = new(20*3*(year_end - year_start + 1), "float")  ;只看3個月
 lon_all = new(20*3*(year_end - year_start + 1), "float")

 do year = year_start, year_end

    lat = asciiread(diri+path(0)+"Lat"+year+".txt",(/20,12/),"float"); year, month
    lon = asciiread(diri+path(1)+"Lon"+year+".txt",(/20,12/),"float")

    lat@_FillValue = 9453.
    lon@_FillValue = 9453.

    i = year - year_start
    lat_all(i+59*i:60*i+59) = ndtooned(lat(:,9:11))   ;把資料變成一維
    lon_all(i+59*i:60*i+59) = ndtooned(lon(:,9:11))

 end do

 lat_all!0 = "lat"
 lon_all!0 = "lon"
print(lat_all(0:10))
;print(lat_all&lat(0:10)) ; wrong 
 lat_all&lat = lat_all
 lon_all&lon = lon_all
print(lat_all(0:10))
print(lat_all&lat(0:10))
 printVarSummary(lat_all)

;==========================================
;cul density
;==========================================

 latN = 35.
 latS = 0.
 lonW = 90.
 lonE = 210.

 dlat = 2.5
 dlon = 2.5                      ;格點大小(2.5x2.5)

 nlat = tointeger((latN - latS) / dlat) ; convert into integer
 nlon = tointeger((lonE - lonW) / dlon)

 lat_den = fspan(latS, latN, nlat)
 lon_den = fspan(lonW, lonE, nlon)
 
 density = new((/nlat, nlon/), "float") 
 density(:, :) = 0 ; initial value are 0s
 
 do i = 0, dimsizes(lat_all) - 1
   if(.not. all(ismissing(lat_all(i))))then ; exclude missing values
     do j = 0, nlat - 1
       if(lat_all(i) .gt. (lat_den(j) - dlat) .and. lat_all(i) .le. (lat_den(j) + dlat)) then ;選定符合一定lat區間的資料
         do k = 0, nlon - 1
           if(lon_all(i) .gt. (lon_den(k) - dlon) .and. lon_all(i) .le. (lon_den(k) + dlon)) then ;選定符合一定lon區間的資料
             density(j, k) = density(j, k) + 1
           end if
         end do
       end if
     end do
   end if
 end do
 
 density = nameDim(density, (/"lat", "lon"/), "density", "")
 density&lat = lat_den
 density&lon = lon_den

 density&lat@units = "degree_north"
 density&lon@units = "degree_east"

;  printVarSummary(density)
;  printMinMax(density,False)

  ;二維的命名,最後一格是單位




 
;==========================================
;set res 
;==========================================


 diro = "/data/course/2023_NCL_course/student/wlhsieh/HW3/"
 optname = "TC_density"
 wks = gsn_open_wks("png",diro+optname)

 res = True
 
 res@mpMaxLatF = latN
 res@mpMinLatF = latS
 res@mpMaxLonF = lonE
 res@mpMinLonF = lonW
 res@mpCenterLonF = (lonW+lonE)/2

 res@gsnAddCyclic = False

 res@cnFillOn = True
 res@cnFillMode = "RasterFill"
 res@cnFillPalette  = "MPL_Purples"
 res@cnLevelSelectionMode = "ManualLevels"
 res@cnLinesOn = False
 res@cnLineLabelsOn = False
 res@cnInfoLabelOn   = False
 res@cnMinLevelValF = 0
 res@cnMaxLevelValF = 20
 res@cnLevelSpacingF = 1

 plot = gsn_csm_contour_map(wks,density,res)
 

end

