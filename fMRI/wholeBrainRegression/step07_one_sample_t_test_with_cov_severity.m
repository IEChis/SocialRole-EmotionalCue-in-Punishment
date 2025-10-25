%% 被试内设计的covariate分析
% filename = 'IndPars_m2c_emoparty_both.csv';
filename = "F:\IEChis\SCNU2024\Project00\SPP_TPP_emotion_fMRI\Behavior\Modeling_Rstan\IndPars_m2c_emoparty_both_Final_12916.csv";

opts = detectImportOptions(filename);
opts.SelectedVariableNames = setdiff(opts.VariableNames, 'lambda');
para_data = readtable(filename, opts);
para_data = sortrows(para_data, 'subjid');

% %% to z-score
% alpha_cols = contains(para_data.Properties.VariableNames, 'alpha_');
% kappa_cols = contains(para_data.Properties.VariableNames, 'kappa_');
% 
% para_data{:, alpha_cols} = zscore(para_data{:, alpha_cols});
% para_data{:, kappa_cols} = zscore(para_data{:, kappa_cols});


%%
con_name = {'1spp-tpp', '2pos-neg', '3spp(pos-neg)', '4tpp(pos-neg)','5pos(spp-tpp)', '6neg(spp-tpp)', ...
           '7spp(pos-neg)-tpp(pos-neg)', '8e_spp-tpp', '9e_pos-neg'};

mydata = struct();

for i = 1:length(con_name)
    current_con = con_name{i};
    valid_name = matlab.lang.makeValidName(['con_', current_con]);
    mydata.(valid_name).original_name = current_con;
    
    switch current_con
        case '1spp-tpp'
            % alpha_ps - alpha_pt + alpha_ns - alpha_nt
            result = para_data.alpha_ps - para_data.alpha_pt + ...
                     para_data.alpha_ns - para_data.alpha_nt;
            
        case '2pos-neg'
            result = para_data.alpha_ps + para_data.alpha_pt - ...
                     para_data.alpha_ns - para_data.alpha_nt;
                 
        case '3spp(pos-neg)'    
            result = para_data.alpha_ps - para_data.alpha_ns;
        
        case '4tpp(pos-neg)'    
            result = para_data.alpha_pt - para_data.alpha_nt;    
            
        case '5pos(spp-tpp)'
            result = para_data.alpha_ps - para_data.alpha_pt;
         
        case '6neg(spp-tpp)'
            result = para_data.alpha_ns - para_data.alpha_nt;
                        
        case '7spp(pos-neg)-tpp(pos-neg)'
            result = para_data.alpha_ps - para_data.alpha_pt - ...
                     para_data.alpha_ns + para_data.alpha_nt;
                        
        case '8e_spp-tpp' 
            result = para_data.kappa_ps - para_data.kappa_pt + ...
                     para_data.kappa_ns - para_data.kappa_nt;
            
        case '9e_pos-neg' 
            result = para_data.kappa_ps + para_data.kappa_pt - ...
                     para_data.kappa_ns - para_data.kappa_nt;
    end

    mydata.(valid_name).subjid = para_data.subjid; 
    mydata.(valid_name).result = result;         
                         
end




    %% step03: preparing fMRI data
spm('defaults', 'FMRI');
root_path='F:\IEChis\SCNU2024\Project00\fMRIdata\Group_party_emo_dur0\noST_100s_s6_party_emo_dur0';
con_path=dir(fullfile(root_path,'con*'));
con_cnt=1;
for i=1:9
%     1spp-tpp,2pos-neg,3spp(pos-neg),4tpp(pos-neg)
%     5pos(spp-tpp),6neg(spp-tpp),7spp(pos-neg)-tpp(pos-neg)
%     8e_spp-tpp,9e_pos-neg
%     if i==3||i==4
%         continue;
%     end
    img_path=fullfile(root_path,con_path(i).name);
    con_file=spm_select ('FPList',[img_path,filesep], '.*S1.*\.nii');
    con_file=cellstr(con_file);
    output_folder = ['Group_cov_para12916_', con_name{con_cnt}];
    mkdir(img_path,output_folder);
    output_path=fullfile(img_path,output_folder);
    
    current_con = con_name{con_cnt};  % 获取第 con_cnt 个情况的原始名称
    valid_field_name = matlab.lang.makeValidName(['con_', current_con]);  % 转
    fa_cov_used = mydata.(valid_field_name).result;
    
    
    matlabbatch{1}.spm.stats.factorial_design.dir =cellstr(output_path);
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_file;
    matlabbatch{1}.spm.stats.factorial_design.cov.c = fa_cov_used;% needs change
    matlabbatch{1}.spm.stats.factorial_design.cov.cname = con_name{con_cnt};
    matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;

    % matlabbatch{1}.spm.stats.factorial_design.cov(2).c = lo_cov_used;
    % matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'lo_vname';
    % matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
    % matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;

    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = con_name{con_cnt};
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
    
    

    con_cnt=con_cnt+1;
end    


