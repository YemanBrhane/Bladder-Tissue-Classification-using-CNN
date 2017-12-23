%images path and dir
path_ = 'F:\Data\bladder\';
%image_drive ='D:\MAIA_Course\data';
num = [3];

for nn =1:length(num) 
    patientNum = num(nn);

    path_t=[path_  '00' num2str(patientNum) '\' 'annotations_t\'];

    path_t_dir= dir(path_t);
    path_t_dir(1:2) = [];

    num_tumor = numel(path_t_dir);
    

    for  i = 1: num_tumor
        str = ['processing image ' num2str(i)];
        disp(str);

        name_im_t  = [path_t path_t_dir(i).name];
        im_t = imread(name_im_t); 
        im_t = 50 * (im_t(:,:,1)>0);
        
        home = pwd;
        p=[path_  '00' num2str(patientNum) '\' 'annotations\'];
        cd (p)
        mask = uint8(im_t);
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