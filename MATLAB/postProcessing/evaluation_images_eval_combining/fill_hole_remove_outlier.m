function res_out = fill_hole_remove_outlier(res_in)
	%{
		RES_OUT = FILL_HOLE_REMOVE_OUTLIER(RES_IN)
		
		INPUT: 
			RES_IN: input image which is output of classification result: It has three unique values
			
		OPERATION:
			It separate the image into cancer, softissue and muscle and applies morphological operation on theses regions
			.
			.
			.
			Finally add the separately cleaned images
		
		OUTPUT:
			RES_OUT : clean image where small regions and holes removed
	%}
    unique_Values = unique(res_in);
    res_out=zeros(size(res_in),'uint8');
	
    for ii=2:length(unique_Values)
	
        im  =  res_in==unique_Values(ii);
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

        numberToExtract = sum(allAreas>=40000);
		
        % Extract the "numberToExtract" largest blob(a)s using ismember().
        biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
		
        % Convert from integer labeled image into binary (logical) image.
        seg_res = unique_Values(ii) * uint8(biggestBlob > 0);
		
        %figure();imshow(seg_res)
        res_out  = res_out + seg_res;
		
        %mask = uint8(imfill(mask,'holes')); 
        %figure();imshow(mask,[]);
    end
end