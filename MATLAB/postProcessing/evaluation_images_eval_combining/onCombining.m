
function [ DiceCof , Accuracy ] = onCombining(truth,im)
	%{
		Inputs:
			im 		: input image
			truth	: Groud truth image
			
			This is implemetation of evalaution of an input image: First region of interest is extracted,  then
			overlapping patches(128 x 128) are taken with stride of [ 20 20]. model is evaluated using the patches.
				.
				.
				.
				.
			finaly patch to Whole Image Classification is evaluated using 	MAX, SUM and MOJORITY VOTE patch combining methods
			are evaluated
		Outputs:
			DiceCof  : 1 x 3 : MAX, SUM, MOJORITY Vote dice index of classification result
			Accuracy : 1 x 3 : MAX, SUM, MOJORITY Vote pixelwise classification accuracy
	%}

    DiceCof  = zeros(1,3); % max, sum, majority vote
    Accuracy = zeros(1,3); % max, sum, majority vote
	
    %% matconvnet compile
	
	convSetup = '../../matconvnet_24/matlab/vl_setupnn.m';
	run(convSetup) ;

	% model name 
	model = '../../model/model.mat';

	net = load(model, 'net') ;
	net = dagnn.DagNN.loadobj(net.net) ;
	conserve_memory = true;
	
	% num classes	
	num_classes = 3;
    
    %% get roi
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
    truth = truth(row_min:row_max, col_min:col_max,:);
	mask_roi = uint8(mask (row_min:row_max, col_min:col_max,:));
	[M,N,~] = size(roi_im);
	
	classification_out_max = zeros(M , N , num_classes,'single'); % Normal , Cancer, Muscle
	classification_out_sum = zeros(M , N , num_classes,'single'); % Normal , Cancer, Muscle
	classification_out_majorVote = zeros(M , N , num_classes,'single'); % Normal , Cancer, Muscle
	
	stride  = [20,20];
	
	p_r= 128;
	p_c = 128;
	


	M  = size(roi_im,1);
	N  = size(roi_im,2);
	
	patch_col_half = floor(p_c/2);
	patch_row_half = floor (p_r/2);
	
	X = M-(patch_row_half)*2;
	Y = N-(patch_col_half)*2;
	tissue_percentage_thresh = 0.1;
	
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
 				%sumCombining()
 				%majorityVoteCombining()
			end
			
		end
		
    end
	
    save classification_out_max classification_out_max;
	%% analyse the combining rules: Segmentation
    disp('analysing combining');
	
	%% max combining: I have to consider if max is in 2 or more classes
	out_max_ = max(max(classification_out_max(:,:,1),...
	classification_out_max(:,:,2)), classification_out_max(:,:,3));
	
	%out_max_norml = 10 * uint8(classification_out_max(:,:,1) == out_max_  &  out_max_~=0); % normal`
	
	out_max_cancer= 50 * uint8(classification_out_max(:,:,2) == out_max_   &  out_max_~=0); % cancer
	
	out_max_muscle= 150 * uint8(classification_out_max(:,:,3) == out_max_   &  out_max_~=0); % muscle
	
	out_max = out_max_muscle + out_max_cancer ;%+ out_max_norml;
    out_max = mask_roi .* uint8(out_max);
	%save out_max out_max;
    
    %% apply some post processing
    out_max = fill_hole_remove_outlier(out_max);
	DiceCof(1) = computeDSC(truth, out_max);
	
    %% Compute Accuracy	
	 Accuracy(1) = computeAccuracy(truth, out_max);
	
	
	%% sum combining
	out_sum_max_ = max(max(classification_out_sum(:,:,1),...
	classification_out_sum(:,:,2)), classification_out_sum(:,:,3));
	
	%out_sum_norml=10 * uint8(classification_out_sum(:,:,1) == out_sum_max_ & out_sum_max_ ~=0); % normal`
	
	out_sum_cancer= 50 * uint8(classification_out_sum(:,:,2) == out_sum_max_ & out_sum_max_ ~=0); % cancer
	
	out_sum_muscle= 150 * uint8(classification_out_sum(:,:,3) == out_sum_max_ & out_sum_max_ ~=0 ); % muscle
	
	out_sum = out_sum_muscle + out_sum_cancer;% + out_sum_norml;
	
    out_sum = mask_roi .* uint8(out_sum);
	%save out_sum out_sum;
    
    %% apply some post processing
    out_sum = fill_hole_remove_outlier(out_sum);
    
    %% compute Dice Coeeficent
	DiceCof(2) = computeDSC(truth, out_sum);
	
    %% Compute Accuracy	
	 Accuracy(2) = computeAccuracy(truth, out_sum);
    
    	
	%% majority vote combining
	out_majorvote_max_ = max(max(classification_out_majorVote(:,:,1),...
	classification_out_majorVote(:,:,2)), classification_out_majorVote(:,:,3));
	
	%out_majorvote_norml= uint8(classification_out_majorVote(:,:,1) == out_majorvote_max_ & out_majorvote_max_~=0); % normal`
	
	out_majorvote_cancer= 50 * uint8(classification_out_majorVote(:,:,2) == out_majorvote_max_  & out_majorvote_max_~=0 ); % cancer
	
	out_majorvote_muscle= 150 * uint8(classification_out_majorVote(:,:,3) == out_majorvote_max_  & out_majorvote_max_~=0 ); % muscle
	
	
	out_majorvote = out_majorvote_muscle + out_majorvote_cancer;% + out_majorvote_norml;
	
    out_majorvote = mask_roi .* uint8(out_majorvote);
   
	%save out_majorvote out_majorvote;
    %% apply some post processing
    out_majorvote = fill_hole_remove_outlier(out_majorvote);
    
    %% compute Dice Coeeficent
    DiceCof(3) = computeDSC(truth, out_majorvote);
	
    %% Compute Accuracy	
	 Accuracy(3) = computeAccuracy(truth, out_majorvote);
    
    
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
	
	function sumCombining()
	
		s = ones(p_r,p_c, num_classes);
		
		for cl=1:num_classes
			s(:,:,cl) = s(:,:,cl)*classiff_output(cl);
		end
		
		classification_out_sum (row_idx , col_idx,:) =...
		(classification_out_sum (row_idx , col_idx,:) + s);
		
	end
	
	function majorityVoteCombining()
	
		[~ , I]= max(classiff_output); 
		
        classification_out_majorVote(row_idx , col_idx,I) = ...
		(classification_out_majorVote(row_idx , col_idx,I)  + ones (length(row_idx) , length(col_idx)));
    end
end

function scores = cnnEvaluate(net, im,conserve_memory )

		% obtain the CNN otuput
		net.conserveMemory = conserve_memory;

		% run the CNN
		net.eval({'input', im});

		scores = net.vars(net.getVarIndex('prob')).value;
		
		scores = squeeze(gather(scores));

		% show the classification results
		%[bestScore, best] = max(scores);
end

function nonbgd_percentage = computPatchScore(patch)
	% Compute percentage of non zero part of the patch
    [h,w,~] = size(patch);
	
    tissue_pixels  = sum(patch(:));  
	
    nonbgd_percentage= tissue_pixels / (h*w);
end

function DSC = computeDSC(truth, result)
    % compute Dice coefficient:
    DSC = 2 * sum(sum(result==truth & truth>0 & result>0 ))/(sum(truth(:)>0) + sum(result(:)>0));
end

function Acc = computeAccuracy(truth, result)
    % compute Dice coefficient:
    Acc = sum(sum(result==truth))/(size(truth,1) * size(truth,2));
end

