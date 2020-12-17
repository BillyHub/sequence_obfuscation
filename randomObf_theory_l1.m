function [Prob_Au] = randomObf_theory_l1(p_obf, r, m)
% lower bound for the random obfuscation when l = 1

Prob_Au = 0;
for k = 0:m
    Prob_Au = Prob_Au + nchoosek(m, k)*p_obf^k*(1-p_obf)^(m-k)*(1-(1-1/r)^k);
end
end