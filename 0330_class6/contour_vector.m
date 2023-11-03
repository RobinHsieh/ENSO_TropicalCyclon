clear;
x = linspace(-2*pi,2*pi);
y = linspace(0,4*pi);
[X,Y] = meshgrid(x,y);
Z = exp(-Y).*sin(X) + exp(-0.1*Y).*cos(Y);
gg=figure;
gg=contourf(X,Y,Z,10,'w--');

%h=figure;
%[C,h]=contour(X,Y,Z,8);%,'ShowText','on');
%clabel(C,h,[1.1 0.45 -0.164]);

[FX,FY] = gradient(Z);
%h2=figure;
%h2=quiver(X(1:5:100,1:5:100),Y(1:5:100,1:5:100),FX(1:5:100,1:5:100),FY(1:5:100,1:5:100));