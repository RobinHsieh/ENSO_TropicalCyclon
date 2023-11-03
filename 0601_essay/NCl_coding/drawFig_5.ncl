function set_maps_res(res: logical)
local local_res
begin
  local_res = res

  local_res@mpLimitMode     = "LatLon"       ; required
  local_res@mpMinLatF       =   0.           ; min lat
  local_res@mpMaxLatF       =  45.           ; max lat
  local_res@mpMinLonF       = 260.           ; min lon
  local_res@mpMaxLonF       = 340.           ; max lon
  local_res@mpCenterLonF    = 300.

  return local_res
end



function set_contour_res(res: logical)
local local_res
begin
  local_res = res

  local_res@cnFillOn       = True
  local_res@gsnAddCyclic   = False  ; It is important to set False when plotting non-global data
  ; local_res@cnFillOpacityF = 0.65
  local_res@cnLevelSelectionMode = "ExplicitLevels"  ; set explicit contour levels
  local_res@cnLevels       = (/-6., -5., -4., -3., -2.,-1.,0.5, 1., 2., 3., 4., 5., 6./)
  local_res@cnFillPalette  = "MPL_RdYlBu"
  local_res@cnFillColors   = (/127,125,122,116,111, 92, -1, 55, 42, 36, 27, 22, 14, 6/)
  local_res@cnLinesOn      = False                   ; turn off contour lines

  return local_res
end



begin

f = addfile("../data/TrackDensity.nc", "r")

AllTrackDensity = f->AllTrackDensity({0:45}, {260:340})
EPWTrackDensity = f->EPWTrackDensity({0:45}, {260:340})
CPWTrackDensity = f->CPWTrackDensity({0:45}, {260:340})
EPCTrackDensity = f->EPCTrackDensity({0:45}, {260:340})

AllTrackDensity_std = dim_standardize_n(AllTrackDensity, 0, (/0, 1/))
EPWTrackDensity_std = dim_standardize_n(EPWTrackDensity, 0, (/0, 1/))
CPWTrackDensity_std = dim_standardize_n(CPWTrackDensity, 0, (/0, 1/))
EPCTrackDensity_std = dim_standardize_n(EPCTrackDensity, 0, (/0, 1/))
; AllTrackDensity_std = dim_standardize(AllTrackDensity, 0)
; EPWTrackDensity_std = dim_standardize(EPWTrackDensity, 0)
; CPWTrackDensity_std = dim_standardize(CPWTrackDensity, 0)
; EPCTrackDensity_std = dim_standardize(EPCTrackDensity, 0)
; AllTrackDensity_std = AllTrackDensity_std - (avg(AllTrackDensity_std) / stddev(AllTrackDensity_std))
; print(avg(AllTrackDensity_std) / stddev(AllTrackDensity_std))
; AllTrackDensity_std = AllTrackDensity_std + 0.9344725
; EPWTrackDensity_std = EPWTrackDensity_std + 0.730433
; CPWTrackDensity_std = CPWTrackDensity_std + 0.5116325
; EPCTrackDensity_std = EPCTrackDensity_std + 0.8002407
print(max(AllTrackDensity_std)+" "+min(AllTrackDensity_std))
print(max(EPWTrackDensity_std)+" "+min(EPWTrackDensity_std))
print(max(CPWTrackDensity_std)+" "+min(CPWTrackDensity_std))
print(max(EPCTrackDensity_std)+" "+min(EPCTrackDensity_std))
EPWTrackDensity_std_a = (EPWTrackDensity_std - AllTrackDensity_std) * 2.0
CPWTrackDensity_std_a = (CPWTrackDensity_std - AllTrackDensity_std) * 1.5
EPCTrackDensity_std_a = (EPCTrackDensity_std - AllTrackDensity_std) * 2.0
print(max(EPWTrackDensity_std_a)+" "+min(EPWTrackDensity_std_a))
print(max(CPWTrackDensity_std_a)+" "+min(CPWTrackDensity_std_a))
print(max(EPCTrackDensity_std_a)+" "+min(EPCTrackDensity_std_a))

copy_VarCoords(AllTrackDensity, EPWTrackDensity_std_a)
copy_VarCoords(AllTrackDensity, CPWTrackDensity_std_a)
copy_VarCoords(AllTrackDensity, EPCTrackDensity_std_a)


res = True
res@gsnDraw = False
res@gsnFrame = False

map_res = set_maps_res(res)
contour_res = set_contour_res(map_res)

wks_type = "png"
; wks_type@wkWidth = 10000
; wks_type@wkHeight = 8000


; wks = gsn_open_wks(wks_type, "../image/Fig_5All_NCL")
; contourMapAll = gsn_csm_contour_map(wks, AllTrackDensity_std, contour_res)
; draw(contourMapAll)
; frame(wks)

; wks = gsn_open_wks(wks_type, "../image/Fig_5EPW_NCL")
; contourMapEPW = gsn_csm_contour_map(wks, EPWTrackDensity_std, contour_res)
; draw(contourMapEPW)
; frame(wks)

; wks = gsn_open_wks(wks_type, "../image/Fig_5CPW_NCL")
; contourMapCPW = gsn_csm_contour_map(wks, CPWTrackDensity_std, contour_res)
; draw(contourMapCPW)
; frame(wks)

; wks = gsn_open_wks(wks_type, "../image/Fig_5EPC_NCL")
; contourMapEPC = gsn_csm_contour_map(wks, EPCTrackDensity_std, contour_res)
; draw(contourMapEPC)
; frame(wks)

wks = gsn_open_wks(wks_type, "../image/Fig_5EPWa_NCL")
contourMapEPWa = gsn_csm_contour_map(wks, EPWTrackDensity_std_a, contour_res)
draw(contourMapEPWa)
frame(wks)

wks = gsn_open_wks(wks_type, "../image/Fig_5CPWa_NCL")
contourMapCPWa = gsn_csm_contour_map(wks, CPWTrackDensity_std_a, contour_res)
draw(contourMapCPWa)
frame(wks)

wks = gsn_open_wks(wks_type, "../image/Fig_5EPCa_NCL")
contourMapEPCa = gsn_csm_contour_map(wks, EPCTrackDensity_std_a, contour_res)
draw(contourMapEPCa)
frame(wks)

end
