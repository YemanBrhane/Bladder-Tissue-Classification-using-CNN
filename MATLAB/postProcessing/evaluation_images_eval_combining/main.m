%% read an image
clc;
warning('off');

patientNum_ = [16 1];

%% images and annotation directory
%image_drive = 'F:/Data/test';
image_drive ='H:\Academic\DataSets\bladder';
    
%% 
diceCoeff_data = [];
Accuracy_data  = [];

for p=1:length(patientNum_)

    disp(['patient num: ' num2str(p)]);
    patientNum = patientNum_(p);
	
    if patientNum<10
        patientNum = ['00' num2str(patientNum)];
    else
        patientNum = ['0' num2str(patientNum)];
    end

    % images
    image_path =[image_drive '/' num2str(patientNum) '/' 'images/'];
    localFolder_im =  image_path;
    images_dir= dir(localFolder_im);
    images_dir(1:2) = [];

    % Annoatations path and dir
    annotation_path = [image_drive '/' num2str(patientNum) '/annotations/'] ;
    localFolder_anno = annotation_path;% '*.png, *.tiff'
    annotation_dir= dir(localFolder_anno);
    annotation_dir(1:2) = []; % remove some directory info

    num_images = numel(images_dir);
    num_anno = numel(annotation_dir);    

    if (num_images ~=num_anno)
        error('Error:number of images and annorations different!');   
    end

    for  i =1:num_images
        
        str = ['processing image ' num2str(i)];
        disp(str);
        
        name_im_i  = [image_path images_dir(i).name];
        im_i = imread(name_im_i); 
        if size(im_i,3) == 4 % if .tiff image
           im_i = im_i (:,:,1:3); 
        end
		
		% some preprocessing: some of the images have unwanted black background
		% pixel values less than 20 or greater than 200 make it background
		im_i(im_i<20 | im_i>200)=225;
		
        %%figure('name', 'input image');imshow(im_i,[]);
        name_anno_i  = [annotation_path annotation_dir(i).name];
        %anno_i = single(imread(name_anno_i)); 
        anno_im = imread(name_anno_i);
       
       [DiceCoeff , Accuracy ] = onCombining(anno_im(:,:,1) , im_i);
        diceCoeff_data  = [diceCoeff_data ; DiceCoeff];
        Accuracy_data = [Accuracy_data ; Accuracy];
        
        %% save results
        save diceCoeff_data diceCoeff_data;
        save Accuracy_data Accuracy_data;
    end
end

save diceCoeff_data diceCoeff_data; save Accuracy_data Accuracy_data;

%% visualize
boxPlotAccuracyDiceIndex(diceCoeff_data, Accuracy_data)

