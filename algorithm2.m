function [percentage_avg] = algorithm2(user_sequence, user1_pattern, r, n, valid_user_num, p_obf, l, h, sigma, iteration)
% Executing algorithm2 obfuscation

% user_sequence: user sequence dataset
% user1_pattern: user1's unique pattern
% r: location size
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% p_obf: probability of obfuscation
% l: pattern length
% h: pattern letter maximum distance
% sigma: parameter for algorithm2
% iteration: number of iterations

r_total = r + l;% extra l letters for unique pattern
loc_set = 1:r_total;
percentage_vec = [];
for iter = 1:iteration
    user_seq_obfu = {};
    for userIndex = 1:n
        user_seq = user_sequence{1,userIndex};
        seqLen = size(user_seq,2);
        seqIndex = 0;
        if seqLen >= 1            
            q_tilda = zeros(1,r_total);
            q = zeros(1,r_total);
            q_obs = zeros(1,r_total);           
            while (seqIndex < seqLen)                
                % skip the obfuscation for the first data point, only used for statistics
                if (seqIndex == 0)
                   q_obs(user_seq(seqIndex+1)) =  q_obs(user_seq(seqIndex+1)) + 1;
                   q_tilda(user_seq(seqIndex+1)) = (q_obs(user_seq(seqIndex+1)) / (seqIndex + 1))^sigma;
                   q(user_seq(seqIndex+1)) = q_tilda(user_seq(seqIndex+1)) / (sum(q_tilda, 2));                 
                   seqIndex = seqIndex + 1;
                   continue;
                end
                q_max = max(q);
                q_min = min(q);
                b = 0.99 * min(1/(r_total*q_max-1), (r_total-1)/(1-r_total*q_min));
                a = (1+b)/r_total;
                p = a - b*q;              
                x_rand=rand;
                if (x_rand <= p_obf)
                    select=1;
                else
                    select=0;
                end                
                if (select == 1)
                    % obfuscate the sequence based on probability vector p
                    w = p;
                    w = w/sum(w,2);% make sure the probabilites add up to 1
                    cp = [0, cumsum(w)];
                    rnum = rand;
                    ind = find(rnum>cp, 1, 'last');
                    x_obf = loc_set(ind);
                    user_seq(seqIndex+1) = x_obf;
                end                
                q_obs(user_seq(seqIndex+1)) =  q_obs(user_seq(seqIndex+1)) + 1;
                q_tilda = (q_obs/(seqIndex+1)).^sigma;
                q = q_tilda / sum(q_tilda, 2);
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