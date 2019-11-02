% This is Submission for CS-599:Biometircs fall 2019 
% Assignment 3 :  Design and Evaluate an Face Recognition System
% Group:
%   1. Rakshith Churchagundi Amarnath
%   2. Urvi Chandreshkumar Sheth
%   3. Aditya Yaji
%

%we have divided training and testing dataset as one indoor and one outdoor
%image of same person for all the folders


maindir='D:\FaceRecog\face_data\Gallery\';
subdir =  dir( maindir ); 
T = [];

probemaindir = 'D:\FaceRecog\face_data\Probe\';  
probesubdir =  dir( probemaindir );  
    
M= zeros(146,146); 
Euc_dist = zeros(146,146);
test_counter = 1;

 for i = 1 : length( subdir )  
    if( isequal( subdir( i ).name, '.' ) ||  isequal( subdir( i ).name, '..' ) ||  ~subdir( i ).isdir )   % ????????  
        continue;  
    end  
      
    subdirpath = fullfile( maindir, subdir( i ).name, '*.nef' );  
    images = dir( subdirpath ); 
       
 
     imagepath = fullfile( maindir, subdir( i ).name, images( 1 ).name  );
     img = imread(imagepath);
     img = rgb2gray(img);
     [irow,icol] = size(img);
     temp = reshape(img',irow*icol,1);   % Reshaping 2D images into 1D image vectors
     T = [T temp];
     [m, A, Eigenfaces] = EigenfaceCore(T);
     
   
    for j = 1 : length( probesubdir )  
       if( isequal( probesubdir( j ).name, '.' ) ||  isequal( probesubdir( j ).name, '..' ) ||  ~probesubdir( j ).isdir )   % ????????  
        continue;  
       end  
       
       M(1,i-1)= str2double(subdir(i).name);
       M(j-1,1)=str2double(probesubdir(j).name);
        
       subdirpath = fullfile( probemaindir, probesubdir( j ).name, '*.nef' );  
       images = dir( subdirpath ); 
        
       imagepath = fullfile( probemaindir, probesubdir( j ).name, images( 1 ).name  );
       [Euc_dist] = Recognition(imagepath,m,A, Eigenfaces,Euc_dist,test_counter);%Calculate Euclidean Distance for test images and store them in array
        
        M(j-1, i-1)= Euc_dist(test_counter)/10000000000000000000; %divided by 10^18 just to get the float values which can be used to generate the graph
        test_counter = test_counter + 1;
        
   end 
 
 end 
 


comparedhmvalue='D:\FaceRecog\face_data\';
dirfilename=strcat(comparedhmvalue,'Mmatrix_val.xlsx'); 
xlswrite(dirfilename,M)