function [Pro_Bu] = algorithm1_thoery_l1(p_obf, r, m)
% lower bound for the algorithm1 obfuscation when l = 1

Pro_Bu = 0;
for k = 0:r-2
    Pro_Bu = Pro_Bu + nchoosek(m, k)*p_obf^k*(1-p_obf)^(m-k)*(k/(r-1));
    
end
for k = (r-1):m
    Pro_Bu = Pro_Bu + nchoosek(m, k)*p_obf^k*(1-p_obf)^(m-k);
end
end