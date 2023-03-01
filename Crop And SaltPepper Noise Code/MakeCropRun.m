clc
clear all
close all

sourcePattern='G:\Arshad\term 4\Codes\01-to make\01-FinalCodeAndReports\CropCodeAndDetails\Code\sourcePattern';
sourceImg='G:\Arshad\term 4\Codes\01-to make\01-FinalCodeAndReports\CropCodeAndDetails\Code\sourceImg' ;
saveDestination='G:\Arshad\term 4\Codes\01-to make\01-FinalCodeAndReports\CropCodeAndDetails\Code\destinationCrop';


Pformat='png' ;


sourceIAddress = fullfile(sourceImg,sprintf('*.%s',Pformat));
filesI = dir(sourceIAddress);


sourcePAddress = fullfile(sourcePattern,sprintf('*.%s',Pformat));
filesP = dir(sourcePAddress);
 
for k = 1:length(filesI)
    
    imgAddress=fullfile(sourceImg,filesI(k).name) 
    Img=imread(imgAddress);
    [m,n]=size(Img);
    
    
    for L = 1:length(filesP)
      
     PatAddress=fullfile(sourcePattern,filesP(L).name) 
     patImg=imread(PatAddress);
    [p,q]=size(Img);
    newImg=Img ;
    
    for i=1:p
        for j=1:q
            
            if patImg(i,j)==0 ;
             
               newImg(floor((n/p)*i),floor((m/q)*j))=0;
%              newImg(i,j)=255;
                
            end
        end
    end
    1
    addressWrite=fullfile(saveDestination ,sprintf('%s_%s.%s' ,filesI(k).name(1:length(filesI(k).name)-4) , filesP(L).name(1:length(filesP(L).name)-4),Iformat)) ;
    imwrite(newImg , addressWrite ); 
     
    imshow(newImg); 
    end
        
end

    
    