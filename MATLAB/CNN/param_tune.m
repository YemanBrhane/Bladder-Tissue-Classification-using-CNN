clearvars -except imdb

%load('F:\Project_Files\Code\ImageDatabase\imdb_aug_norm_centered.mat');


disp('Tuning parameters')


%[dropOut InFeatureMapSize intermidiateFeatureMapSize fullyconnectedFeatureMapSize InputFilterSize];

c1= [0.5 78 450  1024 11]; 
c2=[0.5  110 400 1024 9];
c3=[0.1  110 400 1024 11];
c4=[0.3  110 400 2048 11];
c5=[0.3  110 600 1024 9]; 

c6=[0.5  110 600 2048 11];
c7=[0.5  110 600 1024 11];

% Learning rate
lr= [ 0.001];

parametres =[c1;c2;c3;c4;c5;c6;c7];
%optimizer = ['adam' 'sgd'];



%% tuning starts here
for i = 1: 7
    disp(['itration: ' num2str(i)])
    X = parametres(i,:);
    param.dropOut =X(1);
     param.InFeatureMapSize = X(2);
        param.intermidiateFeatureMapSize = X(3);
           param.fullyconnectedFeatureMapSize = X(4);
            param.InputFilterSize  = X(5);
			param.lr = lr;

    expDir = ['result\'...
    num2str(param.dropOut) '_'...
    num2str(param.InFeatureMapSize) '_' ...
    num2str(param.intermidiateFeatureMapSize) '_' ...
    num2str(param.fullyconnectedFeatureMapSize) '_'...
    num2str(param.InputFilterSize)...
    ];
    close all
    [net, info] = ConvNet_definition(imdb, param, expDir);		
end



