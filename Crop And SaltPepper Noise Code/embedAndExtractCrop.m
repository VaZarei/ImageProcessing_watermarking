
%% Crop I  970224 10:44 pm




    
% design for dcm and png with all size    970203  12:16 am

%% Begin and Enter image from folder

% clc
% clear all
% close all ;

%% Flags

imgFormat='png';

Active=true ;
notActive=false ;

FlagFigure =notActive;
flagEmbedding = Active ;       % Embedding
flagNoise = Active ;           % inject Noise_Crop
flagExtracting = Active ;      % Extracting
FlagIQMS = Active ;            % Calculate IQMS




%% Entry Images Address and adjusment Noise rate

saveDestination = 'F:\Arshad\Article_Code\Mail2Ostad\SlidesAndCode-VahidZarei\To Send\Crop And SaltPepper Noise Code\destinationImgCrop';   % Destination
sourceHimgs = 'F:\Arshad\Article_Code\Mail2Ostad\SlidesAndCode-VahidZarei\To Send\Crop And SaltPepper Noise Code\sourceHimgs';  % source Host images
sourceMimg  = 'F:\Arshad\Article_Code\Mail2Ostad\SlidesAndCode-VahidZarei\To Send\Crop And SaltPepper Noise Code\sourceMimg- 64\Logo- 64.jpg' ; % source message image
sourcePattern='F:\Arshad\Article_Code\Mail2Ostad\SlidesAndCode-VahidZarei\To Send\Crop And SaltPepper Noise Code\sourcePattern';  % sourceCrop Pattern


 NoiseRate=[0.00:0.01:0.99];       % inject Noise Unit
 % NoiseRate=[0.00 0.97];   % inject Noise Array

%% Raad Begin

message=imread(sourceMimg);     % uint 8 bashad
messagebw=im2bw(message,0.4);
[mm, nm] = size(messagebw);
figure;imshow(messagebw);title('Binary Message');




filePattern = fullfile(sourceHimgs,sprintf('*.%s',imgFormat));
jpegFiles = dir(filePattern);

for k = 1:length(jpegFiles)
    
    FolderNames{k} = jpegFiles(k).name ;
    Folder = fullfile(saveDestination,FolderNames{k});
    mkdir(Folder);
    
    
    baseFileName = jpegFiles(k).name;
    fullFileName = fullfile(sourceHimgs, baseFileName);
    
    if (strcmp(imgFormat,'dcm'))
    imageArray = dicomread(fullFileName);
    else
     imageArray = imread(fullFileName);
    end
    
    [m, n, p]=size(imageArray);
    
    if (p==3)
        hgray=rgb2gray(imageArray);
    else
        hgray=imageArray ;
    end
    
    %% Save host image And Message image
    
    HImgStoreName = sprintf('Host_%s',baseFileName) ;
    HImgStoreName = fullfile(saveDestination,FolderNames{k},HImgStoreName);
    
    if (strcmp(imgFormat,'dcm'))
        dicomwrite( hgray,HImgStoreName);
    else
       imwrite( hgray,HImgStoreName);
    end
    
    MImgStoreName = sprintf('BinaryMessage.png') ;
    MImgStoreName = fullfile(saveDestination,FolderNames{k},MImgStoreName);
    imwrite( messagebw,MImgStoreName);
    
    %%   old code inject
    
    
    % figure;imshow(hgray , []);title('Host gray image');
    Plan=im2bw(hgray) ;
    Plan(:)=1 ;
    
    
    maskMessage=message;
    maskMessage(:)=3;
    
    
    %% Configuration
    
    if (flagEmbedding == Active )
        
    display('01 - Embedding ...')
        
        whgray=hgray;
        
       
        if (strcmp(imgFormat,'dcm'))
            info = dicominfo(HImgStoreName);
            depth=double(info.BitDepth) ;
        else
            info = imfinfo(HImgStoreName);
            depth=double(info.BitDepth) ;
            
        end
        
        
        
        %% Replace Message In Host
        
        
        place1=1;
        place2=2;
        
        for i=1:mm                                % A1,B3,C2,D4 Location
            for j=1:nm
                
    %%          A1 ,(i,n/4-j+1)
    
                
                if ((whgray(i,floor(n/4-j+1))==0) || (whgray(i,floor(n/4-j+1))==1))                                     
                    whgray(i,floor(n/4-j+1))=2;
                end
                if ((whgray(i,floor(n/4-j+1))==2^depth-1) || (whgray(i,floor(n/4-j+1))==2^depth-2))
                    whgray(i,floor(n/4-j+1))=2^depth-3 ;
                end                                              
              
                
                charBit1=messagebw(i,j);
                
                bit2=ich(whgray(i,floor(n/4-j+1)),place2,2);
                if (bit2==charBit1)
                    whgray(i,floor(n/4-j+1))=       chPlace(whgray(i,floor(n/4-j+1)),'1',place1,2);                   
                   
                else
                    whgray(i,floor(n/4-j+1))=       chPlace(whgray(i,floor(n/4-j+1)),'0',place1,2);
                   
                end
                
                
   %%          B3 ,(m/2+i,n/2-j+1)      
   
              
                 if ((whgray(floor(m/2+i),floor(n/2-j+1))==0) || (whgray(floor(m/2+i),floor(n/2-j+1))==1))
                    whgray(floor(m/2+i),floor(n/2-j+1))=2;
                end
                if ((whgray(floor(m/2+i),floor(n/2-j+1))==2^depth-1) || (whgray(floor(m/2+i),floor(n/2-j+1))==2^depth-2))
                    whgray(floor(m/2+i),floor(n/2-j+1))=2^depth-3 ;
                end
                
                
                bit2=ich(whgray(floor(m/2+i),floor(n/2-j+1)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/2+i),floor(n/2-j+1))= chPlace(whgray(floor(m/2+i),floor(n/2-j+1)),'1',place1,2);               
                   
                else
                    whgray(floor(m/2+i),floor(n/2-j+1))= chPlace(whgray(floor(m/2+i),floor(n/2-j+1)),'0',place1,2);
                    
                end
                
                
  %%          C2 ,(m/4+i,3/4*n-j+1) 
  
  
                if ((whgray(floor(m/4+i),floor(3/4*n-j+1))==0) || (whgray(floor(m/4+i),floor(3/4*n-j+1))==1))
                    whgray(floor(m/4+i),floor(3/4*n-j+1))=2;
                end
                if ((whgray(floor(m/4+i),floor(3/4*n-j+1))==2^depth-1) || (whgray(floor(m/4+i),floor(3/4*n-j+1))==2^depth-2))
                    whgray(floor(m/4+i),floor(3/4*n-j+1))=2^depth-3 ;
                end
                
                
                bit2=ich(whgray(floor(m/4+i),floor(3/4*n-j+1)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/4+i),floor(3/4*n-j+1))= chPlace(whgray(floor(m/4+i),floor(3/4*n-j+1)),'1',place1,2);          
                    
                else
                    whgray(floor(m/4+i),floor(3/4*n-j+1))= chPlace(whgray(floor(m/4+i),floor(3/4*n-j+1)),'0',place1,2);
                   
                end
                
                
                
 %%          D4 ,(3/4*m+i,n-j+1)    
 
 
                if ((whgray(floor(3/4*m+i),floor(n-j+1))==0) || (whgray(floor(3/4*m+i),floor(n-j+1))==1))
                    whgray(floor(3/4*m+i),floor(n-j+1))=2;
                end
                if ((whgray(floor(3/4*m+i),floor(n-j+1))==2^depth-1) || (whgray(floor(3/4*m+i),floor(n-j+1))==2^depth-2))
                    whgray(floor(3/4*m+i),floor(n-j+1))=2^depth-3 ;
                end
                
                
                bit2=ich(whgray(floor(3/4*m+i),floor(n-j+1)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(3/4*m+i),floor(n-j+1))= chPlace(whgray(floor(3/4*m+i),floor(n-j+1)),'1',place1,2);           
                   
                else
                    whgray(floor(3/4*m+i),floor(n-j+1))= chPlace(whgray(floor(3/4*m+i),floor(n-j+1)),'0',place1,2);
                    
                end
                
                
                Plan(i,floor(n/4-j+1))=charBit1 ;
                Plan(floor(m/2+i),floor(n/2-j+1))=charBit1 ;
                Plan(floor(m/4+i),floor(3/4*n-j+1))=charBit1 ;
                Plan(floor(3/4*m+i),floor(n-j+1))=charBit1 ;
                
            end
        end
        
        
        
        
        
        for i=1:mm                                % A2,B4,C3,D1 Location
            for j=1:nm
                
                
  %%         A2 ,(m/2-i+1,j)                
                
                
  
               if ((whgray(floor(m/2-i+1),j)==0) || (whgray(floor(m/2-i+1),j)==1))
                    whgray(floor(m/2-i+1),j)=2;
                end
                if ((whgray(floor(m/2-i+1),j)==2^depth-1) || (whgray(floor(m/2-i+1),j)==2^depth-2))
                    whgray(floor(m/2-i+1),j)=2^depth-3 ;
                end


                charBit1=messagebw(i,j);
                
                bit2=ich(whgray(floor(m/2-i+1),j),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/2-i+1),j)=       chPlace(whgray(floor(m/2-i+1),j),'1',place1,2);                
                   
                else
                    whgray(floor(m/2-i+1),j)=       chPlace(whgray(floor(m/2-i+1),j),'0',place1,2);
                   
                end
                
                
  %%          B4 ,(m-i+1,n/4+j)  
  
                
                if ((whgray(floor(m-i+1),floor(n/4+j))==0) || (whgray(floor(m-i+1),floor(n/4+j))==1))
                    whgray(floor(m-i+1),floor(n/4+j))=2;
                end
                if ((whgray(floor(m-i+1),floor(n/4+j))==2^depth-1) || (whgray(floor(m-i+1),floor(n/4+j))==2^depth-2))
                    whgray(floor(m-i+1),floor(n/4+j))=2^depth-3 ;
                end              
                  
                bit2=ich(whgray(floor(m-i+1),floor(n/4+j)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m-i+1),floor(n/4+j))=     chPlace(whgray(floor(m-i+1),floor(n/4+j)),'1',place1,2);             
                    
                else
                    whgray(floor(m-i+1),floor(n/4+j))=     chPlace(whgray(floor(m-i+1),floor(n/4+j)),'0',place1,2);
                   
                end
                
                
  %%          C3 ,(3/4*m-i+1,n/2+j)
  
  
                if ((whgray(floor(3/4*m-i+1),floor(n/2+j))==0) || (whgray(floor(3/4*m-i+1),floor(n/2+j))==1))
                    whgray(floor(3/4*m-i+1),floor(n/2+j))=2;
                end
                if ((whgray(floor(3/4*m-i+1),floor(n/2+j))==2^depth-1) || (whgray(floor(3/4*m-i+1),floor(n/2+j))==2^depth-2))
                    whgray(floor(3/4*m-i+1),floor(n/2+j))=2^depth-3 ;
                end
                
                
                
                bit2=ich(whgray(floor(3/4*m-i+1),floor(n/2+j)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(3/4*m-i+1),floor(n/2+j))= chPlace(whgray(floor(3/4*m-i+1),floor(n/2+j)),'1',place1,2);         
                    
                else
                    whgray(floor(3/4*m-i+1),floor(n/2+j))= chPlace(whgray(floor(3/4*m-i+1),floor(n/2+j)),'0',place1,2);
                    
                end
                
                
 %%          D1 ,(m/4-i+1,3/4*n+j)     
 
                if ((whgray(floor(m/4-i+1),floor(3/4*n+j))==0) || (whgray(floor(m/4-i+1),floor(3/4*n+j))==1))
                    whgray(floor(m/4-i+1),floor(3/4*n+j))=2;
                end
                if ((whgray(floor(m/4-i+1),floor(3/4*n+j))==2^depth-1) || (whgray(floor(m/4-i+1),floor(3/4*n+j))==2^depth-2))
                    whgray(floor(m/4-i+1),floor(3/4*n+j))=2^depth-3 ;
                end
                
                
                bit2=ich(whgray(floor(m/4-i+1),floor(3/4*n+j)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/4-i+1),floor(3/4*n+j))= chPlace(whgray(floor(m/4-i+1),floor(3/4*n+j)),'1',place1,2);         
                    
                else
                    whgray(floor(m/4-i+1),floor(3/4*n+j))= chPlace(whgray(floor(m/4-i+1),floor(3/4*n+j)),'0',place1,2);
                   
                end
                
                
                Plan(floor(m/2-i+1),j)=charBit1 ;
                Plan(floor(m-i+1),floor(n/4+j))=charBit1 ;
                Plan(floor(3/4*m-i+1),floor(n/2+j))=charBit1 ;
                Plan(floor(m/4-i+1),floor(3/4*n+j))=charBit1 ;
                
            end
        end
        
        
        for i=1:mm                                % A3,B1,C4,D2 Location
            for j=1:nm
                
                charBit1=messagebw(i,j);
                
 %%           A3 , 4 , (3/4*m-i+1,n/4-j+1)
 
 
                if ((whgray(floor(3/4*m-i+1),floor(n/4-j+1))==0) || (whgray(floor(3/4*m-i+1),floor(n/4-j+1))==1))
                    whgray(floor(3/4*m-i+1),floor(n/4-j+1))=2;
                end
                if ((whgray(floor(3/4*m-i+1),floor(n/4-j+1))==2^depth-1) || (whgray(floor(3/4*m-i+1),floor(n/4-j+1))==2^depth-2))
                    whgray(floor(3/4*m-i+1),floor(n/4-j+1))=2^depth-3 ;
                end
                
                
                
                
                if (i+1<=mm)
                    charBit2=messagebw(i+1,j);
                    xorBits=xor(charBit1,charBit2);
                    
                    bit2=ich(whgray(floor(3/4*m-i+1),floor(n/4-j+1)),place2,2);
                    if (bit2==xorBits)
                        whgray(floor(3/4*m-i+1),floor(n/4-j+1))= chPlace(whgray(floor(3/4*m-i+1),floor(n/4-j+1)),'1',place1,2);     
                        
                    else
                        whgray(floor(3/4*m-i+1),floor(n/4-j+1))= chPlace(whgray(floor(3/4*m-i+1),floor(n/4-j+1)),'0',place1,2);
                       
                    end
                end
                
                
 %%           B1 , 6 ,(m/4-i+1,n/2-j+1)
 
 
                if ((whgray(floor(m/4-i+1),floor(n/2-j+1))==0) || (whgray(floor(m/4-i+1),floor(n/2-j+1))==1))
                    whgray(floor(m/4-i+1),floor(n/2-j+1))=2;
                end
                if ((whgray(floor(m/4-i+1),floor(n/2-j+1))==2^depth-1) || (whgray(floor(m/4-i+1),floor(n/2-j+1))==2^depth-2))
                    whgray(floor(m/4-i+1),floor(n/2-j+1))=2^depth-3 ;
                end
 
 
                if (j+1<=nm)
                    charBit2=messagebw(i,j+1);
                    xorBits=xor(charBit1,charBit2);
                    
                    bit2=ich( whgray(floor(m/4-i+1),floor(n/2-j+1)),place2,2);
                    if (bit2==xorBits)
                        whgray(floor(m/4-i+1),floor(n/2-j+1))=   chPlace(whgray(floor(m/4-i+1),floor(n/2-j+1)),'1',place1,2);       
                       
                    else
                        whgray(floor(m/4-i+1),floor(n/2-j+1))=   chPlace(whgray(floor(m/4-i+1),floor(n/2-j+1)),'0',place1,2);
                       
                    end
                end
                
                
 %%           C4 , 2 ,(m-i+1,3/4*n-j+1)
 
 
 
                if ((whgray(m-i+1,floor(3/4*n-j+1))==0) || (whgray(m-i+1,floor(3/4*n-j+1))==1))
                   whgray(m-i+1,floor(3/4*n-j+1))=2;
                end
                if ((whgray(m-i+1,floor(3/4*n-j+1))==2^depth-1) || (whgray(m-i+1,floor(3/4*n-j+1))==2^depth-2))
                    whgray(m-i+1,floor(3/4*n-j+1))=2^depth-3 ;
                end
 
 
                if (j-1>=1)
                    charBit2=messagebw(i,j-1);
                    xorBits=xor(charBit1,charBit2);
                    
                    bit2=ich( whgray(m-i+1,floor(3/4*n-j+1)),place2,2);
                    if (bit2==xorBits)
                        whgray(m-i+1,floor(3/4*n-j+1))=   chPlace(whgray(m-i+1,floor(3/4*n-j+1)),'1',place1,2);       
                       
                    else
                        whgray(m-i+1,floor(3/4*n-j+1))=   chPlace(whgray(m-i+1,floor(3/4*n-j+1)),'0',place1,2);
                       
                    end
                end
                
                
 %%            D2 , 8 ,(m/2-i+1,n-j+1)
 
 
                
                if ((whgray(floor(m/2-i+1),n-j+1)==0) || (whgray(floor(m/2-i+1),n-j+1)==1))
                    whgray(floor(m/2-i+1),n-j+1)=2;
                end
                if ((whgray(floor(m/2-i+1),n-j+1)==2^depth-1) || (whgray(floor(m/2-i+1),n-j+1)==2^depth-2))
                    whgray(floor(m/2-i+1),n-j+1)=2^depth-3 ;
                end
                
                
                
                if (i-1>=1)
                    charBit2=messagebw(i-1,j);
                    xorBits=xor(charBit1,charBit2);
                    
                    bit2=ich(whgray(floor(m/2-i+1),n-j+1),place2,2);
                    if (bit2==xorBits)
                        whgray(floor(m/2-i+1),n-j+1)=     chPlace(whgray(floor(m/2-i+1),n-j+1),'1',place1,2);         
                      
                    else
                        whgray(floor(m/2-i+1),n-j+1)=     chPlace(whgray(floor(m/2-i+1),n-j+1),'0',place1,2);
                       
                    end
                end
                
                
                Plan(floor(3/4*m-i+1),floor(n/4-j+1))=xorBits ;
                Plan(floor(m/4-i+1),floor(n/2-j+1))=xorBits ;
                Plan(m-i+1,floor(3/4*n-j+1))=xorBits ;
                Plan(floor(m/2-i+1),floor(n-j+1))=xorBits ;
            end
        end
        
        for i=1:mm                                % A4,B2,C1,D3 Location
            for j=1:nm
                
                charBit1=messagebw(i,j);
                
                
  %%            A4 , (3/4*m+i,j)
  
                if ((whgray(floor(3/4*m+i),j)==0) || (whgray(floor(3/4*m+i),j)==1))
                    whgray(floor(3/4*m+i),j)=2;
                end
                if ((whgray(floor(3/4*m+i),j)==2^depth-1) || (whgray(floor(3/4*m+i),j)==2^depth-2))
                    whgray(floor(3/4*m+i),j)=2^depth-3 ;
                end
  
  
                bit2=ich(whgray(floor(3/4*m+i),j),place2,2);
                if (bit2==charBit1)
                    whgray(floor(3/4*m+i),j)=       chPlace(whgray(floor(3/4*m+i),j),'1',place1,2);               % A4 , (3/4*m+i,j)
                    
                else
                    whgray(floor(3/4*m+i),j)=       chPlace(whgray(floor(3/4*m+i),j),'0',place1,2);
                    
                end
                
  %%             B2 , (m/4+i,n/4+j)
  
  
                if ((whgray(floor(m/4+i),floor(n/4+j))==0) || (whgray(floor(m/4+i),floor(n/4+j))==1))
                    whgray(floor(m/4+i),floor(n/4+j))=2;
                end
                if ((whgray(floor(m/4+i),floor(n/4+j))==2^depth-1) || (whgray(floor(m/4+i),floor(n/4+j))==2^depth-2))
                    whgray(floor(m/4+i),floor(n/4+j))=2^depth-3 ;
                end
  
  
                bit2=ich(whgray(floor(m/4+i),floor(n/4+j)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/4+i),floor(n/4+j))=     chPlace(whgray(floor(m/4+i),floor(n/4+j)),'1',place1,2);            
                   
                else
                    whgray(floor(m/4+i),floor(n/4+j))=     chPlace(whgray(floor(m/4+i),floor(n/4+j)),'0',place1,2);
                   
                end
                
                
  %%            C1 , (i,n/2+j)         
  
  
                if ((whgray(i,floor(n/2+j))==0) || (whgray(i,floor(n/2+j))==1))
                    whgray(i,floor(n/2+j))=2;
                end
                if ((whgray(i,floor(n/2+j))==2^depth-1) || (whgray(i,floor(n/2+j))==2^depth-2))
                    whgray(i,floor(n/2+j))=2^depth-3 ;
                end
                
                
                bit2=ich(whgray(i,floor(n/2+j)),place2,2);
                if (bit2==charBit1)
                    whgray(i,floor(n/2+j))=         chPlace(whgray(i,floor(n/2+j)),'1',place1,2);                
                    
                else
                    whgray(i,floor(n/2+j))=         chPlace(whgray(i,floor(n/2+j)),'0',place1,2);
                    
                end
                
                
  %%            D3 , (m/2+i,3/4*n+j)
  
  
  
                if ((whgray(floor(m/2+i),floor(3/4*n+j))==0) || (whgray(floor(m/2+i),floor(3/4*n+j))==1))
                    whgray(floor(m/2+i),floor(3/4*n+j))=2;
                end
                if ((whgray(floor(m/2+i),floor(3/4*n+j))==2^depth-1) || (whgray(floor(m/2+i),floor(3/4*n+j))==2^depth-2))
                    whgray(floor(m/2+i),floor(3/4*n+j))=2^depth-3 ;
                end
  
  
                bit2=ich(whgray(floor(m/2+i),floor(3/4*n+j)),place2,2);
                if (bit2==charBit1)
                    whgray(floor(m/2+i),floor(3/4*n+j))=   chPlace(whgray(floor(m/2+i),floor(3/4*n+j)),'1',place1,2);           
                    
                else
                    whgray(floor(m/2+i),floor(3/4*n+j))=   chPlace(whgray(floor(m/2+i),floor(3/4*n+j)),'0',place1,2);
                   
                end
                
                
                
                Plan(floor(3/4*m+i),j)=charBit1 ;
                Plan(floor(m/4+i),floor(n/4+j))=charBit1 ;
                Plan(i,floor(n/2+j))=charBit1 ;
                Plan(floor(m/2+i),floor(3/4*n+j))=charBit1 ;
                
            end
        end
        
        if (FlagFigure==Active)
        figure;imshow((whgray)) ;title('Replaced Message');
        end
        
        %% Save WaterMarked
        ImgStoreName = sprintf('WaterMareked_%s',baseFileName) ;
        ImgStoreName = fullfile(saveDestination,FolderNames{k},ImgStoreName) ;
        
        if (strcmp(imgFormat,'dcm'))
        dicomwrite( whgray,ImgStoreName);
        else
            imwrite( whgray,ImgStoreName);
        end
        
        
        
        
    end  % end first for loop
end  % end if(FlagEmbedding)

%% inject noise

if (flagNoise==Active)
    
   display('02 - Inject Noise Crop...')
    
    SizeNoiseArray=size(NoiseRate);
    
    
    WaterMarkedFolders=dir(saveDestination);
    WaterMarkedFoldersCount=size(WaterMarkedFolders);
    
    for w=3:1:WaterMarkedFoldersCount(1)
        
        AddressWatermarked=(fullfile(saveDestination,WaterMarkedFolders(w).name,sprintf('WaterMareked_%s',WaterMarkedFolders(w).name )));
       
         if (strcmp(imgFormat,'dcm'))
        whgray=dicomread(AddressWatermarked);
        else
            whgray=imread(AddressWatermarked);
        end
        
%         for x=1:SizeNoiseArray(2)
 %% Crop Embed Pattern Code  
 
 
 
 sourcePAddress = fullfile(sourcePattern,sprintf('*.png'));
 filesP = dir(sourcePAddress);
 
 for L = 1:length(filesP)
     
 PatAddress=fullfile(sourcePattern,filesP(L).name) ;
 patImg=imread(PatAddress);
 [p,q]=size(patImg);
 
 newImg=whgray ;
 [m,n]=size(whgray);
 
 for i=1:p
     for j=1:q
         
         if patImg(i,j)==0 ;
             
             newImg(floor((n/p)*i),floor((m/q)*j))=0;
             %              newImg(i,j)=255;
             
         end
     end
 end
 
 noisyGray=newImg ;
 
%             noisyGray = imnoise(whgray,'salt & pepper', NoiseRate(x));
 % END Crop Embed Pattern Code              
            Address_noise_folder = fullfile(saveDestination,WaterMarkedFolders(w).name,'WaterMarked_Noise_Folder');
            mkdir(Address_noise_folder);
            
            [a,b]=size(WaterMarkedFolders(w).name);
            AddressAndName_noisy=fullfile(Address_noise_folder,sprintf('%s_.%s' , WaterMarkedFolders(w).name(1:b-4),filesP(L).name));
            
          
           if (strcmp(imgFormat,'dcm'))
            dicomwrite(noisyGray,AddressAndName_noisy);
            else
                imwrite(noisyGray,AddressAndName_noisy);
            end
            
            if (FlagFigure==Active)
            figure;imshow(noisyGray);title(sprintf('noise _ %s Rate = %.3f' ,WaterMarkedFolders(w).name,NoiseRate(x) ));
            end
            
        end
        
    end
end  % if (flagNoise==Active)

%% extract Stage


if (flagExtracting == Active )
    
     display('03 - Extracting ...') ;
     
     
    
        if (strcmp(imgFormat,'dcm'))
            info = dicominfo(HImgStoreName);
            depth=double(info.BitDepth) ;
        else
            info = imfinfo(HImgStoreName);
            depth=double(info.BitDepth) ;
            
        end
        
     
    %% Read Noisy Images
    
    
    WaterMarkedFolders=dir(saveDestination);
    WaterMarkedFoldersCount=size(WaterMarkedFolders);
    
    for w=3:1:WaterMarkedFoldersCount(1)
        
        
        Address_noise_folder = fullfile(saveDestination,WaterMarkedFolders(w).name,'WaterMarked_Noise_Folder');
        noisy_folder = dir(Address_noise_folder) ;
        
        [a,b]=size(noisy_folder);
        
        for q=3:1:a
            
            AddressNoisyFile=fullfile(saveDestination,WaterMarkedFolders(w).name,'WaterMarked_Noise_Folder',noisy_folder(q).name);
            
            if (strcmp(imgFormat,'dcm'))
            noisyGray = dicomread(AddressNoisyFile);
            else
               noisyGray = imread(AddressNoisyFile);
            end
            
            [m, n]=size(noisyGray);
            
            
            
            %%  Recovery No.1
            
            messRecov=im2bw(zeros(mm,nm));
            maskMessage=rgb2gray(message);
            maskMessage(:)=3;
            
            place1=1;
            place2=2;
            
            flag=0;
            for i=1:mm
                for j=1:nm
                    
                    if (noisyGray(i,floor(n/4-j+1))~=0 && (noisyGray(i,floor(n/4-j+1))~=2^depth-1))                             % A1 ,(i,n/4-j+1)
                        bit1=ich(noisyGray(i,floor(n/4-j+1)),place1,2);
                        bit2=ich(noisyGray(i,floor(n/4-j+1)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    if ((noisyGray(floor(m/2+i),floor(n/2-j+1))~=0 && (noisyGray(floor(m/2+i),floor(n/2-j+1))~=2^depth-1)) && (flag==0))      % B3 ,(m/2+i,n/2-j+1)
                        bit1=ich(noisyGray(floor(m/2+i),floor(n/2-j+1)),place1,2);
                        bit2=ich(noisyGray(floor(m/2+i),floor(n/2-j+1)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(floor(m/4+i),floor(3/4*n-j+1))~=0 && (noisyGray(floor(m/4+i),floor(3/4*n-j+1))~=2^depth-1)) && (flag==0))   % C2,(m/4+i,3/4*n-j+1)
                        bit1=ich(noisyGray(floor(m/4+i),floor(3/4*n-j+1)),place1,2);
                        bit2=ich(noisyGray(floor(m/4+i),floor(3/4*n-j+1)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(floor(3/4*m+i),floor(n-j+1))~=0 && (noisyGray(floor(3/4*m+i),floor(n-j+1))~=2^depth-1))&& (flag==0))        % D4,(3/4*m+i,n-j+1)
                        bit1=ich(noisyGray(floor(3/4*m+i),floor(n-j+1)),place1,2);
                        bit2=ich(noisyGray(floor(3/4*m+i),floor(n-j+1)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    
                    if ((noisyGray(floor(m/2-i+1),j)~=0 && (noisyGray(floor(m/2-i+1),j)~=2^depth-1))&& (flag==0))                % A2,(m/2-i+1,j)
                        bit1=ich(noisyGray(floor(m/2-i+1),j),place1,2);
                        bit2=ich(noisyGray(floor(m/2-i+1),j),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    
                    if ((noisyGray(floor(m-i+1),floor(n/4+j))~=0 && (noisyGray(m-i+1,floor(n/4+j))~=2^depth-1))&& (flag==0))                % B4,(m-i+1,n/4+j)
                        bit1=ich(noisyGray(m-i+1,floor(n/4+j)),place1,2);
                        bit2=ich(noisyGray(m-i+1,floor(n/4+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    
                    if ((noisyGray(floor(3/4*m-i+1),floor(n/2+j))~=0 && (noisyGray(floor(3/4*m-i+1),floor(n/2+j))~=2^depth-1))&& (flag==0))        % C3,(3/4*m-i+1,n/2+j)
                        bit1=ich(noisyGray(floor(3/4*m-i+1),floor(n/2+j)),place1,2);
                        bit2=ich(noisyGray(floor(3/4*m-i+1),floor(n/2+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(floor(m/4-i+1),floor(3/4*n+j))~=0 && (noisyGray(floor(m/4-i+1),floor(3/4*n+j))~=2^depth-1))&& (flag==0))        % D1,(m/4-i+1,3/4*n+j)
                        bit1=ich(noisyGray(floor(m/4-i+1),floor(3/4*n+j)),place1,2);
                        bit2=ich(noisyGray(floor(m/4-i+1),floor(3/4*n+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if (((noisyGray(floor(3/4*m+i),j)~=0 && (noisyGray(floor(3/4*m+i),j)~=2^depth-1))&& (flag==0))&& (flag==0))     % A4,(3/4*m+i,j)
                        bit1=ich(noisyGray(floor(3/4*m+i),j),place1,2);
                        bit2=ich(noisyGray(floor(3/4*m+i),j),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(floor(m/4+i),floor(n/4+j))~=0 && (noisyGray(floor(m/4+i),floor(n/4+j))~=2^depth-1))&& (flag==0))             % B2,(m/4+i,n/4+j)
                        bit1=ich(noisyGray(floor(m/4+i),floor(n/4+j)),place1,2);
                        bit2=ich(noisyGray(floor(m/4+i),floor(n/4+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(i,floor(n/2+j))~=0 && (noisyGray(i,floor(n/2+j))~=2^depth-1))&& (flag==0))              % C1,(i,n/2+j)
                        bit1=ich(noisyGray(i,floor(n/2+j)),place1,2);
                        bit2=ich(noisyGray(i,floor(n/2+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    if ((noisyGray(floor(m/2+i),floor(3/4*n+j))~=0 && (noisyGray(floor(m/2+i),floor(3/4*n+j))~=2^depth-1))&& (flag==0))   % D3,(m/2+i,3/4*n+j)
                        bit1=ich(noisyGray(floor(m/2+i),floor(3/4*n+j)),place1,2);
                        bit2=ich(noisyGray(floor(m/2+i),floor(3/4*n+j)),place2,2);
                        if (bit1==1)
                            messRecov(i,j)=bit2 ;
                            maskMessage(i,j)=bit2 ;
                            flag=1;
                        else
                            messRecov(i,j)=~bit2 ;
                            maskMessage(i,j)=~bit2 ;
                            flag=1;
                        end
                    end
                    
                    
                    
                    
                    flag=0 ;
                end
                %             flag=0 ;
                
            end
           
            
            if (FlagFigure==Active)
            figure;imshow(messRecov);title('Recovery No.1');
            end
            
            %%  Recovery No.2
            for t=1:2                                            % (3/4*m-i+1,n/4-j+1)  A3 , 4
                for i=1:mm
                    for j=1:nm
                        
                        if ((i-1>=1) && (floor(3/4*m-i+1+1)<=m))
                            
                            if ((maskMessage(i,j)==3) && (maskMessage(i-1,j)~=3) && (noisyGray(floor(3/4*m-i+1+1),floor(n/4-j+1))~=0) && (noisyGray(floor(3/4*m-i+1+1),floor(n/4-j+1))~=2^depth-1))
                                
                                bit1=ich(noisyGray(floor(3/4*m-i+1+1) ,floor(n/4-j+1)),place1,2);
                                bit2=ich(noisyGray(floor(3/4*m-i+1+1) ,floor(n/4-j+1)),place2,2);
                                if (bit1==1)
                                    bit=bit2 ;
                                else
                                    bit=~bit2 ;
                                end
                                
                                
                                
                                if (bit==0)
                                    messRecov(i,j)=messRecov(i-1,j) ;
                                    maskMessage(i,j)=messRecov(i-1,j) ;
                                    
                                else
                                    messRecov(i,j)=~messRecov(i-1,j) ;
                                    maskMessage(i,j)=~messRecov(i-1,j) ;
                                end
                            end
                        end
                        
                    end
                end
                
                
                
                for i=1:mm                                                                    % B1,6    (m/4-i+1,n/2-j+1)
                    for j=1:nm
                        
                        if ((j-1>=1) && (floor(n/2-j+1+1)<=n))
                            
                            if ((maskMessage(i,j)==3) && (maskMessage(i,j-1)~=3) && (noisyGray(floor(m/4-i+1),floor(n/2-j+1+1))~=0) && (noisyGray(floor(m/4-i+1),floor(n/2-j+1+1))~=2^depth-1))
                                
                                bit1=ich(noisyGray(floor(m/4-i+1),floor(n/2-j+1+1)),place1,2);
                                bit2=ich(noisyGray(floor(m/4-i+1),floor(n/2-j+1+1)),place2,2);
                                if (bit1==1)
                                    bit=bit2 ;
                                else
                                    bit=~bit2 ;
                                end
                                
                                
                                
                                if (bit==0)
                                    messRecov(i,j)=messRecov(i,j-1) ;
                                    maskMessage(i,j)=messRecov(i,j-1) ;
                                    
                                else
                                    messRecov(i,j)=~messRecov(i,j-1) ;
                                    maskMessage(i,j)=~messRecov(i,j-1) ;
                                end
                            end
                        end
                        
                    end
                end
                
                % (m-i+1,3/4*n-j+1)  C4 , 2
                for i=1:mm
                    for j=1:nm
                        
                        if ((j+1<=nm) && (floor(3/4*m-i+1-1)>=1))
                            
                            if ((maskMessage(i,j)==3) && (maskMessage(i,j+1)~=3) && (noisyGray(m-i+1,floor(3/4*n-j+1-1))~=0) && (noisyGray(m-i+1,floor(3/4*n-j+1-1))~=2^depth-1))
                                
                                bit1=ich(noisyGray(m-i+1,floor(3/4*n-j+1-1)),place1,2);
                                bit2=ich(noisyGray(m-i+1,floor(3/4*n-j+1-1)),place2,2);
                                if (bit1==1)
                                    bit=bit2 ;
                                else
                                    bit=~bit2 ;
                                end
                                
                                
                                
                                if (bit==0)
                                    messRecov(i,j)=messRecov(i,j+1) ;
                                    maskMessage(i,j)=messRecov(i,j+1) ;
                                    
                                else
                                    messRecov(i,j)=~messRecov(i,j+1) ;
                                    maskMessage(i,j)=~messRecov(i,j+1) ;
                                end
                            end
                        end
                        
                    end
                end
                
                % (m/2-i+1,n-j+1)  D2 , 8
                for i=1:mm
                    for j=1:nm
                        
                        if ((i+1<=mm) && (floor(m/2-i+1-1>=1)))
                            
                            if ((maskMessage(i,j)==3) && (maskMessage(i+1,j)~=3) && (noisyGray(floor(m/2-i+1-1),n-j+1)~=0) && (noisyGray(floor(m/2-i+1-1),n-j+1)~=2^depth-1))
                                
                                bit1=ich(noisyGray(floor(m/2-i+1-1),n-j+1),place1,2);
                                bit2=ich(noisyGray(floor(m/2-i+1-1),n-j+1),place2,2);
                                if (bit1==1)
                                    bit=bit2 ;
                                else
                                    bit=~bit2 ;
                                end
                                
                                
                                if (bit==0)
                                    messRecov(i,j)=messRecov(i+1,j) ;
                                    maskMessage(i,j)=messRecov(i+1,j) ;
                                    
                                else
                                    messRecov(i,j)=~messRecov(i+1,j) ;
                                    maskMessage(i,j)=~messRecov(i+1,j) ;
                                end
                            end
                        end
                        
                    end
                end
            end
            
           
            
            if (FlagFigure==Active)
            figure;imshow(messRecov);title('Recovery No.2');
            end
            %% Recovery No.03  Past Processing Message fuzzy
            one=0 ;
            zero=0;
            for i=1:mm
                for j=1:(nm)
                    
                    if (maskMessage(i,j)== 1)
                        one=one+1;
                    end
                    
                    if (maskMessage(i,j)== 0)
                        zero=zero+1;
                    end
                    
                end
            end
            
            if (one>zero)
                select=1 ;
            else
                select=0 ;
            end
            
            
            r=1 ;
            one=0 ;
            zero=0;
            
            for i=1:mm
                for j=1:nm
                    
                    while (maskMessage(i,j)==3)
                        
                        
                        
                        for p=i-r:i+r
                            for qq=j-r:j+r
                                
                                if ((p>=1)&&(qq>=1)&&(p<=mm)&&(qq<=nm))
                                    if  ((maskMessage(p,qq)~=3))
                                        
                                        if (maskMessage(p,qq)==1)
                                            one=one+1;
                                        else
                                            zero=zero+1 ;
                                        end
                                        
                                        
                                    end
                                    
                                end
                            end
                        end
                        
                        if (one>zero)
                            
                            bit=1 ;
                            r=1 ;
                            one=0 ;
                            zero=0;
                            maskMessage(i,j)=bit ;
                            
                        elseif (one<zero)
                            bit=0 ;
                            r=1 ;
                            one=0 ;
                            zero=0;
                            maskMessage(i,j)=bit ;
                            
                        else
                            %             r=r+1
                            maskMessage(i,j)=select;
                            one=0 ;
                            zero=0;
                            
                            
                        end
                        
                    end    % end while
                    %         maskMessage(i,j)=bit ;
                    messRecov(i,j)=maskMessage(i,j) ;
                end
            end
            
            if (FlagFigure==Active)
            figure;imshow((messRecov)) ;title('recovery Message Pass Az Fuzzy');
            end
            
            saveMessageRecoveryFolder=fullfile(saveDestination,WaterMarkedFolders(w).name,'Message_Recovery_Folder');
            mkdir(saveMessageRecoveryFolder);
            
            
            [y,o]=size(noisy_folder(q).name);
            
            messageNameAddress=fullfile(saveMessageRecoveryFolder,sprintf('%s.png',noisy_folder(q).name(1:(o-4)))) ;
            imwrite(messRecov,messageNameAddress);
            
        end
    end   % end for loop WaterMarkedFoldersCount Noisy
    
    
    
    
end  %if (flagExtracting == Active )

%% IQMS


if (FlagIQMS == Active)
    
    display('04 - Report - IQMS ...') ;
   
    
    %% psnr_snr_ssim Between host and Message
    
    ContentDestination=dir(saveDestination);
    [d,f]=size(ContentDestination);
    
    
    psnr_ssim_snr=cell(5);
    psnr_ssim_snr(1,1)={'Table.01 Compare Host Image And Watermarked Image Without Any Attack'};
    psnr_ssim_snr(2,4)={'IQMS'};
    psnr_ssim_snr(3,3)={'PSNR'};
    psnr_ssim_snr(3,4)={'SNR'};
    psnr_ssim_snr(3,5)={'SSIM'};
    psnr_ssim_snr(3,6)={'SIZE'};
    psnr_ssim_snr(4,1)={'ROW'};
    psnr_ssim_snr(4,2)={'NAME'};
    
    
    
    RowCount=4;
    CalCount=1;
    Count=1;
    
    for f=3:d
        
        nameMessageSize=size(ContentDestination(f).name);
        
        RowCount=RowCount+1;
        
        
        
       hostAddress=fullfile(saveDestination,ContentDestination(f).name,sprintf('Host_%s',ContentDestination(f).name));
        
        if (strcmp(imgFormat,'dcm'))
        hostImage=dicomread(hostAddress);
        else
            hostImage=imread(hostAddress);
        end
        
        [na rd]=size(hostImage);
        
        ExtractedMessageAddress=fullfile(saveDestination,ContentDestination(f).name,sprintf('WaterMareked_%s',ContentDestination(f).name));
        
        if (strcmp(imgFormat,'dcm'))
        ExtractedMessageImage=dicomread(ExtractedMessageAddress);
        else
         ExtractedMessageImage=imread(ExtractedMessageAddress);
        end
        
        psnrCal = psnr(hostImage,ExtractedMessageImage);
%         snrCal  = snr(hostImage,ExtractedMessageImage);
        ssimCal = ssim(hostImage,ExtractedMessageImage);
        
        nameMessage=ContentDestination(f).name(1:(nameMessageSize(2)-4)) ;
        psnr_ssim_snr{RowCount,CalCount}=Count ;
        psnr_ssim_snr{RowCount,CalCount+1}=nameMessage ;%{ContentDestination(f).name};
        psnr_ssim_snr{RowCount,CalCount+2}= psnrCal;
%         psnr_ssim_snr{RowCount,CalCount+3}= snrCal;
        psnr_ssim_snr{RowCount,CalCount+4}= ssimCal;
        psnr_ssim_snr{RowCount,CalCount+5}= sprintf('%d*%d',na,rd);
        
        %        reportsAddressFolder=fullfile(saveDestination,'00_ReportsExcel');
        %        mkdir(reportsAddressFolder);
        %        reportsAddressFile1=fullfile(reportsAddressFolder,'01_psnr_ssim_snr.xlsx');
       
        
        Count=Count+1 ;
        
    end
    
     xlswrite('t1_psnr_ssim_snr.xlsx',psnr_ssim_snr);
     

  
%% BER Between host and Message    

   
    t3_Crop_IQMS(1,1)={'Table.01 Compare Original binary message Image And Extracted message Image with various Crop Noise Size.'};
    
    t3_Crop_IQMS(4,1)={'Row'};
    t3_Crop_IQMS(4,2)={'Name'};
    t3_Crop_IQMS(4,3)={'Size.WaterMarked'};
    t3_Crop_IQMS(4,4)={'Size.Messsage'};
    t3_Crop_IQMS(4,5)={'CropPercent'};
    t3_Crop_IQMS(4,6)={'BER(%)'};
    t3_Crop_IQMS(4,7)={'MSE'};
    t3_Crop_IQMS(4,8)={'CC'};
    t3_Crop_IQMS(4,9)={'NC'};
    
    

  ContentDestination=dir(saveDestination);  
    
  [subWimg,dd]=size(ContentDestination)  ;
  
  counter=1 ;
   for i=3:subWimg 
       
       
       
      
       originalMessageAddress=fullfile(saveDestination,ContentDestination(i).name,sprintf('BinaryMessage.png'));
       messageImage=imread(originalMessageAddress);


      extImgFolder=fullfile(saveDestination,ContentDestination(i).name,'Message_Recovery_Folder');
      ContentExtImgFolder=dir(extImgFolder);
      [countImg,dd]=size(ContentExtImgFolder) ;
      
      noisyWatermarkedAddress=fullfile(saveDestination,ContentDestination(i).name,sprintf('WaterMarked_Noise_Folder'));
      noisyWatermarkedFolder=dir(noisyWatermarkedAddress);
      
       
       for j=3:countImg
           
           addressCropImg=fullfile(extImgFolder,ContentExtImgFolder(j).name);  % message extractt
           
           cropImg=imread(addressCropImg);
           [mm,nm]=size(cropImg) ;
           
           NoisyWatermarkedCropImgAddress=fullfile(noisyWatermarkedAddress,noisyWatermarkedFolder(j).name);
           NoisyWatermarkedcropImg=imread(NoisyWatermarkedCropImgAddress);
           [m,n]=size(NoisyWatermarkedcropImg) ;
           
           berCal = BER(messageImage,cropImg);
           mseCal = immse(single(messageImage),single(cropImg));
           ccCal = corr2(single(messageImage),single(cropImg));
           ncCal = NC(single(messageImage),single(cropImg));
           Per=cropPercent(NoisyWatermarkedcropImg);
           
           t3_Crop_IQMS{4+counter,1}=counter;
           t3_Crop_IQMS{4+counter,2}=ContentExtImgFolder(j).name ;
           t3_Crop_IQMS{4+counter,3}=sprintf('%1.0f*%1.0f',m,n);
           t3_Crop_IQMS{4+counter,4}=sprintf('%1.0f*%1.0f',mm,nm);
           t3_Crop_IQMS{4+counter,5}=sprintf('%0.4f %%',Per);
           t3_Crop_IQMS{4+counter,6}= berCal;
           t3_Crop_IQMS{4+counter,7}= mseCal;
           t3_Crop_IQMS{4+counter,8}= ccCal;
           t3_Crop_IQMS{4+counter,9}=ncCal;
           
           counter=counter+1 ;
           
       end
       
       
       
   end
   
 
    xlswrite('t3_Crop_IQMS-64.xlsx',t3_Crop_IQMS);
    
 
    
end % if (FlagIQMS == Active)




