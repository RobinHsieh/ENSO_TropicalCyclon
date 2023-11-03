; Functions definition ---------------------
function set_maps_res(res: logical)
local local_res
begin
  local_res = res

  ; local_res@gsnMaximize     = True
  local_res@mpLimitMode     = "LatLon"       ; required
  local_res@mpMinLatF       = -10.           ; min lat
  local_res@mpMaxLatF       =  45.           ; max lat
  local_res@mpMinLonF       =  90.           ; min lon
  local_res@mpMaxLonF       = 300.           ; max lon
  local_res@mpCenterLonF    = 195.

  return local_res
end



function set_windbarb_vector(res: logical)
local local_res
begin
  local_res = res

  local_res@gsnAddCyclic             = False

  local_res@vcGlyphStyle             = "LineArrow"    ; select line arrow
  local_res@vcRefLengthF             = 0.05           ; define length of vec ref
  local_res@vcRefMagnitudeF          = 25.            ; make vectors larger
  local_res@vcRefAnnoOn              = False          ; turn off ref wind barb
  local_res@vcMinDistanceF           = 0.018          ; thin out wind barbs
  local_res@vcLineArrowThicknessF    = 15.            ; set the wind barb thickness
  ; local_res@trYReverse               = True           ; reverse the Y-axis
  ; local_res@vcWindBarbColor          = (/111, 111, 111/) / 255.

  return local_res
end



function set_windShear_contourMap_res(res: logical)
local local_res
begin
  local_res = res

  local_res@gsnMaximize    = True
  local_res@cnFillOn       = True
  local_res@mpFillOn       = True
  local_res@gsnAddCyclic   = False  ; It is important to add this when plotting non-global data
  ; local_res@cnFillOpacityF = 0.65
  local_res@cnLevelSelectionMode = "ExplicitLevels"  ; set explicit contour levels
  local_res@cnLevels       = (/-6., -5., -4., -3., -2.,-1.,0.5, 1., 2., 3., 4., 5., 6./)
  local_res@cnFillPalette  = "MPL_RdYlBu"
  local_res@cnFillColors   = (/127,125,122,116,111, 92, -1, 55, 42, 36, 27, 22, 14, 6/)

  return local_res
end



; Main program strat -----------------------
begin
path = "~/Programming/NCL/climate/0414_essay/"

u_windFile = addfile(path + "data/uwnd.mon.mean.nc", "r")
v_windFile = addfile(path + "data/vwnd.mon.mean.nc", "r")
; printVarSummary(u_windFile->uwnd)
; printVarSummary(u_windFile->time)

latDim = 23
lonDim = 85


All_uwnd850 = u_windFile->uwnd(:, 2, {-10:45}, {90:300})  ; get u wind in 850 hPa
All_vwnd850 = v_windFile->vwnd(:, 2, {-10:45}, {90:300})  ; get v wind in 850 hPa

All_uwnd200 = u_windFile->uwnd(:, 9, {-10:45}, {90:300})  ; get u wind in 200 hPa
All_vwnd200 = v_windFile->vwnd(:, 9, {-10:45}, {90:300})  ; get v wind in 200 hPa
; print(All_uwnd850(: ,1, 1))

EPW_years = (/19510101, 19511201, 19570101, 19571201, 19650101, 19651201, 19720101, 19721201, 19760101, 19761201, 19820101, 19821201, 19870101, 19871201, 19970101, 19971201/)
yyyy  := EPW_years / 10000
mmdd  := EPW_years % 10000
mm    := mmdd / 100
dd    := mmdd % 100
hh    := dd * 0
mn    := dd * 0
sc    := dd * 0
units := "hours since 1800-01-01 00:00:00"
EPW_years := cd_inv_calendar(yyyy, mm, dd, hh, mn, sc, units, 0)

EPW_uwnd850 = new((/dimsizes(EPW_years)*12/2, latDim, lonDim/), float)
EPW_vwnd850 = new((/dimsizes(EPW_years)*12/2, latDim, lonDim/), float)
; print(EPW_years)
EPW_uwnd200 = new((/dimsizes(EPW_years)*12/2, latDim, lonDim/), float)
EPW_vwnd200 = new((/dimsizes(EPW_years)*12/2, latDim, lonDim/), float)
do index = 0, dimsizes(EPW_years) - 1, 2
    EPW_uwnd850(index*12/2:index*12/2+11, :, :) = All_uwnd850({EPW_years(index):EPW_years(index+1)}, :, :)
    EPW_vwnd850(index*12/2:index*12/2+11, :, :) = All_vwnd850({EPW_years(index):EPW_years(index+1)}, :, :)

    EPW_uwnd200(index*12/2:index*12/2+11, :, :) = All_uwnd200({EPW_years(index):EPW_years(index+1)}, :, :)
    EPW_vwnd200(index*12/2:index*12/2+11, :, :) = All_vwnd200({EPW_years(index):EPW_years(index+1)}, :, :)
end do


CPW_years = (/19530101, 19531201, 19910101, 19911201, 19940101, 19941201, 20020101, 20021201, 20040101, 20041201/)
yyyy  := CPW_years / 10000
mmdd  := CPW_years % 10000
mm    := mmdd / 100
dd    := mmdd % 100
hh    := dd * 0
mn    := dd * 0
sc    := dd * 0
units := "hours since 1800-01-01 00:00:00"
CPW_years := cd_inv_calendar(yyyy, mm, dd, hh, mn, sc, units, 0)

CPW_uwnd850 = new((/dimsizes(CPW_years)*12/2, latDim, lonDim/), float)
CPW_vwnd850 = new((/dimsizes(CPW_years)*12/2, latDim, lonDim/), float)

CPW_uwnd200 = new((/dimsizes(CPW_years)*12/2, latDim, lonDim/), float)
CPW_vwnd200 = new((/dimsizes(CPW_years)*12/2, latDim, lonDim/), float)
do index = 0, dimsizes(CPW_years) - 1, 2
    CPW_uwnd850(index*12/2:index*12/2+11, :, :) = All_uwnd850({CPW_years(index):CPW_years(index+1)}, :, :)
    CPW_vwnd850(index*12/2:index*12/2+11, :, :) = All_vwnd850({CPW_years(index):CPW_years(index+1)}, :, :)

    CPW_uwnd200(index*12/2:index*12/2+11, :, :) = All_uwnd200({CPW_years(index):CPW_years(index+1)}, :, :)
    CPW_vwnd200(index*12/2:index*12/2+11, :, :) = All_vwnd200({CPW_years(index):CPW_years(index+1)}, :, :)
end do


EPC_years = (/19540101, 19541201, 19550101, 19551201, 19640101, 19641201, 19730101, 19731201, 19750101, 19751201, 19880101, 19881201, 19980101, 19981201, 19990101, 19991201/)
yyyy  := EPC_years / 10000
mmdd  := EPC_years % 10000
mm    := mmdd / 100
dd    := mmdd % 100
hh    := dd * 0
mn    := dd * 0
sc    := dd * 0

units := "hours since 1800-01-01 00:00:00"
EPC_years := cd_inv_calendar(yyyy, mm, dd, hh, mn, sc, units, 0)
; print(EPC_years)
EPC_uwnd850 = new((/dimsizes(EPC_years)*12/2, latDim, lonDim/), float)
EPC_vwnd850 = new((/dimsizes(EPC_years)*12/2, latDim, lonDim/), float)

EPC_uwnd200 = new((/dimsizes(EPC_years)*12/2, latDim, lonDim/), float)
EPC_vwnd200 = new((/dimsizes(EPC_years)*12/2, latDim, lonDim/), float)
do index = 0, dimsizes(EPC_years) - 1, 2
    EPC_uwnd850(index*12/2:index*12/2+11, :, :) = All_uwnd850({EPC_years(index):EPC_years(index+1)}, :, :)
    EPC_vwnd850(index*12/2:index*12/2+11, :, :) = All_vwnd850({EPC_years(index):EPC_years(index+1)}, :, :)

    EPC_uwnd200(index*12/2:index*12/2+11, :, :) = All_uwnd200({EPC_years(index):EPC_years(index+1)}, :, :)
    EPC_vwnd200(index*12/2:index*12/2+11, :, :) = All_vwnd200({EPC_years(index):EPC_years(index+1)}, :, :)
end do


; Calculate the average wind direction
All_uwnd850Avg = dim_avg_n_Wrap(All_uwnd850, 0)
All_vwnd850Avg = dim_avg_n_Wrap(All_vwnd850, 0)
All_uwnd200Avg = dim_avg_n_Wrap(All_uwnd200, 0)
All_vwnd200Avg = dim_avg_n_Wrap(All_vwnd200, 0)

EPW_uwnd850Avg = dim_avg_n_Wrap(EPW_uwnd850, 0)
EPW_vwnd850Avg = dim_avg_n_Wrap(EPW_vwnd850, 0)
EPW_uwnd200Avg = dim_avg_n_Wrap(EPW_uwnd200, 0)
EPW_vwnd200Avg = dim_avg_n_Wrap(EPW_vwnd200, 0)

CPW_uwnd850Avg = dim_avg_n_Wrap(CPW_uwnd850, 0)
CPW_vwnd850Avg = dim_avg_n_Wrap(CPW_vwnd850, 0)
CPW_uwnd200Avg = dim_avg_n_Wrap(CPW_uwnd200, 0)
CPW_vwnd200Avg = dim_avg_n_Wrap(CPW_vwnd200, 0)

EPC_uwnd850Avg = dim_avg_n_Wrap(EPC_uwnd850, 0)
EPC_vwnd850Avg = dim_avg_n_Wrap(EPC_vwnd850, 0)
EPC_uwnd200Avg = dim_avg_n_Wrap(EPC_uwnd200, 0)
EPC_vwnd200Avg = dim_avg_n_Wrap(EPC_vwnd200, 0)

; Calculate the anomaly of EPW, CPW, EPC wind direction in 850 hPa
EPW_uwnd850Avg_a = (EPW_uwnd850Avg - All_uwnd850Avg) * 10
EPW_vwnd850Avg_a = (EPW_vwnd850Avg - All_vwnd850Avg) * 10

CPW_uwnd850Avg_a = (CPW_uwnd850Avg - All_uwnd850Avg) * 10
CPW_vwnd850Avg_a = (CPW_vwnd850Avg - All_vwnd850Avg) * 10

EPC_uwnd850Avg_a = (EPC_uwnd850Avg - All_uwnd850Avg) * 10
EPC_vwnd850Avg_a = (EPC_vwnd850Avg - All_vwnd850Avg) * 10

copy_VarCoords(EPW_uwnd850Avg, EPW_uwnd850Avg_a)
copy_VarCoords(EPW_vwnd850Avg, EPW_vwnd850Avg_a)

copy_VarCoords(CPW_uwnd850Avg, CPW_uwnd850Avg_a)
copy_VarCoords(CPW_vwnd850Avg, CPW_vwnd850Avg_a)

copy_VarCoords(EPC_uwnd850Avg, EPC_uwnd850Avg_a)
copy_VarCoords(EPC_vwnd850Avg, EPC_vwnd850Avg_a)

; Calculate the average wind shear between 850 hPa and 200 hPa
All_windShearAvg = ((All_uwnd850Avg - All_uwnd200Avg)^2 + (All_vwnd850Avg - All_vwnd200Avg)^2)^0.5
EPW_windShearAvg = ((EPW_uwnd850Avg - EPW_uwnd200Avg)^2 + (EPW_vwnd850Avg - EPW_vwnd200Avg)^2)^0.5
CPW_windShearAvg = ((CPW_uwnd850Avg - CPW_uwnd200Avg)^2 + (CPW_vwnd850Avg - CPW_vwnd200Avg)^2)^0.5
EPC_windShearAvg = ((EPC_uwnd850Avg - EPC_uwnd200Avg)^2 + (EPC_vwnd850Avg - EPC_vwnd200Avg)^2)^0.5

copy_VarCoords(All_uwnd850Avg, All_windShearAvg)
copy_VarCoords(EPW_uwnd850Avg, EPW_windShearAvg)
copy_VarCoords(CPW_uwnd850Avg, CPW_windShearAvg)
copy_VarCoords(EPC_uwnd850Avg, EPC_windShearAvg)

; Calculate the anomaly wind shear of EPW, CPW, EPC between 850 hPa to 200 hPa
EPW_windShearAvg_a = (EPW_windShearAvg - All_windShearAvg)
CPW_windShearAvg_a = (CPW_windShearAvg - All_windShearAvg)
EPC_windShearAvg_a = (EPC_windShearAvg - All_windShearAvg)

copy_VarCoords(All_windShearAvg, EPW_windShearAvg_a)
copy_VarCoords(All_windShearAvg, CPW_windShearAvg_a)
copy_VarCoords(All_windShearAvg, EPC_windShearAvg_a)


; *** Picture resource ***
res = True
res@gsnDraw = False
res@gsnFrame = False

; *** Panel resource ***
resP = True                       ; modify the panel plot
resP@gsnMaximize = True           ; use full page

map_res = set_maps_res(res)
map_res@tiMainString = "Vertical wind shear & 850 hPa wind"  ; add titles
windbarb_res = set_windbarb_vector(res)
windShearMap_res = set_windShear_contourMap_res(map_res)

wks_type = "png"
wks_type@wkWidth = 10000
wks_type@wkHeight = 8000


wks1 = gsn_open_wks(wks_type, "../image/Fig_91")

windbarbsAll = gsn_csm_vector(wks1, All_uwnd850Avg, All_vwnd850Avg, windbarb_res)
mapAll = gsn_csm_map(wks1, map_res)
overlay(mapAll, windbarbsAll)

windbarbsEPW = gsn_csm_vector(wks1, EPW_uwnd850Avg, EPW_vwnd850Avg, windbarb_res)
mapEPW = gsn_csm_map(wks1, map_res)
overlay(mapEPW, windbarbsEPW)

gsn_panel(wks1, (/mapAll, mapEPW/), (/2,1/), resP)    ; now draw as one plot


windbarbsCPW = gsn_csm_vector(wks1, CPW_uwnd850Avg, CPW_vwnd850Avg, windbarb_res)
mapCPW = gsn_csm_map(wks1, map_res)
overlay(mapCPW, windbarbsCPW)

windbarbsEPC = gsn_csm_vector(wks1, EPC_uwnd850Avg, EPC_vwnd850Avg, windbarb_res)
mapEPC = gsn_csm_map(wks1, map_res)
overlay(mapEPC, windbarbsEPC)

gsn_panel(wks1, (/mapCPW, mapEPC/), (/2,1/), resP)    ; now draw as one plot


windbarbsEPW_a = gsn_csm_vector(wks1, EPW_uwnd850Avg_a, EPW_vwnd850Avg_a, windbarb_res)
windShearContourEPW_a = gsn_csm_contour_map(wks1, EPW_windShearAvg_a, windShearMap_res)
overlay(windShearContourEPW_a, windbarbsEPW_a)

gsn_panel(wks1, (/mapAll, windShearContourEPW_a/), (/2,1/), resP)    ; now draw as one plot
; frame(wks1)


wks2 = gsn_open_wks(wks_type, "../image/Fig_92")

; cmap = (/(/255, 255, 255, 255/), (/44, 196, 178, 255/), (/54, 118, 186, 255/), (/54, 126, 190, 255/), (/46, 144, 205, 255/), (/88, 178, 227, 255/), (/158, 217, 222, 255/), (/254, 228, 121, 255/), (/251, 180, 63, 255/), (/246, 152, 53, 255/), (/240, 109, 53, 255/), (/237, 71, 56, 255/), (/237, 56, 56, 255/)/)
; cmap = (/(/255, 255, 255/), (/44, 196, 178/), (/54, 118, 186/), (/54, 126, 190/), (/46, 144, 205/), (/88, 178, 227/), (/158, 217, 222/), (/254, 228, 121/), (/251, 180, 63/), (/246, 152, 53/), (/240, 109, 53/), (/237, 71, 56/), (/237, 56, 56/)/)
; cmap := cmap / 255.
; print(cmap)
; gsn_define_colormap(wks2, cmap)
; gsn_draw_colormap(wks2)
 
windbarbsCPW_a = gsn_csm_vector(wks2, CPW_uwnd850Avg_a, CPW_vwnd850Avg_a, windbarb_res)
windShearContourCPW_a = gsn_csm_contour_map(wks2, CPW_windShearAvg_a, windShearMap_res)
overlay(windShearContourCPW_a, windbarbsCPW_a)

windbarbsEPC_a = gsn_csm_vector(wks2, EPC_uwnd850Avg_a, EPC_vwnd850Avg_a, windbarb_res)
windShearContourEPC_a = gsn_csm_contour_map(wks2, EPC_windShearAvg_a, windShearMap_res)
overlay(windShearContourEPC_a, windbarbsEPC_a)

gsn_panel(wks2, (/windShearContourCPW_a, windShearContourEPC_a/), (/2, 1/), resP)
; frame(wks2)


end
