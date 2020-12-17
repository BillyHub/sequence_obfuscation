function db(t,p,r, l)
global sequence;
global a;
if (t > l)
    if (mod(l,p) == 0)
        sequence = [sequence, a(2:p+1)];
    end
else
    a(t+1) = a(t - p +1);
    db(t + 1, p, r, l);
    for j = a(t - p+1) + 1: r-1
        a(t+1) = j;
        db(t + 1, t, r, l);
    end
end
end