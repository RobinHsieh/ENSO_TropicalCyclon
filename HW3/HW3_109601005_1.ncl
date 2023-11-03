begin

; Files access  ---------------------------------------

dir_input_1 = "/Users/robinhsieh/Programming/NCL/climate/HW3/2018_TC_JTWC_Lat/" 
dir_input_2 = "/Users/robinhsieh/Programming/NCL/climate/HW3/2018_TC_JTWC_Lon/"

dir_output = "/Users/robinhsieh/Programming/NCL/climate/HW3/"
optname = "typhoon_SO_generateLat8-30Lon116-154"

; Analysis  -------------------------------------------



; Visualization  --------------------------------------

wks = gsn_open_wks("png",dir_output+optname) ; work station

res = True
res@gsnMaximize = True
res@gsnDraw = False           ; don't draw graphics when the gsn function is called
res@gsnFrame = False          ; don't advance frame when the gsn function is called

res@mpMaxLatF = 30.
res@mpMinLatF = 8.
res@mpMaxLonF = 154.
res@mpMinLonF = 116. 
res@mpCenterLonF = 135.

map = gsn_csm_map(wks, res) 

plots_res = True
plots_res@gsMarkerSizeF = 0.03
plots_res@gsMarkerIndex = 1

; hadle 1980 to 2015 datas

plot_allyear = new(2015-1980+1, graphic)

; El_nino = (/1982, 1987, 1997, 2015/)
; La_nina = (/1988, 1989, 1999, 2000/)

lat_El_nino = (/9453./)
lat_La_nina = (/9453./)
lat_normal = (/9453./)
lon_El_nino = (/9453./)
lon_La_nina = (/9453./)
lon_normal = (/9453./)

do year = 1980, 2015
  lat = asciiread(dir_input_1 + "Lat" + year + ".txt", (/20,12/), "float")
  lon = asciiread(dir_input_2 + "Lon" + year + ".txt", (/20,12/), "float")
  lat@_FillValue = 9453.
  lon@_FillValue = 9453.
  
  if(year .eq. 1982 .or. year .eq. 1987 .or. year .eq. 1997 .or. year .eq. 2015) then
    plots_res@gsMarkerColor = "Red"
    lat_El_nino := array_append_record(lat_El_nino, lat(:, 9-1), 0)
    lat_El_nino := array_append_record(lat_El_nino, lat(:, 10-1), 0)
    lon_El_nino := array_append_record(lon_El_nino, lon(:, 9-1), 0)
    lon_El_nino := array_append_record(lon_El_nino, lon(:, 10-1), 0)
  elseif(year .eq. 1988 .or. year .eq. 1989 .or. year .eq. 1999 .or. year .eq. 2000) then
    plots_res@gsMarkerColor = "Blue"
    lat_La_nina := array_append_record(lat_La_nina, lat(:, 9-1), 0)
    lat_La_nina := array_append_record(lat_La_nina, lat(:, 10-1), 0)
    lon_La_nina := array_append_record(lon_La_nina, lon(:, 9-1), 0)
    lon_La_nina := array_append_record(lon_La_nina, lon(:, 10-1), 0)
  else
    plots_res@gsMarkerColor = "Green"
    lat_normal := array_append_record(lat_normal, lat(:, 9-1), 0)
    lat_normal := array_append_record(lat_normal, lat(:, 10-1), 0)
    lon_normal := array_append_record(lon_normal, lon(:, 9-1), 0)
    lon_normal := array_append_record(lon_normal, lon(:, 10-1), 0)
  end if
  
  plot_allyear(year - 1980) = gsn_add_polymarker(wks, map, lon(:, 9-1:10-1), lat(:, 9-1:10-1), plots_res) ; look at Sep and Oct

end do

;print(lat_El_nino)
;print(lon_El_nino)

delete(lat_El_nino@_FillValue)
delete(lat_La_nina@_FillValue)
delete(lat_normal@_FillValue)

delete(lon_El_nino@_FillValue)
delete(lon_La_nina@_FillValue)
delete(lon_normal@_FillValue)


do index = 0, dimsizes(lon_El_nino) - 1
  if(lon_El_nino(index) .lt. 116. .or. lon_El_nino(index) .gt. 154.) then
    lon_El_nino(index) = 9453.
  end if
  if(lat_El_nino(index) .lt. 8. .or. lat_El_nino(index) .gt. 30.) then
    lat_El_nino(index) = 9453.
  end if
end do
do index = 0, dimsizes(lon_La_nina) - 1
  if(lon_La_nina(index) .lt. 116. .or. lon_La_nina(index) .gt. 154.) then
    lon_La_nina(index) = 9453.
  end if
  if(lat_La_nina(index) .lt. 8. .or. lat_La_nina(index) .gt. 30.) then
    lat_La_nina(index) = 9453.
  end if
end do
do index = 0, dimsizes(lon_normal) - 1
  if(lon_normal(index) .lt. 116. .or. lon_normal(index) .gt. 154.) then
    lon_normal(index) = 9453.
  end if
  if(lat_normal(index) .lt. 8. .or. lat_normal(index) .gt. 30.) then
    lat_normal(index) = 9453.
  end if
end do

lat_El_nino@_FillValue = 9453.
lat_La_nina@_FillValue = 9453.
lat_normal@_FillValue = 9453.

lon_El_nino@_FillValue = 9453.
lon_La_nina@_FillValue = 9453.
lon_normal@_FillValue = 9453.

;print(lat_El_nino)
;print(lon_El_nino)
lat_El_ninoAvg = dim_avg(lat_El_nino)
lat_La_ninaAvg = dim_avg(lat_La_nina)
lat_normalAvg = dim_avg(lat_normal)

lon_El_ninoAvg = dim_avg(lon_El_nino)
lon_La_ninaAvg = dim_avg(lon_La_nina)
lon_normalAvg = dim_avg(lon_normal)

plotAvg_res = True
plotAvg_res@gsMarkerSizeF = 0.1
plotAvg_res@gsMarkerIndex = 2               ; set predefined markers to the cross marker
plotAvg_res@gsMarkerThicknessF = 8
; plot_mean
plotAvg_res@gsMarkerColor = "Red"
plot_ElAvg = gsn_add_polymarker(wks, map, lon_El_ninoAvg, lat_El_ninoAvg, plotAvg_res)
plotAvg_res@gsMarkerColor = "Blue"
plot_LaAvg = gsn_add_polymarker(wks, map, lon_La_ninaAvg, lat_La_ninaAvg, plotAvg_res)
plotAvg_res@gsMarkerColor = "Green"
plot_normalAvg = gsn_add_polymarker(wks, map, lon_normalAvg, lat_normalAvg, plotAvg_res)

colors = (/"Red", "Blue", "Green"/)
labels = (/"El nino", "La nina", "Normal"/)

xleg = (/0.25, 0.45, 0.65/)
xtxt = xleg + 0.05

yleg = (/0.2, 0.2, 0.2/)
ytxt = yleg

do i = 0, 2
  plots_res@gsMarkerColor = colors(i)
  gsn_polymarker_ndc(wks, xleg(i), yleg(i), plots_res)
end do

txres = True
txres@txFontHeightF = 0.015
gsn_text_ndc(wks, labels, xtxt, ytxt, txres)

draw(map)
frame(wks)



end
