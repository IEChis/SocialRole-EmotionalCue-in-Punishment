%function first_level
clc;
clear;
cutoff = 100;%filter (80,100,128,run/3)
analysis_name = 'noST_100s_s6_party_emo_dur0_sepST';
if ~exist('spm.m', 'file')
    error('SPM path error.');
end
spmpath=fileparts(which('spm.m')); % find the pathway of spm.m
addpath([spmpath filesep 'toolbox']);
spm('defaults', 'FMRI');


img_path = 'F:\IEChis\SCNU2024\Project00\fMRIdata';
img_folders = dir([img_path,'\S*']);
tim_file = {'party_emo_dur0_run01.mat','party_emo_dur0_run02.mat','party_emo_dur0_run03.mat','party_emo_dur0_run04.mat'};%model_specify.mat

for sub_num = 1:length(img_folders)
    if sub_num==9 || sub_num==17
        continue;
    end
    
    
    % set output folders and output path
    path = [img_path, '\' img_folders(sub_num).name ];
    if ~exist(path,'dir')
        continue;
    end
    if exist([path '\' analysis_name],'dir')
        rmdir([path '\' analysis_name],'s')
    end

    mkdir(path,analysis_name);
    out_path=[path '\' analysis_name];

    %find the smoothed and normalized data, as well as motion
    %parameters.
    run_folder=dir([path, '\*RUN*']);
    run1_folder=dir([path '\' run_folder(1).name '\*ep2d*']);
    run2_folder=dir([path '\' run_folder(2).name '\*ep2d*']);
    run3_folder=dir([path '\' run_folder(3).name '\*ep2d*']);
    run4_folder=dir([path '\' run_folder(4).name '\*ep2d*']);
    %%
    run1_file=spm_select ('FPList',[path '\' run_folder(1).name '\'  run1_folder(1).name '\'], '^s6wu.*\.nii');
    run1_file= cellstr(run1_file);

    run1_rp=spm_select ('FPList',[path '\' run_folder(1).name '\' run1_folder(1).name '\'], '^rp.*\.txt');%head move
    run1_rp=cellstr(run1_rp);
    %%
    run2_file=spm_select ('FPList',[path '\' run_folder(2).name '\' run2_folder(1).name '\'], '^s6wu.*\.nii');
    run2_file= cellstr(run2_file);

    run2_rp=spm_select ('FPList',[path '\' run_folder(2).name '\' run2_folder(1).name '\'], '^rp.*\.txt');
    run2_rp=cellstr(run2_rp);
    %%
    run3_file=spm_select ('FPList',[path '\' run_folder(3).name '\' run3_folder(1).name '\'], '^s6wu.*\.nii');
    run3_file= cellstr(run3_file);

    run3_rp=spm_select ('FPList',[path '\' run_folder(3).name '\' run3_folder(1).name '\'], '^rp.*\.txt');
    run3_rp=cellstr(run3_rp);

    %%
    run4_file=spm_select ('FPList',[path '\' run_folder(4).name '\' run4_folder(1).name '\'], '^s6wu.*\.nii');
    run4_file= cellstr(run4_file);

    run4_rp=spm_select ('FPList',[path '\' run_folder(4).name '\' run4_folder(1).name '\'], '^rp.*\.txt');
    run4_rp=cellstr(run4_rp);
    %%
    run1_vector=[path '\' run_folder(1).name '\party_emo_dur0_run01.mat'];
    run1_vector=cellstr(run1_vector);
    
    run2_vector=[path '\' run_folder(2).name '\party_emo_dur0_run02.mat'];
    run2_vector=cellstr(run2_vector);
    
    run3_vector=[path '\' run_folder(3).name '\party_emo_dur0_run03.mat'];
    run3_vector=cellstr(run3_vector);
    
    run4_vector=[path '\' run_folder(4).name '\party_emo_dur0_run04.mat'];
    run4_vector=cellstr(run4_vector);

    
    %% prepare contrasts
    
    % TSTS RUN
    if sub_num==1 ||sub_num==2 ||sub_num==3 ||sub_num==8 ||sub_num==9 ||sub_num==10 ||sub_num==11 ||sub_num==16 ||sub_num==17 ||sub_num==18 ||sub_num==19 ||sub_num==24 ||sub_num==25 ||sub_num==26 ||sub_num==27
        con_name=readtable('.\matrix_party_emo_ts_Reverse.csv','Delimiter', ',','ReadVariableNames', true, 'VariableNamingRule', 'preserve');
        con_weight=table2array(con_name(:,2:width(con_name)));
    % STST RUN
    else
        con_name=readtable('.\matrix_party_emo_st_Reverse.csv','Delimiter', ',','ReadVariableNames', true, 'VariableNamingRule', 'preserve');
        con_weight=table2array(con_name(:,2:width(con_name)));
        
    end   


    %% -----------------------------------------------------------------------
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(out_path);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;%TR=1.5(szu)
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;  %since we did not perform slice timing, we kept this to the default
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8; %same as above
    %% run1
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = run1_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi =run1_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = run1_rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = cutoff;
    %% run2
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = run2_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi =run2_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg =run2_rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = cutoff;
    %% run3
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = run3_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi =run3_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg =run3_rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = cutoff;
    %% run4
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = run4_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi =run4_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg =run4_rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = cutoff;  
    %%
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    %% 2. generate the SPM.mat file
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    %% 3. estimate contrasts

    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    for con_len=1:size(con_name,1)
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.name = con_name.con_name{con_len};
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.weights = con_weight(con_len,:);
        matlabbatch{3}.spm.stats.con.consess{con_len}.tcon.sessrep = 'none';
    end
    
    matlabbatch{3}.spm.stats.con.delete = 0;

    %     %% 4. outputs the results.
    %     matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    %     matlabbatch{4}.spm.stats.results.conspec.titlestr = '';
    %     matlabbatch{4}.spm.stats.results.conspec.contrasts = Inf;
    %     matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
    %     matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
    %     matlabbatch{4}.spm.stats.results.conspec.extent = 0;
    %     matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
    %     matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
    %     matlabbatch{4}.spm.stats.results.units = 1;
    %     matlabbatch{4}.spm.stats.results.print = 'ps';
    %     matlabbatch{4}.spm.stats.results.write.none = 1;


    %% do the job
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
    sprintf('sub_num = %.0f done',sub_num)
end


