
function mask = ROI (G)
	%{
		ROI extract region of interest
		The function accepts a gray scale of RGB image and extracts region of interest using MORPHOLOGICAL OPERARTION
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



