clear
tStart = cputime;
udir='/data/course/ERA-Interim/Monthly/0.5x0.5/Global/U/';
udinfo=dir(fullfile(udir, '*.nc'));
ncfileu=fullfile( udir, {udinfo.name} );
%read v wind component file


num_files = length(udinfo);
udata = cell(num_files, 1);
%create a vdata cell


lat= ncread(ncfileu{1},'lat',[121],[121]);
lon= ncread(ncfilev{1},'lon',[201],[401]);
for k=1:num_files
    ufilename=ncfileu{k};
    vfilename=ncfilev{k};
    udata{k}=permute(squeeze(ncread(ufilename,'u',[201 121 37 1],[401 121 1 Inf])),[3 2 1]);
    %read v 1000 hPa (37) wind variable
    
end
us=cell2mat(udata);
%convert cell to matrix


%%calculate annual cycle
us_ac=zeros(12,121,401);
%create v annual cycle array

for k=1:num_files
    us_ac=us_ac+us((k-1)*12+1:k*12,:,:);
    % calculate sum
    
end
us_ac=us_ac./40;
%calculate mean


for k=1:num_files
    us((k-1)*12+1:k*12,:,:)=us((k-1)*12+1:k*12,:,:)-us_ac;
    %remove seasonal cycle
    
end

uv= [ ]; %combine us and vs
t = cputime-tStart
%%EOF calculation from Climat Data toolbox
x=reshape(uv,480,242*401);
x=detrend(x);
c=x*x';
[Vs D]=eig(c);
Vs=x'*Vs;
sq = (sqrt(diag(D)))';
sq = sq(ones(1,242*401),:);
Vs = Vs ./ sq;
PCs=Vs'*x';
expvar=100*(diag(D)./trace(D))';
EOFs=Vs';
eof_maps = reshape(EOFs,480,242,401); 
eof_maps = permute(eof_maps,[2 3 1]);
%%get EOF1 u, v vector & PC1
ueof1=eof_maps(1:121,:,480);
veof1=eof_maps(122:242,:,480);
ueof1=ueof1.*std(PCs(480,:));
veof1=veof1.*std(PCs(480,:));
PC1=PCs(480,:)./std(PCs(480,:));
%get EOF2 u, v vector & PC2
ueof2=eof_maps(1:121,:,479);
veof2=eof_maps(122:242,:,479);
ueof2=ueof2.*std(PCs(479,:));
veof2=veof2.*std(PCs(479,:));
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
set(gca,'XTick',1982:8:2018,'Position', [0.035 0.15 0.42 0.2]);
ax=gca;
ax.YLim = [-4.0 4.0];
ax.XLim = [1979 2018+11/12];

%subplot
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
%draw u wind (shading) & coastlines


%draw u v wind vector map

patch([1.36 1.36 1.74 1.74],[-0.345 -0.545 -0.545 -0.345],'white');
text(1.38,-0.39 ,'1.0 m/s');
quiver(1.41,-0.5,0.24,0,'AutoScale','off','maxheadsize',12);
hold off;
%write title


%subplot
%draw PC2 timeseries & title


%save picture

t = cputime-tStart