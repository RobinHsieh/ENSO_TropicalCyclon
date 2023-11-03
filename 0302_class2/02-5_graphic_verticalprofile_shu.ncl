begin
;==============================================
;open file
;==============================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/T/"
 fn_T = "EC_T_mon_2016.nc"
 f_T = addfile(diri+fn_T,"r")

;==============================================
;read data
;==============================================

 latN = 5.
 latS = -5.
 lonW = 85.
 lonE = 90.

 time = cd_calendar(f_T->time(:),-1)
 lev = f_T->level(:)
 lat = f_T->latitude({latS:latN})
 lon = f_T->longitude({lonW:lonE})

 T = short2flt(f_T->t(:,:,{latS:latN},{lonW:lonE}))
 T&time = time
 printVarSummary(T)

;==============================================
; cul the regional average
;==============================================

T_avg=dim_avg_n_Wrap(T,(/2,3/))
printVarSummary(T_avg)


;==============================================
;draw
;==============================================
 diro = "/data/wltsai/2023_NCL_course/0302_class2/"
 optname = "02-5_verticalprofile"

 wks = gsn_open_wks("pdf",diro+optname)

 res = True
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
;----------------------------------------------------------------1 (Default)

 res@tiMainString = "Jan 2016 Temperature profile"
 res@tmYROn = False
 res@tmXTOn = False
 res@trYReverse =True
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
;----------------------------------------------------------------2 Y-reverse axis

 res@xyLineThicknesses = 4.0
 res@xyLineColor = "Blue"
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
 ;----------------------------------------------------------------3 Thick + color
;https://www.ncl.ucar.edu/Document/Graphics/Images/dashpatterns.png

 res@xyDashPattern = 1
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
;----------------------------------------------------------------4 Change dash pattern

 res@xyMarkLineMode = "MarkLines"
 res@xyMarkerColor = "Red"
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
;----------------------------------------------------------------5 Add Markers

 res@xyMarkerThicknessF = 3.
 res@xyMarker = 6
 plot = gsn_csm_xy(wks,T_avg({201601},:),lev(:),res)
;----------------------------------------------------------------6 Change Marker Thckness and style



end

