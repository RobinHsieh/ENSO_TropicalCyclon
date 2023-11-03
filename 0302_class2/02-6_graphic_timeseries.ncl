begin
;================================================
;open file
;================================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/SST/"
 fns = systemfunc("ls "+diri+"*.nc")
 f = addfiles(fns,"r")

 number_file = dimsizes(fns)

;================================================
;nino3.4 region
;================================================

 latN = 5.
 latS = -5.
 lonW = 190.
 lonE = 240.

;================================================
;read data
;================================================

 lon = f[0]->longitude({lonW:lonE})
 lat = f[0]->latitude({latS:latN})

 time = cd_calendar(f[:]->time,-1)
 time!0 = "time"
 time&time = time

 nlon = dimsizes(lon)
 nlat = dimsizes(lat)
 ntime = dimsizes(time)

 sst = new((/ntime,nlat,nlon/),"float")

 do i = 0,number_file-1
    sst(12*i:12*i+11,:,:) = short2flt(f[i]->sst(:,{latS:latN},{lonW:lonE}))
 end do

 sst&time = time

; printVarSummary(sst)
; printVarSummary(time)

;================================================
;cul index
;================================================

ssta=dim_rmvmean_n_Wrap(sst,0)
index=dim_avg_n_Wrap(ssta,(/1,2/))
printMinMax(index,False)
x=fspan(1979,2018,(2018-1979+1)*12)
;================================================
;draw
;================================================

 diro = "/data/course/2023_NCL_course/student/" + ""
 optname = "02-6_SSTA_time_series"
 wks = gsn_open_wks("pdf",diro+optname)

 plot = gsn_csm_xy(wks,x,index,False)
;----------------------------------------------------------------1 False (Default)
  res = True

;----------------------------------------------------------------2 Ref series

;----------------------------------------------------------------3 window size&ratio

;----------------------------------------------------------------4 Y-axis string&value

;----------------------------------------------------------------5 value labels


;----------------------------------------------------------------6 tick thinkness



end

