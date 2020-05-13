

function[Mean,Result]= NewRBPimaSel(Existinglist)


AttributeCount=sum(Existinglist);
ind = find(Existinglist);
data = load('pima.dat');

data=data(:,ind);

inputData = data(:,1:end-1);
targetData = data(:,end);

indices = crossvalind('Kfold',targetData,10);

 for i = 1:10
    t=tic;
    test = (indices == i); train = ~test;
    goal=0;
    spread=1;
    maxNeuron=2;
    net = newrb(inputData(train,:)',targetData(train)',goal,spread,maxNeuron);
    testOutput = sim(net,inputData(test,:)');
    %testOutput = round(testOutput);
        
    [min, max]=MinMax(testOutput);
    testOutput= (testOutput-min(1,1))/(max(1,1)-min(1,1));
    testOutput = round(testOutput);

    timeVar(i) = toc(t);
    tableVar(i,:) = valueTable(testOutput,targetData(test));
    accVar(i) = ACC(tableVar(i,4) , tableVar(i,2) , tableVar(i,3) , tableVar(i,1));
    sensitivityVar(i) = sensitivity(tableVar(i,4) , tableVar(i,1));
    specificityVar(i) = specificity(tableVar(i,3) , tableVar(i,2));
    mccVar(i) = MCC(tableVar(i,4) , tableVar(i,2) , tableVar(i,3) , tableVar(i,1));
    f1Var(i) = F1_Score(tableVar(i,4) , tableVar(i,2) , tableVar(i,1));
    rocVar(i,:) = ROC(tableVar(i,4) , tableVar(i,1) , tableVar(i,2) , tableVar(i,3));
 end

%mean_mse = mean(mseVar)
mean_acc = mean(accVar);
std_acc = std(accVar);
mean_mcc = mean(mccVar);
mean_f1 = mean(f1Var);
mean_specificity = mean(specificityVar);
mean_sensitivity = mean(sensitivityVar);
mean_time = mean(timeVar);


Mean=mean_acc;

Result=[mean_acc std_acc mean_mcc mean_f1 mean_sensitivity mean_specificity mean_time];
