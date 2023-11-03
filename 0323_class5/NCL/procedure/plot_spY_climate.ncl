;*************************************************************
; Author : Rung-Ying Su (Amber)
; Date : 2023.03.20
; This is an example file for teaching NCL course
;
;*************************************************************

undef("plot_spY_climate")
procedure plot_spY_climate(n:string,year:string,  x_tem:float, dir_out:string, Name:string, res:logical)
;********************************************************************************************************************************
;  Objective: Output scatter plots on map with index found with ind_value
;             in January, April, July and October in a specific year.
;  Variables:
;    n: average type
;    year: The average period written in outputted figure
;    w_tem: Input w 500
;    x_tem: Input data needed be averaged
;    dir_out: File path of output figures
;    Name: Variable names  (ex: Ps_2000)
;    res: Plot setting, including the color bar setting
;         res@cnFillPalette      = "WhiteYellowOrangeRed"
;         tres@cnLevels          = ispan(900,1000,10)
;********************************************************************************************************************************
begin
load "/data/course/2023_NCL_course/TA/0323_class5/NCL/procedure/set_res.ncl"

      if (n .eq. "spY")
;        w500 = w500_tem
        x = x_tem
      else if (n .eq. "clm")
;        w500 := clmMonTLL(w500_tem)
        x = clmMonTLL(x_tem)
        year = "clm("+year+")"
      end if
      end if
      dim = dimsizes(x_tem)
;      w500_ann = new((/1,dim(1),dim(2)/),"float")
      x_ann = new((/1,dim(1),dim(2)/),"float")
;      w500_ann(0,:,:) = dim_avg_n_Wrap(w500,0)
      x_ann(0,:,:) = dim_avg_n_Wrap(x,0)
;      w500 := array_append_record(w500,w500_ann,0)
      x := array_append_record(x,x_ann,0)
	  x!1 = "lat"
	  x!2 = "lon"
;******************************************************************
; assume data is 3D (time,lat,lon)
;**********************************************************************
      a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
      lsdata = a->LSMASK
      lsm  = landsea_mask(lsdata,x&lat,x&lon)

; lsm is a 2D array, in order to use it in mask, we must conform it
; to the size of the 3D array "data".

;      w500    = mask(w500,lsm .ge.1 ,False)
      x       = mask(x,lsm .ge.1 ,False)
;********************************************************************************************
;...2. Plot single variable
      typeP = "png"
      typeP@wkHeight = 2000
      typeP@wkWidth = 2000
      setvalues NhlGetWorkspaceObjectId()
        "wsMaximumSize" : 300000000
      end setvalues
      varName = Name+"_"+year
      wks = gsn_open_wks(typeP,dir_out+varName)
      plot_ov = new(5,graphic)
      plot = new(5,graphic)

      do iMon = 0, 4
        k = iMon*3
;      do iMon = 1, 13, 3
        if (iMon .eq. 0)
          MonSt  = "01"
        else if (iMon .eq. 1)
          MonSt  = "04"
        else if (iMon .eq. 2)
          MonSt  = "07"
        else if (iMon .eq. 3)
          MonSt  = "10"
        else if (iMon .eq. 4)
          MonSt  = "ANN"
        end if
        end if
        end if
        end if
        end if

;********************************************
;  Plot
;********************************************
;---Name the output file
;        res_W@tiMainString     = varName
;        res_W@tiMainFontHeightF = 0.02

;---Plot Map and w500=0
        res@gsnDraw    = False                         ; don't draw
        res@gsnFrame   = False                         ; don't advance frame
        res@mpMaxLatF  =  30                           ; select subregion
        res@mpMinLatF  = -30
        res@mpCenterLonF = 180.
        res@gsnLeftString          = "(" + set_fig_num(iMon) +") "+ MonSt
        res@gsnStringFontHeightF = 0.025
        res@tmXBLabelFontHeightF = 0.014
        res@tmYLLabelFontHeightF = 0.014
        res@pmLabelBarOrthogonalPosF = 0.3

;        res@mpShapeMode = "FreeAspect"
;        res@vpWidthF = 2.0
;        res@vpHeightF = 0.4
        plot(iMon) = gsn_csm_contour_map(wks,x(k,:,:),res)   ; create the diffF plot (shaded)
;        plot_ov(iMon) = gsn_csm_contour(wks,w500(k,:,:),res_W)   ; create the diffP plot (shaded)
;        overlay(plot(iMon),plot_ov(iMon))
      end do
;************************************************
; create panel
;************************************************
      resp                            = True
      resp@gsnPanelXWhiteSpacePercent = 1.8
      resp@gsnPanelYWhiteSpacePercent = 1.8
      resp@gsnPanelMainString   = varName
      resp@gsnPanelMainFontHeightF = 0.025
      resp@gsnPanelBottom   = 0.07;0.07
      resp@gsnPanelLabelBar    = False
      resp@gsnPanelRowSpec = True
;      resp@gsnPanelYF = (/-1,-1,.48,.48/)      ; Adjust bottommost plots.

;************************************************
      gsn_panel(wks,plot,(/2,2,1/),resp)             ; now draw as one plot


end

