function [rateNC ] = NC( w1,w2 )

[nw1 mw1]=size(w1);

  %% up fraction
  
  tot_up=0;
  l_tot=0;
  r_tot=0;
  for i=1:nw1
      for j=1:mw1
          
          b=w1(i,j)*w2(i,j);
          tot_up=tot_up+b ;
          
   %% downLeft   
          
          l=w1(i,j)^2;
          l_tot=l_tot+l ;
    
    %% downRight
      
          r=w2(i,j)^2;
          r_tot=r_tot+r ;
         
          
      end
  end
    
  
      %% downLeftRight
      
      rateNC=tot_up/sqrt(l_tot*r_tot);
 
 



end

