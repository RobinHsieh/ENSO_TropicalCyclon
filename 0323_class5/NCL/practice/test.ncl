undef("plot")
procedure plot(figName,figTopic,variable)
begin
  wks = gsn_open_wks("png",figName)

  res                          = True

;-----String-----
  res@tiMainString             = figTopic
  res@tiMainFontHeightF        = 0.015

  res@gsnLeftString            = "ERA-Interim"
  res@gsnLeftStringFontHeightF = 0.012
  res@gsnRightString           = "K"
  res@gsnLeftStringFontHeightF = 0.012

;-----Contour-----

  res@cnFillOn                 = True
  res@cnLinesOn                = False
  res@cnLineLabelsOn           = False
  res@cnInfoLabelOn            = False

;-----Color_bar-----

  res@cnLevelSelectionMode     = "ManualLevels"
  res@cnMinLevelValF           = 295.
  res@cnMaxLevelValF           = 303.
  res@cnLevelSpacingF          = 1.
  res@cnFillPalette            = "cmp_b2r"

  res@lbLabelFontHeightF       = 0.012
  res@pmLabelBarHeightF        = 0.05
  res@pmLabelBarWidthF         = 0.6
  res@pmLabelBarOrthogonalPosF = 0.2

;-----Tickmarks-----

  res@tmXTOn                   = False
  res@tmYROn                   = False

  res@tmXBLabelFontHeightF     = 0.012
  res@tmYLLabelFontHeightF     = 0.012

  res@mpCenterLonF             = 180.
  res@mpMinLatF                = -30
  res@mpMaxLatF                =  30
;  res@mpMinLonF                = 120.
;  res@mpMaxLonF                = 280.

  contour = gsn_csm_contour_map(wks,variable,res)
end

