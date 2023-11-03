clear
npgo=fileread('/data/yshuang/index/NPGO.txt');
disp(npgo);

fn=fopen('/data/yshuang/index/NPGO.txt');
npgoi=textscan(fn,'%d%d%f','Delimiter','\t');
fclose(fn);

%disp(fileread('/data/yshuang/index/nino34index.txt'));
filename=fopen('/data/yshuang/index/nino34index.txt');
%a=textscan(filename,'%s',1);
%b=textscan(filename,'%s',5);
%c=textscan(filename,'%d%d%f%f%f','Delimiter','\t'); 
fclose(filename);
%nino34=cell2mat(c(1,5));
%disp(nino34);

fid1=fopen('/data/course/ASCII/2018_TC_JTWC_Lon/Lon1980.txt');
%line1=fgetl(fid1);
%line2=fscanf(fid1,'%g',[12 20]);  %filled in column order
%line2=line2';
%fclose(fid1);

fid2='/data/course/ASCII/2018_IGRA/IGRA_20NS_stations.txt';
%fd2=fopen(fid2);
%line2=fscanf(fd2,'%g',[8 Inf]);  % '%s''%c'[89 82]
%fclose(fd2);
%line3=readtable(fid2,'Delimiter', '\t', 'ReadVariableNames', false, 'Format', '%11c%f%f%f%30c%f%f%f');
%location=table2array(line3(:, [2 3 4 6 7 8]));
%disp(location);

fidbin = fopen('/data/course/2023_NCL_course/TA/0309_class3/fnldata.dat');
%Data= fread(fidbin,[91*46*3 3],'float');
%GHT=reshape(Data(:,1),91,46,3);
%U=reshape(Data(:,2),91,46,3);
%V=reshape(Data(:,3),91,46,3);
fclose(fidbin);

ncfile='/data/course/ERA-Interim/Monthly/0.5x0.5/Global/U/ERAITM_Mon_1980_U_361x720.nc';
%ncdisp(ncfile);       
%udata = ncread(ncfile,'u');
%nctime = ncread(ncfile,'time')/24;
%D = datetime(nctime+2,'ConvertFrom','excel')