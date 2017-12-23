%{
	This code combines two separate ground truths(muscle and tumor) into one image 
%}

%images path or dir
path_ = 'F:\Data\bladder\';
%image_drive ='D:\MAIA_Course\data';
num = [9];

for nn =1  
    patientNum = num(nn);

    path_t=[path_  '00' num2str(patientNum) '\' 'annotations_t\'];

    path_t_dir= dir(path_t);
    path_t_dir(1:2) = [];
    % Annoatations path and dir
    path_m=[path_  '00'  num2str(patientNum) '\' 'annotations_m\'];

    path_m_dir= dir(path_m);
    path_m_dir(1:2) = [];

    num_tumor = numel(path_t_dir);
    num_muscle = numel(path_m_dir);    

    if (num_tumor ~= num_muscle)
        error('Error:number of images and annorations different!');   
    end

    for  i = 1: num_muscle
        str = ['processing image ' num2str(i)];
        disp(str);

        name_im_t  = [path_t path_t_dir(i).name];
        im_t = imread(name_im_t); 
        im_t = 50 * (im_t(:,:,1)>0);
        [r_t, c_t] = size(im_t);

        name_im_m  = [path_m path_m_dir(i).name];
        im_m = imread(name_im_m); 
        im_m = 150* (im_m(:,:,1)>0);
        [r_m, c_m] = size(im_m);

        if (r_m~=r_t || c_m~=c_t)
           error('Size tumor mask diffrent from size of muscle mask'); 
        end

        mask = im_t + im_m;

        if max(mask(:)>150)
            error('the is overlap in the between tumor and muscle annotation given by the doctor');            
        else
            home = pwd;
            p=[path_  '00' num2str(patientNum) '\' 'annotations\'];
            cd (p)
            mask = uint8(mask);
            if i<10
                name  = ['00' num2str(i) '.png'];
            else
                name  = ['0' num2str(i) '.png'];
            end
            %figure, imshow(mask)
            imwrite(mask,name)
            cd(home)
        end       
    end
end