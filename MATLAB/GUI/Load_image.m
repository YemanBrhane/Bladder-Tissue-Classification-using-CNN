function image=Load_image(display)
	%===========================================================
	% developed by:
	%               Yeman Brhane Hagos
	%==========================================================
	% IMAGE = LOAD_IMAGE (DISPLAY) return an image selected by user. It accepts DISPLAY  which is handle
	% to text display ui control element in graphical interface. 

	%% update info. display
	set(display,'string',{'Image Loading...'});%';'2. Press Pattern Distinct';...
	% '3. Press Pattern Distinct';'4. Press Final Saliency'});

	home=pwd;
	[fileName,pathname]= uigetfile('*.*','Open Image');
	% pathname
	if fileName ~= 0 
		cd(pathname);
		image=imread(fileName);
	else
		error('Please select an image');
	end
	%image(1:20,1:20);
	 cd (home);
	% pwd
	% image = 255-double(image);
	if size(image,3) == 4 % if .tiff image
	   image = image (:,:,1:3); 
	end

	% some preprocessing: some of the images have unwanted black background
	% pixel values less than 20 or greater than 200 make it background
	image(image<20 | image>200)=225;
			
	image = uint8(image);
end