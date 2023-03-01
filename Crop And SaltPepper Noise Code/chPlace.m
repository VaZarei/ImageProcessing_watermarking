 function [newVal,oldbin,newbin]=chPlace(oldValue, charBit , place , base )     % chPlace( oldValue , charBit , threshold , base )

% oldValue = 253 ;
% charBit= 1;
% base=2;
% place=2;


oldValue=floor(abs(oldValue));
charBit=num2str(charBit);

decTobaseOldvalue=dec2base(oldValue,base);

oldbin=decTobaseOldvalue ;

[a b]=size(decTobaseOldvalue);



t=b-place+1 ;
decTobaseOldvaluep=decTobaseOldvalue;
decTobaseOldvaluep(t)=charBit ;

newbin=decTobaseOldvaluep;

newVal=base2dec(decTobaseOldvaluep,base);
 end