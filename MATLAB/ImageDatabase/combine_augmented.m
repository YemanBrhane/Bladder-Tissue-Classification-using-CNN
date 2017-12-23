%{


This code Combines previous created database of augmented patches( imdb_45.mat';imdb_lr.mat';imdb_ud.mat';)
it selects 12000 patches fromeach classes database of all agumentation databases. Thare are no validation data
as we don't need to augment validation data.

Finally it randomly permutes the patches
%}

db_name  = 'imdb_aug_only';
disp('creating empty db');
imdb = struct();

% we can initialize part of the structures already
imdb.meta.sets = {'train', 'val'};
imdb.meta.classes = { 'normal', 'cancer','muscle'}; % label: 1 , 2, 3  
imdb.meta.patientnum = [];

% images go here
imdb.images.data = []; % array dimensions restriction
% this will contain the mean of the training set
imdb.images.data_mean = []; % []
% a label per image
imdb.images.labels = [];
% vector indicating to which set an image belong, i.e.,
% training, validation, etc.
imdb.images.set = [];    

dbs = cell(1,3);
dbs{1} = 'imdb_45.mat';

dbs{2} = 'imdb_lr.mat';

dbs{3} = 'imdb_ud.mat';
num = 12000; % number of patches from each class to be selected

for i=1:3
    disp(i)
    im_db = load(dbs{i});
    l = im_db.imdb.images.labels;
    
    % normal
    idx_n = find(l==1);
    N  = length(idx_n);
    p = randperm(N,num);
    selected_index = idx_n(p);
    
    %label = l(selected_index);
    
    data = im_db.imdb.images.data(:,:,:,selected_index);
    imdb.images.data = cat( 4, imdb.images.data , data);
    imdb.images.labels = cat( 2,  imdb.images.labels   , 1*ones(1,num)) ;
    % cancer
    idx_c = find(l==2);
    N  = length(idx_c);
    p = randperm(N,num);
    selected_index = idx_c(p);
    label = l(selected_index);
    data = im_db.imdb.images.data(:,:,:,selected_index);
    imdb.images.data = cat( 4, imdb.images.data , data);
    imdb.images.labels = cat( 2,  imdb.images.labels   , 2*ones(1,num)) ;
    % muscle
    idx_m = find(l==3);
    N  = length(idx_m);
    p = randperm(N,num);
    selected_index = idx_m(p);
    label = l(selected_index);
    data = im_db.imdb.images.data(:,:,:,selected_index);
    imdb.images.data = cat( 4, imdb.images.data , data);
    imdb.images.labels = cat( 2,  imdb.images.labels   , 3*ones(1,num)) ;
    
    imdb.images.set = cat( 2,  imdb.images.set  , ones(1,3*num)) ;
	%save(db_name,'imdb','-v7.3');
end
% randomly permute data
N  = length(imdb.images.labels);
indices = randperm(N);
imdb.images.data(:,:,:,:) = imdb.images.data(:,:,:,indices);
imdb.images.labels(:) = imdb.images.labels(indices);
imdb.images.set(:) = imdb.images.set(indices);
save(db_name,'imdb','-v7.3');





