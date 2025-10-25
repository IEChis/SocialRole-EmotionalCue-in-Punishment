clc;
clear all;
spm('defaults', 'FMRI');

path = ['E:\IEChis\SCNU2024\Project00\fMRIdata'];
folders = dir([path,'\S*']);

for i = 2 :length(folders)
    if i==9 || i==17
        continue;
    end
    
    sub_file = folders(i).name;
    run_folder = dir([path, '\', sub_file, '\EP2D_BOLD_TASK1*']); %add"_TASK1",in case some have REST

   %% func folder
    run1_folder = dir([path '\' sub_file '\'   run_folder(1).name '\ep2d*']);
    run1_file = spm_select ('FPList',[path '\' sub_file '\'    run_folder(1).name '\' run1_folder.name], '^f20.*\.nii');
    run1_file = cellstr(run1_file);
    chek_len(i,1) = length(run1_file);
    
    run2_folder = dir([path '\' sub_file '\'   run_folder(2).name '\ep2d*']);
    run2_file = spm_select ('FPList',[path '\' sub_file '\'  run_folder(2).name '\' run2_folder.name], '^f20.*\.nii');
    run2_file = cellstr(run2_file);
    chek_len(i,2) = length(run2_file);
    
    run3_folder = dir([path '\' sub_file '\'   run_folder(3).name '\ep2d*']);
    run3_file = spm_select ('FPList',[path '\' sub_file '\'  run_folder(3).name '\' run3_folder.name], '^f20.*\.nii');
    run3_file = cellstr(run3_file);
    chek_len(i,3) = length(run3_file);
    
    run4_folder = dir([path '\' sub_file '\'   run_folder(4).name '\ep2d*']);
    run4_file = spm_select ('FPList',[path '\' sub_file '\'  run_folder(4).name '\' run4_folder.name], '^f20.*\.nii');
    run4_file = cellstr(run4_file);
    chek_len(i,4) = length(run4_file);

    %% strature folders and t1 file
    T1_folders = dir([path, '\', sub_file,  '\T1*']);
    t1_folder = dir([path '\' sub_file '\'   T1_folders(2).name '\T1w*']);
    
    t1_file = spm_select ('FPList',[path '\' sub_file '\'    T1_folders(2).name '\' t1_folder.name], '^s20.*\.nii');
    t1_file = cellstr(t1_file);
    
 
    %% #1. realign
    %session 1
    matlabbatch{1}.spm.spatial.realignunwarp.data(1).scans = run1_file;
    matlabbatch{1}.spm.spatial.realignunwarp.data(1).pmscan = '';
    %session 2
    matlabbatch{1}.spm.spatial.realignunwarp.data(2).scans = run2_file;
    matlabbatch{1}.spm.spatial.realignunwarp.data(2).pmscan = '';
    %session3
    matlabbatch{1}.spm.spatial.realignunwarp.data(3).scans = run3_file;
    matlabbatch{1}.spm.spatial.realignunwarp.data(3).pmscan = '';
    %session4
    matlabbatch{1}.spm.spatial.realignunwarp.data(4).scans = run4_file;
    matlabbatch{1}.spm.spatial.realignunwarp.data(4).pmscan = '';
  
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
    
    %% #2. segmentation (check path)
    matlabbatch{2}.spm.spatial.preproc.channel.vols =t1_file; % T1_structure iamge
    matlabbatch{2}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{2}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{2}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(1).tpm = {'E:\spm12\tpm\TPM.nii,1'};% (matlab-toolbox-spm12-TPM)
    matlabbatch{2}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{2}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).tpm = {'E:\spm12\tpm\TPM.nii,2'};
    matlabbatch{2}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{2}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).tpm = {'E:\spm12\tpm\TPM.nii,3'};
    matlabbatch{2}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).tpm = {'E:\spm12\tpm\TPM.nii,4'};
    matlabbatch{2}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{2}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).tpm = {'E:\spm12\tpm\TPM.nii,5'};
    matlabbatch{2}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{2}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(6).tpm = {'E:\spm12\tpm\TPM.nii,6'};
    matlabbatch{2}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{2}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{2}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{2}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{2}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{2}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{2}.spm.spatial.preproc.warp.write = [0 1];  %save only forward or [1 1]
    
    %% #3. generating the bias parameters (bu yao gai dong)
    matlabbatch{3}.cfg_basicio.file_dir.cfg_fileparts.files(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
    
    %% #4. generating the biased T1 image (build new brain)
    matlabbatch{4}.spm.util.imcalc.input(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
    matlabbatch{4}.spm.util.imcalc.input(2) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
    matlabbatch{4}.spm.util.imcalc.input(3) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
    matlabbatch{4}.spm.util.imcalc.input(4) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
    matlabbatch{4}.spm.util.imcalc.output = 'Brain';
    matlabbatch{4}.spm.util.imcalc.outdir(1) = cfg_dep('Get Pathnames: Directories (unique)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','up'));
    matlabbatch{4}.spm.util.imcalc.expression = '(i1 + i2 + i3) .* i4';
    matlabbatch{4}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{4}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{4}.spm.util.imcalc.options.mask = 0;
    matlabbatch{4}.spm.util.imcalc.options.interp = 1;
    matlabbatch{4}.spm.util.imcalc.options.dtype = 4;
    
    %% #5. coregisteration. Corrected T1 image as reference, change the functional images 
    %5.1 estimate
    matlabbatch{5}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Image Calculator: Imcalc Computed Image', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{5}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign & Unwarp: Unwarped Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','meanuwr'));
    %(check run)
    matlabbatch{5}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','uwrfiles'));
    matlabbatch{5}.spm.spatial.coreg.estimate.other(2) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','uwrfiles'));
    matlabbatch{5}.spm.spatial.coreg.estimate.other(3) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','uwrfiles'));
    matlabbatch{5}.spm.spatial.coreg.estimate.other(4) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{4}, '.','uwrfiles'));
    
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{5}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    %5.2. write. These files will be used to MVPA analysis.
    %         matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    %         matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    %         matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    %         matlabbatch{5}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
    
    
    %% #6. normalization
    matlabbatch{6}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    % (check run)
    matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','uwrfiles'));
    matlabbatch{6}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','uwrfiles'));
    matlabbatch{6}.spm.spatial.normalise.write.subj.resample(3) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','uwrfiles'));
    matlabbatch{6}.spm.spatial.normalise.write.subj.resample(4) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{4}, '.','uwrfiles'));
  
    matlabbatch{6}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
        90 90 108];
    matlabbatch{6}.spm.spatial.normalise.write.woptions.vox = [2 2 2];  %2 mm cube
    matlabbatch{6}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{6}.spm.spatial.normalise.write.woptions.prefix = 'w';
    
    %% 7. smoothing
    matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{7}.spm.spatial.smooth.fwhm = [6 6 6];% or [8 8 8]
    matlabbatch{7}.spm.spatial.smooth.dtype = 0;
    matlabbatch{7}.spm.spatial.smooth.im = 0;
    matlabbatch{7}.spm.spatial.smooth.prefix = 's6';
    
    
    %% 8. Do the normalization only for corrected T1 image.
    %     matlabbatch{8}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    %     matlabbatch{8}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Image Calculator: Imcalc Computed Image', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    %     matlabbatch{8}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
    %         90 90 108];
    %     matlabbatch{8}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
    %     matlabbatch{8}.spm.spatial.normalise.write.woptions.interp = 4;
    %     matlabbatch{8}.spm.spatial.normalise.write.woptions.prefix = 'w';
    
    %% do the job
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
    sprintf('i = %.0f done',i)
end
xlswrite([path '\Check_run_length6.xls'],chek_len,1);

