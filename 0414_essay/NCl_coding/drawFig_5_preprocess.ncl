; NCL are always passed by reference
procedure processTrackDensity(trackDensity[*][*]:float, trackDot[*][*]:float, resolution:float)
local index, row, column
begin
  do index = 0, dimsizes(trackDot(:, 0)) - 1
    row = floattointeger((trackDot(index, 0) + 90 + resolution/2) / resolution) 
    column = floattointeger((trackDot(index, 1) + resolution/2) / resolution)
    trackDensity(row, column) = trackDensity(row, column) + 1
  end do
end



begin

resolution = 1.0  ; latitude and longtitude grid

dim_lat = floattointeger(180/resolution) + 1
dim_lon = floattointeger(360/resolution)

npts = dim_lat
finish = -90. + resolution * (npts - 1)
lat = fspan(-90., finish, npts)
lat!0 = "lat"
lat@long_name = "latitude"
lat@units = "degrees_north"

npts = dim_lon
finish = 0. + resolution * (npts - 1)
lon = fspan(0., finish, npts)
lon!0 = "lon"
lon@long_name = "longitude"
lon@units = "degrees_east"

AllTrackDot = table_attach_rows(readAsciiTable("../data/AllEastPacific.csv", 2, "float", (/0, 0/)),\
                                readAsciiTable("../data/AllWestPacific.csv", 2, "float", (/0, 0/)), 0)
EPWTrackDot = table_attach_rows(readAsciiTable("../data/EPWEastPacific.csv", 2, "float", (/0, 0/)),\
                                readAsciiTable("../data/EPWWestPacific.csv", 2, "float", (/0, 0/)), 0)
CPWTrackDot = table_attach_rows(readAsciiTable("../data/CPWEastPacific.csv", 2, "float", (/0, 0/)),\
                                readAsciiTable("../data/CPWWestPacific.csv", 2, "float", (/0, 0/)), 0)
EPCTrackDot = table_attach_rows(readAsciiTable("../data/EPCEastPacific.csv", 2, "float", (/0, 0/)),\
                                readAsciiTable("../data/EPCWestPacific.csv", 2, "float", (/0, 0/)), 0)

AllTrackDensity = new((/dim_lat, dim_lon/), float)
AllTrackDensity!0 = "lat"
AllTrackDensity!1 = "lon"
AllTrackDensity&lat = lat
AllTrackDensity&lon = lon
AllTrackDensity(:, :) = 0

EPWTrackDensity = new((/dim_lat, dim_lon/), float)
copy_VarCoords(AllTrackDensity, EPWTrackDensity)
EPWTrackDensity(:, :) = 0

CPWTrackDensity = new((/dim_lat, dim_lon/), float)
copy_VarCoords(AllTrackDensity, CPWTrackDensity)
CPWTrackDensity(:, :) = 0

EPCTrackDensity = new((/dim_lat, dim_lon/), float)
copy_VarCoords(AllTrackDensity, EPCTrackDensity)
EPCTrackDensity(:, :) = 0

processTrackDensity(AllTrackDensity, AllTrackDot, resolution)
processTrackDensity(EPWTrackDensity, EPWTrackDot, resolution)
processTrackDensity(CPWTrackDensity, CPWTrackDot, resolution)
processTrackDensity(EPCTrackDensity, EPCTrackDot, resolution)


; ** Set options for the format to accessed the file
; ** This will specify the method when executing addfile() or addfiles()
setfileoption("nc","preFill",False)
setfileoption("nc","defineMode",True)  ; set only for files opened for writing

; ** Open a new NetCDF file to write to
fout_name = "TrackDensity.nc"
system("rm -f ../data/" + fout_name)
fout = addfile("../data/" + fout_name, "c")  ; option "c" is for "create and than write" mode

; ** Define the dimension names and their sizes on the file
; parameter: file name, dim name, dim size, unlimited dim or not
filedimdef(fout, (/"lat", "lon"/), (/dim_lat, dim_lon/), (/False, False/))

; ** Define each variablei's name, its type, its dimension names on the file
filevardef(fout, "lat", "float", "lat")
filevardef(fout, "lon", "float", "lon")
filevardef(fout, "AllTrackDensity", "float", (/"lat", "lon"/))
filevardef(fout, "EPWTrackDensity", "float", (/"lat", "lon"/))
filevardef(fout, "CPWTrackDensity", "float", (/"lat", "lon"/))
filevardef(fout, "EPCTrackDensity", "float", (/"lat", "lon"/))

; ** Define each variable's attributes on the file
filevarattdef(fout, "lat", lat)
filevarattdef(fout, "lon", lon)
filevarattdef(fout, "AllTrackDensity", AllTrackDensity)
filevarattdef(fout, "EPWTrackDensity", EPWTrackDensity)
filevarattdef(fout, "CPWTrackDensity", CPWTrackDensity)
filevarattdef(fout, "EPCTrackDensity", EPCTrackDensity)

; ** Now write the variables to the file
; "(/" and "/)" prevent the (re)writing of attributes
fout->lat = (/lat/)
fout->lon = (/lon/)
fout->AllTrackDensity = (/AllTrackDensity/)
fout->EPWTrackDensity = (/EPWTrackDensity/)
fout->CPWTrackDensity = (/CPWTrackDensity/)
fout->EPCTrackDensity = (/EPCTrackDensity/)

; ** Close file. Not necessary, but a good habit
delete(fout)

end
