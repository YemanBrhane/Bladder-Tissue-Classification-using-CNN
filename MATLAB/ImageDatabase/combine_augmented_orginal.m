%{
This code combines patches of augmented and non augmented images, it selects some of the orginal patches
and combine them with the orginal ones. and saves the final image database that willl be used to train our network
%}

db_name  = 'imdb_final'; % augmented and orginal patches combined

% orginal Patches
im_db_org = load('E:\no_augumentation_val_1_16\imdb.mat');

% number of patches to be selected from each class: muscle, cancer, Normal(soft tissue)
num  = 12000;

im_db_org_set = im_db_org.imdb.images.set;
idx_train  = find(im_db_org_set==1); % index of training images

label_all = im_db_org.imdb.images.labels; % label of training and validation images
l = label_all;

l = l(idx_train); % lable of training images

% normal: label==1
idx_n = find(l==1);
N  = length(idx_n);
p = randperm(N,num);
selected_index = idx_n(p);

data = im_db_org.imdb.images.data(:,:,:,selected_index);
labels = 1*ones(1,num);


% cancer: label==2
idx_c = find(l==2);
N  = length(idx_c);
p = randperm(N,num);
selected_index = idx_c(p);
%label = l(selected_index);
data = cat( 4, data,im_db_org.imdb.images.data(:,:,:,selected_index));
labels =  cat(2,labels,2*ones(1,num));

% muscle: label==3
idx_m = find(l==3);
N  = length(idx_m);
p = randperm(N,num);
selected_index = idx_m(p);
label = l(selected_index);
data = cat( 4, data, im_db_org.imdb.images.data(:,:,:,selected_index));
labels = cat(2,labels,3*ones(1,num) );

% set=1, which is training sets and 3 * num because of the three classes
set = ones(1,3*num);

% add validation images: no need of Augmentation

idx_val  = find(im_db_org_set==2);
data = cat( 4, data , im_db_org.imdb.images.data(:,:,:,idx_val));
labels = cat( 2, labels   , label_all(idx_val)) ;
set = cat(2, set, 2*ones(1,length(idx_val)));


%*******************************************************

clear('im_db_org');

N  = length(labels);
indices = randperm(N);
data(:,:,:,:) = data(:,:,:,indices);
labels(:) = labels(indices);
set(:) = set(indices);

disp('combining with previous db')
load('imdb_aug_only.mat');
imdb.images.data = cat( 4, imdb.images.data, data );
imdb.images.labels = cat( 2,imdb.images.labels, labels) ;
imdb.images.set = cat(2, imdb.images.set, set);

%**********************************************************************


N  = length(imdb.images.labels);
indices = randperm(N);
imdb.images.data(:,:,:,:) = imdb.images.data(:,:,:,indices);
imdb.images.labels(:) = imdb.images.labels(indices);
imdb.images.set(:) = imdb.images.set(indices);

save(db_name,'imdb','-v7.3');
