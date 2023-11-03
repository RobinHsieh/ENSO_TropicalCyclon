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

;====================================================================
;read data
;====================================================================

 T = short2flt(f_T[:]->t(:,{1000},{latS:latN},{lonW:lonE}))
 T&time = time
 printVarSummary(T)

 SST = short2flt(f_SST[:]->sst(:,{latS:latN},{lonW:lonE}))
 SST&time = time
 printVarSummary(SST)

;====================================================================
;cul anomaly
;====================================================================

 T_anomaly = dim_rmvmean_n_Wrap(T({198301:198312},:,:),0)
 printVarSummary(T_anomaly)

 SST_anomaly = dim_rmvmean_n_Wrap(SST({198301:198312},:,:),0)
 printVarSummary(SST_anomaly)

 ;delete([/T,SST/])

;====================================================================
;draw
;====================================================================
 diro = "/data/wltsai/2023_NCL_course/0302_class2/"
 optname = "02-4_SSTA_TA_1983"
 wks = gsn_open_wks("png",diro+optname)

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

 res@gsnLeftString = " "
 res@gsnRightString = "deg. C"

 res@gsnFrame = False
 res@gsnDraw = False
 res@gsnMaximize = True

 res2 = True
 res2@gsnFrame = False
 res2@gsnDraw = False
 res2@cnLevelSelectionMode = "ManualLevels"
 res2@cnLevelSpacingF = 0.5
 res2@cnInfoLabelOn = False

;====================================================================
;png -> gif
;====================================================================

 monti = (/"January","February","March","April","May","June",\
           "July","August","September","October","November","December"/)


 do i = 0,12-1

   res@tiMainString = monti(i)+"1983 TA & SSTA"
   plot = gsn_csm_contour_map(wks,SST_anomaly(i,:,:),res)
   plot2 = gsn_csm_contour(wks,T_anomaly(i,:,:),res2)

   overlay(plot,plot2)
   draw(plot)
   frame(wks)

 end do

 cmd = "convert -delay 30 "+diro+optname+"*.png "+diro+optname+".gif"
 system(cmd)
 cmd = "rm "+diro+optname+"*.png"
 system(cmd)

 print("total time (sec) : "+get_cpu_time())



end

