%% read an image
clc;
warning('off');

%% add some folders
addpath('../feature_extraxtion') 


patientNum_ = [16 1];

%% images and annotation directory
image_drive = 'F:/Data/test';
%image_drive ='D:\MAIA_Course\data';
    
%% 
svm_classifier_names = cell(1,2);
svm_classifier_names {1} = '../../model/svm/posterior/classifier_Posterior_feature.mat';
svm_classifier_names {2} = '../../model/svm/posterior/classifier_Posterior_pro.mat';
%svm_classifier_names = { 'classifier_Posterior_feature.mat', 'classifier_Posterior_pro'};
layer = {'fc6' , 'prob'};

for cn=1:length(svm_classifier_names)
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
		image_path =[image_drive '/' num2str(patientNum) '/' 'images/images/'];
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
		   
		   [DiceCoeff , Accuracy ] = onCombining(anno_im(:,:,1) , im_i , svm_classifier_names{cn} , layer{cn});
			diceCoeff_data  = [diceCoeff_data ; DiceCoeff];
			Accuracy_data = [Accuracy_data ; Accuracy];
			
			%% save results
			save (['diceCoeff_data' layer{cn}] ,'diceCoeff_data');
			save (['Accuracy_data' layer{cn}] ,'Accuracy_data');
			%save Accuracy_data Accuracy_data;
		end
	end

	save (['diceCoeff_data' layer{cn}], 'diceCoeff_data');
	save (['Accuracy_data' layer{cn}], 'Accuracy_data');

end
%% visualize
%boxPlotAccuracyDiceIndex(diceCoeff_data, Accuracy_data)

