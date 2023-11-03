
function  [power,rn, cil, cih,freq] = spec_anal(x,pLow,pHigh,jave,pct)
   n = length(x);          % number of samples
   f = (0:n-1)*(1./n);     % frequency range
   freq= f(2:313)*12;
   x1=x.*permute(tukeywin(n,pct),[2 1]);
   y=fft(x1);
   power = abs(y).^2;
   pow = [power(313:623) power(2:624)];
   
   if (jave >= 3 & mod(jave,2) ~= 0);
       wgt         = ones(1,jave);
       wgt(1)      = 0.5  ; 
       wgt(jave) = 0.5  ;
       wgt         = wgt/sum(wgt);
       power=tsmovavg(pow,'w',wgt);
       ja=(jave-1)/2. ;
       power = power(312+ja:312+ja+311);
   elseif (mod(jave,2) == 0 & jave >= 3);
       disp('jave must be odd number');
       return;
   else;
       wgt=1;
       power=power(2:313)
   end;
   
   power = power*2/n;    % power of the DFT
   
   [acf,lags] = autocorr(x);
   r     = acf(2);
   r2    = 2.*r;
   rsq   = r*r;

   temp  = r2*cos(2*pi*freq./12)    ; %vector

   mkov  = 1./(1. + rsq - temp)      ; %Markov Model
   
   sum1  = sum (mkov)                ; %sum Markov elements
   sum2  = sum (power)           ; %sum spectral elements
   scale = sum2/sum1                 ; %scaling factor
   
  tapcf= 0.5*(128-93*pct)/(8-5*pct)^2;
  df= 2./(tapcf*sum(wgt.^2));
  xLow  = chi2inv(pLow,  df)/df     ; %lower confidence
  xHigh = chi2inv(pHigh, df)/df     ; %upper confidence
  rn=mkov*scale;
  cil=rn*xLow;
  cih=rn*xHigh;
end