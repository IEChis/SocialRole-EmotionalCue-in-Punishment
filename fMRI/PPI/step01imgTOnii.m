%%img2nii.m--------------------------------------------
%Script to convert hdr/img files to nii.
%This script uses SPM function, so you need to install SPM5 or later.
%Kiyotaka Nemoto 05-Nov-2014

%for ROI
input_dir = fullfile(pwd, 'img'); 
output_dir = fullfile(pwd, 'ROIs'); 
if ~exist(output_dir, 'dir')
    mkdir(output_dir); 
end

%select files
img_files = dir(fullfile(input_dir, '*reg_*.img')); 
if isempty(img_files)
    error('No .img files found in the "img" folder.');
end
 

for i = 1:length(img_files)
    input_file = fullfile(input_dir, img_files(i).name); 
    [~, fname, ~] = fileparts(img_files(i).name);
    output_file = fullfile(output_dir, [fname, '.nii']);
    V = spm_vol(input_file);
    ima = spm_read_vols(V); 
    V.fname = output_file; 
    spm_write_vol(V, ima); 
    fprintf('Converted: %s -> %s\n', input_file, output_file); 
end

% %%PPI for all sub
% 
% root_path = 'E:\IEChis\SCNU2024\Project00\fMRIdata';
% sub_folders = dir(fullfile(root_path, 'S*'));
% 
% for sub = 1:length(sub_folders)
%     sub_folder_path = fullfile(root_path, sub_folders(sub).name, 'noST_100s_s6_party_emo_dur0');
%     ppi_folders = dir(fullfile(sub_folder_path, 'PPI*'));
%     
%     for ppi = 1:length(ppi_folders)
%         ppi_folder_path = fullfile(sub_folder_path, ppi_folders(ppi).name);
%         img_files = dir(fullfile(ppi_folder_path, '.img'));
%         
%         if isempty(img_files)
%             fprintf('No .img files found in: %s\n', ppi_folder_path);
%             continue;
%         end
%         
%         for i = 1:length(img_files)
%             input_file = fullfile(ppi_folder_path, img_files(i).name);
%             [~, fname, ~] = fileparts(img_files(i).name);
%             output_file = fullfile(ppi_folder_path, [fname, '.nii']);
%             V = spm_vol(input_file);
%             ima = spm_read_vols(V);
%             V.fname = output_file;
%             spm_write_vol(V, ima);
% %             fprintf('Converted: %s -> %s\n', input_file, output_file);
%         end
%     end
% end