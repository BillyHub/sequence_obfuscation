function [percentage_avg] = obfuscation_subsampling(user_sequence, r, n, valid_user_num, l, h, iteration)
% Executing subsampling obfuscation

% user_sequence: user sequence dataset
% r: letter size
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% l: pattern length
% h: pattern letter maximum distance
% iteration: number of iterations

percentage_vec = [];
for iter = 1:iteration
    user1_pattern = randi([1,r],1,l);
    % pattern detection
    pattern_contain = {};
    for userIndex=1:n
        pattern_contain{end+1} = pattern_detection(user_sequence{1,userIndex}, user1_pattern, h);
    end
    percentage = sum([pattern_contain{1,:}] == true) / valid_user_num;
    percentage_vec = [percentage_vec, percentage];
end
percentage_avg = mean(percentage_vec);
end