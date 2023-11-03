;*************************************************************
; Author : Rung-Ying Su (Amber)
; Date : 2023.03.20
; This is an example file for teaching NCL course
;
;*************************************************************


undef("range")
procedure range(Name:string, var:float, r:float, p:integer)
local n, a, b, c, d


begin
;=============================
; Variable description:
;   -  Name: variable name
;   -  var : data matrix
;   -  r   : range array
;=============================


;--- Check r is monotonic increasing or decreasing
      if (isMonotonic(r) .eq. 0)
          print("Error: Range List is NOT monotonic increasing/decreasing")
          exit
      else if (isMonotonic(r) .eq. 1)
          r = r(::-1)
      else
          r = r
      end if
      end if

      dim = dimsizes(r)

;--- Print range of var
      print("==== Distribution of "+ Name+" =====")
      print(" - "+Name + " >="+" " + r(0) +" : "+ num(var .ge. r(0)))

      do n = 1, dim-1
          print(" - "+Name + " >="+" " + r(n) +" : "+ num((var .ge. r(n)) .and. (var .lt. r(n-1))))
      end do

      print(" - "+Name + " < "+" " + r(dim-1) +" : "+ num(var .lt. r(dim-1)))


;--- Print the grid number with missing value
      print(" - "+Name + " missing: "+ num(ismissing(var)))

;--- Print the persontage of missing value and valid value
      a = tofloat(num(ismissing(var)))
      b = tofloat(num(.not. ismissing(var)))
      c = (a/(a+b))*100 ;% of missing value
      d = 100-c         ;% of valid value
      print(" - "+Name + " % of missV : "+ sprintf("%5.2f", c)+"%")
      print(" - "+Name + " % of validV: "+ sprintf("%5.2f", d)+"%")
/;
      print(" - "+Name + " % of missV : "+ c)
      print(" - "+Name + " % of validV: "+ d)
;/
      dim1 = dimsizes(var)
      dim2 = dimsizes(dim1)
;=================
;---Output Figure
;=================
  if (p .eq. 1)
    wks = gsn_open_wks("png",Name@path)
    res = True

;--Manually set the bin intervals
    res@tiMainString = Name
    res@gsnHistogramBinIntervals = r
    if (dim2 .ne. 1)
      plot = gsn_histogram(wks,ndtooned(var),res)
    else
      plot = gsn_histogram(wks,var,res)
    end if
  else if (p .eq. 2)
    wks = gsn_open_wks("png",Name@path+"P")
    res = True
    res@gsnHistogramComputePercentages = True
    res@gsnHistogramComputePercentagesNoMissing = True
;--Manually set the bin intervals
    res@tiMainString = Name
    ;res@gsnRightString = "%"
    res@gsnHistogramBinIntervals = r
    if (dim2 .ne. 1)
      plot = gsn_histogram(wks,ndtooned(var),res)
    else
      plot = gsn_histogram(wks,var,res)
    end if
  end if
  end if


end



;******************************************************************
;        ind_value.ncl : find out specific value's ind(multiple matrix
;            ----ch1 : ndtooned(tar) + logic
;            ----tar : target matrix
;
;            Reference: https://www.ncl.ucar.edu/Document/Functions/Bu
;
;******************************************************************
undef("ind_value")
function ind_value(ch1:logical, tar)
local a1D, dsizes_a, indices,  dim_ida, npts, ndim

begin
;****************************
; tar : target matrix
; find out specific value
;****************************

     a1D      = ndtooned(ch1)
     dsizes_a = dimsizes(tar)
     if ( any(ch1)) then
         indices  = ind_resolve(ind(a1D),dsizes_a)
         dim_ida  = dimsizes(indices)
         npts     = dim_ida(0)       ; number of missing values
         ndim     = dim_ida(1)       ; rank of "a"  (here 4)
         delete(dsizes_a)
         delete(dim_ida)
;         indices@_FillValue = msg_val
         indices@npts = npts
         indices@ndim = ndim
         return(indices)
     else
;         print("Warning : No values match ch1 in your data.")
         return(0)
     end if
end









undef("plot_scatter_map")
procedure plot_scatter_map(figName, Topic, lat, lon)
begin
  n = num(.not. ismissing(lat))
  wks   = gsn_open_wks ("png",figName)              ; send graphics to PNG file
  res             = True                              ; plot mods desired
  res@gsnFrame    = False                             ; don't advance yet
  res@gsnMaximize = True

  res@mpMinLatF = -30
  res@mpMaxLatF =  30
  res@mpCenterLonF         = 180.          ; set center lon
;  res@mpMinLatF = 21                      ; set for Taiwan map
;  res@mpMaxLatF = 26
;  res@mpMinLonF = 119
;  res@mpMaxLonF = 123
  res@tmXBLabelFontHeightF = 0.01         ; Change x axis label font
  res@tmYLLabelFontHeightF = 0.01         ; Change Y axis label font
  res@tiMainString = Topic
  res@gsnRightString = "n= "+ n

  map = gsn_csm_map(wks,res)                ; Create the map plot, don't draw

  mkres               = True
  mkres@gsMarkerIndex = 2
  mkres@gsMarkerSizeF = 0.002
  mkres@gsMarkerThicknessF = 4.0
  mkres@gsMarkerColor = "Red"

  gsn_polymarker(wks,map,lon,lat,mkres)

  frame(wks)
;---Example in Main code
;lat = h&lat
;lon = h&lon
;b = ind_value(((M .ge. 0) .and. (pre_ct_hpa .ge. 900)) , M)
;i0 = b(:,0)
;i1 = b(:,1)
;i2 = b(:,2)
;
;do m = 0, nmon-1
;      if ( any(i0 .eq. m))
;        tar = ind(i0 .eq. m)
;        lat_ind = i1(tar)
;        lon_ind = i2(tar)
;        lat2 = lat(lat_ind)
;        lon2 = lon(lon_ind)
;        plot_scatter_map("./test/"+sprinti("%0.2i", m), "M>=0, Pt>=900 (mon = "+sprinti("%0.2i", m)+")", lat2, lon2)
;        ;plot_scatter_map("./test/test", "test", lat2, lon2)
;        delete([/tar,lat_ind, lon_ind,lat2,lon2/])
;      end if
;end do

end




