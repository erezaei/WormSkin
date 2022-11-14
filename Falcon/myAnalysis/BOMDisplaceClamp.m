%%% Sylvia Fechner (Ehsan's updates)
%%% Stanford University, 
%%% 20151115
%%% Update: 20210625
%%% Script to analyze data from FALCON in Displacement Clamp
%%% you need to install SigTOOl for importData function

%%% ToDo signs indicate work in progress 
%%% Currently, automatically saved data are saved in the same folder
%%% write into csv file: mac can't write to excel !! 
    % --> which values?
    % how to write each Indentation as col header??? in excel and csv

%%  load dat.files 
clear; close all; clc;
ephysData=ImportPatchData(); % Import Patch Data function written by Sammy Katta to load dat.files 
%%
% load notes to get several values automatically needed for the conversion of the signals
loadFileMode = 1; % change here, if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('/Users/erezaei/Desktop/SU-Research/Falcon_Local/Julu-Aug-2021/20210702-EHR-notes.xlsx'); % be careful in which Folder saved.
end

%% Analysis Individual Recording 
close all; clc
TF = isfield(ephysData,'zz');
if TF==1
   ephysData = rmfield(ephysData,'zz') 
end

TF1 = isfield(ephysData,'ZZZ');
if TF1==1
   ephysData = rmfield(ephysData,'ZZZ') 
end

TF2 = isfield(ephysData,'ZZZZ');
if TF2==1
   ephysData = rmfield(ephysData,'ZZZZ') 
end

TF3 = isfield(ephysData,'E11');
if TF3==1
   ephysData = rmfield(ephysData,'E11') 
end
TF4 = isfield(ephysData,'zz1');
if TF4==1
   ephysData = rmfield(ephysData,'zz1') 
end
TF5 = isfield(ephysData,'CB128H16');
if TF5==1
   ephysData = rmfield(ephysData,'CB128H16') 
end
Num_Worm=length(fieldnames(ephysData));
fields = fieldnames(ephysData);
FilNam=extractBefore(string(fields(1)),'0');
for jj=1:Num_Worm
%%% hardcoding part:
name = string(fields(jj)); % name of recording. placed into varaibel fiels names%

%name = 'EHR-003'; % name of recording. placed into varaibel fiels names%
stimuli = 'FiveStep'; % protocol names: FiveStep or Fifteen Steps (Fifteen Steps does nor work yet!)
%%%%%

Filenumber = 1; % wil be used to extract sampling freuqnecy; first file loaded, maybe change (ToDO: check if I did it)


Files = 1:length(ephysData.(name).protocols);% load all protocols  

% load all data from all protocols 
% load Current, Actuator Sensor, And Cantilver Signal of each step%
% if else statement included to also load protocols which don't have
% ForceClamp data; not necessary for Current
A=[];B=[]; C=[];D=[];   % to get an empty array, if I analyzed different files before
for i = Files(:,1):Files(:,end);
A{i} = ephysData.(name).data{1, i}; %Current
if isempty(ephysData.(name).data{3, i}) == 1
    continue
 else
B{i} = ephysData.(name).data{3, i}; % actuator Sensor
end
 if isempty(ephysData.(name).data{4, i}) ==1
    continue
 else
 C{i} = ephysData.(name).data{4, i}; % Cantilever Signal
 end
  if isempty(ephysData.(name).data{2, i}) == 1 
     continue
 else
 D{i} = ephysData.(name).data{2, i}; % actuator SetPoint
  end
end


% find all files with certain protocol name: 
% ifelse statement: if not respective stimuli name (FiveStep or FiveRampHold), then empty array; 
for i = Files(:,1):Files(:,end)
   if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 1
        continue
   else 
         A{1, i} = []; B{1, i} = []; C{1, i} = []; D{1, i} = [];          
    end      
end


%compare Input Stimuli
isFiveStep = strcmp('FiveStep',stimuli); 
isFiveRamp = strcmp('FiveRampHold',stimuli);
isFifteenStep = strcmp('FifteenStep',stimuli); 


% showing in command prompt: AllStimuli = patchmaster Filenumber; number
% needed to enter in command prompt window to delete a whole block for the
% analysis

AllStimuliBlocks = (find(strcmpi(ephysData.(name).protocols, stimuli)));


% deleting whole blocks of FiveBlockStimuli; Whole block=Filenumber
% while 1
% prompt = {'Enter BlockNr (leave empty to quit) (leave empty in initial analysis round; rerun after plotting the figures)'};
% dlg_title = 'Delete a block?';
% num_lines = 1;
% defaultans = {''};
% IndValues = inputdlg(prompt,dlg_title,num_lines,defaultans);
% FirstValue = str2num(IndValues{1});
% 
% if isempty(FirstValue) == 1 
%      break
%  else
%     A{1, FirstValue}  = []; 
%     B{1, FirstValue}  = [];
%     C{1, FirstValue}  = [];
%     D{1, FirstValue}  = []; 
%  end
% end

% removes all empty cells from the cell array
AShort = A(~cellfun('isempty',A)); BShort = B(~cellfun('isempty',B)); CShort = C(~cellfun('isempty',C)); DShort = D(~cellfun('isempty',D));

% concatenating all stimuli
Aall = []; Aall = cat(2,AShort{:}); 
Ball = []; Ball = cat(2,BShort{:}); 
Call = []; Call = cat(2,CShort{:});
Dall = []; Dall = cat(2,DShort{:});

% calculate sampling frequency
fs = ephysData.(name).samplingFreq{1, Files(:,AllStimuliBlocks(1))}; % sampling frequency from first Stimuli loaded; 
interval = 1/fs;   %%% get time interval to display x axis in seconds 
ENDTime = length(Aall)/fs; %%%
Time = (0:interval:ENDTime-interval)'; 


ActuSensor = [];
for i = 1:size(Ball,2),
ActuSensor(:,i) = Ball(:,i)*1.5; % 1.5 = sensitivity of P-841.10 from Physik Instrumente; travel distance 15 um; within 10 V; ToDo: measure real sensitivity
end


%%%%%% ForceClampSignals %%%%%%%

% to get Deflection of Cantilever: multiply with Sensitivity 
% get Sensitivity from Notes Day of Recording  
FindRowStiff = strcmpi(raw,name); % name = recorded cell
[Stiffrow,col] = find(FindRowStiff,1); % Siffrow: row correasponding to recorded cell

headers = raw(1,:);
ind = find(strcmpi(headers, 'Sensitivity(um/V)')); % find col with Sensitivity
Sensitivity = raw(Stiffrow,ind); 
Sensitivity = cell2mat(Sensitivity);

indStiffness = find(strcmpi(headers, 'Stiffness (N/m)'));
Stiffness = raw(Stiffrow,indStiffness); 
Stiffness = cell2mat(Stiffness);
 

[Start,ActuSetPointZero,CantiDefl,Indentation,MeanIndentation,Force,MeanForce,normCantiDefl,allRiseTime,allOvershoot] = AnalyzeForceClampBOM(interval,ActuSensor,isFiveStep,isFifteenStep,Ball,Call,Dall,Sensitivity,Stiffness,fs);

%MeanForce = MeanForce';
%MeanIndentation = MeanIndentation';

%%%calculate Stiffness

MeanIndentationVer = MeanIndentation';
MeanForceVer = MeanForce';

StiffnessWorm = MeanIndentationVer\MeanForceVer % is doing a leastsquarefit



WormStiff(jj,1)=StiffnessWorm;
ForcInd((1+45*(jj-1)):(45*jj),1)=MeanIndentationVer(1:45);
ForcInd((1+45*(jj-1)):(45*jj),2)=MeanForceVer(1:45);




%% now figures to check if recording okay, if not, run previous part again to delete a block of stimuli
close all
xScatter = (1:length(MeanIndentation));
%LengthInmsForPlot = LengthInms*1000;

%%%cantilever signals %%%%

% figure()
% for i = 1:size(Ball,2)
% subplot(ceil(size(Ball,2)/5),5,i)
% plot(Time,CantiDefl(:,i))
% %ylim([-5*10^-11 1*10^-11])
% %RecNum = i; % include number of i within legend or title to easier
% %determine the position of the plot
% title(round(MeanIndentation(i),1)) %% 
% ylabel('µm')
% end
% suptitle({'Cantilever Deflection (corrected with Sensitivity of Cantilever)';'Bold numbers: Indentation in µm'}) 


%%%normalized cantilever signals %%%%
% figure()
% for i = 1:size(Ball,2)
% subplot(ceil(size(Ball,2)/5),5,i)
% plot(Time,ActuSensor(:,i))
% ylim([-1 16])
% %ylim([-5*10^-11 1*10^-11])
% %RecNum = i; % include number of i within legend or title to easier
% %determine the position of the plot
% title(round(MeanIndentation(i),1)) %% 
% ylabel('µm')
% end
% suptitle({'Actuator Sensor (corrected with sensitivity of P-841.10 (1.5))';'Bold numbers: Indentation in µm'}) 

%%%normalized cantilever signals %%%%
% figure()
% for i = 1:size(Ball,2)
% subplot(ceil(size(Ball,2)/5),5,i)
% plot(Time,Indentation(:,i))
% ylim([-1 16])
% %ylim([-5*10^-11 1*10^-11])
% %RecNum = i; % include number of i within legend or title to easier
% %determine the position of the plot
% title(round(MeanIndentation(i),1)) %% 
% ylabel('µm')
% end
% suptitle({'Indentation: Actuator Sensor - Cantilever Signal (Zero for Sensitivity Check on glass)';'Bold numbers: Indentation in µm'}) 



%%% plotting ForceClamp signals in a subplot
allRiseTimeInms = allRiseTime*1000;

figure()
subplot(3,3,1)
plot(Time,CantiDefl)
%xlim([0 0.6])
xlabel('Time (s)')
title('Cantilever Deflection')
ylabel('Deflection (µm)')
hold on
subplot(3,3,2)
plot(Time,Indentation)
%xlim([0 0.6])
xlabel('Time (s)')
ylabel('Indentation (µm)')
title('Indentation')
hold on
subplot(3,3,3)
plot(Time,Force)
%xlim([0 0.6])
xlabel('Time (s)')
ylabel('Force (µN)')
title('Force')
hold on
subplot(3,3,4)
plot(Time,ActuSetPointZero)
%xlim([0 0.6])
xlabel('Time (s)')
ylabel('Displacement (µm)')
title('Displacement ActuSetPoint')
hold on
subplot(3,3,5)
plot(Time,ActuSensor)
%xlim([0 0.6])
xlabel('Time (s)')
ylabel('Displacement (µm)')
title('Displacement ActuSensor')
hold on
subplot(3,3,6)
plot(Time,normCantiDefl)
%xlim([0 0.6])
xlabel('Time (s)')
ylabel('normalized Deflection')
title('Cantilever Defl norm')
hold on
subplot(3,3,7)
scatter(MeanIndentation, allRiseTimeInms)  
%xlim([0 0.3])
title('RiseTime (CantiDefl) (0.63%)')
ylabel('Rise Time Tau (ms)')
xlabel('Indentation')
%xlim([0 max(MeanIndentation)+1])
 hold on
 subplot(3,3,8)
 scatter(MeanIndentation, allOvershoot)  
 %xlim([0 max(MeanIndentation)+1])
 ylabel('% to steady state')
 xlabel('Indentation (µm)')
 title('Overshoot (CantiDefl)')
hold on 
subplot(3,3,9)
plot(MeanIndentation, MeanForce, '.', MeanIndentation, StiffnessWorm*MeanIndentation,'LineWidth',2, 'MarkerSize',10)
legend({'Data','FitStiffness'},'FontSize',8)
title(StiffnessWorm)
ylabel('Force (µN)')
xlabel('Indentation (µm)')
suptitle({'ForceClampSignals'}) 


%% Export Data

%rToDo: %how to write each Indentation as col header???

ExportMeanDataMechanics = [MeanIndentationVer,MeanForceVer];
%ExportTracesInd = [MeanIndentationVer,MeanForceVer];

%%% write Matlabvariables
if isFiveStep == 1 
save(sprintf('FiveStep-%s.mat',name)); %save(sprintf('%sTEST.mat',name))
else 
disp 'change for FifteenStep'
end

%%% write as csv, because cannot write with mac to excel

%save single Indentation values in separate csv file
filename = sprintf('IndAndForceValues-%s.csv',name) ;
fid = fopen(filename, 'w');
fprintf(fid, 'Ind-%s, Force-%s \n',name,name); %, MergeInd,MeanSameIndCurrent, asdasd, ..\n); %\n means start a new line
fclose(fid);
dlmwrite(filename, ExportMeanDataMechanics, '-append', 'delimiter', '\t'); %Use '\t' to produce tab-delimited files.


filename = sprintf('TracesIndentation-%s.csv',name) ;
%fid = fopen(filename, 'w');
%fprintf(fid,'Ind1, Ind2, Ind3, Ind4, Ind5, Ind6, Ind7, Ind8, Ind9,Ind10,Ind11,Ind12,Ind13,Ind14 \n'); %, MergeInd,MeanSameIndCurrent, asdasd, ..\n); %\n means start a new line
%fclose(fid);
dlmwrite(filename, Indentation, '-append', 'delimiter', '\t'); %Use '\t' to produce tab-delimited files.

filename = sprintf('TracesForce-%s.csv',name) ;
%fid = fopen(filename, 'w');
%fprintf(fid,'Ind1, Ind2, Ind3, Ind4, Ind5, Ind6, Ind7, Ind8, Ind9,Ind10,Ind11,Ind12,Ind13,Ind14 \n'); %, MergeInd,MeanSameIndCurrent, asdasd, ..\n); %\n means start a new line
%fclose(fid);
dlmwrite(filename, Force, '-append', 'delimiter', '\t'); %Use '\t' to produce tab-delimited files.

end

WStif = array2table(WormStiff);
WStif.Properties.VariableNames(1:1) = {sprintf('%s',FilNam)};
writetable(WStif,'WormStif_200mM.xls','Sheet',1,'Range','G123')

WforcInd = array2table(ForcInd);
WforcInd.Properties.VariableNames(1:2) = {sprintf('Ind%s',FilNam),sprintf('Forc%s',FilNam)};
writetable(WforcInd,'Forc_Ind.xls','Sheet',1,'Range','AE1:AF1500')

