begin

;====================================================================
;open file
;====================================================================

 var = (/"T/","SST/"/)
 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/"

 fn_T = systemfunc("ls "+diri+var(0)+"*.nc")
 fn_SST = systemfunc("ls "+diri+var(1)+"*.nc")

 f_T = addfiles(fn_T(:),"r")
 f_SST = addfiles(fn_SST(:),"r")

 number_file = dimsizes(fn_T)

;====================================================================
;read information
;====================================================================

 latN = 15.
 latS = -15.
 lonW = 0.
 lonE = 360.

 lon = f_T[0]->longitude({lonW:lonE})
 lat = f_T[0]->latitude({latS:latN})
 time = cd_calendar(f_T[:]->time(:),-1)

 nlon = dimsizes(lon)
 nlat = dimsizes(lat)
 ntime = dimsizes(time)

;====================================================================
;read data
;====================================================================

 T = new((/ntime,nlat,nlon/),"float")
 SST = new((/ntime,nlat,nlon/),"float")

 do i = 0,number_file-1
    T(12*i:12*i+11,:,:) = short2flt(f_T[i]->t(:,{1000},{latS:latN},{lonW:lonE}))
    SST(12*i:12*i+11,:,:) = short2flt(f_SST[i]->sst(:,{latS:latN},{lonW:lonE}))
 end do

 T&time = time
 printVarSummary(T)

 SST&time = time
 printVarSummary(SST)

;====================================================================
;cul anomaly
;====================================================================

T_anly=dim_rmvmean_n_Wrap(T,0)
printVarSummary(T_anly)
SST_anly=dim_rmvmean_n_Wrap(SST,0)
printVarSummary(SST_anly)
delete([/T,SST/])
;====================================================================
;draw
;====================================================================

 diro = "/data/wltsai/2023_NCL_course/0302_class2/"
 optname = "02-2_SSTA_TA_overlay"
 wks = gsn_open_wks("pdf",diro+optname)

 res = True
 res@mpMaxLatF = latN
 res@mpMinLatF = latS
 res@mpMaxLonF = 300.
 res@mpMinLonF = 120.
 res@mpCenterLonF = 180.
 res@mpFillOn = True
 res@cnFillDrawOrder = "Predraw"


 res@cnFillOn = True
 res@cnLinesOn = False
 res@pmLabelBarOrthogonalPosF = 0.065
 res@lbLabelOffsetF = 0.15

 res@cnLevelSelectionMode = "ManualLevels"
 res@cnMinLevelValF = -4.
 res@cnMaxLevelValF = 4.
 res@cnLevelSpacingF = 0.2

 res@tiMainString = "1983/01 TA & SSTA"
 res@gsnLeftString = " "
 res@gsnRightString = "deg. C"

 plot = gsn_csm_contour_map(wks,SST_anly({198301},:,:),res)
 ;----------------------------------------------------------------1 copy from 2D_contour_SSTA

 res2 = True
 res2@gsnFrame = False
 res2@gsnDraw = False
 res2@cnLevelSelectionMode = "ManualLevels"
 res2@cnLevelSpacingF = 0.5
 res2@cnInfoLabelOn = False

 plot2 = gsn_csm_contour(wks,T_anly({198301},:,:),res2)
 ;----------------------------------------------------------------1 copy from 2D_contour_TA

overlay(plot,plot2)
draw(plot)
frame(wks)

 ;----------------------------------------------------------------3 overlay
 print("total time (sec) : "+get_cpu_time())



end

