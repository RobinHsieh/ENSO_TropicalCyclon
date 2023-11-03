;*************************************************************
; Author : Rung-Ying Su (Amber)
; Date : 2023.03.20
; This is an example file for teaching NCL course
;
;*************************************************************

undef("set_res")
function set_res(n:integer)



begin
    if (n .eq. 0)
      res_W =True
      res_W@gsnDraw              = False             ; do not draw the plot
      res_W@gsnFrame             = False             ; do not advance the frame
      res_W@cnFillOn             = False ; do not color fill
      res_W@cnLinesOn            = True ; turn the contour lines on
      res_W@cnLineLabelsOn       = False
      res_W@cnInfoLabelOn        = False
      res_W@cnLineLabelInterval  =2
      res_W@cnLineLabelDensityF  =0.2
      res_W@cnLineThicknessF     =0.2
      res_W@gsnContourZeroLineThicknessF = 4.
      res_W@cnInfoLabelOrthogonalPosF = 0.4 ; push the InfoLabel down below the label bar
      res_W@gsnLeftString     = ""
      res_W@gsnRightString    = ""
      res_W@lbLabelBarOn      = False
      return(res_W)
    else if (n .eq. 1)
      tres = True
      tres@gsnDraw              = False             ; do not draw the plot
      tres@gsnFrame             = False             ; do not advance the frame
;      tres@cnFillDrawOrder      = "Predraw"  ; draw contours first
      tres@gsnStringFontHeightF = 0.020
      tres@tiMainFontHeightF    = 0.02
      tres@cnFillOn             = True        ; Shaded
      tres@lbBoxLinesOn         = True   ; turn off labelbar box lines
      tres@cnLinesOn            = False               ; turn off contour lines
      tres@cnLineLabelsOn       = False               ; turn off contour label
      tres@cnLevelSelectionMode = "ExplicitLevels"
      tres@lbLabelFontHeightF   =.015              ; Change labelbar font
      tres@lbLabelPosition      = "Bottom"          ; Change labelbar position
      tres@lbAutoManage         = False
      tres@pmLabelBarDisplayMode = "Always"
      tres@pmLabelBarOrthogonalPosF = 0.17         ;-- move the labelbar (<0:upward, >0:downward  compare with defalt)
      tres@pmLabelBarHeightF    = .08                  ; color bar's height
      tres@pmLabelBarWidthF     = .8                    ; color bar's width
      tres@mpFillOn             = True
      tres@mpMinLatF            = -30
      tres@mpMaxLatF            =  30
      tres@mpCenterLonF         = 180.          ; set center lon
      tres@tmXBLabelFontHeightF = 0.01         ; Change x axis label font
      tres@tmYLLabelFontHeightF = 0.01         ; Change Y axis label font
;      tres@cnFillMode           ="RasterFill"
      tres@cnRasterSmoothingOn  =True
      ;tres@cnSmoothingOn  = True
      return(tres)

    end if
    end if

end



undef("set_fig_num")
function set_fig_num(n:integer)

begin
      if (n .eq. 0)
            return("a")
      else if (n .eq. 1)
            return("b")
      else if (n .eq. 2)
            return("c")
      else if (n .eq. 3)
            return("d")
      else if (n .eq. 4)
            return("e")
      else if (n .eq. 5)
            return("f")
      else if (n .eq. 6)
            return("g")
      end if
      end if
      end if
      end if
      end if
      end if
      end if
end


undef("set_ColorBar")
procedure set_ColorBar(n:integer,res)
begin
;      res = True
      if (n .eq. 0)         ; For variables with all positive values
        res@cnFillPalette     = "WhiteYellowOrangeRed"
      else if (n .eq. 1)    ; For P-E, relative to dry and wet (brown --> green)
        cmap2 = read_colormap_file("MPL_BrBG")
        y1 = cmap2(0:50,:)
        y2 = cmap2(77:,:)
        cmap2 := array_append_record(y1,y2,0)
        res@cnFillPalette     = cmap2
      else if (n .eq. 2)    ; For variables ranges from negative to postive value (blue --> red)
        res@cnFillPalette     = "BlWhRe"
      else if (n .eq. 3)    ; For variables ranges from negative to postive value (blue --> red)
        res@cnFillPalette     = "BlAqGrYeOrRe"
      else if (n .eq. 4)
        cmap2 = read_colormap_file("testcmap")
        y1 = cmap2(0:88,:)
        y2 = cmap2(110:,:)
        cmap2 := array_append_record(y1,y2,0)
        res@cnFillPalette     = cmap2
      else if (n .eq. 5)    ; For P-E, relative to dry and wet (brown --> green, with light color for small residual)
        res@cnFillPalette     = "MPL_BrBG"
      else if (n .eq. 6)    ; For SST
        res@cnFillPalette     = "cmp_b2r"


      end if
      end if
      end if
      end if
      end if
      end if
      end if
      return(res)

end


