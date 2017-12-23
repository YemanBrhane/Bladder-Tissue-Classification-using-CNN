function muscle_Cancer_Normal_separate_python()

patch_dst = 'F:\Project_Files\code_python\python_patches_folder\patches_ud';

folders = [1 3 4 6 7 8 9 10 11 13 14 16 17 18 20];
for m = 1:length(folders)
    patientNum  = folders(m);
    str = ['processing patient ' num2str(patientNum)];
    disp(str);
    fprintf('.\n.\n');

    warning('off'); % Image size warnings

    if patientNum<10
        patientNum = ['00' num2str(patientNum)];
    else
        patientNum = ['0' num2str(patientNum)];
    end

    %images path and dir
    image_drive = 'F:\Project_Files\Code\patchesFolder_ud';
    %image_drive ='D:\MAIA_Course\data';

    mat_path =[image_drive '\' num2str(patientNum)];
    localFolder_im =  [mat_path '\*.mat'];
    mat_dir= dir(localFolder_im);
    % mat_dir(1:2) = [];
    % Annoatations path and dir

    num_mat_files = numel(mat_dir); 

    for  i =1 : num_mat_files
        str = ['processing image ' num2str(i)];
        disp(str);
        name_mat_i  = [mat_path '\' mat_dir(i).name];
        %im_i = single(imread(name_im_i)); 
        X = load(name_mat_i) ;
        X  = X.tissuepatchs_Matfile;
        for kk = 1:length(X)
            data  = X(kk).patchs;
            data   = rmfield(data, 'tissuePercentage');
            type  = X(kk).type;
            home  = pwd;
            cd (patch_dst)

            patch_folder = [patch_dst '\'  patientNum '\' type ];
            file_name = [type '_' num2str(i)];
            if ~(7==exist(patch_folder,'dir'))
                mkdir ( patch_folder);
            end
            cd (patch_folder);
            save (file_name,'data');

            cd (home);            
        end      
    end
end
end %end fun


