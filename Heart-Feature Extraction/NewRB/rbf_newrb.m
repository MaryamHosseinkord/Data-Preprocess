clc;
clear;
close all;

data = load('Heart.dat');

inputData = data(:,1:end-1);
targetData = data(:,end);

FESTD = mapstd(inputData,0,1);
[FEPC,score] = princomp(FESTD);
FEPC = FEPC(:,1:5);
inputDataNew = FESTD*FEPC;

indices = crossvalind('Kfold',targetData,10);

 for i = 1:10
    t=tic;
    test = (indices == i); train = ~test;
    goal=0;
    spread=5;
    MN=2;
    net = newrb(inputDataNew(train,:)',targetData(train)',goal,spread,MN);
    testOutput = sim(net,inputDataNew(test,:)');
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
 end

mean_acc = mean(accVar)
std_acc = std(accVar)
mean_mcc = mean(mccVar)
mean_f1 = mean(f1Var)
mean_sensitivity = mean(sensitivityVar)
mean_specificity = mean(specificityVar)
mean_time = mean(timeVar)



figure;
x=0:0.01:1;
y=0:0.01:1;
plot(x,y,'-');
hold on;
plot(0,1,'or');
text(0,1, ['\leftarrow Perfect classification'])
hold on;

plot((1-mean_specificity),mean_sensitivity,'ro');  
axis([0 1 0 1]);
title('ROC Plot');
xlabel('FPR');
ylabel('TPR');