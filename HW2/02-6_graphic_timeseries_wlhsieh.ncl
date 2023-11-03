begin
;================================================
;open file
;================================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Inter-tropical/Pre_T/"
 fns = systemfunc("ls "+diri+"*.nc")
;print(fns) ;test
 f = addfiles(fns,"r")
;print(f) ;test

 number_file = dimsizes(fns)
;print(number_file) ;test
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

print(f[0]) ;test
 lon = f[0]->lon({lonW:lonE})
 lat = f[0]->lat({latS:latN})

 nlon = dimsizes(lon)
 nlat = dimsizes(lat)

 tp = new((/12*number_file, nlat, nlon/), "float")

;print(f[0]->tp(:,{latS:latN},{lonW:lonE})) ;test

 do i = 0, number_file - 1
    tp(12*i:12*i+11, :, :) = f[i]->tp(:, {latS:latN}, {lonW:lonE}) * 1000
    tp@units = "mm"
 end do

; printVarSummary(sst)
; printVarSummary(time)

;================================================
;cul index
;================================================
;print(tp) ;test
tpa = dim_rmvmean_n_Wrap(tp, 0)
;print(tpa) ;test
index = dim_avg_n_Wrap(tpa, (/1, 2/))
printMinMax(index, False)
x = fspan(2001, 2010, (2010 - 2001 + 1)*12)
;print(index) ;test
;print(x) ;test
;================================================
;draw
;================================================

 diro = "/data/course/2023_NCL_course/student/wlhsieh/HW2/"
 optname = "02-6_SSPA_time_series"
 wks = gsn_open_wks("pdf", diro+optname)

 plot = gsn_csm_xy(wks, x, index, False)
;----------------------------------------------------------------1 False (Default)

 res = True
 res@gsnAboveYRefLineColor = "red"              ; above ref line fill red
 res@gsnBelowYRefLineColor = "blue"             ; below ref line fill blue
 res@gsnYRefLine           = 0.0                ; create a reference line

 plot = gsn_csm_xy(wks, x, index, res)
;----------------------------------------------------------------2 Ref series

 res@vpXF      = 0.1
 res@vpYF      = 0.7
 res@vpWidthF  = 0.8
 res@vpHeightF = 0.4
 res@tmXTOn = False
 res@tmYROn = False


 plot = gsn_csm_xy(wks, x, index, res)
;----------------------------------------------------------------3 window size&ratio

 res@trYMaxF = 6.5
 res@trYMinF = -4.5
 res@tiMainString = "SSPA(precipitation avg) in nino3.4 region"
 res@tiYAxisSide = "Right"
 res@tiYAxisString = "mm"

 plot = gsn_csm_xy(wks, x, index, res)
;----------------------------------------------------------------4 Y-axis string&value

 res@tmXBMode        = "Explicit" ;tm = TickMark
 res@tmXBValues      = (/2001, 2005, 2009/)
 res@tmXBLabels      = "" + res@tmXBValues
 res@tmXBMinorValues = ispan(2001, 2010, 1)  ;If not set, minor tick marks will be absent from the bottom X Axis.

 plot = gsn_csm_xy(wks, x, index, res)
;----------------------------------------------------------------5 value labels

 res@tmBorderThicknessF = 5.
 res@tmXBMajorThicknessF = 2.
 res@tmXBMinorThicknessF = 2.

 plot = gsn_csm_xy(wks, x, index, res)
;----------------------------------------------------------------6 tick thinkness

end

