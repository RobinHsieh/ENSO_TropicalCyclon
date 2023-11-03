begin

;========================================================
; information :
; Source data: IGRA, NOAA
; web: https://www.ncdc.noaa.gov/data-access/weather-balloon/integrated-global-radiosonde-archive
; data: https://www1.ncdc.noaa.gov/pub/data/igra/igra2-station-list.txt
;========================================================

 diri = "/data/course/ASCII/2018_IGRA/"
 fname = "IGRA_20NS_stations.txt"

 str = asciiread(diri+fname, -1, "string")


  
 nrow = numAsciiRow(diri+fname)


 str := asciiread(diri+fname, nrow/2, "string")
 print(str)

;========================================================
; read data
;========================================================
;============================================
 id = new(nrow/2,"string")
 lat = new(nrow/2,"float")
 lon = new(nrow/2,"float")


 do i = 0,nrow/2-1
    element := str_split(str(i)," ")
    id(i) = element(0)
    lat(i) = tofloat(element(1))
    lon(i) = tofloat(element(2))
 end do

; print("ID: "+id+", lat: "+lat+", lon: "+lon)
; print("-----------------------------------")
; print("ID: "+id+", lat: "+sprintf("%6.2f",lat)+", lon: "+sprintf("%6.2f",lon))

;==============================================
 staname = new(nrow/2,"string")

 do j = 0,nrow/2-1
     char := str_split_by_length(str(j), 1)
     staname(j) = str_concat(char(42-1:71-1)); station name


 end do

 ;print(char)
 print(staname) 


end 
