clc
close all
clear all

mask=ones(512);
mask(:)=255;
img=mask ;
len=448 ;

%% for R corner
%  for i=512:-1:512-len    
%     for j=512:-1:512-len

%% for Center
t=0 ;
% img(:)=255 ;
% for i=(512/2)-(len/2):(512/2)+(len/2)-1   
%      for j=(512/2)-(len/2):(512/2)+(len/2)-1
% 

%% for Left

%    for i=1:512
%        for j=1:len
           
%% Inverse
% img(:)=0 ;

       for i=512:-1:512-len+1
       for j=512:-1:512-len+1
          img(i,j)=0 ;
          t=t+1 ;
    end
end       
t
 per=cropPercent( img );
imwrite(img , sprintf('Right corner%1.0f.png',len));
imshow(img);title (sprintf('Right corner%1.0f.png',len));