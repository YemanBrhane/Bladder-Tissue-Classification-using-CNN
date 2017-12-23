function res_out = fill_hole_remove_outlier(image_im)
	%{
		FILL_HOLE_REMOVE_OUTLIER Rsome holes and outlier noises from an imge
		res_out = FILL_HOLE_REMOVE_OUTLIER (IMAGE_IN) returns an image same size as IMAGE_IN with all small holes 
		and outliers removed.
	%}

	if nargin ~= 1
		error('FILL_HOLE_REMOVE_OUTLIER (IMAGE_IN) accepts ONLY one inputs');
	end
	
    unique_Values = unique(image_im);
    res_out=zeros(size(image_im),'uint8');
    for ii=2:length(unique_Values)
        im  =  image_im==unique_Values(ii);
        se = strel('disk',30);
        im = imclose(im,se);
        %figure();imshow(im)
        % Get all the object properties.  
        [labeledImage, ~] = bwlabel(im);
        blobMeasurements = regionprops(labeledImage, 'area');
        % Get all the areas
        allAreas = [blobMeasurements.Area];

        % sort in order of largest to smallest.
        % Sort them.
        
        [~, sortIndexes] = sort(allAreas, 'descend');
   
        numberToExtract = sum(allAreas>=30000);

        % Extract the "numberToExtract" largest blob(a)s using ismember().
        biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
        % Convert from integer labeled image into binary (logical) image.
        seg_res = unique_Values(ii) * uint8(biggestBlob > 0);
        %figure();imshow(seg_res)
        res_out  = res_out + seg_res;
    end
end