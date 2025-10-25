%% before DICOM: move bold images to specifc folder named analysis_data
clc;
clear all;
% set path
path = 'D:\ML_emotion_SPP_TPP\fMRI_rawdata';

% file_path = fullfile([path,'\S*\S202*\ZHOU*\EP2D_BOLD_T*']);%文件所在目录
% file_folder = dir([path,'\S*\S202*\ZHOU*']);
% target_path = fullfile(path, '\S*');%将要移动到的目录下
sub_folders = dir(fullfile(path,'\S*'));%target path

for i = 1:31 %
    file_folder = dir(fullfile([sub_folders(i).folder,'\S*\S202*\ZHOU*']));

    % search the dir begin with "EP2D" and "T1W" named
    folders = dir(fullfile([file_folder(i).folder],'\ZHOU*\EP2D_BOLD_T*'));%s
    folders = [folders;  dir(fullfile([file_folder(i).folder], '\ZHOU*\T1W*'))];%t
  
    % if found，remove to pre_DICOM 
    if ~isempty(folders)
        % set postDIC path
        preDIC_folder = fullfile(path,'analysis_data/',sub_folders(i).name);%target path
        
        % 
        if ~exist(preDIC_folder, 'dir')
            mkdir(preDIC_folder);
        end
        
        % move / cope EP2D file to preDICOM dir
        for k = 1:length(folders)
            movefile(fullfile(folders(k).folder, folders(k).name), preDIC_folder);
%             copyfile(fullfile(folders(k).folder, folders(k).name), preDIC_folder);
        end
    end
end