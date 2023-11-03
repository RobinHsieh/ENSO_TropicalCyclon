clear;
B=[1 2 3; 5 6 7; 9 7 6];
B2=[2; 6; 7];  %4x1 array
A2=[9 7 6 7];  %1x4 array

%Matrix calculation
%t=B2*3+1
%d=B2*A2
%anod=t/B2
%anod*B2
%anod2=t\B2
%anod2*t
%BB = B^2 %B*B

%Matrix's elements calculation
%t2=B2.*3+1
%al=1./A2  %1x1 array / 4x1 array 
%la=1.\A2 %la=A2./1
%tt=t.^2 %t.*t
%ta2=t.*B2   
%bda=B2.*A2  %B2.*A2=A2.*B2 & bda=A2*B2 can't run.

%tranpose array 
%array must be 2-dimension array.
%B2'  %B2'=B2.'
%B2(3)=7+i
%B2'  %B2'~=B2.'

%cat
%Z=cat(4,rand(3),B)