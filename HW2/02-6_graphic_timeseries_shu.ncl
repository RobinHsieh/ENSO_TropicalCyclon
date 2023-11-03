begin
;================================================
;open file
;================================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/SST/"
 fns = systemfunc("ls "+diri+"ERAITM_Mon_{2001..2010}_SST_361x720.nc")
 f = addfiles(fns,"r")
print(f[0])
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
;x=fspan(1979,2018,(2018-1979+1)*12)
x = fspan(2001, 2010, (2010 - 2001 + 1)*12)
;================================================
;draw
;================================================

 diro = "/data/course/2023_NCL_course/student/wlhsieh/HW2/"
 optname = "02-6_SSTA_time_series"
 wks = gsn_open_wks("pdf",diro+optname)

 plot = gsn_csm_xy(wks,x,index,False)
;----------------------------------------------------------------1 False (Default)

 res = True
 res@gsnAboveYRefLineColor = "red"              ; above ref line fill red
 res@gsnBelowYRefLineColor = "blue"             ; below ref line fill blue
 res@gsnYRefLine           = 0.0                ; create a reference line

 plot = gsn_csm_xy(wks,x,index,res)
;----------------------------------------------------------------2 Ref series

 res@vpXF      = 0.1
 res@vpYF      = 0.7
 res@vpWidthF  = 0.8
 res@vpHeightF = 0.4
 res@tmXTOn = False
 res@tmYROn = False


 plot = gsn_csm_xy(wks,x,index,res)
;----------------------------------------------------------------3 window size&ratio

 res@trYMaxF = 3.5
 res@trYMinF = -3.5
 res@tiMainString = "SSTA in nino3.4 region"
 res@tiYAxisSide = "Right"
 res@tiYAxisString = "degrees C"

 plot = gsn_csm_xy(wks,x,index,res)
;----------------------------------------------------------------4 Y-axis string&value

 res@tmXBMode        = "Explicit"
 res@tmXBValues      = (/1983,1998,2016/)
 res@tmXBLabels      = "" + res@tmXBValues
 res@tmXBMinorValues = ispan(1979,2018,1)               ;If not set, minor tick marks will be absent from the bottom X Axis.

 plot = gsn_csm_xy(wks,x,index,res)
;----------------------------------------------------------------5 value labels

 res@tmBorderThicknessF = 5.
 res@tmXBMajorThicknessF = 5.
 res@tmXBMinorThicknessF = 2.

 plot = gsn_csm_xy(wks,x,index,res)
;----------------------------------------------------------------6 tick thinkness




end

