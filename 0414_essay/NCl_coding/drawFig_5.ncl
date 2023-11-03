function set_maps_res(res: logical)
local local_res
begin
  local_res = res

  local_res@mpLimitMode     = "LatLon"       ; required
  local_res@mpMinLatF       =   0.           ; min lat
  local_res@mpMaxLatF       =  45.           ; max lat
  local_res@mpMinLonF       = 100.           ; min lon
  local_res@mpMaxLonF       = 280.           ; max lon
  local_res@mpCenterLonF    = 190.

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

AllTrackDensity = f->AllTrackDensity({0:45}, {100:280})
EPWTrackDensity = f->EPWTrackDensity({0:45}, {100:280})
CPWTrackDensity = f->CPWTrackDensity({0:45}, {100:280})
EPCTrackDensity = f->EPCTrackDensity({0:45}, {100:280})

AllTrackDensity_std = dim_standardize_n_Wrap(AllTrackDensity, 0, (/0, 1/))
EPWTrackDensity_std = dim_standardize_n_Wrap(EPWTrackDensity, 0, (/0, 1/))
CPWTrackDensity_std = dim_standardize_n_Wrap(CPWTrackDensity, 0, (/0, 1/))
EPCTrackDensity_std = dim_standardize_n_Wrap(EPCTrackDensity, 0, (/0, 1/))

EPWTrackDensity_std_a = (EPWTrackDensity_std - AllTrackDensity_std) * 2
CPWTrackDensity_std_a = (CPWTrackDensity_std - AllTrackDensity_std) * 2
EPCTrackDensity_std_a = (EPCTrackDensity_std - AllTrackDensity_std) * 2

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
