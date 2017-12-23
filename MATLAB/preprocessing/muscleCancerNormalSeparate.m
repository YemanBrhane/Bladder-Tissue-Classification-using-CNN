function muscleCancerNormalSeparate(patientNum, opt)
	%{
		This accepts patient Number (PATIENTNUM) and an option(OPT) with values augmenation or normal.
		Then it will create a struct file for each image in patient number folder. this struct contains 
		extarcted pathes(with muscle, normal and cancer as field names, and vlaues extarcted muscle patches, normal patches and cancer patches respectively).
		then it will save this struct file as mat file same name as the image name.
	%}
    str = ['processing patient ' num2str(patientNum)];
    disp(str);
    fprintf('.\n.\n');
    
    warning('off'); % Image size warnings
    
    if patientNum<10
        patientNum = ['00' num2str(patientNum)];
    else
        patientNum = ['0' num2str(patientNum)];
    end

    %images path and dir
    %image_drive = 'F:\Data\bladder';
    %image_drive ='D:\MAIA_Course\data';
    image_drive = 'I:\Academic\DataSets\bladder';
    
    image_path =[image_drive '/' num2str(patientNum) '/' 'images/'];
    localFolder_im =  image_path;
    images_dir= dir(localFolder_im);
    images_dir(1:2) = [];
    % Annoatations path and dir
    annotation_path = [image_drive '/' num2str(patientNum) '/annotations/'] ;
    localFolder_anno = annotation_path;% '*.png, *.tiff'
    annotation_dir= dir(localFolder_anno);
    annotation_dir(1:2) = [];

    num_images = numel(images_dir);
    num_anno = numel(annotation_dir);    

    if (num_images ~=num_anno)
        error('Error:number of images and annorations different!');   
    end
  
    for  i =1: num_images

        str = ['processing image ' num2str(i)];
        disp(str);
        % mat file to store patches that contain tissue(cancer, 
        % normal and muscle) for the ith image
        tissuepatchs_Matfile  = struct;
        name_im_i  = [image_path images_dir(i).name];
        %im_i = single(imread(name_im_i)); 
        im_i = imread(name_im_i); 
        if size(im_i,3) == 4
           im_i = im_i (:,:,1:3); 
        end
        
		%% get roi
		mask = ROI (im_i(:,:,2));

		% cleaned image
		im_i = im_i.* repmat(mask,[1,1,3]); 
		im_i(im_i==0)=225;
        
        %%
        %figure('name', 'input image');imshow(im_i,[]);
        name_anno_i  = [annotation_path annotation_dir(i).name];
        %anno_i = single(imread(name_anno_i)); 
        anno_im = imread(name_anno_i);
        anno_im = anno_im(:,:,1);
        
        %% in case of data augumentation
        if strcmp(opt.do,'augmentation')
			% rotate by 45 degree
            anno_im_= imrotate(anno_im, 45, 'crop', 'nearest');
            im_i_ = imrotate(im_i, 45, 'crop', 'bicubic');
            im_i_(im_i_<10 | im_i_>200)=226;
			angle = '45';
			create_save_patches()
			
			% flip LR
			anno_im_ = fliplr(anno_im);
			im_i_ = fliplr(im_i);
			angle = 'lr';
			create_save_patches()
			
			%flip UD
			anno_im_ = flipud(anno_im);
			im_i_ = flipud(im_i);
			angle = 'ud';
			create_save_patches()
        else
            im_i_ = im_i;
            anno_im_ = anno_im;
			create_save_patches()

        end
        
        
        %figure('name','The whole annotation'), imshow(anno_im,[]);
		
    end %end for

	
	
		function create_save_patches()
			% separate image into muscle, normal, and tumor part
			image_struct = separate(im_i_, anno_im_);

			for k = 1:length(image_struct)
				
			   patch_Matfile = patchExtractor( image_struct(k).image) ;
			   % store patches and type of patchs
			   tissuepatchs_Matfile(k).patchs = patch_Matfile;
			   tissuepatchs_Matfile(k).type = image_struct(k).type;
			   
			end
			home  = pwd;
			cd ../
			
			patch_folder = [pwd  '\patchesFolder_' angle '\' patientNum ];
			file_name = [patientNum '_' num2str(i)];
			if ~(7==exist(patch_folder,'dir'))
				mkdir(patch_folder);
			end
			cd (patch_folder);
			save (file_name, 'tissuepatchs_Matfile', '-v7.3')%,'-nocompression');
			
			cd (home);
		end

        
end %end fun


function image_struct= separate(image, anno_image)

	image_struct = struct;

	% image_struct.image...image itself
	% image_struct.type...class type

	anno_im = anno_image;
	% cancer, muscle and normal/background pixel value in annotation image
	unique_values = unique(anno_image);

	% sort the unique values
	unique_values = sort(unique_values,'ascend');


	% normal_pxl = unique_values(1); % 0

	% background 
	bcgd_mask = anno_im==0;

	if (size( bcgd_mask,3)==1)
		mask = repmat(uint8(bcgd_mask),[1 1 3]);
	end  

	%Soft tissue
	im_softTissue = mask.* image;
	im_softTissue(im_softTissue==0)=225;
	image_struct(1).image = im_softTissue;
	image_struct(1).type = 'normal';

	%figure('name','Soft Tissue'), imshow(im_softTissue);

	if length(unique_values)>=2
		for i = 2:length(unique_values)
			anno_im  = anno_image;

			% if cancer
			if (unique_values(i)==50)
				anno_im( anno_im~=50) = 0; 
				anno_im  = anno_im>0;
				if (size( anno_im,3)==1)
				mask = repmat(uint8(anno_im),[1 1 3]);
				end 
				im = image .* mask;
				im(im==0)=225;
				image_struct(i).image = im;
				image_struct(i).type = 'cancer';
				% %figure('name', 'Bladder cancer area'), imshow(im);
			% if muscle
			elseif (unique_values(i)==150)
				anno_im( anno_im~=150) = 0; 
				anno_im  = anno_im>0;
				if (size( anno_im,3)==1)
					mask = repmat(uint8(anno_im),[1 1 3]);
				end 
				im = image .* mask;
				im(im==0)=225;
				image_struct(i).image = im;
				image_struct(i).type = 'muscle';     
			  %figure('name', 'Bladder muscle area'), imshow(im);
			end
		end

	end

end