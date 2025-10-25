function P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name)
P.subject=sub_name;  %% set the subject names
P.directory=sub_path;%% set the path where SPM.mat file is stored for each subject
P.VOI= [mask_path filesep ROI_name]; %[mask_path filesep 'R_insula_from_spmF_0004.img']; %% this need to be changed for different studies
P.Region=ROI_name(1:end-4);  %% this is the base name of the output directory
P.analysis='psy';
P.method='cond';
P.Estimate=1;
P.contrast=0;
P.extract='mean';
P.Tasks={'0','1spp_pos', '2spp_neg','3tpp_pos','4tpp_neg'};
P.Weights=[];
P.CompContrasts=1;
P.Weighted=0;
P.GroupDir=[work_dir filesep 'Group_PPI_' ROI_name(1:end-4)];
P.ConcatR=0;
P.preservevarcorr=0;
P.equalroi=0;
P.FLmask=1;
% %%
% 因为负激活，做反向
P.Contrasts(1).left={'2spp_neg','3tpp_pos'};
P.Contrasts(1).right={'1spp_pos','4tpp_neg'};
P.Contrasts(1).Contrail={'xsn^1','xtp^1','xsp^1','xtn^1'};
P.Contrasts(1).STAT='T';
P.Contrasts(1).Weighted=0;
P.Contrasts(1).MinEvents=1;
P.Contrasts(1).name='spp(pos-neg)-tpp(pos-neg)';


% P.Contrasts(1).left={'1spp_pos','4tpp_neg'};
% P.Contrasts(1).right={'2spp_neg','3tpp_pos'};
% 'spm_spm:beta (0002) - Sn(1) 1spp_posxsp^1*bf(1)'
% 'spm_spm:beta (0004) - Sn(1) 2spp_negxsn^1*bf(1)'
% 'spm_spm:beta (0016) - Sn(2) 3tpp_posxtp^1*bf(1)'
% 'spm_spm:beta (0018) - Sn(2) 4tpp_negxtn^1*bf(1)'
% P.Contrasts(1).Contrail={'xsp^1','xtn^1','xsn^1','xtp^1'};
% P.Contrasts(1).STAT='T';
% P.Contrasts(1).Weighted=0;
% P.Contrasts(1).MinEvents=1;
% P.Contrasts(1).name='spp(pos-neg)-tpp(pos-neg)';

% P.Contrasts(1).left={'1spp_pos'};
% P.Contrasts(1).right={'3tpp_pos'};
% P.Contrasts(1).Contrail={'xsp^1','xtp^1'};
% P.Contrasts(1).STAT='T';
% P.Contrasts(1).Weighted=0;
% P.Contrasts(1).MinEvents=1;
% P.Contrasts(1).name='pos(spp-tpp)';

% P.Contrasts(1).left={'1spp_pos'};
% P.Contrasts(1).right={'2spp_neg'};
% P.Contrasts(1).Contrail={'xsp^1','xsn^1'};
% P.Contrasts(1).STAT='T';
% P.Contrasts(1).Weighted=0;
% P.Contrasts(1).MinEvents=1;
% P.Contrasts(1).name='spp(pos-neg)';

% 
% P.Contrasts(2).left={'1spp_pos'};
% P.Contrasts(2).right={'3tpp_pos'};
% P.Contrasts(2).Contrail={'xsp^1','xtp^1'};
% P.Contrasts(2).STAT='T';
% P.Contrasts(2).Weighted=0;
% P.Contrasts(2).MinEvents=1;
% P.Contrasts(2).name='pos(spp-tpp)';

% % '0','1spp_pos', '2spp_neg','3tpp_pos','4tpp_neg'
% P.Contrasts(1).left={'1spp_pos','3tpp_pos'};
% P.Contrasts(1).right={'2spp_neg','4tpp_neg'};
% P.Contrasts(1).STAT='T';
% P.Contrasts(1).Weighted=0;
% P.Contrasts(1).MinEvents=1;
% P.Contrasts(1).name='e_pos-neg';

% P.Contrasts(1).left={'1spp_pos','2spp_neg'};
% P.Contrasts(1).right={'3tpp_pos','4tpp_neg'};
% P.Contrasts(1).STAT='T';
% P.Contrasts(1).Weighted=0;
% P.Contrasts(1).MinEvents=1;
% P.Contrasts(1).name='e_spp-tpp';

% P.Contrasts(3).left={'1spp_pos'};
% P.Contrasts(3).right={'none'};
% P.Contrasts(3).Contrail={'xsp^1'};
% P.Contrasts(3).STAT='T';
% P.Contrasts(3).Weighted=0;
% P.Contrasts(3).MinEvents=1;
% P.Contrasts(3).name='1spp_pos';
% 
% P.Contrasts(4).left={'2spp_neg'};
% P.Contrasts(4).right={'none'};
% P.Contrasts(4).Contrail={'xsn^1'};
% P.Contrasts(4).STAT='T';
% P.Contrasts(4).Weighted=0;
% P.Contrasts(4).MinEvents=1;
% P.Contrasts(4).name='2spp_neg';
% 
% P.Contrasts(5).left={'3tpp_pos'};
% P.Contrasts(5).right={'none'};
% P.Contrasts(5).Contrail={'xtp^1'};
% P.Contrasts(5).STAT='T';
% P.Contrasts(5).Weighted=0;
% P.Contrasts(5).MinEvents=1;
% P.Contrasts(5).name='3tpp_pos';
% 
% P.Contrasts(6).left={'4tpp_neg'};
% P.Contrasts(6).right={'none'};
% P.Contrasts(6).Contrail={'xtn^1'};
% P.Contrasts(6).STAT='T';
% P.Contrasts(6).Weighted=0;
% P.Contrasts(6).MinEvents=1;
% P.Contrasts(6).name='4tpp_neg';

return;





