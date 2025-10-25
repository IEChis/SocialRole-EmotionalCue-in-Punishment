clc;
clear all;

path=['F:\IEChis\SCNU2024\Project00\fMRIdata'];  % put this .m file to the folder which stores all subjects' subfolders.
files=dir([path,'\S*']);  %% all subs' folders.

analysis_name={'noST_100s_s6_party_emo_dur0_Rev'};
% contrast_name={'1spp-tpp','2pos-neg','3spp(pos-neg)','4tpp(pos-neg)','5pos(spp-tpp)','6neg(spp-tpp)','7spp(pos-neg)-tpp(pos-neg)','8e_spp-tpp','9e_pos-neg','10e_spp(pos-neg)','11e_tpp(pos-neg)','12e_pos(spp-tpp)','13e_neg(spp-tpp)','14e_spp(pos-neg)-tpp(pos-neg)','15e_fair','16e_unfair-fair','17spp_pos','18spp_neg','19tpp_pos','20tpp_neg','21e_spp_pos','22e_spp_neg','23e_tpp_pos','24e_tpp_neg','25e_unfair'}; %
contrast_name={'1spp(pos-neg)-tpp(pos-neg)','2tpp(pos-neg)-spp(pos-neg)'}; %

%mkdir([path,'\group_analysis\'],analysis_name);
if ~exist([path, '\Group_party_emo_dur0'],'dir')
    mkdir(path,'Group_party_emo_dur0')
end
outpath=[path,'\Group_party_emo_dur0\' analysis_name{1} ]; % the aim folder.
        
for i=1:length(files)
    if i==9 || i==17
        continue;
    end 
    
    filepath=[path,'\',files(i).name,'\' analysis_name{1}]; % contrast files are in "analysis" folder

    confiles=dir([filepath,'\*con*.nii']); % find all the contrast files

    for k=1:length(confiles)

        if ~exist([outpath '\' confiles(k).name(1:end-4) '_' contrast_name{k}],'dir')  %only making the output folders once
            mkdir([outpath '\'],[confiles(k).name(1:end-4) '_' contrast_name{k}]); %making some output folders in the aim folder
        end
        real_input=[filepath '\' confiles(k).name(1:end-4) '.nii' ]; %
        real_output=[outpath '\' [confiles(k).name(1:end-4) '_' contrast_name{k}] '\' [files(i).name '_' confiles(k).name(1:end-4) '.nii']];

        copyfile(real_input, real_output);
    end
  
end

