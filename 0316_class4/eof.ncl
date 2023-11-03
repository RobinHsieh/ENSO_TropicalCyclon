;================================================
;conduct EOF analysis on monthly SST
;plot EOF modes and their time series
;================================================
begin

;************************************************
;read data
;************************************************
diri = "./SODA_2.2.4/"
fnames = systemfunc("ls " + diri + "SODA_sst_*.nc")
f = addfiles(fnames, "r")
printVarSummary(f)
sst = f[:]->sst(:, {30:-30}, {120:280})

printVarSummary(sst)
printMinMax(sst, 0)
print("---")

;remove seasonal cucle
sst_rmAnnCyc = rmMonAnnCycTLL(sst)

;************************************************
;EOF analysis
;************************************************
neof = 3
optEOF = False
optETS = False
x = sst_rmAnnCyc

eof = eofunc_n_Wrap(x, neof, optEOF, 0)
eof_ts = eofunc_ts_n_Wrap(x, eof, optETS, 0)

printVarSummary(eof)
printVarSummary(eof_ts)
print("---")

;************************************************
;plot
;************************************************
wks 	= gsn_open_wks("pdf","eof")
plot 	= new(neof*2,graphic)

;------------------------------------------------
;EOFs
;------------------------------------------------
res = True

res@gsnDraw			= False
res@gsnFrame		= False
res@gsnAddCyclic	= False

res@cnFillOn		= True
res@cnLinesOn		= True
res@cnFillPalette	= "BlueDarkRed18"

res@mpMinLonF		= 120.
res@mpMaxLonF		= 280.
res@mpCenterLonF	= 200.
res@mpMinLatF		= -30.
res@mpMaxLatF		=  30.

res@tmXTOn					= False
res@tmYROn					= False
res@tmXBLabelFontHeightF	= 0.02
res@tmYLLabelFontHeightF	= 0.02

res@gsnLeftString				= "Eigenvector"
res@gsnRightStringFontHeightF	= 0.02
res@gsnLeftStringFontHeightF	= 0.02

res@tiMainFontHeightF	= 0.02

res@pmLabelBarOrthogonalPosF = 0.2

;------------------------------------------------
res@tiMainString 	= "Mode 1"
res@gsnRightString	= sprintf("%5.1f",eof@pcvar(0))+"%"
plot(0) = gsn_csm_contour_map(wks,eof(0,:,:),res)

res@tiMainString 	= "Mode 2"
res@gsnRightString  = sprintf("%5.1f",eof@pcvar(1))+"%"                 
plot(1) = gsn_csm_contour_map(wks,eof(1,:,:),res)

res@tiMainString 	= "Mode 3"
res@gsnRightString  = sprintf("%5.1f",eof@pcvar(2))+"%"
plot(2) = gsn_csm_contour_map(wks,eof(2,:,:),res)

;------------------------------------------------
;time series
;------------------------------------------------
tsres	= True

tsres@gsnDraw	= False
tsres@gsnFrame	= False

tsres@vpHeightF	= 0.25
tsres@vpWidthF	= 0.8

tsres@tmXBMode			= "Explicit"
tsres@tmXBValues		= ispan(1,109,12)
tsres@tmXBLabels		= ispan(1991,2000,1)
tsres@tmXBMinorOn		= True
tsres@tmXBMinorValues	= ispan(1,120,1)
tsres@tmXTOn			= False
tsres@tmYROn			= False

tsres@tiXAxisString	= ""
tsres@tiYAxisString	= ""

tsres@gsnYRefLine				= 0.
tsres@gsnXYBarChart				= True
tsres@gsnAboveYRefLineColor		= "red"
tsres@gsnBelowYRefLineBarColors	= "blue"

tsres@gsnLeftString 	= "Time series"
tsres@tiMainString		= ""

;------------------------------------------------
tsres@gsnRightString	= "ts_mean: "+sprintf("%5.1f",eof_ts@ts_mean(0))
plot(3) = gsn_csm_xy(wks,ispan(1,120,1),eof_ts(0,:),tsres)

tsres@gsnRightString      = "ts_mean: "+sprintf("%5.1f",eof_ts@ts_mean(1))
plot(4) = gsn_csm_xy(wks,ispan(1,120,1),eof_ts(1,:),tsres)

tsres@gsnRightString      = "ts_mean: "+sprintf("%5.1f",eof_ts@ts_mean(2))
plot(5) = gsn_csm_xy(wks,ispan(1,120,1),eof_ts(2,:),tsres)

;------------------------------------------------
;panel
;------------------------------------------------
resP = True

resP@gsnPanelMainString			= "EOF modes of 1991-2000 SST"
resP@gsnPanelMainFontHeightF	= 0.015
resP@gsnPanelXWhiteSpacePercent	= 5
resP@gsnPanelYWhiteSpacePercent	= 5

gsn_panel(wks,plot,(/2,3/),resP)

print("Total CPU time: " + get_cpu_time())
end
