function [pattern_included, index] = pattern_detection(seq, pattern, h)
% pattern detection with distance requirement h

len = size(seq,2);
l = length(pattern);
pattern_included = false;
index = [];

if (len < l)
    return;
end
if (l == 1)
    for p1 = 1: len
        if (seq(p1) ~= pattern(1))
            continue;
        else
            pattern_included = true;
            index = p1;
            return;
        end
    end
elseif (l == 2)
    for p1 = 1: (len - 1)
        if (seq(p1) ~= pattern(1))
            continue;
        end
        for p2 = (p1+1) : len
            if (seq(p2) ~= pattern(2))
                continue;
            end
            if ((p2-p1) > h)
                break;
            else
                pattern_included = true;
                index = [p1, p2];
                return;
            end
        end
    end
elseif (l == 3)
    for p1 = 1: (len - 2)
        if (seq(p1) ~= pattern(1))
            continue;
        end
        for p2 = (p1+1) : (len - 1)
            if (seq(p2) ~= pattern(2))
                continue;
            end
            if ((p2-p1) > h)
                break;
            end
            for p3 = (p2+1) : len
                if (seq(p3) ~= pattern(3))
                    continue;
                end
                if ((p3-p2) > h)
                    break;
                else
                    pattern_included = true;
                    index = [p1, p2, p3];
                    return;
                end
            end
        end
    end
end
end