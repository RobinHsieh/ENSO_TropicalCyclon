clear
tStart = cputime;
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
us_ac=zeros(401,121,12);
vs_ac=zeros(401,121,12);
for k=1:num_files
    us_ac=us_ac+us(:,:,(k-1)*12+1:k*12);
    vs_ac=vs_ac+vs(:,:,(k-1)*12+1:k*12);
end
us_ac=us_ac./40;
vs_ac=vs_ac./40;

for k=1:num_files
    us(:,:,(k-1)*12+1:k*12)=us(:,:,(k-1)*12+1:k*12)-us_ac;
    vs(:,:,(k-1)*12+1:k*12)=vs(:,:,(k-1)*12+1:k*12)-vs_ac;
end

uv=[us vs];
t = cputime-tStart
%Climat Data toolbox
xx=reshape(uv,242*401,480);
xx=detrend(xx');
c=xx*xx';
[Vs D]=eig(c);
Vs=xx'*Vs;
sq = (sqrt(diag(D)))';
sq = sq(ones(1,242*401),:);
Vs = Vs ./ sq;
PCs=Vs'*xx';
expvar=100*(diag(D)./trace(D))';
EOFs=Vs;
eof_maps = reshape(EOFs,401,242,480); 
ueof1=eof_maps(:,1:121,480);
veof1=eof_maps(:,122:242,480);
ueof1=ueof1'.*std(PCs(480,:));
veof1=veof1'.*std(PCs(480,:));
PC1=PCs(480,:)./std(PCs(480,:));
ueof2=eof_maps(:,1:121,479);
veof2=eof_maps(:,122:242,479);
ueof2=ueof2'.*std(PCs(479,:));
veof2=veof2'.*std(PCs(479,:));
PC2=PCs(479,:)./std(PCs(479,:));

figure('Position', [100 100 1100 600]);
subplot(2,1,1);
load coastlines;
ax = axesm('mercator','MapLatLimit',[-30 30],'MapLonLimit',[100 300],'grid','on','frame','on');
axis off
set(gca, 'xlim', [-1.78 1.78]);
set(gca, 'ylim', [-0.89 0.89]);
setm(gca,'MLabelParallel','south');
mlabel('MLabelLocation',60);
getm(gca,'FLineWidth');
setm(gca,'FLineWidth',1);
set(gca,'Position', [0.025 0.46 0.45 0.53]);

map = [0 0.9 0.4; 0 0.65 0; 0 0.8 0 ; 0 0.9 0 ; 0 1 0 ; 1 1 1; 1 1 1; 1 1 0;1 0.8 0;1 0.4 0;0.9 0 0;0.7 0 0];
colormap(map);
[x,y] = meshgrid(double(lon), double(lat));
contourfm(y,x,ueof1,[-1.2 -1.0 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0 1.2],'LineColor',[0.5 0.5 0.5]);
c1 = contourcbar;
caxis([-1.2 1.2]);
c1.Ticks = [-1.0 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0];
c1.Location = 'south';
c1.Position = [0.08 0.45 0.33 0.03];

geoshow(coastlat, coastlon,'color','b','LineWidth',1.);

hold on;
x2=x(1:15:121,1:15:401);
y2=y(1:15:121,1:15:401);
ueof1=ueof1(1:15:121,1:15:401);
veof1=veof1(1:15:121,1:15:401);
qv1=quiverm(y2,x2,veof1,ueof1,'k',1);
qv1(1).LineWidth=1.1;
qv1(2).LineWidth=1.1;
title(strcat('EOF1 (',num2str(round(expvar(1,480),1)),'%)'));
patch([1.36 1.36 1.74 1.74],[-0.345 -0.545 -0.545 -0.345],'white');
text(1.38,-0.39 ,'1.0 m/s');
quiver(1.41,-0.5,0.15721668015,0,'AutoScale','off','maxheadsize',12);
hold off;

subplot(2,2,3);
date=linspace(1979,2018+11/12,480);
plot(date,PC1);
title('PC1 (1979-2018)');
set(gca,'XTick',1982:8:2018,'Position', [0.035 0.15 0.42 0.2],'XMinorTick','on','YMinorTick','on');
ax=gca;
ax.YLim = [-4.0 4.0];
ax.XLim = [1979 2018+11/12];

subplot(2,2,2);
load coastlines;
ax = axesm('mercator','MapLatLimit',[-30 30],'MapLonLimit',[100 300],'grid','on','frame','on');
axis off
set(gca, 'xlim', [-1.78 1.78]);
set(gca, 'ylim', [-0.89 0.89]);
setm(gca,'MLabelParallel','south');
mlabel('MLabelLocation',60);
plabel('PLabelLocation',15);
getm(gca,'FLineWidth');
setm(gca,'FLineWidth',1);
set(gca,'Position', [0.515 0.46 0.45 0.53]);

[x,y] = meshgrid(double(lon), double(lat));
contourfm(y,x,-ueof2,[-1.2 -1.0 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0 1.2],'LineColor',[0.5 0.5 0.5]);
caxis([-1.2 1.2]);
c = contourcbar;
c.Ticks = [-1.0 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4 0.6 0.8 1.0];
c.Location = 'south';
c.Position = [0.58 0.44 0.33 0.03];

geoshow(coastlat, coastlon,'color','b','LineWidth',1.);

hold on;
x2=x(1:15:121,1:15:401);
y2=y(1:15:121,1:15:401);
ueof2=ueof2(1:15:121,1:15:401);
veof2=veof2(1:15:121,1:15:401);
qv2=quiverm(y2,x2,-veof2,-ueof2,'k',1.);
qv2(1).LineWidth=1.1;
qv2(2).LineWidth=1.1;
patch([1.36 1.36 1.74 1.74],[-0.345 -0.545 -0.545 -0.345],'white');
text(1.38,-0.39 ,'1.0 m/s');
quiver(1.41,-0.5,0.24,0,'AutoScale','off','maxheadsize',12);
hold off;
title(strcat('EOF2 (',num2str(round(expvar(1,479),1)),'%)'));

subplot(2,2,4);
date=linspace(1979,2018+11/12,480);
plot(date,-PC2);
title('PC2 (1979-2018)');
set(gca,'XTick',1982:8:2018,'Position', [0.535 0.15 0.42 0.2],'XMinorTick','on','YMinorTick','on');
ax=gca;
ax.YLim = [-3.5 4.5];
ax.XLim = [1979 2018+11/12];

saveas(gca,'plot_windeof.png');
t = cputime-tStart