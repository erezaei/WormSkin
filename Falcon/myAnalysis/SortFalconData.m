function [ActuSensor, fs,interval, Time, Aall, Ball, Call, Dall, Files, isSixteenStep, isFiveStep, isFiveRamp, isStep, isFiveSine, isFifteenStep, isIVStep, isFivePosStep] = SortFalconData(name,stimuli,ephysData, ReadFromSheet)

Filenumber = 1; % wil be used to extract sampling freuqnecy; first file loaded, maybe change (ToDO: check if I did it)
   
Files = 1:length(ephysData.(name).protocols);% load all protocols  

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
  if isempty(ephysData.(name).data{2, i}) == 1 % actuator input
     continue
 else
 D{i} = ephysData.(name).data{2, i}; % actuator SetPoint
  end
end


% find all files with certain protocol name: 
% ifelse statement: if not respective stimuli name (FiveStep or FiveRampHold), then empty array; 
for i = Files(:,1):Files(:,end);
   if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 1;
        continue
   else 
         A{1, i} = []; B{1, i} = []; C{1, i} = []; D{1, i} = [];          
    end      
end


%compare Input Stimuli
isFiveStep = strcmp('FiveStep',stimuli); 
isFiveRamp = strcmp('FiveRampHold',stimuli);
isStep = strcmp('Step',stimuli);
isRamp = strcmp('Ramp-Hold',stimuli);
isFiveSine = strcmp('FiveSine',stimuli);
isFifteenStep = strcmp('FifteenStep',stimuli); 
isIVStep = strcmp('IVStep',stimuli); 
isSixteenStep = strcmp('SixteenStep',stimuli); 
isFivePosStep = strcmp('FivePosStep',stimuli);

% showing in command prompt: AllStimuli = patchmaster Filenumber;
% this helps to identify which "five Block to delete"

AllStimuliBlocks = (find(strcmpi(ephysData.(name).protocols, stimuli)))

if ReadFromSheet == 1;

    % finds meta datasheet, if deleting rec is preassigned
headers = raw(1,:);
FindRowRecording = strcmpi(raw,name); 
[FindRowRecording,col] = find(FindRowRecording,1); % 1 indicates to use only the first row with this name; in metadata sheet replicates of rec name
CellFiveBlock = find(strcmpi(headers, 'FiveBlockRec'));
AllFiveBlockUsed = raw(FindRowRecording,CellFiveBlock);
AllFiveBlockdeleted = [];
CellFiveBlockdeleted = find(strcmpi(headers, 'deletedFiveBlock'));
AllFiveBlockdeleted = raw(FindRowRecording,CellFiveBlockdeleted);
AllFiveBlockdeleted = [AllFiveBlockdeleted{:}] ;


SizeOfDeletedBlocks = size(AllFiveBlockdeleted,2);
if SizeOfDeletedBlocks == 1
display 'only one block deleted'
elseif SizeOfDeletedBlocks > 1
    AllFiveBlockdeleted = str2num(AllFiveBlockdeleted); % creates double, needed for for loop  
end
%end

%AllFiveBlockdeleted = cell2mat(AllFiveBlockdeleted);
% deleting whole blocks of FiveBlockStimuli; Whole block=Filenumber
if isnan(AllFiveBlockdeleted)==1
 display 'NaN value, no block deleted'
else
for i= 1:length(AllFiveBlockdeleted)
    A{1, AllFiveBlockdeleted(i)}  = []; 
    B{1, AllFiveBlockdeleted(i)}  = [];
    C{1, AllFiveBlockdeleted(i)}  = [];
    D{1, AllFiveBlockdeleted(i)}  = []; 
end
end

else
    
while 1
prompt = {'BlockNr (leave empty to quit)'};
dlg_title = 'Delete a block?';
num_lines = 1;
defaultans = {''};
IndValues = inputdlg(prompt,dlg_title,num_lines,defaultans);
FirstValue = str2num(IndValues{1});

if isempty(FirstValue) == 1 
     break
 else
    A{1, FirstValue}  = []; 
    B{1, FirstValue}  = [];
    C{1, FirstValue}  = [];
    D{1, FirstValue}  = []; 
 end
end

end

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
ENDTime = length(Aall)/fs; %%% don't remember why I complicated it
Time = (0:interval:ENDTime-interval)'; 

ActuSensor = [];
for i = 1:size(Ball,2),
ActuSensor(:,i) = Ball(:,i)*1.5; % 1.5 = sensitivity of P-841.10 from Physik Instrumente; travel distance 15 um; within 10 V; ToDo: measure real sensitivity
end


end