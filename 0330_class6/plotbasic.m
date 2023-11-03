clear
x=linspace(0,2*pi,100);
y=exp(-x).*sin(4.*x);
h1=figure;                        %must write
p1=plot(x,y,'black','Marker','o');
%set(p1,'lineStyle',':');
%set(p1,'linewidth',1);
%set(p1,'MarkerIndices',1:4:100);
%set(gca, 'YScale', 'log')
%xlabel('Time');
%ylabel('Amplitude');
title('A Damped Sine Wave');
ax=gca;
%ax.YLim = [-0.8 0.8];
%ax.XLim = [0 2.*pi];
%yticks('Manual');
%yticks([-0.8 -0.6 -0.4 -0.2 0. 0.2 0.4 0.6 0.8]);
%ax.XTick= [0 0.5*pi pi 1.5*pi 2*pi];
%xticklabels({'0' '0.5\pi' '\pi' '1.5\pi' '2\pi'})
%grid on;
saveas(h1,'plot1_basic.png');

%y2=(exp(0.1*x)-1).*cos(2.*x);
%h2=figure;                      %must write
%p2=plot(x,y,'ko',x, y2,'r-*');
%p2(1).MarkerIndices=1:1:100;
%p2(2).MarkerIndices=1:3:100;
%legend('A damped sine wave','A growing cosine wave','location','best'); %northwest
%grid off;
%saveas(h2,'plot2_basic.png');