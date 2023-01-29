% Test subsampling obfuscation method on dataset sequences
clear all

%% parameters initialization
l = 3;% pattern length
h = 10;% pattern letter maximum distance

%% load the dataset sequence for each user
% load the location set
load('RealityMiningSample/topTowerList_Top20.mat');
r = size(topTowerList, 2);
% load the dataset sequences
load('RealityMiningSample/user_wholeSeq_sampling_topTower20_25mins_truncated1000.mat');
n = size(user_wholeSeq_sampling_truncated,2);
% translate the original data sequence to natural numbers
keySet = topTowerList;
valueSet = 1:r;
M = containers.Map(keySet, valueSet);
user_sequence = {};
user1_search = true;
valid_user_num = 0;% count the number of users whose sequence is not empty
for userIndex = 1:n
    seqLen = size(user_wholeSeq_sampling_truncated{1,userIndex},2);
    if (seqLen > 0)
        if (user1_search)% treat the first valid user as user1
            user1_index = userIndex;
            user1_search = false;
            m = size(user_wholeSeq_sampling_truncated{1,userIndex},2);
        end
        for seq_idx = 1:seqLen
            user_sequence{1,userIndex}(seq_idx) = M(user_wholeSeq_sampling_truncated{1,userIndex}(seq_idx));
        end
        valid_user_num = valid_user_num + 1;
    end
end

percent_subsampling = obfuscation_subsampling(user_sequence, r, n, valid_user_num, l, h, 1e4)