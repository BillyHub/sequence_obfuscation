function [percentage_avg] = obfuscation_superstring(user_sequence, superStringSeq, user1_pattern, n, valid_user_num, p_obf, l, h, iteration)
% Executing proposed superstring based obfuscation method
% optimized version of superstring based on De Bruijn sequence:
% https://en.wikipedia.org/wiki/De_Bruijn_sequence

% Corresponding code to the paper "Sequence Obfuscation to Thwart Pattern
% Matching Attacks" by Bo Guan et al., at IEEE International Symposium on
% Information Theory (ISIT), 2020.

% user_sequence: user sequence dataset
% superStringSeq: superstring based obfuscation sequence
% user1_pattern: user1's unique pattern
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% p_obf: probability of obfuscation
% l: pattern length
% h: pattern letter maximum distance
% iteration: number of iterations

superString_len = length(superStringSeq);
percentage_vec = [];
for iter = 1:iteration
    user_seq_obfu = {};% obfuscated sequence
    for userIndex = 1:n
        user_seq = user_sequence{1,userIndex};
        seqLen = size(user_seq,2);
        obf_index = 0;
        seqIndex = 0;
        if seqLen >= 1
            % circular shift the superstring randomly to the right
            digit_shift = randi([0 superString_len - 1],1);
            shifted_superString = circshift(superStringSeq,digit_shift);
            % copy the front (l-1) letters to the end
            shifted_superString = [shifted_superString, shifted_superString(1:l-1)];
            while (seqIndex < seqLen)
                x_rand=rand;
                if (x_rand <= p_obf)
                    select=1;
                else
                    select=0;
                end
                if (select == 1)
                    if (obf_index <  (superString_len + l -1))
                        user_seq(seqIndex+1) = shifted_superString(obf_index + 1);% obfuscation
                    else
                        obf_index = 0;%reset the obfuscation index
                        % re-generate the random superstring
                        digit_shift = randi([0 superString_len - 1],1);
                        shifted_superString = circshift(superStringSeq,digit_shift);
                        shifted_superString = [shifted_superString, shifted_superString(1:l-1)];
                        user_seq(seqIndex+1) = shifted_superString(obf_index + 1);% obfuscation
                    end
                    obf_index = obf_index + 1;
                end
                seqIndex = seqIndex + 1;
            end
        end
        user_seq_obfu{end+1} = user_seq;
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
