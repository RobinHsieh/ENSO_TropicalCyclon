clear
udir='/data/course/ERA-Interim/Monthly/0.5x0.5/Global/U/';
udinfo=dir(fullfile(udir, '*.nc'));
ncfileu=fullfile( udir, {udinfo.name} );
vdir='/data/course/ERA-Interim/Monthly/0.5x0.5/Global/V/';
vdinfo=dir(fullfile(vdir, '*.nc'));
ncfilev=fullfile( vdir, {vdinfo.name} );
num_files = length(udinfo);
udata = cell(num_files, 1);
vdata = cell(num_files, 1);
lat= ncread(ncfileu{1},'lat',[121],[121]);
lon= ncread(ncfileu{1},'lon',[201],[401]);
for k=1:num_files
    ufilename=ncfileu{k};
    vfilename=ncfilev{k};
    udata{k}=permute(squeeze(ncread(ufilename,'u',[201 121 37 1],[401 121 1 Inf])),[3 2 1]);
    vdata{k}=permute(squeeze(ncread(vfilename,'v',[201 121 37 1],[401 121 1 Inf])),[3 2 1]);
end
us=permute(cell2mat(udata),[3 2 1]);
vs=permute(cell2mat(vdata),[3 2 1]);

filename=fopen('/data/yshuang/index/nino34index.txt');
a=textscan(filename,'%s',1);
b=textscan(filename,'%s',5);
c=textscan(filename,'%d%d%f%f%f','Delimiter','\t'); 
fclose(filename);
nino34=cell2mat(c(1,5));
nino34=nino34./std(nino34);
ur = zeros(401,121);
vr = zeros(401,121);

for jj=1:121
    for ii=1:401
        [r,mm,bb] = regression(nino34(349:828),squeeze(us(ii,jj,:)),'one');
        ur(ii,jj) = mm;
        [r,mm,bb] = regression(nino34(349:828),squeeze(vs(ii,jj,:)),'one');
        vr(ii,jj) = mm;
    end
end
figure('Position', [100 100 800 400]);
ur=permute(ur,[2 1]);
vr=permute(vr,[2 1]);
[x,y] = meshgrid(double(lon), double(lat));
x2=x(1:15:121,1:15:401);
y2=y(1:15:121,1:15:401);
ur=ur(1:15:121,1:15:401);
vr=vr(1:15:121,1:15:401);
quiver(x2,y2,ur,vr);
ax=gca;
ax.YLim = [-32 32];
ax.XLim = [98 302];
