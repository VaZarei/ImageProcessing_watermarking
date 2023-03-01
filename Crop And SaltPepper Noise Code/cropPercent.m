function [ percent ] = cropPercent( cropImg )

 [m,n]=size(cropImg);
 
 tot=0 ;
 for i=1:m
     for j=1:n
         
         if (cropImg(i,j)==0)
             
             tot=tot+1 ;
         end
     end
 end
 
  
  percent=((tot/(m*n))*100)        

  tot

end
