begin
; ==================================
; open file
; ==================================

diri = "/data/course/ERA-Interim/Monthly/0.5x0.5/Global/"
var = (/"U/", "V/", "T/"/)

fn_U = "ERAITM_Mon_2016_U_361x720.nc"  ; float
fn_V = "ERAITM_Mon_2016_V_361x720.nc"  ; float
fn_T = "EC_T_Mon_2016.nc"              ; short

f_U = addfile(diri+var(0)+fn_U, "r")
f_V = addfile(diri+var(1)+fn_V, "r")
f_T = addfile(diri+var(2)+fn_T, "r")

; ===========
; read data: at 1000 hPa
; ===========

time = cd_calendar(f_U->time(:), -1)
lat = f_U->lat(:)
lon = f_U->lon(:)
u = f_U->u(:, {1000}, :, :)
v = f_V->v(:, {1000}, :, :)
T = short2flt(f_T->t(:, {1000}, :, :))
u&time = time
v&time = time
T&time = time

printVarSummary(u)
printVarSummary(v)
printVarSummary(T)

; ====
; draw
; ====

diro = "/data/wlhsieh/2023_NCL_course/0302_class2/"
optname = "02-1_vector"
wks = gsn_open_wks("pdf", diro+optname)

res = True
res@vcMinDistanceF = 0.017
res@









end
