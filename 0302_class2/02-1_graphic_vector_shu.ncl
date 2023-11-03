begin
;==============================================
;open file
;==============================================

 diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/"
 var = (/"U/","V/","T/"/)

 fn_U = "ERAITM_Mon_2016_U_361x720.nc"   ; float
 fn_V = "ERAITM_Mon_2016_V_361x720.nc"   ; float
 fn_T = "EC_T_mon_2016.nc"               ; short

 f_U = addfile(diri+var(0)+fn_U,"r")
 f_V = addfile(diri+var(1)+fn_V,"r")
 f_T = addfile(diri+var(2)+fn_T,"r")

;==============================================
;read data : at 1000hPa
;==============================================

time=cd_calendar(f_U->time(:),-1)
lat=f_U->lat(:)
lon=f_U->lon(:)
u=f_U->u(:,{1000},:,:)
v=f_V->v(:,{1000},:,:)
T=short2flt(f_T->t(:,{1000},:,:))
u&time=time
v&time=time
T&time=time
printVarSummary(u)
printVarSummary(v)
printVarSummary(T)

;==============================================
;draw
;==============================================

 diro = "/data/wltsai/2023_NCL_course/0302_class2/"
 optname = "02-1_vector"
 wks = gsn_open_wks("pdf",diro+optname)

 res = True
 res@vcMinDistanceF = 0.017            ; separate vectors 
 res@vcGlyphStyle   = "CurlyVector"    ; turn on curly vectors
 plot = gsn_csm_vector_map(wks,u({201601},:,:),v({201601},:,:),res)
;----------------------------------------------------------------1 False (Default)

 res@vcRefLengthF = 0.045
 plot = gsn_csm_vector_map(wks,u({201601},:,:),v({201601},:,:),res)
;----------------------------------------------------------------2 Change vector length by Ref length

 res@vcRefMagnitudeF = 10.
 res@vcRefAnnoOrthogonalPosF = -1.0     ; move Ref arrow upward
 plot = gsn_csm_vector_map(wks,u({201601},:,:),v({201601},:,:),res)
;----------------------------------------------------------------3 Change Ref. magnitude (wind speed)

 plot = gsn_csm_vector_scalar_map(wks,u({201601},:,:),v({201601},:,:),T({201601},:,:),res)
;----------------------------------------------------------------4 Colorful vectors base on third field (T)

 res@gsnScalarContour = True
 res@cnFillOn = True
 res@cnLinesOn = False

 plot = gsn_csm_vector_scalar_map(wks,u({201601},:,:),v({201601},:,:),T({201601},:,:),res)
 ;----------------------------------------------------------------5 The third field will be drawn as contours

end

