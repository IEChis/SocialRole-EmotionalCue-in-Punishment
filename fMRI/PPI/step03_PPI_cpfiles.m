%%  This script is used to copy files; From each subject's folder to a  group folder.
rootpath=['F:' filesep 'IEChis' filesep 'SCNU2024' filesep 'Project00' filesep 'fMRIdata'];
path=['F:' filesep 'IEChis' filesep 'SCNU2024' filesep 'Project00' filesep 'fMRIdata'];
outpath=[path filesep 'gPPI'];
folders=dir([rootpath,filesep,'S*']);
outputs=dir([outpath,filesep,'Group_PPI_*6mm*-6_14_24*']);
for i=1:length(folders)
    if i == 9 || i==17
        continue;
    end 
    path2=[rootpath,filesep,folders(i).name,filesep, 'noST_100s_s6_party_emo_dur0_Rev'];
    for j=1:length(outputs)
%         outp2={'spp(pos-neg)-tpp(pos-neg)','pos(spp-tpp)','1spp_pos', '2spp_neg','3tpp_pos','4tpp_neg'};
%         outp2={'spp(pos-neg)'};
            outp2={'spp(pos-neg)-tpp(pos-neg)'};
        for k=1:length(outp2)
            real_input=[path2,filesep,outputs(j).name(7:end),filesep,'con_PPI_' outp2{k} '_' folders(i).name '.img'];% nii
            if i==1
                mkdir([outpath,filesep,outputs(j).name,filesep,outp2{k}]);
            end
            real_output=[outpath,filesep,outputs(j).name,filesep,outp2{k},filesep,'con_PPI_' outp2{k} '_' folders(i).name '.nii'];
            copyfile(real_input,real_output);
        end
    end
end