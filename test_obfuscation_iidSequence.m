% Compare each obfuscation method on i.i.d. sequences
clear all

%% parameters initialization
r = 20;% location size before adding extra l letters for the unique pattern
m = 1e3;% sequence length
l = 2;% pattern length
h = 10;% pattern letter maximum distance
n = 1e2;% number of users
sigma = 1/10;% for algorithm2

%% generate the iid sequence for each user
user_sequence = {};
for userIndex = 1:n
    user_sequence{userIndex} = randi([1,r],1,m);
end

%% generate a unique pattern and insert the pattern into user 1's sequence at a random index
if (l == 1)
    user1_pattern = [r+1];
end
if (l == 2)
    user1_pattern = [r+1, r+2];
end
if (l == 3)
    user1_pattern = [r+1, r+2, r+3];
end
% random index for inserting the unique pattern
place = randi([1,m],1);
user_sequence{1} = [user_sequence{1}(1:place-1), user1_pattern, user_sequence{1}(place:end)];

%% generate the superstring generated by the de bruijn sequence
superstring_seq = de_bruijn_sequence(r+l,l) + 1;% extra l letters for unique pattern; adding one for superstring offset

%% define the validation vector for each obfuscation method
percent_randomObf = [];
%percent_randomObf_theory = [];
percent_deBruijnObf = [];
percent_algorithm1 = [];
%percent_algorithm1_theory = [];
percent_algorithm2 = [];
percent_algorithm3 = [];

%% executing each obfuscation method
for p_obf = 0.02:0.02:0.1
    percent_randomObf = [percent_randomObf, obfuscation_random(user_sequence, user1_pattern, r, n, n, p_obf, l, h, 1e3)];
    %percent_randomObf_theory = [percent_randomObf_theory, randomObf_theory_l1(p_obf, r+l, m)];
    percent_deBruijnObf = [percent_deBruijnObf, obfuscation_superstring(user_sequence, superstring_seq, user1_pattern, n, n, p_obf, l, h, 1e3)];
    percent_algorithm1 = [percent_algorithm1, algorithm1(user_sequence, user1_pattern, r, n, n, p_obf, l, h, 1e2)];
    %percent_algorithm1_theory = [percent_algorithm1_theory, algorithm1_theory_l1(p_obf, r+l, m)];
    percent_algorithm2 = [percent_algorithm2, algorithm2(user_sequence, user1_pattern, r, n, n, p_obf, l, h, sigma, 1e2)];
    percent_algorithm3 = [percent_algorithm3, algorithm3(user_sequence, user1_pattern, r, n, n, p_obf, l, h, 1e1)];
end

%% plot the figure in terms of p_obf
figure;
p = 0.02:0.02:0.1;
plot(p, percent_randomObf, 'og-');hold on;
%plot(p, percent_randomObf_theory, 'dr-');hold on;
plot(p, percent_deBruijnObf, 'dr-');hold on;
plot(p, percent_algorithm1, 'xb-');hold on;
%plot(p, percent_algorithm1_theory, 'dr-');hold on;
plot(p, percent_algorithm2, 'sk-');hold on;
plot(p,percent_algorithm3, 'vm-');
xlabel('p_{obf}');ylabel('validation percentage');
legend('random obf', 'de bruijn obf','algorithm1 obf','algorithm2 obf', 'algorithm3 obf', 'Location','southeast');
grid on;
set(gcf,'Position',[100 100 500 400])
%title('r = 20 + l, m = 1000, l = 2, h = 10, using iid sequence');
