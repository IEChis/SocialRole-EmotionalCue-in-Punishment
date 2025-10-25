%%dicom functional 
clc;
clear all
spm('defaults', 'FMRI');

path = ['E:\IEChis\SCNU2024\Project00\weixin_fMRIdata'];

folders = dir([path,'\S*']);

for i = 1:31 %length(folders)
    run_folder = dir([path,'\',folders(i).name,'\EP2D_BOLD*']);
    run_num = length(run_folder);
    for run = 1:run_num
        run_file = run_folder(run).name
        
        INPUTS = spm_select ('FPList',[path '\' folders(i).name '\' run_file '\'], 'S20.*\.IMA');
        INPUTS= cellstr(INPUTS);
        
        matlabbatch{1}.spm.util.import.dicom.data =INPUTS;
        matlabbatch{1}.spm.util.import.dicom.root = 'series';
        matlabbatch{1}.spm.util.import.dicom.outdir =cellstr([path '\' folders(i).name '\' run_file '\']);
        matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
        
        %clear matlabbatch;
        spm_jobman('serial', matlabbatch);
        clear matlabbatch;
        
        %zip the pre_DICOM files
        all_files=[path '\' folders(i).name '\' run_file '\*.IMA'];
        countfile=length(dir(all_files));
        savefile=[path '\'  folders(i).name '\' run_file '\DICOM_file_volume_' num2str(countfile) '.zip'];
        zip(savefile, all_files);
        delete(all_files);
    end
end

%% dicom structure T1
clc;
clear all
spm('defaults', 'FMRI');

path = ['E:\IEChis\SCNU2024\Project00\weixin_fMRIdata'];

folders = dir([path,'\S*']);

for i = 1:31 %length(folders)
        T1_folder = dir([path,'\',folders(i).name,'\T1*']);
        T1_file = T1_folder(2).name;
        INPUTS = spm_select ('FPList',[path '\' folders(i).name '\' T1_file '\'], 'S20.*\.IMA');
        INPUTS= cellstr(INPUTS);
        
        matlabbatch{1}.spm.util.import.dicom.data =INPUTS;
        matlabbatch{1}.spm.util.import.dicom.root = 'series';
        matlabbatch{1}.spm.util.import.dicom.outdir =cellstr([path '\' folders(i).name '\' T1_file '\']);
        matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
        matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
        matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
        
        %clear matlabbatch;
        spm_jobman('serial', matlabbatch);
        clear matlabbatch;
        
        %zip the pre_DICOM files
        all_files=[path '\' folders(i).name '\' T1_file '\*.IMA'];
        countfile=length(dir(all_files));
        savefile=[path '\'  folders(i).name '\' T1_file '\DICOM_file_volume_' num2str(countfile) '.zip'];
        zip(savefile, all_files);
        delete(all_files);
end
