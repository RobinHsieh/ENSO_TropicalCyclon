; Functions definition ---------------------
function set_histogram_res(res: logical)
local local_res
begin
  local_res = res
  local_res@tiXAxisString = "standard deviation of SST"
  local_res@tiYAxisString = "frequency"
  return local_res
end



function set_xy_marker_res(res: logical)
local local_res
begin
  local_res = res
  ; tr: handle coordinate transformations
  local_res@trYMaxF = 3.5
  local_res@trYMinF = -3.5
  local_res@trXMaxF = 2006.5      ; Defines the upper bound of the X-Axis coordinate
  local_res@trXMinF = 1949.5      ; Defines the lower bound of the X-Axis coordinate
  local_res@xyMarkLineModes = "Markers"
  local_res@xyMarkers = 16        ; Markers style
  local_res@xyMarkerSizeF = 0.01
  local_res@vpHeightF = 0.4
  local_res@vpWidthF = 0.7
  return local_res
end



function set_xy_bar_res(res: logical)
local local_res
begin
  local_res = res
  ; local_res@gsnMaximize = True
  local_res@trYMaxF = 3.5
  local_res@trYMinF = -3.5
  local_res@trXMaxF = 2006.5
  local_res@trXMinF = 1949.5
  local_res@gsnXYBarChart = True
  local_res@gsnXYBarChartBarWidth = 0.6
  local_res@gsnYRefLine = 0.
  local_res@gsnAboveYRefLineColor = "grey"
  local_res@gsnBelowYRefLineColor = "grey"
  local_res@vpHeightF = 0.4
  local_res@vpWidthF = 0.7
  return local_res
end



; Main program strat -----------------------
begin


path = "~/Programming/NCL/climate/0414/"
fileNames = systemfunc("ls " + path + "data/ERSST.v5 | egrep '....(07|08|09|10).nc' | tail -n 292 | head -n 228")
; print(fileNames)


sstYearAvgList_nino3 = new((/57/), float)
sstYearAvgList_nino4 = new((/57/), float)
xList = fspan(1950, 2006, 57)


do index = 0, 56, 1
  ; read a file's variables into variable files
  files := addfiles(path + "data/ERSST.v5/" + fileNames(index*4:index*4+3), "r")

  ; concate all sst variables of four month into one
  sst_nino3 := files[:]->sst(:, :, {-5:5}, {210:270})   ; coordinate {210:270} = 150W to 90W
  sst_nino4 := files[:]->sst(:, :, {-5:5}, {160:210})   ; coordinate {160:210} = 160E to 150W

  ; calculate sst average in a year into variable ssts
  temp_nino3 := dim_avg_n_Wrap(sst_nino3, (/2, 3/))
  temp_nino4 := dim_avg_n_Wrap(sst_nino4, (/2, 3/))
  sstYearAvgList_nino3(index) = dim_avg_n_Wrap(temp_nino3, 0)
  sstYearAvgList_nino4(index) = dim_avg_n_Wrap(temp_nino4, 0)
end do

sstAllAvg = (dim_avg(sstYearAvgList_nino3) + dim_avg(sstYearAvgList_nino4)) / 2
; print(sstAllAvg)

sstYearAvgList_nino3 := dim_standardize(sstYearAvgList_nino3, 1)
sstYearAvgList_nino4 := dim_standardize(sstYearAvgList_nino4, 1)

timeSeries = ispan(1950, 2006, 1)
sstYearAvgList_nino3!0 = "time"
sstYearAvgList_nino3&time = timeSeries
copy_VarCoords(sstYearAvgList_nino3, sstYearAvgList_nino4)
; print(sstYearAvgList_nino4)


; handle regression
rc_nino3 = regline(xList, sstYearAvgList_nino3)
rc_nino4 = regline(xList, sstYearAvgList_nino4)
; regression line: y = mx + b
; x: xList
; m: rc
; b: rc@yintercept
y_nino3 = rc_nino3*xList + rc_nino3@yintercept
y_nino4 = rc_nino4*xList + rc_nino4@yintercept
sstYearAvgAdjustList_nino3 = sstYearAvgList_nino3 - y_nino3
sstYearAvgAdjustList_nino4 = sstYearAvgList_nino4 - y_nino4


res = True
res@gsnDraw = False
res@gsnFrame = False


wks = gsn_open_wks("png", path + "image/Fig1bHistogram")

histo_res = set_histogram_res(res)

plot1 = gsn_histogram(wks, sstYearAvgList_nino3, histo_res)
plot2 = gsn_histogram(wks, sstYearAvgList_nino4, histo_res)

gsn_panel(wks, (/plot1, plot2/), (/1, 2/), False)


wks_2 = gsn_open_wks("png", path + "image/Fig1b")

xymarker_res = set_xy_marker_res(res)

plot3_1 = gsn_csm_xy(wks_2, xList, sstYearAvgList_nino3, xymarker_res)
plot4_1 = gsn_csm_xy(wks_2, xList, sstYearAvgAdjustList_nino3, xymarker_res)

xybar_res = set_xy_bar_res(res)

plot3_2 = gsn_csm_xy(wks_2, xList, sstYearAvgList_nino4, xybar_res)
plot4_2 = gsn_csm_xy(wks_2, xList ,sstYearAvgAdjustList_nino4, xybar_res)


overlay(plot3_1, plot3_2)
overlay(plot4_1, plot4_2)
gsn_panel(wks_2, (/plot3_1, plot4_1/), (/2, 1/), False)


end
