
function mask = ROI (G)
	%{
		INPUT:
			G : input image, can be RGB or grayscale image
			
			The function applies morhological operartions: dilation, erossion and region propories
		
		OUTPUT:
			MASK : single channel and has same row and column size as G. ones in region of interest and zeros in background
	%}
     if size(G,3)==3
        G = G(:,:,2); 
     end
    %figure();imshow(G)
    % G = im(:,:,2);
    level = graythresh(G);
    BW = imbinarize(G,level);
    BW = imcomplement(BW);
    %figure, imshow(BW,[]);
    se = strel('disk',50);
    mask = imdilate(BW,se);
    %figure, imshow(mask,[]);

    mask = uint8(imfill(mask,'holes'));
    se = strel('disk',30);
    mask = imerode(mask,se);
    
    % Get all the object properties.  
    [labeledImage, ~] = bwlabel(mask);
    blobMeasurements = regionprops(labeledImage, 'area');
    % Get all the areas
    allAreas = [blobMeasurements.Area];

    % sort in order of largest to smallest.
    % Sort them.
    [~, sortIndexes] = sort(allAreas, 'descend');

    numberToExtract = sum(allAreas>=200000);
    % Extract the "numberToExtract" largest blob(a)s using ismember().
    biggestBlob = ismember(labeledImage, sortIndexes(1:numberToExtract));
    % Convert from integer labeled image into binary (logical) image.
    mask = biggestBlob > 0;

end



