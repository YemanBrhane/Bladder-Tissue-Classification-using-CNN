function patch_Matfile = patchExtractor( image_in_separated)
    p_w = 128;
    p_h = 128;
    
    %% some preprocessing
    
    % APPLY OTSU thrsholding on  green channel of the image
    g = image_in_separated(:,:,2);    
    level = graythresh(g);
    BW = imbinarize(g,level);
  figure,imshow(BW)
    % complement the binary image
    BW_comp = imcomplement(BW);
    figure,imshow(BW_comp)
    
    % find non zero part of of the image
    [ row , col] = find(BW_comp ~=0);
    row_min = min(row);
    %row_max = max(row);
    
    col_min = min(col);
    %col_max = max(col);
    
    %% crop Part of the image which is non zero
    %im_croped = image_in(row_min:row_max , col_min:col_max,:);
    im_croped = image_in_separated(row_min:end , col_min:end,:);
    figure, imshow(im_croped,[]);
    
    % for the whole image
    %im_croped_whole = image_whole(row_min:end , col_min:end,:);
    

    % crop the binary image
    %BW_croped = BW_comp(row_min:row_max , col_min:col_max,:);
    BW_croped = BW_comp(row_min:end , col_min:end,:);
        
    
    %% extarct patches and compute non zero part percentage score
    [r, c] = size(BW_croped);
    M  = floor(r/p_h);
    N  = floor(c/p_w);
    
    %************************************************
	%patch11_score  patch12_score   ......      patch1N_score
	%patch21_score     ....           .             .                            
	%   .               .             .             .
	%   .               .             .             .
	%   .               .             .             .
	%patchM1_score  patchM2_score    ......     patchMN_score
    
     %************************************************
     patch_score_matrix = computePathScore(BW_croped, p_h, p_w,M,N);
     
     % analyse and extract tissue patches based on patch score matrix
     patch_Matfile = tissuePatchesExtrator(im_croped,patch_score_matrix, p_h, p_w, M,N);
     
end
    




