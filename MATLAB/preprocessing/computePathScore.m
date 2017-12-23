function patch_score_mat = computePathScore(BW_croped, p_h, p_w, M,N)

	%{
		This accepts BW_croped(image), patch height(p_h), patch_width(p_w),size of the returned matrix patch score
		(pre detrmined by calling function). It extracts patches and compute tissue percentatage of the patches
	%}

     patch_score_mat = zeros(M,N);
     patch_area  = p_h * p_w;
    for i = 1:M
        for j = 1:N            
            if (i ==1 && j==1)
                patch = BW_croped(1:p_h , 1:p_w);
            else
                patch = BW_croped(((i-1)*p_h + 1):i *p_h,...
                     ((j -1) * p_w + 1): j *p_w);
            end
            tissue_pixel  = sum(patch(:));            
            % Compute percentage of non zero part of the patch
            patch_score_mat (i , j)= tissue_pixel / patch_area;          
        end        
    end
end