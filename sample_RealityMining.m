% sample the Reality Mining dataset sequence
% Corresponding to: http://realitycommons.media.mit.edu/realitymining.html

% s(u).all_locs: The unique set of towers seen by the subject. (areaID.cellID)
% examples:
% 39402.30213
% 39402.30331
% 39402.30333

% s(n).locs: Time-stamped tower transitions. [date, areaID.cellID] (0 is no signal)

clear all
load realitymining.mat

%% extract cell towers appearing in the Reality Mining dataset sequence with top ranked frequency
top_tower_num = 20;% number of top frequent Cellular Towers wanted 
n = size(s,2);% number of users
towerFreqList = [];% the list of appearing towers
total_len = 0;% sum of all users' sequence length
for u = 1:n
    if (~isempty(s(u).all_locs))
        locs = s(u).all_locs;
        if locs(1) == 0
            locs = locs(2:end);% eliminate the zero cellular signal
        end
        towerFreqList = [towerFreqList,locs'];
        total_len = total_len + length(s(u).locs(:, 2));
    end
end
towerUniqList = unique(towerFreqList);% make the tower list unique
towerUniqList = sort(towerUniqList);% sort in ascending order
% average frequency for each tower value over all users
towerFreq = zeros(size(towerUniqList));% initialize tower frequency vector
for i = 1:length(towerUniqList)
    for u = 1:n
        if (~isempty(s(u).all_locs))
            towerFreq(i) = towerFreq(i) + sum(s(u).locs(:, 2) == towerUniqList(i));
        end
    end
end
towerFreq = towerFreq / total_len;
[towerFreqSorted, towerIndex_sorted_byFreq] = sort(towerFreq, 'descend');
topTowerIndexList = towerIndex_sorted_byFreq(1:top_tower_num);
topTowerList = towerUniqList(topTowerIndexList);
% save the variable topTowerList in subfolder 'RealityMiningSample'
if ~exist('RealityMiningSample', 'dir')
    mkdir('RealityMiningSample');
end
save('RealityMiningSample/topTowerList_Top20.mat','topTowerList');

%% sampling
% For each interested user, only sample the data points with time interval larger than a threshold
% and the sampling points should be in the topTowerList
threshold = 10;% in minitues
user_wholeSeq_sampling = {};
for userIndex = 1:n
    seqSampling = [];
    sampSize = size(s(userIndex).locs,1); %length of the data sequence
    if sampSize == 0
        user_wholeSeq_sampling{end+1} = [];
        continue;
    end
    initialTime = s(userIndex).locs(1,1);
    loopTimes = 0;
    preTime = 0;
    while (loopTimes < sampSize)
        %current time
        if (loopTimes == 0)
            time = initialTime;
        else
            time = s(userIndex).locs(loopTimes + 1,1);
        end
        currentLoc = s(userIndex).locs(loopTimes + 1,2);
        if ((time - preTime >= ((1/24 * (threshold/60))) || preTime == 0) &&...
                (ismember(currentLoc,topTowerList)))
            seqSampling = [seqSampling, currentLoc];
            preTime = time;
        end
        loopTimes = loopTimes + 1;
    end
    user_wholeSeq_sampling{end+1} = seqSampling;
end
% save the variable
save('RealityMiningSample/user_wholeSeq_sampling_topTower20_10mins.mat','user_wholeSeq_sampling');
%{
load ('RealityMiningSample/user_wholeSeq_sampling_topTower20_10mins.mat')
n = 106;
%}

%% truncate the Reality Mining dataset sequence with a specific length
trun_len = 1000;% truncating length
user_wholeSeq_sampling_truncated = {};
valid_user_num = 0;% number of users with sampled sequence length greater or equal to trun_len
unique_loc_num = [];% unique locations for each user sequence
sequence_size = [];
% calculate the unique location numbers
for userIndex = 1:n
    seq = user_wholeSeq_sampling{userIndex};
    seqLen = size(user_wholeSeq_sampling{userIndex}, 2);
    if (seqLen > 0)
        seq_set = [];
        seq_index = 0;
        while (seq_index < seqLen)
            if (~ismember(seq(seq_index+1), seq_set))
                seq_set = [seq_set, seq(seq_index+1)];
            end
            seq_index = seq_index + 1;
        end
        unique_loc_num = [unique_loc_num, size(seq_set, 2)];
        sequence_size = [sequence_size, seqLen];
    else
        unique_loc_num = [unique_loc_num, 0];
        sequence_size = [sequence_size, 0];
    end
end
mean(unique_loc_num)% print the average number of unique sampled locations of the users
mean(sequence_size)% print the average sequence size of the users
% truncate the sequences
for userIndex = 1:n
    seqLen = size(user_wholeSeq_sampling{userIndex}, 2);
    if seqLen < trun_len
        %user_wholeSeq_sampling_truncated{userIndex} = user_wholeSeq_sampling{userIndex};% keep the sequence
        user_wholeSeq_sampling_truncated{userIndex} = [];% drop the sequence
    else
        user_wholeSeq_sampling_truncated{userIndex} = user_wholeSeq_sampling{userIndex}(1:trun_len);
        valid_user_num = valid_user_num + 1;
    end
end
% save the variable
save('RealityMiningSample/user_wholeSeq_sampling_topTower20_10mins_truncated1000_droppedLessThan.mat','user_wholeSeq_sampling_truncated');
