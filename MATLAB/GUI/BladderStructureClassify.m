
function output= BladderStructureClassify(im, display)
	%{
	BLADDERSTRUCTURECLASSIFY classify bladder structure into muscle, cancer and soft tissue
	
	OUTPUT = BLADDERSTRUCTURECLASSIFY (IM , DISPLAY) returns an otuput image same size as IM 
	with muscle, cancer and soft tissue part of the image classified. It accespts also a 
	second input DISPLAY a handle to text uicontrol in the graphical user interface to 
	diaplay the progress of the classification to user.
	
	The function also assumes there is matconvnet setup in same folder and pretrained cnn network
	
	%}

	
	if nargin ~= 2
		error('BLADDERSTRUCTURECLASSIFY (IM , DISPLAY) accepts 2 inputs');
	end
	
	convSetup = '../matconvnet_24/matlab/vl_setupnn.m';
	run(convSetup) ;

	% model name 
	model = 'model.mat';

	net = load(model, 'net') ;
	net = dagnn.DagNN.loadobj(net.net) ;
    conserve_memory = true;
	
	% num classes	
	num_classes = 3;
    
    %% get roi
	set(display,'string',{'Image Loading';'ROI Selecting...'});
    mask = ROI (im(:,:,2));
	
	% cleaned image
    roi_ = im.* uint8(repmat(mask,[1,1,3])); 
    roi_(roi_==0)=225;
    
    % cutt region of interest part
    [r,w] = find(mask>0);
    row_min = min(r);
    row_max = max(r);
    
    col_min = min(w);
    col_max = max(w);
    
    roi_im = roi_(row_min:row_max, col_min:col_max,:);
	mask_roi = uint8(mask (row_min:row_max, col_min:col_max,:));
	[M,N,~] = size(roi_im);
	
	classification_out_max = zeros(M , N , num_classes,'single'); % Normal , Cancer, Muscle
	stride  = [20,20];
	p_r	= 128;
	p_c = 128;
	


	M  = size(roi_im,1);
	N  = size(roi_im,2);
	
	patch_col_half = floor(p_c/2);
	patch_row_half = floor (p_r/2);
	
	X = M-(patch_row_half)*2;
	Y = N-(patch_col_half)*2;
	tissue_percentage_thresh = 0.1;
	
	set(display,'string',{'Image Loading';'ROI Selecting' ; 'Patch Classification...'});
	disp('computing classification');
	for i=patch_row_half:stride(1):X
		for j=patch_col_half:stride(2):Y
			row_start = i- patch_row_half+1;
			row_end   = i + patch_row_half;
			col_start = j- patch_col_half+1;
			col_end   = j + patch_col_half;
            
            row_idx = row_start:row_end;
            col_idx = col_start:col_end;
			patch = roi_im (row_idx , col_idx,:);
			BW = binarizePatch();
			% compute tissue percentage of the patch
			tissue_percentage = computPatchScore(BW);
			
			if tissue_percentage< tissue_percentage_thresh
				% do something
			else
				patch = single(patch);
				% normalize the input patch image
				patch= patch/255;
				patch = patch - net.meta.trainingPatchesMean;
				classiff_output = cnnEvaluate(net, patch,conserve_memory );
				
				maxCombining()
% 				sumCombining()
% 				majorityVoteCombining()
			end
			
		end
		
	end
	
	%% analyse the combining rules: Segmentation
	set(display,'string',{'Image Loading';'ROI Selecting' ; 'Patch Classification';...
	'Max Combining'});
    disp('analysing combining');
	% max combining: I have to consider if max is in 2 or more classes
	out_max_ = max(max(classification_out_max(:,:,1),...
	classification_out_max(:,:,2)), classification_out_max(:,:,3));
	%out_max_norml = 10 * uint8(classification_out_max(:,:,1) == out_max_  &  out_max_~=0); % normal`
	out_max_cancer= 50 * uint8(classification_out_max(:,:,2) == out_max_   &  out_max_~=0); % cancer
	out_max_muscle= 150 * uint8(classification_out_max(:,:,3) == out_max_   &  out_max_~=0); % muscle
	out_max = out_max_muscle + out_max_cancer ;%+ out_max_norml;
    out_max = mask_roi .* uint8(out_max);
	%save out_max out_max;
    
    %% apply some post processing
	set(display,'string',{'Image Loading';'ROI Selecting' ; 'Patch Classification';...
	'Max Combining';'Post Processing...'});
    out_max = fill_hole_remove_outlier(out_max);
	% roi_im = roi_(row_min:row_max, col_min:col_max,:);
	[Row_in , Col_in, ~] = size(im); 
	output = zeros(Row_in, Col_in);
	output(row_min:row_max, col_min:col_max,:) = out_max;

    %% inline functions that use shared variables: they share variables with parent function
    
    function BW = binarizePatch()
        patch_ = patch;
        if size(patch_, 3)==3 % if image is RGB take Green channel
            patch_  = patch_(:,:,2);
        end
        level = graythresh(patch_);
        BW = imbinarize(patch_,level);
        BW = imcomplement(BW);
    end
	
	function maxCombining()
		s = ones(p_r,p_c, num_classes);
		for cl=1:num_classes
			s(:,:,cl) = s(:,:,cl)*classiff_output(cl);
		end
		classification_out_max (row_idx , col_idx,:) =...
		max(classification_out_max (row_idx , col_idx,:),s);			
	end
end

function scores = cnnEvaluate(net, im,conserve_memory )
	%{
		evalaue pretrained CNN model (net), for an input image or patch (im)
		and a boolean parametre conserve memory:
		conserve_memory=true, intermmidiate activations will be lost
		conserve_memory  = false, intermidiate results will be held so ifyou want you can visualize them
	%}
	% obtain the CNN otuput
	net.conserveMemory = conserve_memory;

	% run the CNN
	net.eval({'input', im});

	scores = net.vars(net.getVarIndex('prob')).value;
	scores = squeeze(gather(scores));
end

function nonbgd_percentage = computPatchScore(patch)  
	%{
		Compute the proportion of area of patch that contains
		tissue
	%}
    [h,w,~] = size(patch);
    tissue_pixels  = sum(patch(:));            
    % Compute percentage of non zero part of the patch
    nonbgd_percentage= tissue_pixels / (h*w);
end
