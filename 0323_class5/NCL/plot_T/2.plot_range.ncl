load "../procedure/my_functions.ncl"

begin

;=============================
; Open file
;=============================
  var = "T"
  dir = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/"+var
  fs  = systemfunc("ls "+dir+"/*.nc")
  f   = addfiles(fs,"r")
  ListSetType(f,"cat") ;如果是cat的形式儲存資料可以不用打沒關係~

;=============================
; Read
;=============================
  latN = 20.
  latS = -20.
  Y1   = 1980
  Y2   = 2009
  plev = 1000. ; 1000 hPa
  lat  = f[0]->latitude({latS:latN})
  lon  = f[0]->longitude
  time = cd_calendar(f[:]->time,0) ;把日期轉換成我們看得懂的整數型態
  Time = ind(time(:,0) .ge. Y1 .and. time(:,0) .le. Y2) ;時間只取1980到2009年
  T    = short2flt(f[:]->t(Time,{plev},{latS:latN},:))      ;只要30年, 近地表, 南北緯20度之間的資料, 並同時轉成浮點數
  


;=============================
; Analysis
;=============================

  T_mean = dim_avg_n_Wrap(T,0) ;將第0維度值平均

;=============================
; Plot distribution
;=============================
  level = fspan(290, 310, 11)
  dir = "./" 
  var = var+"_1000hPa"
  var@path = dir+"Distribution_"+var
  range(var,T_mean,level,1)
  exit
  


end
