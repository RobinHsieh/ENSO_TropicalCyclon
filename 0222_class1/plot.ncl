begin

;=============================
; Open file
;=============================

  dir = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/T"
  fs  = systemfunc("ls "+dir+"/*.nc")
  f   = addfiles(fs,"r")
  ListSetType(f,"cat") ;如果是cat的形式儲存資料可以不用打沒關係~

;=============================
; Read
;=============================
  
  latN = 20.
  latS = -20.

  lat  = f[0]->latitude({latS:latN})
  lon  = f[0]->longitude
  time = cd_calendar(f[:]->time,0) ;把日期轉換成我們看得懂的整數型態
                                   ;詳細內容可以去NCL官網查ㄛ
;print(time)

  Time = ind(time(:,0) .ge. 1980 .and. time(:,0) .le. 2009) ;時間只取1980到2009年
  T    = short2flt(f[:]->t(Time,{1000},{latS:latN},:))      ;只要30年, 近地表, 南北緯20度之間的資料, 並同時轉成浮點數

;printVarSummary(T)

;=============================
; Analysis
;=============================

  T_mean = dim_avg_n_Wrap(T,0) ;將第0維度值平均

;=============================
; Plot
;=============================

  wks = gsn_open_wks("png","T_mean")

  res                          = True

;-----String-----

  res@tiMainString             = "Mean-state T (1000-hPa)"
  res@tiMainFontHeightF        = 0.015

  res@gsnLeftString            = "ERA-Interim"
  res@gsnLeftStringFontHeightF = 0.012
  res@gsnRightString           = "K" 
  res@gsnLeftStringFontHeightF = 0.012

;-----Contour-----

  res@cnFillOn                 = True
  res@cnLinesOn                = False
  res@cnLineLabelsOn           = False
  res@cnInfoLabelOn            = False

;-----Color_bar-----

  res@cnLevelSelectionMode     = "ManualLevels"
  res@cnMinLevelValF           = 295.
  res@cnMaxLevelValF           = 303.
  res@cnLevelSpacingF          = 1.
  res@cnFillPalette            = "cmp_b2r"

  res@lbLabelFontHeightF       = 0.012
  res@pmLabelBarHeightF        = 0.05
  res@pmLabelBarWidthF         = 0.6
  res@pmLabelBarOrthogonalPosF = 0.2

;-----Tickmarks-----

  res@tmXTOn                   = False
  res@tmYROn                   = False

  res@tmXBLabelFontHeightF     = 0.012
  res@tmYLLabelFontHeightF     = 0.012

  res@mpCenterLonF             = 200.
  res@mpMinLatF                = latS
  res@mpMaxLatF                = latN
  res@mpMinLonF                = 120.
  res@mpMaxLonF                = 280.

  contour = gsn_csm_contour_map(wks,T_mean,res)

end
