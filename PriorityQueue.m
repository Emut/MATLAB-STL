classdef PriorityQueue < handle
    %PriorityQueue custom order random insert queue with mixed elements
    %   Umut Ekici 2019
    %   https://github.com/Emut/MATLAB-STL
    %   numutekici@gmail.com
    %
    %   Front of the queue is always the smallest element*
    %   Push and Pop with O(log(n)), Top with O(1)
    %   *smallest is the default behaviour, this can be changed by giving
    %   any function handle taking 2 elements and returning a logical
    %   value as a result of this comparison (e.g. @ge would make this a
    %   max heap
    
    %properties(Access = private)
    properties
        memberCount;
        keyHeap;
        compareKeys;
    end
    
    methods
        function obj = PriorityQueue(compareHandle)
            obj.memberCount = 0;
            if nargin < 1
                obj.compareKeys = @le;
            else
                obj.compareKeys = compareHandle;
            end
        end
        function push(obj, key)
            obj.memberCount = obj.memberCount + 1;
            pivotInd = obj.memberCount;
            obj.keyHeap{pivotInd} = key;
            
            while(true)
                parentInd = obj.getParentOf(pivotInd);
                if(parentInd < 0)
                    break;  %reached the root
                end
                if(~obj.compareKeys(obj.keyHeap{pivotInd}, obj.keyHeap{parentInd}))
                    break;  %parent is smaller than inserted, heap OK
                end
                %else swap the 2 keys
                obj.swapKeys(pivotInd, parentInd);
                pivotInd = parentInd;   %continue upwards
            end
        end
        
        function retKey = pop(obj)
            retKey = obj.keyHeap{1};    %return the top
            obj.swapKeys(1, obj.memberCount);   %bring end key to top
            obj.memberCount = obj.memberCount - 1;
            
            pivotInd = 1;
            while(true)
                leftInd = obj.getLeftChildOf(pivotInd);
                if(leftInd < 0)
                    break;  %reached bottom
                end
                rightInd = obj.getRightChildOf(pivotInd);
                
                if(obj.compareKeys(obj.keyHeap{pivotInd}, obj.keyHeap{leftInd}))
                    leftOK = true;
                else
                    leftOK = false;
                end
                
                if(rightInd < 0)
                    rightOK = true;
                elseif(obj.compareKeys(obj.keyHeap{pivotInd}, obj.keyHeap{rightInd}))
                    rightOK = true;
                else
                    rightOK = false;
                end
                
                if(~leftOK && ~rightOK) %if both child violate, swap with the largest
                    if(obj.compareKeys(obj.keyHeap{leftInd}, obj.keyHeap{rightInd}))
                        rightOK = true;
                    else
                        leftOK = true;
                    end
                end
                
                if(leftOK && rightOK)
                    break; %heap is OK
                elseif(rightOK)
                    obj.swapKeys(pivotInd, leftInd);
                    pivotInd = leftInd; %continue down on left child
                else
                    obj.swapKeys(pivotInd, rightInd);
                    pivotInd = rightInd; %continue down on right child
                end
            end
        end
        
        function retKey = top(obj)
            retKey = obj.keyHeap{1};
        end
        
        function retSize = size(obj)
            retSize = obj.memberCount;
        end
    end
    
    methods
        function r = getParentOf(~, ind)
            if(ind < 2)
                r = -1;
                return;
            end
            r = floor(ind/2);
        end
        
        function r = getLeftChildOf(obj, ind)
            r = 2*ind;
            if(r > obj.memberCount)
                r = -1;
            end
        end
        
        function r = getRightChildOf(obj, ind)
            r = 2*ind + 1;
            if(r > obj.memberCount)
                r = -1;
            end
        end
        
        function swapKeys(obj, val1, val2)
            tempKey = obj.keyHeap{val1};
            obj.keyHeap{val1} = obj.keyHeap{val2};
            obj.keyHeap{val2} = tempKey;
        end
    end
end

