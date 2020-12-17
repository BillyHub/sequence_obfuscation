function [percentage_avg] = obfuscation_random(user_sequence, user1_pattern, r, n, valid_user_num, p_obf, l, h , iteration)
% Executing random obfuscation

% user_sequence: user sequence dataset
% user1_pattern: user1's unique pattern
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% p_obf: probability of obfuscation
% l: pattern length
% h: pattern letter maximum distance
% iteration: number of iterations

percentage_vec = [];
for iter = 1:iteration
    user_seq_obfu = {};
    for userIndex = 1:n
        user_seq = user_sequence{1,userIndex};
        seqLen = size(user_seq,2);
        seqIndex = 0;
        if seqLen >= 1
            while (seqIndex < seqLen)
                x_rand=rand;
                if (x_rand <= p_obf)
                    select=1;
                else
                    select=0;
                end
                if (select == 1)
                    user_seq(seqIndex+1) = randi([1,r+l],1);% obfuscation
                end
                seqIndex = seqIndex + 1;
            end
        end
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