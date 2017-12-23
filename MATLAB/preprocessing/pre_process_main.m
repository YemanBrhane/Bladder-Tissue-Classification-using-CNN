%{  
YB Hagos
This is main for preprcessing
%}

%% Clear workspace
clc; close all; clear;


% do = 'augmentation';

do = 'normal';

%% figures control
%set(groot,'defaultFigureVisible','off'); 
set(groot,'defaultFigureVisible','on'); 
if strcmp(do,'normal')
    opt.do = do;
elseif strcmp(do,'augmentation')
    opt.do = do;
else 
   error('process not known please select the process correctly'); 
end

disp('Execution Started...');
fprintf('.\n.\n');

% patient numbers
folder = 16;%[9 10 11 13 14 17 18 20];

for k = 1:length(folder)
    patientNum = folder(k);
    muscleCancerNormalSeparate(patientNum, opt);

end

