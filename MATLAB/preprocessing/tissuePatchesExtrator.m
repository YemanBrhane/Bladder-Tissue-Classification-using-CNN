function patch_Matfile = tissuePatchesExtrator(image_croped,patch_score_matrix, p_h, p_w, M,N)

patch_Matfile = struct;

n=0; % number of tissue patches stored
for i = 1:M
    for j = 1:N

        %% extract patch (i, j) 
        if (i==1 && j==1 )
            %test_patch = image_croped(1:p_h , 1:p_w,:);
            test_patch = image_croped(1:p_h , 1:p_w,:);
        else 
            %test_patch =image_croped(((i-1)*p_h + 1):i *p_h , ((j -1) * p_w + 1): j *p_w, : );
            test_patch =image_croped(((i-1)*p_h + 1):i *p_h , ((j -1) * p_w + 1): j *p_w, : );
        end
        %%    (i, j) patch tissue percentage score               
        score = patch_score_matrix(i,j);
        
        %% check if patch is tissue patch
		
		% if patch is boundary patch
       if score>0.2
           generatePatchMat()
       end
    end
end
 
 function generatePatchMat()
        if (i==1 || j==1 || j==N || i==M)
            
            if (i==1 && j==1)
                    % upper left corner patch

                    if score>0.3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                    elseif score>0.2
                        score_r = patch_score_matrix(i, j+1);
                        score_b = patch_score_matrix(i+1, j);
                        
                        X = [ score_r>=0.3 , score_b>= 0.3];
                        if sum(X)>=1
                            n = n+1; % number of patches increment 
                            patch_Matfile(n).patch = test_patch;
                            patch_Matfile(n).tissuePercentage = score;
                            
                        end
                    end
            
                
            elseif (i==1 && j~=1 && j~=N)
                    % upper border patches(not corner)
                    
                    if score>0.3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                        
                     elseif score>0.2
                        score_l = patch_score_matrix(i, j-1);
                        score_r = patch_score_matrix(i, j+1);
                        score_b = patch_score_matrix(i+1, j);
                        
                        X = [ score_r>=0.3 , score_b>= 0.3 score_l>=0.3];
                        if sum(X)>=2
                            n = n+1; % number of patches increment 
                            patch_Matfile(n).patch = test_patch;
                            patch_Matfile(n).tissuePercentage = score;
                            
                        end
                    end

                
            elseif (j==1 && i ~=1 && i~=M)
                    % left border patch
                    
                    if score>0.3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                        
                     elseif score>0.2
                        score_t = patch_score_matrix(i-1, j);
                        score_r = patch_score_matrix(i, j+1);
                        score_b = patch_score_matrix(i+1, j);
                        
                        X = [ score_r>=0.3 , score_b>= 0.3 score_t>=0.3];
                        if sum(X)>=2
                            n = n+1; % number of patches increment 
                            patch_Matfile(n).patch = test_patch;
                            patch_Matfile(n).tissuePercentage = score;
                            
                        end
                    end
                    
            elseif (j==N && i==1)
                    % Top right corner patch
                    
                    if score>0.3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                       
                     elseif score>0.2
                        score_l = patch_score_matrix(i, j-1);                      
                        score_b = patch_score_matrix(i+1, j);
                        X = [ score_b>= 0.3 score_l>=0.3];
                        if sum(X)>=1
                            n = n+1; % number of patches increment 
                            patch_Matfile(n).patch = test_patch;
                            patch_Matfile(n).tissuePercentage = score;
                            
                        end
                    end
            elseif (j==N && i~=1 && i~=M)
                    % right border patches
                    
                    if score>0.3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                        
                     elseif score>0.2
                        score_l = patch_score_matrix(i, j-1);
                        score_t = patch_score_matrix(i-1, j);
                        score_b = patch_score_matrix(i+1, j);
                        
                        X = [ score_t>=0.3 , score_b>= 0.3 score_l>=0.3];
                        if sum(X)>=2
                            n = n+1; % number of patches increment 
                            patch_Matfile(n).patch = test_patch;
                            patch_Matfile(n).tissuePercentage = score;
                            
                        end
                    end
                
            elseif (i==M && j==N)
                % Bottom right corner patch
                
                if score>0.3
                    n = n+1; % number of patches increment 
                    patch_Matfile(n).patch = test_patch;
                    patch_Matfile(n).tissuePercentage = score;
                    
                 elseif score>0.2
                    score_l = patch_score_matrix(i, j-1);
                    score_t = patch_score_matrix(i-1, j);                   
                    X = [ score_t>=0.3 score_l>=0.3];
                    
                    if sum(X)>=1
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;
                        
                    end
                end
				
            elseif (i==M && j==1)
                % Bottom left corner patch
                
                if score>0.3
                    n = n+1; % number of patches increment 
                    patch_Matfile(n).patch = test_patch;
                    patch_Matfile(n).tissuePercentage = score;
                    
                 elseif score>0.2
                    score_r= patch_score_matrix(i, j+1);
                    score_t = patch_score_matrix(i-1, j);                   
                    X = [ score_t>=0.3 score_r>=0.3];
                    
                    if sum(X)>=1
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;                        
                    end
                end
            elseif (i==M && j~=1 && j~=N)
                % Bottom border patch
                
                if score>0.3
                    n = n+1; % number of patches increment 
                    patch_Matfile(n).patch = test_patch;
                    patch_Matfile(n).tissuePercentage = score;
                   
                 elseif score>0.2
                    score_r= patch_score_matrix(i, j+1);
                    score_l= patch_score_matrix(i, j-1);
                    score_t = patch_score_matrix(i-1, j);
                   
                    X = [ score_t>=0.3 score_r>=0.3 score_l>=0.3];
                    if sum(X)>=2
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;                       
                    end
                end
            end
			
        % if patch is not boundary patch   
        else

                if score>0.3
                    n = n+1; % number of patches increment 
                    patch_Matfile(n).patch = test_patch;
                    patch_Matfile(n).tissuePercentage = score;
                    
                 elseif score>0.2
                    score_r = patch_score_matrix(i, j+1);
                    score_l = patch_score_matrix(i, j-1);
                    score_t = patch_score_matrix(i-1, j);
                    score_b = patch_score_matrix(i+1, j);
                   
                    X = [ score_t>=0.3 score_r>=0.3 score_l>=0.3 score_b>=0.3];
                    if sum(X)>=3
                        n = n+1; % number of patches increment 
                        patch_Matfile(n).patch = test_patch;
                        patch_Matfile(n).tissuePercentage = score;                        
                    end
                end
        end
    
 end
end