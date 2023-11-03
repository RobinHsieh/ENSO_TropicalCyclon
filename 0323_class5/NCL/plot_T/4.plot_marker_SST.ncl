load "../procedure/my_functions.ncl"

begin

;=============================
; Open file
;=============================
  var = "SST"
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
  sst    = short2flt(f[:]->sst(Time,{latS:latN},:))      ;只要30年, 近地表, 南北緯20度之間的資料, 並同時轉成浮點數
printVarSummary(sst)

;=============================
; Analysis
;=============================

  sst_mean = dim_avg_n_Wrap(sst,0) ;將第0維度值平均

;==============================
; Plot where SST < 294K
;==============================
  cri = 294
  b = ind_value(sst_mean .lt. cri, sst_mean)
  i0 = b(:,0)
  i1 = b(:,1)
  lat2 = lat(i0)
  lon2 = lon(i1)
  path = "./SST_mean_lt_"+cri+"K"
  plot_scatter_map(path, "SST_mean < "+cri+"K", lat2, lon2)
  exit



end
