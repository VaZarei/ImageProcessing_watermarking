function [ berValue ] = BER( im1,im2 )
[m,n]=size(im1);
t=0;
for i=1:m
    for j=1:n
        
        if (im1(i,j)~=im2(i,j))
            t=t+1 ;
        end
    end
end

       berValue=((t/(m*n))*100) ;

end

