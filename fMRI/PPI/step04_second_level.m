clear;
spm('defaults', 'FMRI');

% task_folder={'task01_UG_112TRs','task02_SC_240TRs','task03_RL_144TRs','task04_CC_100TRs','task05_WM_88TRs'};
% task_folder=dir(['D:\fMRI_data_XL\fMRI_data\noslice\group\analysis_noST_6mm_128s\task0*']);%�ҵ�first level��������ļ���
% for con=3 %1:length(task_folder)
root_path='F:\IEChis\SCNU2024\Project00\fMRIdata\Group_party_emo_dur0\gPPI';  % put this .m file to the folder which stores all subjects' subfolders.%��������������������

roi_folders=dir(fullfile(root_path,'Group_PPI_*6mm*-6_14_24*'));

for j =1 : length(roi_folders)
    folders=dir(fullfile(root_path,roi_folders(j).name));
    folders=folders([folders.isdir]);
    folders=folders(~ismember({folders.name}, {'.', '..'}));
    
    path=fullfile(root_path,roi_folders(j).name);


    for i=length(folders):length(folders)

        %% outpath
        con_path=[path ,'\', folders(i).name];
        if exist([con_path,'\group'],'dir')
            rmdir([con_path,'\group'],'s'); % remove older "group" folders
        end
        mkdir(con_path,'group');%�
        out_path=[con_path, '\group'];

        %% con images �
        con_file=spm_select ('FPList',[con_path '\'], '.*con.*\.nii');
        con_file= cellstr(con_file);
    %     chek_len(i,con)=length(con_file);

        %%  set up the model-----------------------------------------------------------------------
        matlabbatch{1}.spm.stats.factorial_design.dir =cellstr(out_path);
        %
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_file;
        %
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


        %% 2. estimate the model
        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


        %% 3. estimate contrasts

        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = 1;
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 0;

        %% do the job

        spm_jobman('serial', matlabbatch);
        clear matlabbatch;

    end
  
    
    
end  



% end

% xlswrite([pwd '\Check_con_file_length.xls'],chek_len,1);
