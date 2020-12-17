function [percentage_avg] = algorithm3(user_sequence, user1_pattern, r, n, valid_user_num, p_obf, l, h, iteration)
% Executing algorithm3 obfuscation

% user_sequence: user sequence dataset
% user1_pattern: user1's unique pattern
% r: location size
% n: number of users
% valid_user_num: number of users whose sequence is not empty
% p_obf: probability of obfuscation
% l: pattern length
% h: pattern letter maximum distance
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
            pattern_set_seen = [];% the pattern set has shown in the obfuscated sequence
            pattern_set_seen_size = 0;           
            new_pattern_count_table = {};% count number of new patterns of each candidate obfuscate letter           
            for loc_index = 1:r_total
                new_pattern_count_table{1,loc_index} = [];
            end            
            while (seqIndex < seqLen)
                % skip the first l data points, only used for statistics
                if (seqIndex == 0)
                    seqIndex = seqIndex + 1;
                    continue;
                end                
                if (seqIndex == 1)
                    pattern_set_seen = [pattern_set_seen;[user_seq(1), user_seq(2)]];
                    pattern_set_seen_size = pattern_set_seen_size + 1;
                    seqIndex = seqIndex + 1;
                    continue;
                end          
                x_rand=rand;
                if (x_rand <= p_obf)
                    select=1;
                else
                    select=0;
                end                
                if (select == 1)% obfuscating the data point
                    % execute the randomness obfuscation if the pattern set has been used up
                    if (pattern_set_seen_size == r^l)
                        user_seq(seqIndex+1) = randi([1,r+l],1);
                        seqIndex = seqIndex + 1;
                        continue;
                    end                    
                    if (seqIndex <= h)% sequence index is within the pattern letter maximum distance               
                        for loc_index = 1:r_total
                            % add the new pattern to the counting table
                            if (~ismember([user_seq(seqIndex), loc_index], pattern_set_seen, 'rows'))
                                new_pattern_count_table{loc_index} = [new_pattern_count_table{loc_index};[user_seq(seqIndex), loc_index]];
                            end
                        end                       
                        unique_new_pattern_count_table = unique_table(new_pattern_count_table);% eliminate the duplicate pattern
                        % sort the pattern count table for each candidate obfuscating letter
                        [r_max_set, max_num] = sort_table(unique_new_pattern_count_table);                                                                                          
                        % choose the letter for obfuscation equally likely from the set who have the maximum number of new unique patterns
                        loc_obf_idx = r_max_set(randi([1,size(r_max_set, 2)],1));
                        user_seq(seqIndex+1) = loc_set(loc_obf_idx);                   
                        % update the pattern_set_seen
                        pattern_set_seen = [pattern_set_seen; unique_new_pattern_count_table{loc_set(loc_obf_idx)}];
                        pattern_set_seen_size = pattern_set_seen_size + max_num;                   
                        % set the chosen obfuscation letter's new pattern list to zero
                        new_pattern_count_table{loc_set(loc_obf_idx)} = [];                   
                    else% sequence index beyond the pattern letter maximum distance, pattern with distance outside the distance must be eliminated for counting                
                        for loc_index = 1:r_total
                            % add the new pattern to the counting table
                            if (~ismember([user_seq(seqIndex), loc_index], pattern_set_seen, 'rows'))
                                new_pattern_count_table{loc_index} = [new_pattern_count_table{loc_index};[user_seq(seqIndex), loc_index]];                 
                            end
                            % eliminate the existing outside pattern from the counting table
                            if (~ismember([user_seq(seqIndex - h), loc_index], pattern_set_seen, 'rows') && size(new_pattern_count_table{loc_index},1) ~=0)
                                new_pattern_count_table{loc_index}(1,:) = [];
                            end                                   
                        end                        
                        unique_new_pattern_count_table = unique_table(new_pattern_count_table);                        
                        [r_max_set, max_num] = sort_table(unique_new_pattern_count_table);                                                                                            
                        loc_obf_idx = r_max_set(randi([1,size(r_max_set, 2)],1));
                        user_seq(seqIndex+1) = loc_set(loc_obf_idx);                  
                        % update the pattern_set_seen
                        pattern_set_seen = [pattern_set_seen; unique_new_pattern_count_table{loc_set(loc_obf_idx)}];
                        pattern_set_seen_size = pattern_set_seen_size + max_num;                  
                        % update the new_pattern_count_table
                        new_pattern_count_table{loc_set(loc_obf_idx)} = [];
                    end    
                else% not obfuscating the data point, but only update the pattern counting table                     
                    if (seqIndex <= h)                        
                        for loc_index = 1:r_total
                            % add the new pattern to the counting table
                            if (~ismember([user_seq(seqIndex), loc_index], pattern_set_seen, 'rows'))
                                new_pattern_count_table{loc_index} = [new_pattern_count_table{loc_index};[user_seq(seqIndex), loc_index]];
                            end
                        end                      
                        unique_new_pattern_count_table = unique_table(new_pattern_count_table);                    
                        % update the pattern_set_seen
                        pattern_set_seen = [pattern_set_seen; unique_new_pattern_count_table{user_seq(seqIndex+1)}];
                        pattern_set_seen_size = pattern_set_seen_size + size(unique_new_pattern_count_table{user_seq(seqIndex+1)}, 1);                 
                        % update the new_pattern_count_table
                        new_pattern_count_table{user_seq(seqIndex+1)} = [];                      
                    else                        
                        for loc_index = 1:r_total
                            % add the new pattern to the counting table
                            if (~ismember([user_seq(seqIndex), loc_index], pattern_set_seen, 'rows'))
                                new_pattern_count_table{loc_index} = [new_pattern_count_table{loc_index};[user_seq(seqIndex), loc_index]];
                            end
                            % eliminate the existing outside pattern from the counting table
                            if (~ismember([user_seq(seqIndex - h), loc_index], pattern_set_seen, 'rows') && size(new_pattern_count_table{loc_index},1) ~=0)
                                new_pattern_count_table{loc_index}(1,:) = [];
                            end                          
                        end                       
                        unique_new_pattern_count_table = unique_table(new_pattern_count_table);                      
                        % update the pattern_set_seen
                        pattern_set_seen = [pattern_set_seen; unique_new_pattern_count_table{user_seq(seqIndex+1)}];
                        pattern_set_seen_size = pattern_set_seen_size + size(unique_new_pattern_count_table{user_seq(seqIndex+1)}, 1);                   
                        % update the new_pattern_count_table
                        new_pattern_count_table{user_seq(seqIndex+1)} = [];                     
                    end  
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
    %iter
end
percentage_avg = mean(percentage_vec);
end