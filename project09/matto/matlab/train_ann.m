%  This document sets up the training data

clear all

data_index = 1;


% Line


target_data = zeros(993,10*1); %993 Genres 128*1024 = About 1 GB
input_data = zeros(993,10*1); %993 Genres 128*1024 = About 1 GB




GenreANN = newff(input_data,target_data,100);

memory

tic;
GenreANN = train(GenreANN,input_data,target_data);
toc



tic;
GenreANN = train(GenreANN,input_data,target_data);
toc

disp(['DONE']);
