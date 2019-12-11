function [retRes] = PriorityQueueTestFunc(val1, val2)
%PriorityQueueTestFunc Compares 2 struct's nID members
%   returns true if val1's nID is smaller or equal to val2's
if(val1.nID <= val2.nID)
    retRes = true;
else
    retRes = false;
end

end

