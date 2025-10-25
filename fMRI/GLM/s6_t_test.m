%second level
clc;
clear all;

spm('defaults', 'FMRI');
basedir=['F:\IEChis\SCNU2024\Project00\fMRIdata'];  % put this .m file to the folder which stores all subjects' subfolders.

% path=[basedir,'\First_group\noST_100s_tpp'];
path=[basedir,'\Group_party_emo_dur0\noST_100s_s6_party_emo_dur0_Rev'];

folders=dir([path,'\*con_*']);

for i=1:length(folders)
    
    %% outpath
    con_path=[path ,'\', folders(i).name];
    if exist([con_path,'\Second_level_s6_party_emo_dur0'],'dir')
        
        
        
        rmdir([con_path,'\Second_level_s6_party_emo_dur0'],'s'); % remove older "group" folders
    end
    mkdir(con_path,'Second_level_s6_party_emo_dur0');%make a folder named group£¬to save the result of second level
    out_path=[con_path, '\Second_level_s6_party_emo_dur0'];
    
    %% con images 
    con_file=spm_select ('FPList',[con_path '\'], '.*con.*\.nii');
    con_file= cellstr(con_file);
    
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

