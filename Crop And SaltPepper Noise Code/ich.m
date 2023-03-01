function [ bit ] = ich (oldValue, place , base )

oldValue=floor(abs(oldValue));

decTobaseOldvalue=dec2base(oldValue,base);



[a b]=size(decTobaseOldvalue);



t=b-place+1 ;

bit=str2num(decTobaseOldvalue(t));


end

