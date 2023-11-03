begin

;==========================================
;open file
;==========================================

 diri = "/data/course/ASCII/"
 path = (/"2018_TC_JTWC_Lat/","2018_TC_JTWC_Lon/"/)
 ; position of Typhoon born        ;column:every month ; row :each typhoon's position(lat/lon)
;==========================================
;read lat & lon (1980)
;==========================================
 year = 1980
 ;(/year,month/) (/20,12/)
 lat = asciiread(diri+path(0)+"Lat"+year+".txt",(/20,12/),"float")  ;路徑,讀取方式,資料格式
 lon = asciiread(diri+path(1)+"Lon"+year+".txt",(/20,12/),"float")
 lat@_FillValue = 9453.  ; missing value
 lon@_FillValue = 9453.                 

; print(lat) 
; print(lon)
; printVarSummary(lat)

;==========================================
;draw (1980)
;==========================================
 diro = "/data/course/2023_NCL_course/student/wlhsieh/HW3/"
 optname = "scatterplot"
 wks = gsn_open_wks("png",diro+optname)

 res = True
 res@gsnMaximize = True

 res@mpMaxLatF = 40
 res@mpMinLatF = 0
 res@mpMaxLonF = 210.
 res@mpMinLonF = 90.
 res@mpCenterLonF = 180.
 ;res@gsnFrame = False
 ;res@gsnDraw = False

 map = gsn_csm_map(wks,res) 

;----------------------------------------------------------------1 Customize map

  pres = True
  pres@gsMarkerSizeF = 0.03
  pres@gsMarkerColor = "Blue"
  pres@gsMarkerIndex = 1

  plot = gsn_add_polymarker(wks,map,lon,lat,pres)

  draw(map)
  frame(wks)


;----------------------------------------------------------------2 add polymarkers

;==========================================
;draw (1980-2015)
;==========================================

 plot_allyear = new(2015-1980+1,graphic)
 res@gsnFrame = False
 res@gsnDraw = False

 map = gsn_csm_map(wks,res)

 do year = 1980, 2015
     lat = asciiread(diri+path(0)+"Lat"+year+".txt", (/20,12/), "float")
     lon = asciiread(diri+path(1)+"Lon"+year+".txt", (/20,12/), "float")
     lat@_FillValue = 9453.
     lon@_FillValue = 9453.

     if(year .eq. 1982 .or. year .eq. 1997 .or. year .eq. 2015)then    ;強聖嬰 -red
         pres@gsMarkerColor = "Red"
     elseif(year .eq. 1983 .or. year .eq. 1998)then   ;強反聖嬰 -blue
         pres@gsMarkerColor = "Blue"
     else ;其他 ->black
         pres@gsMarkerColor = "Black"                         
     end if
  
     plot_allyear(year - 1980) = gsn_add_polymarker(wks, map, lon(:, 9-1:11-1), lat(:, 9-1:11-1), pres)
 end do

 draw(map)
 frame(wks)

;----------------------------------------------------------------3 polymarkers for all years

 colors = (/"Red","Blue","Black"/)
 labels = (/"El nino","La nina","Normal"/)

;標籤的位置
 xleg = (/0.25,0.45,0.65/)                   ; Location of
 xtxt = xleg+0.05                            ; legend markers

 yleg = (/0.3,0.3,0.3/)                      ; and text
 ytxt = yleg

 do i = 0,2    ;3個標籤 -> 3個迴圈
    pres@gsMarkerColor = colors(i)
    gsn_polymarker_ndc(wks,xleg(i),yleg(i),pres)
 end do

;----------------------------------------------------------------4 polymarkers legends

  txres = True
  txres@txFontHeightF = 0.015
  gsn_text_ndc      (wks,labels,xtxt,ytxt,txres)

;----------------------------------------------------------------5 adjust font
  draw(map)
  frame(wks)





end
