function createIMDBRAM(db_name, patch_path, folders)
	% imdb is a matlab struct with several fields, such as:
	%	- images: contains data, labels, ids dataset mean, etc.
	%	- meta: contains meta info useful for statistics and visualization
	%	- any other you want to add

	% check if database exists previously: load or create

	if dbExist(db_name)
		disp('db exists: loading..');
		load(db_name);
	else
		disp('creating empty db');
		imdb = struct();

		% we can initialize part of the structures already
		imdb.meta.sets = {'train', 'val'};
		imdb.meta.classes = { 'normal', 'cancer','muscle'}; % label: 1 , 2, 3  
		imdb.meta.patientnum = [];

		% images go here
		imdb.images.data = []; % array dimensions restriction
		% this will contain the mean of the training set
		imdb.images.data_mean = []; % []
		% a label per image
		imdb.images.labels = [];
		% vector indicating to which set an image belong, i.e.,
		% training, validation, etc.
		imdb.images.set = [];        
		% number of training images
		imdb.images.numImgsTrain = 0;

	end

	% for all petiants
	for n=1:length(folders)
		
		fprintf('.\n.\n');
		
		patient_num = folders(n);
		str = [ 'Patient number ' num2str(patient_num)];
		disp(str);
		
		

		% check if patient prevously added to database
		X  = imdb.meta.patientnum;
		for m=1: length(X)
			if ( X(m) == patient_num)
				error('Patient %d images are allready added to the database!', patient_num );
			end
		end		
		

		if patient_num<10
			patient_num_str = ['00' num2str(patient_num)];
		else
			patient_num_str = ['0' num2str(patient_num)];
		end

		patch_path_n = [patch_path patient_num_str];
		mat_files= dir([patch_path_n '\*.mat']);

		% for all images in a given folder/patient
		for  i =1 : length(mat_files)

			str = ['adding .mat file ' num2str(i) ' to database'];
			disp(str);
			
			% get a mat file
			name  = [patch_path_n '\' mat_files(i).name];
			tissue_patches = load(name);
			
			% mat file patches
			patch_collection = tissue_patches.tissuepatchs_Matfile;
			
			% for all patch_types (cancer, muscle, normal)
			for j = 1:length(patch_collection)%<=3

				patch_type   = patch_collection(j).type;

				im_patches = patch_collection(j).patchs;
				
				localimages  = createSmallDB(im_patches, patch_type, patient_num) ;

				% append new data to the database
				% images appended on the fourth dimention
				imdb.images.data = cat( 4, imdb.images.data , localimages.data) ; % array dimensions restriction

				%imdb.images.data_mean =  cat( 4,  imdb.images.data_mean  , localimages.data_mean) ;
				if isempty(imdb.images.data_mean)
					imdb.images.data_mean = localimages.data_mean;
				else
					imdb.images.data_mean =  imdb.images.data_mean + localimages.data_mean ;            
				end

				imdb.images.labels = cat( 2,  imdb.images.labels   , localimages.labels) ;

				imdb.images.set = cat( 2,  imdb.images.set  , localimages.set) ;

				imdb.images.numImgsTrain = imdb.images.numImgsTrain + localimages.numImgsTrain ;
			end


		end
		imdb.meta.patientnum = [ imdb.meta.patientnum patient_num];
		
			disp('Saving db');

		% now let's add some randomization 
		l = imdb.images.labels;
		N  = length(l);
		indices = randperm(N);
		imdb.images.data(:,:,:,:) = imdb.images.data(:,:,:,indices);
		imdb.images.labels(:) = imdb.images.labels(indices);
		imdb.images.set(:) = imdb.images.set(indices);


		save(db_name,'imdb','-v7.3');
	end

end
