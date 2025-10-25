
%% Add the path to the gPPPI toolbox.
% spmpath=fileparts(which('spm.m')); % find the pathway of spm.m
% addpath([spmpath filesep 'toolbox']);
% addpath([spmpath filesep 'toolbox' filesep 'PPPI']);
spm('defaults','fmri')


%% %%%%%%%%%%%%%%%%%%%%%%%%%% path %%%%%%%%%%%%%%%%%%%

pathx=['F:' filesep 'IEChis' filesep 'SCNU2024' filesep 'Project00' filesep 'fMRIdata'];
root_dir=pathx;  %setup path
work_dir=[pathx filesep 'gPPI'];  %working directory, where to store .psfiles

returnHere=root_dir;

path=root_dir;  %% PPI is based on the first-level analysis of tranditional GLM
mask_path=['F:' filesep 'IEChis' filesep 'SCNU2024' filesep 'Project00' filesep 'SPP_TPP_emotion_fMRI' filesep 'fMRI' filesep 'PPI' filesep 'ROIs']; %% where VOI/mask is stored

subfiles=dir([path filesep 'S*']); %% filename of each subject's directory. start with 3.
ROIfiles=dir([mask_path,filesep,'6mm*-6_14_24*roi.nii']);    %6mm_ACC_PARAinter_-6_14_24_roi

func_path=['F:' filesep 'IEChis' filesep 'SCNU2024' filesep 'Project00' filesep 'SPP_TPP_emotion_fMRI' filesep 'fMRI' filesep 'PPI'];

%% performing the gPPI for each subject
for x=1:length(subfiles)
    if x == 9 || x==17
        continue;
    end    
    sub_name=subfiles(x).name;
    sub_path=fullfile(path,[subfiles(x).name filesep 'noST_100s_s6_party_emo_dur0_Rev']);
    
    
    roi_folder = 'ROImats';
    if ~exist([sub_path filesep roi_folder], 'dir')
            mkdir([sub_path filesep roi_folder]); 
    end
        
    for ROI_num=1:length(ROIfiles)
        cd(returnHere)
        ROI_name=ROIfiles(ROI_num).name;
        
%         if exist([sub_path,filesep,'PPI_' ROI_name(1:end-4)],'dir')
%             continue;
%         end
        cd(func_path)
        P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name);
        PPPI(P,[sub_path,filesep, roi_folder, filesep 'RevContrast_gPPI_' sub_name '_' ROI_name '.mat']);  %% set the parameter for each subject
        clear P;
        cd(pathx);
    end
end
 
% path(originalPath); 

