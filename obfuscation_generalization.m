function [percentage_avg] = obfuscation_generalization(user_sequence, r, group_size, n, valid_user_num, l, h, iteration)
% Executing generalization obfuscation

% user_sequence: user sequence dataset
% r: letter size
% group_size: resolution
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% l: pattern length
% h: pattern letter maximum distance
% iteration: number of iterations

percentage_vec = [];
for iter = 1:iteration
    user1_pattern = randi([1,r],1,l);
    user1_pattern = ceil(user1_pattern / group_size);% generalization
    user_seq_obfu = {};
    for userIndex = 1:n
        user_seq = user_sequence{1,userIndex};
        seqLen = size(user_seq,2);
        seqIndex = 0;
        user_seq = ceil(user_seq / group_size);% generalization
        user_seq_obfu{end+1} = user_seq;
        %userIndex
    end
    % pattern detection
    pattern_contain = {};
    for userIndex=1:n
        pattern_contain{end+1} = pattern_detection(user_seq_obfu{1,userIndex}, user1_pattern, h);
    end
    percentage = sum([pattern_contain{1,:}] == true) / valid_user_num;
    percentage_vec = [percentage_vec, percentage];
end
percentage_avg = mean(percentage_vec);
end