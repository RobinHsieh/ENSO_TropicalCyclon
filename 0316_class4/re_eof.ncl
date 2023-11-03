;================================================
;reconstruct SSTA from the first three EOF modes
;================================================
begin

;************************************************
;read data
;************************************************
diri	= "./SODA_2.2.4/"
fnames	= systemfunc("ls "+diri+"SODA_sst_*.nc")
f		= addfiles(fnames,"r")
sst		= f[:]->sst(:,{30:-30},{120:280})
printVarSummary(sst)
printMinMax(sst,0)
print("---")

ssta = dim_rmvmean_n_Wrap(sst,0)
printVarSummary(ssta)
printMinMax(ssta,0)
print("---")

;************************************************
;EOF analysis
;************************************************
neof	= 3
optEOF	= False
optETS	= False
x		= sst

eof		= eofunc_n_Wrap(x,neof,optEOF,0)
eof_ts	= eofunc_ts_n_Wrap(x,eof,optETS,0)

printVarSummary(eof)
printVarSummary(eof_ts)
print("---")

;************************************************
;reconstruction (eof2data)
;************************************************
ssta1 = eof2data(eof(0:0, :, :), eof_ts(0:0, :))
ssta1!0 = "lat"
ssta1!1 = "lon"
ssta1!2 = "time"
ssta1&lat = ssta&lat
ssta1&lon = ssta&lon
ssta1&time = ispan(1, 120, 1)

ssta2 = eof2data(eof(1:1, :, :), eof_ts(1:1, :))
copy_VarCoords(ssta1, ssta2)

ssta3 = eof2data(eof(2:2, :, :), eof_ts(2:2, :))
copy_VarCoords(ssta1, ssta3)

re_ssta = eof2data(eof, eof_ts)
copy_VarCoords(ssta1, re_ssta)

ssta1 := ssta1(time|:, lat|:, lon|:)
ssta2 := ssta2(time|:, lat|:, lon|:)
ssta3 := ssta3(time|:, lat|:, lon|:)
re_ssta := re_ssta(time|:, lat|:, lon|:)
;************************************************
;plot
;************************************************
wks		= gsn_open_wks("pdf","re_eof")
plot	= new(5,graphic)

res = True

res@gsnDraw			= False
res@gsnFrame		= False
res@gsnAddCyclic	= False

res@cnFillOn		= True
res@cnLinesOn		= True
res@cnFillPalette	= "BlueDarkRed18"

res@mpMinLonF       = 120.
res@mpMaxLonF       = 280.
res@mpCenterLonF    = 200.
res@mpMinLatF       = -30.
res@mpMaxLatF       =  30.

res@tmXTOn	= False
res@tmYROn  = False

res@gsnLeftString	= ""
res@gsnRightString	= ""

;------------------------------------------------
t = 20

res@tiMainString = "SSTA 1"
plot(0) = gsn_csm_contour_map(wks,ssta1(t,:,:),res)

res@tiMainString = "SSTA 2"
plot(1) = gsn_csm_contour_map(wks,ssta2(t,:,:),res)

res@tiMainString = "SSTA 3"
plot(2) = gsn_csm_contour_map(wks,ssta3(t,:,:),res)

res@cnLevelSelectionMode	= "ManualLevels"
res@cnMinLevelValF			= -4.
res@cnMaxLevelValF			=  4.
res@cnLevelSpacingF			=  1.

res@tiMainString = "Reconstructed SSTA"
plot(3) = gsn_csm_contour_map(wks,re_ssta(t,:,:),res)

res@tiMainString = "Original SSTA"
plot(4) = gsn_csm_contour_map(wks,ssta(t,:,:),res)

;------------------------------------------------
resP = True

resP@gsnPanelXWhiteSpacePercent = 5
resP@gsnPanelYWhiteSpacePercent = 5

gsn_panel(wks,plot,(/2,3/),resP)

print("Total CPU time: " + get_cpu_time())
end
