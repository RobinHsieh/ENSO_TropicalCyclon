begin

; Files access  ---------------------------------------

dir_input_1 = "/data/course/ASCII/2018_TC_JTWC_Lat/"
dir_input_2 = "/data/course/ASCII/2018_TC_JTWC_Lon/"

dir_output = "/data/course/2023_NCL_course/student/wlhsieh/HW3/"
optname = "typhoon_SO_generateLat0-90Lon180-210"

; Analysis  -------------------------------------------



; Visualization  --------------------------------------

wks = gsn_open_wks("png",dir_output+optname) ; work station

res = True
res@gsnMaximize = True

res@mpMaxLatF = 40.
res@mpMinLatF = 0.
res@mpMaxLonF = 210.
res@mpMinLonF = 90.
res@mpCenterLonF = 180.

map = gsn_csm_map(wks, res)

pres = True
pres@gsMarkerSizeF = 0.03
pres@gsMarkerIndex = 1

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
    pres@gsMarkerColor = "Red"
    lat_El_nino := array_append_record(lat_El_nino, lat(:, 9-1), 0)
    lat_El_nino := array_append_record(lat_El_nino, lat(:, 10-1), 0)
    lon_El_nino := array_append_record(lon_El_nino, lon(:, 9-1), 0)
    lon_El_nino := array_append_record(lon_El_nino, lon(:, 10-1), 0)
  elseif(year .eq. 1988 .or. year .eq. 1989 .or. year .eq. 1999 .or. year .eq. 2000) then
    pres@gsMarkerColor = "Blue"
    lat_La_nina := array_append_record(lat_La_nina, lat(:, 9-1), 0)
    lat_La_nina := array_append_record(lat_La_nina, lat(:, 10-1), 0)
    lon_La_nina := array_append_record(lon_La_nina, lon(:, 9-1), 0)
    lon_La_nina := array_append_record(lon_La_nina, lon(:, 10-1), 0)
  else
    pres@gsMarkerColor = "Green"
    lat_normal := array_append_record(lat_normal, lat(:, 9-1), 0)
    lat_normal := array_append_record(lat_normal, lat(:, 10-1), 0)
    lon_normal := array_append_record(lon_normal, lon(:, 9-1), 0)
    lon_normal := array_append_record(lon_normal, lon(:, 10-1), 0)
  end if

  plot_allyear(year - 1980) = gsn_add_polymarker(wks, map, lon(:, 9-1:10-1), lat(:, 9-1:10-1), pres) ; look at Sep and Oct

end do

lat_El_nino_avg = dim_avg(lat_El_nino)
lat_La_nina_avg = dim_avg(lat_La_nina)
lat_normal_avg = dim_avg(lat_normal)

lon_El_nino_avg = dim_avg(lon_El_nino)
lon_La_nina_avg = dim_avg(lon_La_nina)
lon_normal_avg = dim_avg(lon_normal)

pres_2 = True
pres_2@gsMarkerSizeF = 0.1
pres_2@gsMarkerIndex = 2
pres_2@gsFillIndex = 6
pres_2@gsMarkerThicknessF = 8
; plot_mean
pres_2@gsMarkerColor = "Red"
plot_El_avg = gsn_add_polymarker(wks, map, lon_El_nino_avg, lat_El_nino_avg, pres_2)
pres_2@gsMarkerColor = "Blue"
plot_La_avg = gsn_add_polymarker(wks, map, lon_La_nina_avg, lat_La_nina_avg, pres_2)
pres_2@gsMarkerColor = "Green"
plot_normal_avg = gsn_add_polymarker(wks, map, lon_normal_avg, lat_normal_avg, pres_2)

colors = (/"Red", "Blue", "Green"/)
labels = (/"El nino", "La nina", "Normal"/)

xleg = (/0.25, 0.45, 0.65/)
xtxt = xleg + 0.05

yleg = (/0.3, 0.3, 0.3/)
ytxt = yleg

do i = 0, 2
  pres@gsMarkerColor = colors(i)
  gsn_polymarker_ndc(wks, xleg(i), yleg(i), pres)
end do

txres = True
txres@txFontHeightF = 0.015
gsn_text_ndc(wks, labels, xtxt, ytxt, txres)

draw(map)
frame(wks)



end

