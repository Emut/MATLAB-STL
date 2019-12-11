bErrorInOrders = false;
pq = PriorityQueue();
for i=1:100
    pq.push(rand);
end

prevKey = -Inf;
for i=1:100
    temp = pq.pop();
    if(temp < prevKey)
        bErrorInOrders = true;
        fprintf('Error in queue order with default comparator!\n');
    end
    prevKey = temp;
end

pqMax = PriorityQueue(@ge);
for i=1:100
    pqMax.push(rand);
end

prevKey = Inf;
for i=1:100
    temp = pqMax.pop();
    if(temp > prevKey)
        bErrorInOrders = true;
        fprintf('Error in queue order with ge comparator!\n');
    end
    prevKey = temp;
end

pqStruct = PriorityQueue(@PriorityQueueTestFunc);
tempStruct.nID = 0;
tempStruct.Data = 0;
for i=1:100
    tempStruct.nID = rand;
    pqStruct.push(tempStruct);
end

prevKey = -Inf;
for i=1:100
    tempStruct = pqStruct.pop();
    if(tempStruct.nID < prevKey)
        bErrorInOrders = true;
        fprintf('Error in queue order with struct comparator!\n');
    end
    prevKey = tempStruct.nID;
end

if(~bErrorInOrders)
    fprintf('Queue orderings are OK\n');
end

fprintf('Timing Tests...\n');

pqTiming = PriorityQueue();
testRep = 1000;
timingTestLevels(1) = 1000;
timingTestLevels(2) = 2000;
timingTestLevels(3) = 4000;
timingTestLevels(4) = 8000;
timingTestLevels(5) = 16000;
timingTestLevels(6) = 32000;
[~,timingTestCnt] = size(timingTestLevels);
for i = 1:timingTestCnt
    while(pqTiming.size() < timingTestLevels(i))
        pqTiming.push(rand);
    end
    
    tic;
    for j = 1:testRep
        pqTiming.pop();
        pqTiming.push(rand);
    end
    testRes(i) = toc;
    fprintf('Average pop + push at %d size took %fms\n', timingTestLevels(i), 1000*testRes(i)/testRep);
end