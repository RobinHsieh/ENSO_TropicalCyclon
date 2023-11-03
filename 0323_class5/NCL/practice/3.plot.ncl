load "./test.ncl"
begin

;=============================
; Open file
;=============================

  dir = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/T"
  fs  = systemfunc("ls "+dir+"/*.nc")
  f   = addfiles(fs,"r")
  ListSetType(f,"cat") ;如果是cat的形式儲存資料可以不用打沒關係~

;=============================
; Read
;=============================
  
  latN = 30.
  latS = -30.

  lat  = f[0]->latitude({latS:latN})
  lon  = f[0]->longitude
  time = cd_calendar(f[:]->time,0) ;把日期轉換成我們看得懂的整數型態
                                   ;詳細內容可以去NCL官網查ㄛ
;print(time)

  Time = ind(time(:,0) .ge. 1980 .and. time(:,0) .le. 2009) ;時間只取1980到2009年
  T    = short2flt(f[:]->t(Time,{1000},{latS:latN},:))      ;只要30年, 近地表, 南北緯20度之間的資料, 並同時轉成浮點數

;printVarSummary(T)

;=============================
; Analysis
;=============================

  T_mean = dim_avg_n_Wrap(T,0) ;將第0維度值平均

;=============================
; Plot
;=============================
figName = "T_mean"
figTopic = "Mean-state T (1000-hPa)"
variable = T_mean
plot(figName,figTopic, variable)

end
