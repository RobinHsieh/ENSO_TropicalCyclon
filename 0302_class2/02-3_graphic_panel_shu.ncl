begin
;============================================
;open file
;============================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Inter-tropical/Pre_T/"
 fn = systemfunc("ls "+diri+"*.nc")
 f = addfiles(fn(:),"r")

 number_file = dimsizes(f)

;============================================
;set information
;============================================

 latN = 15.
 latS = -15.
 lonW = 0.
 lonE = 360.
 mon = ispan(1,12,1)

 lat = f[0]->lat
 lon = f[0]->lon

 nlat = dimsizes(lat)
 nlon = dimsizes(lon)

;============================================
;read data
;============================================

 pre = f[:]->tp(:,{latS:latN},{lonW:lonE})

 printVarSummary(pre)

time=yyyymm_time(2001,2010,"integer")
ntime=dimsizes(time)

pre!0="time"
pre&time=time

;============================================
;cul anomaly
;============================================


pre_anly=(dim_rmvmean_n_Wrap(pre,0))*(1000)
copy_VarCoords(pre,pre_anly)
pre_anly@units="mm"
printVarSummary(pre_anly)

;============================================
;draw : plot pre anomalies (2001/01)
;============================================

 diro = "/data/wltsai/2023_NCL_course/0302_class2/"
 optname = "02-3_pre_panel"
 wks = gsn_open_wks("pdf",diro+optname)

 res = True
 res@mpFillOn = True
 res@mpMaxLatF = latN
 res@mpMinLatF = latS
 res@mpMaxLonF = 300.
 res@mpMinLonF = 120.
 res@mpCenterLonF = 210.

 res@cnFillOn = True
 res@cnLinesOn = False
 res@cnFillDrawOrder = "Predraw"
 res@cnFillPalette = "cmp_b2r"

 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF = -10.
 res@cnMaxLevelValF = 10.
 res@cnLevelSpacingF = 0.5
 plot = gsn_csm_contour_map(wks,pre_anly(0,:,:),res)

;============================================
;panel : plot pre anomalies from (2001/01) to (2001/12)
;============================================

 plot_12mon = new(12,graphic)

 monti = (/"January","February","March","April","May","June",\
           "July","August","September","October","November","December"/)

    res@gsnFrame = False
    res@gsnDraw = False
 do i = 0,12-1

    res@tiMainString = monti(i)
    plot_12mon(i) = gsn_csm_contour_map(wks,pre_anly(i,:,:),res)

 end do

 panel_res = True
 gsn_panel(wks,plot_12mon,(/4,3/),panel_res)
;----------------------------------------------------------------2 gsn_panel
;Just wanna turn off label bar...but we need to re-plot again

 do i = 0,12-1

    res@lbLabelBarOn = False
    res@tiMainString = monti(i)
    res@tiMainFontHeightF = 0.03
    plot_12mon(i) = gsn_csm_contour_map(wks,pre_anly(i,:,:),res)

 end do

 panel_res@gsnPanelLabelBar = True

 gsn_panel(wks,plot_12mon,(/4,3/),panel_res)


;----------------------------------------------------------------3 gsn_legend

 panel_res@gsnPanelYWhiteSpacePercent = 10.
 panel_res@gsnPanelMainString = "2010 precipitation anomaly"

 gsn_panel(wks,plot_12mon,(/4,3/),panel_res)

;----------------------------------------------------------------4 white percent

 panel_res@lbLabelFontHeightF = 0.015
 panel_res@lbBoxSeparatorLinesOn = False
 panel_res@pmLabelBarWidthF = 0.9
 panel_res@lbBottomMarginF = -0.2

 gsn_panel(wks,plot_12mon,(/4,3/),panel_res)



end

