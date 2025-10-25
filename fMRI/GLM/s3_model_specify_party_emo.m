%% model_specify [party,emo]
clc;
clear all;
basedir = 'F:\IEChis\SCNU2024\Project00\SPP_TPP_emotion_fMRI\Behavior\raw_data';

%set input path
inpath = basedir;
file_list = dir(fullfile(inpath, '2nd*.txt'));

%set output path
outdir = 'F:\IEChis\SCNU2024\Project00\fMRIdata';
folders = dir([outdir,'\S*']);

% sort input files to correspond with output folders
subs = zeros(size(file_list));
for i = 1:numel(file_list)
   Region = strsplit(file_list(i).name,'_');
   subs(i) = str2double(Region{5});
end
[~, idx] = sort(subs);
file_list_sorted = file_list(idx); %final file we read

%% 
for sub_num = 1:length(file_list_sorted)
    
    %-------------------------------------------
    % Onsets of each condition for each run
    %-------------------------------------------
    
    % convert formats
    file = textread([inpath '\' file_list_sorted(sub_num).name],'%s');
    [m,n] = size(file);
    nData = reshape(file,23,m*n/23);
    nData = nData';

    nData = nData(2:end,3:end);

    [m,n] = size(nData);
    fileData = zeros(m,n);
    for j = 1:m
       for k = 1:n
           fileData(j,k) = str2double(nData{j,k});
       end
    end
    Data = fileData;
    
    eve_type1 = {'1spp_pos','2spp_neg','5res_sp','6res_sn','9fair','10res_fair'};
    eve_type2 = {'3tpp_pos','4tpp_neg','7res_tp','8res_tn','9fair','10res_fair'}; 
    %%
    %TSTS run
    if sub_num==1 ||sub_num==2 ||sub_num==3 ||sub_num==8 ||sub_num==9 ||sub_num==10 ||sub_num==11 ||sub_num==16 ||sub_num==17 ||sub_num==18 ||sub_num==19 ||sub_num==24 ||sub_num==25 ||sub_num==26 ||sub_num==27
                
        for run = 1:4
            if mod(run,2)==0    %run2,4=>2 stand for SPP
               % parameters
               onset=[];
               dur=[];
               for typ_num = 1:6
                   if typ_num == 1 
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),12); % spp,pos,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'sp';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),9)-Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),8);
                   elseif typ_num == 2
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),12);%spp,neg
                       dur = 4;
                       pname = 'sn';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),9)-Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),8);
                   elseif typ_num == 3 % dec
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 4
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 5
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 1),12); % spp,fair,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'none';
                       pv1 = 'none';
                   else
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 1),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   end

                   % try duration=0
                   dur=0;
                   
                   names{typ_num} = eve_type1{typ_num};
                   onsets{typ_num} = onset;
                   durations{typ_num} = dur;
                   pmod(typ_num).name{1} = pname;
                   pmod(typ_num).param{1} = pv1;
                   pmod(typ_num).poly{1} = 1;
        
               end

                
            else                %run1,3=>3 stand for TPP
               % parameters
               onset=[];
               dur=[];
               for typ_num = 1:6
                   if typ_num == 1 
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),12); % tpp,pos,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'tp';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),9)-Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),8);
                   elseif typ_num == 2
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),12);%tpp,neg
                       dur = 4;
                       pname = 'tn';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),9)-Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),8);
                   elseif typ_num == 3 % dec
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 4
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   
                   elseif typ_num == 5
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 1),12); % spp,fair,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'none';
                       pv1 = 'none';
                   else
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 1),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   end

                   % try duration=0
                   dur=0;
                   
                   names{typ_num} = eve_type2{typ_num};
                   onsets{typ_num} = onset;
                   durations{typ_num} = dur;
                   pmod(typ_num).name{1} = pname;
                   pmod(typ_num).param{1} = pv1;
                   pmod(typ_num).poly{1} = 1;
        
               end

            
            end
            %% save conditions.mat conditions;
            outpath = [outdir, '\' folders(sub_num).name];

            run_paths = dir([outpath,'\*RUN*']);
            run1_path = [outpath,'\' run_paths(1).name];
            run2_path = [outpath,'\' run_paths(2).name];
            run3_path = [outpath,'\' run_paths(3).name];
            run4_path = [outpath,'\' run_paths(4).name];

            out_name=['Diff_party_emo_dur0_run0' num2str(run)];%no consider nas

            if run == 1
               save([run1_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 2
               save([run2_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 3
               save([run3_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 4
               save([run4_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            end
        end
    
    %STST run
    else 
        for run = 1:4
            if mod(run,2)~=0    %run1,3=>2 stand for SPP
               % parameters
               onset=[];
               dur=[];
               for typ_num = 1:6
                   if typ_num == 1 
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),12); % spp,pos,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'sp';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),9)-Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),8);
                   elseif typ_num == 2
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),12);%spp,neg
                       dur = 4;
                       pname = 'sn';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),9)-Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),8);
                   elseif typ_num == 3 % dec
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 4
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 5
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 1),12); % spp,fair,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'none';
                       pv1 = 'none';
                   else
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 1),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   end
                   
                   % try duration=0
                   dur=0;

                   names{typ_num} = eve_type1{typ_num};
                   onsets{typ_num} = onset;
                   durations{typ_num} = dur;
                   pmod(typ_num).name{1} = pname;
                   pmod(typ_num).param{1} = pv1;
                   pmod(typ_num).poly{1} = 1;
        
               end

                
            else                %run2,4=>3 stand for TPP
               % parameters
               onset=[];
               dur=[];
               for typ_num = 1:6
                   if typ_num == 1 
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),12); % spp,pos,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'tp';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),9)-Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),8);
                   elseif typ_num == 2
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),12);%spp,neg
                       dur = 4;
                       pname = 'tn';
                       pv1 = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),9)-Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),8);
                   elseif typ_num == 3 % dec
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 4
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   elseif typ_num == 5
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 1),12); % spp,fair,run,[find col12(ons_offers)]; 
                       dur = 4; %duration
                       pname = 'none';
                       pv1 = 'none';
                   else
                       onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 1),13);
                       dur = 3;
                       pname = 'none';
                       pv1 = 'none';
                   end
                   
                   % try duration=0
                   dur=0;

                   names{typ_num} = eve_type2{typ_num};
                   onsets{typ_num} = onset;
                   durations{typ_num} = dur;
                   pmod(typ_num).name{1} = pname;
                   pmod(typ_num).param{1} = pv1;
                   pmod(typ_num).poly{1} = 1;
        
               end

            
            end
            %% save conditions.mat conditions;
            outpath = [outdir, '\' folders(sub_num).name];

            run_paths = dir([outpath,'\*RUN*']);
            run1_path = [outpath,'\' run_paths(1).name];
            run2_path = [outpath,'\' run_paths(2).name];
            run3_path = [outpath,'\' run_paths(3).name];
            run4_path = [outpath,'\' run_paths(4).name];

            out_name=['Diff_party_emo_dur0_run0' num2str(run)];%no consider nas

            if run == 1
               save([run1_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 2
               save([run2_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 3
               save([run3_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            elseif run == 4
               save([run4_path '\' out_name], 'names', 'onsets', 'durations','pmod');
            end
        end
    
    end    
    
%% mine above     

%     
%     for run = 1:4 
%         
%         eve_type = {'01spp_pos', '02spp_neg', '03tpp_pos','04tpp_neg','05res_sp','06res_sn','07res_tp','08res_tn'}; 
%      
%        %% load txt file
%        
%        % sort input files to correspond with output folders
%        subs = zeros(size(file_list));
%        for i = 1:numel(file_list)
%            Region = strsplit(file_list(i).name,'_');
%            subs(i) = str2double(Region{5});
%        end
%        [~, idx] = sort(subs);
%        file_list_sorted = file_list(idx); %final file we read
%        
%        % convert formats
%        file = textread([inpath '\' file_list_sorted(sub_num).name],'%s');
%        [m,n] = size(file);
%        nData = reshape(file,23,m*n/23);
%        nData = nData';
%        
%        nData = nData(2:end,3:end);
%        
%        [m,n] = size(nData);
%        fileData = zeros(m,n);
%        for j = 1:m
%            for k = 1:n
%                fileData(j,k) = str2double(nData{j,k});
%            end
%        end
%        
%        rows_to_delete = find(fileData(:, 8) == 10);  % only unfair condition aligned with behav analysis
%        fileData(rows_to_delete, :) = []; 
%        
%        Data=fileData;
%     
% %        NAS = find(Data(:,10)~=0);%
% %        Data = Data(NAS,:);%
%        %% parameters for each run
%        
%        for typ_num = 1:8 % 4level + 4response
% 
%            if typ_num == 1 
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),12); % spp,pos,run,[find col12(ons_offers)]; 
%                dur = 4; %duration
%            elseif typ_num == 2
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),12);%spp,neg
%                dur = 4;
%            elseif typ_num == 3
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),12);%tpp,pos
%                dur = 4;
%            elseif typ_num == 4
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),12);%tpp,neg
%                dur = 4;
%            elseif typ_num == 5 % dec
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 2),13);
%                dur = 3;
%            elseif typ_num == 6
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 2 & Data(:,19) == 3),13);
%                dur = 3;
%            elseif typ_num == 7
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 2),13);
%                dur = 3;    
%            elseif typ_num == 8 
%                onset = Data(find(Data(:,4)==run & Data(:,21) == 3 & Data(:,19) == 3),13);
%                dur = 3;
%            end
%            
%            
%            names{typ_num} = eve_type{typ_num};
%            onsets{typ_num} = onset;
%            durations{typ_num} = dur;
%            pmod(typ_num).name{1} = 'none'
%            pmod(typ_num).param{1} = 0;
%            pmod(typ_num).poly{1} = 1;
%            
%            onset=[];
%            dur=[];
%        end
%        
%        
%        %% save conditions.mat conditions;
%        outpath = [outdir, '\' folders(sub_num).name];
%        
%        run_paths = dir([outpath,'\*RUN*']);
%        run1_path = [outpath,'\' run_paths(1).name];
%        run2_path = [outpath,'\' run_paths(2).name];
%        run3_path = [outpath,'\' run_paths(3).name];
%        run4_path = [outpath,'\' run_paths(4).name];
%        
%        out_name=['party_emo_dur0_run0' num2str(run)];%no consider nas
%        
%        if run == 1
%            save([run1_path '\' out_name], 'names', 'onsets', 'durations','pmod');
%        elseif run == 2
%            save([run2_path '\' out_name], 'names', 'onsets', 'durations','pmod');
%        elseif run == 3
%            save([run3_path '\' out_name], 'names', 'onsets', 'durations','pmod');
%        elseif run == 4
%            save([run4_path '\' out_name], 'names', 'onsets', 'durations','pmod');
%        end
%         
%     end
end
