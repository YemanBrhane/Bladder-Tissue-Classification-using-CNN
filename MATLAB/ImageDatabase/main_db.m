% create database
close all; clc; clear;

% database of 45 degree rotated image
db_name  = 'imdb_45.mat';	
patch_path = 'F:\Project_Files\Code\patchesFolder_45\' ;
folders = [3 4 6 7 8 9 10 11 13 14 17 18 20];
createIMDBRAM( db_name, patch_path, folders);

% database of left to right flipped
db_name  = 'imdb_lr.mat';	
patch_path = 'F:\Project_Files\Code\patchesFolder_lr\' ;
folders = [3 4 6 7 8 9 10 11 13 14 17 18 20];
createIMDBRAM( db_name, patch_path, folders);


% database of up down  flipped
db_name  = 'imdb_ud.mat';	
patch_path = 'F:\Project_Files\Code\patchesFolder_ud\' ;
folders = [3 4 6 7 8 9 10 11 13 14 17 18 20];
createIMDBRAM( db_name, patch_path, folders);







